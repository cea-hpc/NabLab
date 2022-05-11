/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.cpp

import fr.cea.nabla.ir.annotations.NabLabFileAnnotation
import fr.cea.nabla.ir.interpreter.Context
import fr.cea.nabla.ir.interpreter.ExpressionInterpreter
import fr.cea.nabla.ir.interpreter.NablaValue
import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.ArgOrVarRef
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.Function
import fr.cea.nabla.ir.ir.Instruction
import fr.cea.nabla.ir.ir.InternFunction
import fr.cea.nabla.ir.ir.IrAnnotable
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.LinearAlgebraType
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.PrimitiveType
import fr.cea.nabla.ir.ir.VariableDeclaration
import java.util.Collection
import java.util.List
import java.util.Map
import java.util.Set
import java.util.logging.Logger
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtend.lib.annotations.Data

import static fr.cea.nabla.ir.IrUtils.*

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.generator.Utils.*

@Data
abstract class AbstractPythonEmbeddingContentProvider
{
	protected val extension TypeContentProvider
	protected val extension ExpressionContentProvider

	val Map<String, Integer> executionEvents = newHashMap
	val Map<String, List<String>> globalVariableWriteEvents = newHashMap
	val Set<String> callExecutionEvents = newHashSet

	abstract def String getIncludeContent()

	abstract def String getPrivateMembers(IrModule it)

	abstract def String getPythonJsonInitContent()

	abstract def String getAllScopeStructContent(IrModule it)

	abstract def String getSimulateProlog()

	abstract def String getPythonInitializeContent(IrModule it)

	abstract def String getBeforeWriteContent(Instruction it)

	abstract def String getAfterWriteContent(Instruction it)

	abstract def String getBeforeCallContent(Job it)

	abstract def String getAfterCallContent(Job it)

	abstract def String getCMakeEmbeddingContent()

	abstract def String getCMakeExecutableContent(String includeContent, String linkContent)

	abstract def String wrapLambdaWithGILGuard(Loop it, String lambdaName, String lambdaType, String lambdaParameters, String lambdaBody)

	abstract def String wrapLambdaCallWithGILGuard(String call)

	abstract def String wrapLoopWithGILGuard(Loop it, String loopHeader, String loopBody)

	def isUserDefined(IrAnnotable it)
	{
		NabLabFileAnnotation.tryToGet(it) !== null
	}

	def getWriteEvents(EObject it, boolean before)
	{
		eAllContents.filter[o|
				(o instanceof VariableDeclaration && isUserDefined((o as VariableDeclaration).variable)) ||
				(o instanceof Affectation && isUserDefined((o as Affectation).left.target))
			].map[o|
				if (o instanceof VariableDeclaration)
				{
					getExecutionEvent(o as VariableDeclaration, before)
				}
				else
				{
					getExecutionEvent((o as Affectation), before)
				}
			]
			.toSet
	}

	def getBaseExecutionEvents(IrModule it)
	'''
		{
			«FOR e : executionEvents.keySet.sortBy[k|executionEvents.get(k)]»
			{"«e»", «executionEvents.get(e)»},
			«ENDFOR»
		}'''

	def getCompositeExecutionEvents(IrModule it)
	'''
		{
			«FOR e : globalVariableWriteEvents.keySet SEPARATOR ','»
			{"«e»", {«globalVariableWriteEvents.get(e).map[s|'''"«s»"'''].join(',')»}}
			«ENDFOR»
		}'''

	def computeExecutionEvents(IrModule it)
	{
		jobs.forEach[j|
			val jobEventName = j.name.toFirstUpper
			executionEvents.computeIfAbsent(jobEventName + '.Before', [executionEvents.size])
			executionEvents.computeIfAbsent(jobEventName + '.After', [executionEvents.size])
			callExecutionEvents.add(jobEventName)
			j.eAllContents.filter[o|o instanceof VariableDeclaration || o instanceof Affectation]
					.map[o|
						if (o instanceof VariableDeclaration)
						{
							(o as VariableDeclaration).variable
						}
						else
						{
							(o as Affectation).left.target
						}
					]
					.filter[v|isUserDefined(v)]
					.forEach[v|
						val assignEventName = '''«jobEventName».«v.name.toFirstUpper»'''
						if (!executionEvents.containsKey(assignEventName + '.Before'))
						{
							val eventIndex = executionEvents.size
							executionEvents.put(assignEventName + '.Before', eventIndex)
							executionEvents.put(assignEventName + '.After', eventIndex+1)
							if (v.eContainer instanceof IrModule)
							{
								globalVariableWriteEvents.computeIfAbsent(v.name.toFirstUpper + '.Before', [newArrayList]).add(assignEventName + '.Before')
								globalVariableWriteEvents.computeIfAbsent(v.name.toFirstUpper + '.After', [newArrayList]).add(assignEventName + '.After')
							}
						}
					]
		]
//		functions.forEach[f|
//			val functionName = f.name.toFirstUpper
//			val functionEventName = '''«moduleName».«functionName»'''
//			executionEvents.computeIfAbsent(functionEventName, [executionEvents.size])
//			callExecutionEvents.add(functionEventName)
//			f.eAllContents.filter[o|o instanceof VariableDeclaration || o instanceof Affectation].forEach[a|
//				val assignEventName = if (a instanceof VariableDeclaration)
//				{
//					'''«functionEventName».«(a as VariableDeclaration).variable.name.toFirstUpper»'''
//				}
//				else
//				{
//					'''«functionEventName».«(a as Affectation).left.target.name.toFirstUpper»'''
//				}
//				executionEvents.computeIfAbsent(assignEventName, [executionEvents.size])
//			]
//		]
		
	}

	def getExecutionEvents()
	{
		return executionEvents
	}

	def getCallExecutionEvents()
	{
		return callExecutionEvents
	}

	def getAllExecutionEvents(IrAnnotable it)
	{
		return #[getExecutionEvent(true), getExecutionEvent(false)]
	}

	def dispatch int getExecutionEvent(Job it, boolean before)
	{
		val eventName = '''«name.toFirstUpper»«IF before».Before«ELSE».After«ENDIF»'''
		return executionEvents.get(eventName)
	}

	def getContainerName(Instruction it)
	{
		val job = getContainerOfType(it, Job)
		if (job === null)
		{
			val func = getContainerOfType(it, Function)
			if (func === null)
			{
				return ""
			}
			return func.name
		}
		else
		{
			return job.name
		}
	}

	def dispatch int getExecutionEvent(VariableDeclaration it, boolean before)
	{
		val container = getContainerName(it).toFirstUpper
		val eventName = '''«container».«variable.name.toFirstUpper»«IF before».Before«ELSE».After«ENDIF»'''
		return executionEvents.get(eventName)
	}

	def dispatch int getExecutionEvent(Affectation it, boolean before)
	{
		val container = getContainerName(it).toFirstUpper
		val eventName = '''«container».«left.target.name.toFirstUpper»«IF before».Before«ELSE».After«ENDIF»'''
		return executionEvents.get(eventName)
	}

	def getLocals(EObject it)
	{
		return eAllContents.filter(VariableDeclaration).filter[v|v.variable.isUserDefined].toMap[d|d.variable.name].values
	}

	def hasLocals(EObject it)
	{
		return !eAllContents.filter(VariableDeclaration).filter[v|v.variable.isUserDefined].empty
	}

	def getLocalScopeStructContent(Job it)
	{
		return getLocalScopeStructContent(it, name.toFirstUpper)
	}

	def getLocalScopeStructContent(InternFunction it)
	{
		return getLocalScopeStructContent(it, name.toFirstUpper)
	}

	def getLocalScopeStructContent(EObject it, String name)
	{
		if (hasLocals)
		{
			val moduleName = getContainerOfType(it, IrModule).name.toFirstUpper
			return getLocalScopeStructContent(name + "Context", moduleName, locals)
		} else {
			return ""
		}
	}

	def getLocalScopeStructContent(String name, String moduleName, Collection<VariableDeclaration> locals)
	'''
		struct «name» : «moduleName»Context
		{
			«FOR local : locals»
			const pybind11::object get_«local.variable.name»() const { if («local.variable.name» != nullptr) return pybind11::cast(*«local.variable.name»); else return pybind11::cast<pybind11::none>(Py_None); }
			«ENDFOR»
			
			«FOR local : locals»
			«IF local.variable.const»const «ENDIF»«local.variable.type.cppType» *«local.variable.name» = nullptr;
			«ENDFOR»
			
			using «moduleName»Context::«moduleName»Context;
		};
		
	'''

	def getGlobalScopeDefinition(Job it)
	'''
		«val contextName = getContainerOfType(it, IrModule).name.toFirstUpper + "Context"»
		std::shared_ptr<«contextName»> scope(new «contextName»(this, "«it.name»"));
	'''

	def getGlobalScopeDefinition(InternFunction it)
	'''
		«val contextName = getContainerOfType(it, IrModule).name.toFirstUpper + "Context"»
		std::shared_ptr<«contextName»> scope(new «contextName»(this, "«it.name»"));
	'''

	def getLocalScopeDefinition(Job it)
	'''
		«val contextName = name.toFirstUpper + "Context"»
		std::shared_ptr<«contextName»> scope(new «contextName»(this, "«it.name»"));
	'''

	def getLocalScopeDefinition(InternFunction it)
	'''
		«val contextName = name.toFirstUpper + "Context"»
		std::shared_ptr<«contextName»> scope(new «contextName»(this, "«it.name»"));
	'''

	def getGlobalScopeStructContent(IrModule it)
	'''
		struct «name.toFirstUpper»Context : MoniLogger::MoniLoggerExecutionContext
		{
			«FOR v : variables»
			«IF !v.constExpr»
				«IF v.const || v.type instanceof LinearAlgebraType»const «ENDIF»«getCppType(v.type)»«IF v.type instanceof LinearAlgebraType»&«ENDIF» get_«v.name»() const {return instance->«v.name»;}
			«ENDIF»
			«ENDFOR»
			
			«name.toFirstUpper» *instance = nullptr;
			
			«name.toFirstUpper»Context(«name.toFirstUpper» *instance, std::string name) : MoniLoggerExecutionContext(name), instance(instance) {}
			
			virtual ~«name.toFirstUpper»Context() = default;
		};
	'''

	def getAllArrayShapes(BaseType it)
	{
		val context = new Context(Logger.getLogger(""), null, null)
		val allSizes = sizes.map[s|ExpressionInterpreter.interprete(s, context)].toList
		val result = newArrayList
		result.add(allSizes)
		for (var i = 1; i < allSizes.length; i++)
		{
			val sublist = allSizes.subList(i, allSizes.length)
			result.add(sublist)
		}
		return result
	}

	def getCppTypeForShape(PrimitiveType t, List<NablaValue> sizes)
	'''«t.getName()»Array«sizes.size»D<«sizes.join(',')»>'''

	def getPythonTypeForShape(PrimitiveType t, List<NablaValue> sizes)
	'''«t.getName()»Array«FOR size : sizes SEPARATOR 'x'»«size»«ENDFOR»'''

	def getInstrumentation(int event)
	'''
		MoniLogger::trigger(«event», scope);
	'''

	protected def getScopeParameter()
	'''
		pybind11::cast(scope)'''

	protected def getScopeUpdateContent(String variableName)
	'''
		scope->«variableName» = &«variableName»;'''
}

@Data
class EmptyPythonEmbeddingContentProvider extends AbstractPythonEmbeddingContentProvider
{
	override getIncludeContent()
	{
		""
	}

	override getPrivateMembers(IrModule it)
	{
		""
	}

	override getPythonJsonInitContent()
	{
		""
	}

	override getAllScopeStructContent(IrModule it)
	{
		""
	}

	override getSimulateProlog()
	{
		""
	}

	override getPythonInitializeContent(IrModule it)
	{
		""
	}

	override getBeforeWriteContent(Instruction it)
	{
		""
	}

	override getAfterWriteContent(Instruction it)
	{
		""
	}

	override getBeforeCallContent(Job it)
	{
		""
	}

	override getAfterCallContent(Job it)
	{
		""
	}

	override getCMakeEmbeddingContent()
	{
		""
	}

	override getCMakeExecutableContent(String includeContent, String linkContent)
	'''
		target_link_libraries(«linkContent»)
	'''

	override wrapLambdaWithGILGuard(Loop it, String lambdaType, String lambdaName, String lambdaParameters, String lambdaBody)
	'''
		const std::function<«lambdaType»> «lambdaName» = [&] («lambdaParameters»)
		{
			«lambdaBody»
		};
	'''

	override wrapLambdaCallWithGILGuard(String call)
	'''
		«call»
	'''

	override wrapLoopWithGILGuard(Loop it, String loopHeader, String loopBody)
	'''
		«loopHeader»
		{
			«loopBody»
		}'''
}

@Data
class PythonEmbeddingContentProvider extends AbstractPythonEmbeddingContentProvider
{
	override getIncludeContent()
	'''
		#include <nablabdefs.h>
		#ifdef NABLAB_DEBUG
		#include <Python.h>
		#include <pybind11/embed.h>
		#include <pybind11/stl.h>
		#include <MoniLogger.h>
		#endif
	'''

	override getPrivateMembers(IrModule it)
	'''
		#ifdef NABLAB_DEBUG
		// Debug-specific members
		
		void pythonInitialize();
		
		std::string python_path;
		std::string python_script;
		#endif
	'''

	override getAllScopeStructContent(IrModule it)
	'''
		#ifdef NABLAB_DEBUG
		«getGlobalScopeStructContent(it)»
		
		«FOR j : jobs»
			«getLocalScopeStructContent(j)»
		«ENDFOR»
		#endif
	'''

	override getBeforeWriteContent(Instruction it)
	{
		return beforeWriteContentDispatch
	}

	dispatch def String getBeforeWriteContentDispatch(VariableDeclaration it)
	'''
«««FIXME add support for internal functions
		«IF getContainerOfType(it, InternFunction) === null && isUserDefined(variable)»
		#ifdef NABLAB_DEBUG
		«getInstrumentation(getExecutionEvent(true))»
		#endif
		«ENDIF»
	'''

	dispatch def String getBeforeWriteContentDispatch(Affectation it)
	'''
«««FIXME add support for internal functions
		«IF getContainerOfType(it, InternFunction) === null && isUserDefined(left.target)»
		#ifdef NABLAB_DEBUG
		«getInstrumentation(getExecutionEvent(true))»
		#endif
		«ENDIF»
	'''

	override getAfterWriteContent(Instruction it)
	{
		return afterWriteContentDispatch
	}

	dispatch def String getAfterWriteContentDispatch(VariableDeclaration it)
	'''
«««FIXME add support for internal functions
		«IF getContainerOfType(it, InternFunction) === null && isUserDefined(variable)»
		#ifdef NABLAB_DEBUG
		«variable.name.scopeUpdateContent»
		«getInstrumentation(getExecutionEvent(false))»
		#endif
		«ENDIF»
	'''

	dispatch def String getAfterWriteContentDispatch(Affectation it)
	'''
«««FIXME add support for internal functions
		«IF getContainerOfType(it, InternFunction) === null && isUserDefined(left.target)»
		#ifdef NABLAB_DEBUG
		«IF !left.target.global»
		«left.codeName.toString.scopeUpdateContent»
		«ENDIF»
		«getInstrumentation(getExecutionEvent(false))»
		#endif
		«ENDIF»
	'''

	override getBeforeCallContent(Job it)
	'''
		#ifdef NABLAB_DEBUG
		«IF hasLocals»
		«localScopeDefinition»
		«ELSE»
		«globalScopeDefinition»
		«ENDIF»
		«getInstrumentation(getExecutionEvent(true))»
		#endif
	'''

	override getAfterCallContent(Job it)
	'''
		#ifdef NABLAB_DEBUG
		«getInstrumentation(getExecutionEvent(false))»
		#endif
	'''

	override getPythonJsonInitContent()
	'''
		#ifdef NABLAB_DEBUG
		if (options.HasMember("pythonPath"))
		{
			const rapidjson::Value &valueof_python_path = options["pythonPath"];
			assert(valueof_python_path.IsString());
			python_path = valueof_python_path.GetString();
		}
		if (options.HasMember("pythonScript"))
		{
			const rapidjson::Value &valueof_python_script = options["pythonScript"];
			assert(valueof_python_script.IsString());
			python_script = valueof_python_script.GetString();
		}
		#endif
	'''

	override getSimulateProlog()
	'''
		#ifdef NABLAB_DEBUG
		pythonInitialize();
		#endif
	'''

	override getPythonInitializeContent(IrModule it)
	{
		val allBaseTypes = eAllContents.filter(BaseType)
				.filter[t|!t.sizes.empty && t.sizes
					.forall[s|!(s instanceof ArgOrVarRef) && s.eAllContents.filter(ArgOrVarRef).empty]
				]
				.toMap([t|t.cppType], [t|t]).values
		val allShapes = newHashSet
		val typeShapes = newHashMap
		allBaseTypes.forEach[t|
			val shapes = t.allArrayShapes
			shapes.forEach[s|
				val pythonType = getPythonTypeForShape(t.primitive, s).toString
				if (allShapes.add(pythonType))
				{
					typeShapes.computeIfAbsent(t.primitive, [newArrayList]).add(s)
				}
			]
		]
		
		'''
			#ifdef NABLAB_DEBUG
			void «className»::pythonInitialize()
			{
				«val globalContextName = '''«className»Context'''»
				std::vector<std::string> paths;
				std::vector<std::string> scripts;
				std::string interface_module_name = "«className.toLowerCase»";
				std::function<void (pybind11::module_, pybind11::object)> interface_module_initializer =
						[](pybind11::module_ «className.toLowerCase»_module, pybind11::object context_class) {
					pybind11::class_<«globalContextName», std::shared_ptr<«globalContextName»>>(«className.toLowerCase»_module, "«globalContextName»", context_class)
						«val vars = variables.filter[!constExpr]»
						«FOR v : vars SEPARATOR '\n'».def_property_readonly("«v.name»", &«globalContextName»::get_«v.name»)«ENDFOR»
						.def("__str__", [](«globalContextName» &self)
							{
								std::ostringstream oss;
								oss << self.name;
								return oss.str();
							})
						.def("__repr__", [](«globalContextName» &self)
							{
								std::ostringstream oss;
								oss << self.name;
								return oss.str();
							});
					«FOR job : jobs.filter[j|j.hasLocals]»
					«val varDecs = job.eAllContents.filter(VariableDeclaration).filter[v|isUserDefined(v.variable)].toList»
					«val jobContextName = '''«job.codeName.toFirstUpper»Context'''»
					pybind11::class_<«jobContextName», «globalContextName», std::shared_ptr<«jobContextName»>>(«className.toLowerCase»_module, "«jobContextName»")«IF varDecs.empty»;«ENDIF»
						«IF !varDecs.empty»
						«FOR local : varDecs SEPARATOR '\n'».def_property_readonly("«local.variable.name»", &«jobContextName»::get_«local.variable.name»)«ENDFOR»;
						«ENDIF»
					«ENDFOR»
					«FOR typeShapeEntry : typeShapes.entrySet»
					«FOR shape : typeShapeEntry.value»
					«val type = typeShapeEntry.key»
					«val cppType = getCppTypeForShape(type, shape)»
					pybind11::class_<«cppType»>(«className.toLowerCase»_module, "«getPythonTypeForShape(type, shape)»")
						.def("__getitem__", [](«cppType» &self, unsigned index)
							{
								if (index < self.size()) {
									return self[index];
								} else {
									throw std::out_of_range("list index out of range");
								}
							})
						.def("__len__", [](«cppType» &self)
							{ return self.size(); })
						.def("__str__", [](«cppType» &self)
							{
								std::ostringstream oss;
								oss << self;
								return oss.str();
							})
						.def("__repr__", [](«cppType» &self)
							{
								std::ostringstream oss;
								oss << self;
								return oss.str();
							});
					«ENDFOR»
					«ENDFOR»
				};

				if (!python_script.empty())
				{
					paths.emplace_back(python_path);
					scripts.emplace_back(python_script);
				}

				MoniLogger::register_base_events(«baseExecutionEvents»);

				MoniLogger::register_composite_events(«compositeExecutionEvents»);

				MoniLogger::initialize_monilogger(paths, scripts, interface_module_name, interface_module_initializer);
			}
			#endif
			
		'''
	}

	override getCMakeEmbeddingContent()
	'''
		
		if (CMAKE_BUILD_TYPE STREQUAL Debug)
			set(NABLAB_DEBUG TRUE)
		endif()
		configure_file(nablabdefs.h.in ${CMAKE_BINARY_DIR}/nablabdefs.h)

		# Python embedding
		if (NABLAB_DEBUG)
			find_package(Python COMPONENTS Interpreter Development REQUIRED)
			set(pybind11_DIR "${Python_SITELIB}/pybind11/share/cmake/pybind11")
			find_package(pybind11 REQUIRED)
		endif()
	'''

	override getCMakeExecutableContent(String includeContent, String linkContent)
	'''
		if (NABLAB_DEBUG)
			target_include_directories(«includeContent» ${Python_SITELIB}/monilogger/include)
			add_library(moniloggerlib SHARED IMPORTED)
			set_property(TARGET moniloggerlib PROPERTY IMPORTED_LOCATION ${Python_SITELIB}/monilogger/libmonilogger.so)
			target_link_libraries(«linkContent» moniloggerlib pybind11::embed)
		else()
			target_include_directories(«includeContent»)
			target_link_libraries(«linkContent»)
		endif()
	'''

	override wrapLambdaWithGILGuard(Loop it, String lambdaType, String lambdaName, String lambdaParameters, String lambdaBody)
	'''
		#ifdef NABLAB_DEBUG
		const bool shouldReleaseGIL = «FOR event : #[true, false].flatMap[b|getWriteEvents(b)] SEPARATOR ' || '»MoniLogger::has_registered_moniloggers(«event»)«ENDFOR»;
		const std::function<«lambdaType»> «lambdaName» = [&] («lambdaParameters»)
		{
			if (shouldReleaseGIL)
			{
				pybind11::gil_scoped_acquire acquire;
				«lambdaBody»
				pybind11::gil_scoped_release release;
			}
			else
			{
				«lambdaBody»
			}
		};
		#else
		std::function<«lambdaType»> «lambdaName» = [&] («lambdaParameters»)
		{
			«lambdaBody»
		};
		#endif
	'''

	override wrapLambdaCallWithGILGuard(String call)
	'''
		#ifdef NABLAB_DEBUG
		if (shouldReleaseGIL)
		{
			pybind11::gil_scoped_release release;
			«call»
			pybind11::gil_scoped_acquire acquire;
		}
		else
		{
			«call»
		}
		#else
		«call»
		#endif
	'''

	override wrapLoopWithGILGuard(Loop it, String loopHeader, String loopBody)
	'''
		#ifdef NABLAB_DEBUG
		{
			const bool shouldReleaseGIL = «FOR event : #[true, false].flatMap[b|getWriteEvents(b)] SEPARATOR ' || '»MoniLogger::has_registered_moniloggers(«event»)«ENDFOR»;
			if (shouldReleaseGIL)
			{
				pybind11::gil_scoped_release release;
				«loopHeader»
				{
					pybind11::gil_scoped_acquire acquire;
					«loopBody»
					pybind11::gil_scoped_release release;
				}
				pybind11::gil_scoped_acquire acquire;
			}
			else
			{
				«loopHeader»
				{
					«loopBody»
				}
			}
		}
		#else
		«loopHeader»
		{
			«loopBody»
		}
		#endif
	'''
}