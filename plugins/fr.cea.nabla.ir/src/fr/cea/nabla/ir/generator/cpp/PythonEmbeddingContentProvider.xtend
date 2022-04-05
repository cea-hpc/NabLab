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
import fr.cea.nabla.ir.ir.ItemIndexDefinition
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.JobCaller
import fr.cea.nabla.ir.ir.LinearAlgebraType
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

import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.JobExtensions.*
import static extension fr.cea.nabla.ir.generator.Utils.*

@Data
class PythonEmbeddingContentProvider
{
	public static val String GLOBAL_SCOPE = "py::cast(globalScope)"
	public static val String LOCAL_SCOPE = "py::cast(scope)"

	protected val extension TypeContentProvider
	
	val Map<String, Integer> executionEvents = newHashMap
	val Map<String, List<Integer>> globalVariableWriteEvents = newHashMap
	val Set<String> callExecutionEvents = newHashSet
	
	def isUserDefined(IrAnnotable it)
	{
		NabLabFileAnnotation.get(it) !== null
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
	
	def getExecutionEvents(IrModule it)
	'''
		this->executionEvents =
		{
			«FOR e : executionEvents.keySet.sortBy[k|executionEvents.get(k)]»
			{"«e»", {«executionEvents.get(e)»}},
			«ENDFOR»
			«FOR e : globalVariableWriteEvents.keySet SEPARATOR ','»
			{"«e»", {«globalVariableWriteEvents.get(e).join(',')»}}
			«ENDFOR»
		};
	'''
	
	def computeExecutionEvents(IrModule it) {
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
								globalVariableWriteEvents.computeIfAbsent(v.name.toFirstUpper + '.Before', [newArrayList]).add(eventIndex)
								globalVariableWriteEvents.computeIfAbsent(v.name.toFirstUpper + '.After', [newArrayList]).add(eventIndex+1)
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
	
	def getLocalName(EObject it)
	{
		switch (it)
		{
			case VariableDeclaration:
				return (it as VariableDeclaration).variable.name
			case ItemIndexDefinition:
				return (it as ItemIndexDefinition).index.name
		}
	}
	
	def ifdefGuard(String content)
	'''
		#ifdef NABLAB_DEBUG
		«content»
		#endif
	'''
	
	def getPythonJsonInitContent()
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
	
	def getGlobalScopeStructContent(IrModule it)
	'''
		struct «name.toFirstUpper»Context
		{
			«FOR v : variables»
			«IF !v.constExpr»
				«IF v.const || v.type instanceof LinearAlgebraType»const «ENDIF»«getCppType(v.type)»«IF v.type instanceof LinearAlgebraType»&«ENDIF» get_«v.name»() const {return instance->«v.name»;}
			«ENDIF»
			«ENDFOR»
			
			std::string name = "«name.toFirstUpper»";
			«name.toFirstUpper» *instance = nullptr;
			
			«name.toFirstUpper»Context(«name.toFirstUpper» *instance) : instance(instance) {}
			«name.toFirstUpper»Context(«name.toFirstUpper» *instance, std::string name) : instance(instance), name(name) {}
			«name.toFirstUpper»Context() : instance(nullptr) {}
			
			virtual ~«name.toFirstUpper»Context() = default;
		};
	'''
	
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
		struct «name» : «moduleName»::«moduleName»Context
		{
			«FOR local : locals»
			const py::object get_«local.variable.name»() const { if («local.variable.name» != nullptr) return py::cast(*«local.variable.name»); else return py::cast<py::none>(Py_None); }
			«ENDFOR»
			
			«FOR local : locals»
			«IF local.variable.const»const «ENDIF»«local.variable.type.cppType» *«local.variable.name» = nullptr;
			«ENDFOR»
			
			using «moduleName»::«moduleName»Context::«moduleName»Context;
		};
		
	'''
	
	def getGlobalScopeDefinition(Job it)
	'''
		«getContainerOfType(it, IrModule).name.toFirstUpper»Context scope(this, "«it.name»");
	'''
	
	def getGlobalScopeDefinition(InternFunction it)
	'''
		«getContainerOfType(it, IrModule).name.toFirstUpper»Context scope(this, "«it.name»");
	'''
	
	def getLocalScopeDefinition(Job it)
	'''
		«name.toFirstUpper»Context scope(this, "«it.name»");
	'''
	
	def getLocalScopeDefinition(InternFunction it)
	'''
		«name.toFirstUpper»Context scope(this, "«it.name»");
	'''
	
	def getAllArrayShapes(BaseType it)
	{
		// TODO configure context properly?
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
	
	def getPythonInitializeContent(IrModule it)
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
			void «className»::pythonInitialize()
			{
				«val globalContextName = '''«className»Context'''»
				std::vector<std::string> paths;
				std::vector<std::string> scripts;
				if (!python_script.empty())
				{
					paths.emplace_back(python_path);
					scripts.emplace_back(python_script);
				}
				monilog = MoniLog(
						executionEvents,
						paths,
						scripts,
						"«className.toLowerCase»",
						[](py::module_ «className.toLowerCase»_module)
						{
							py::class_<«className»::«globalContextName»>(«className.toLowerCase»_module, "«globalContextName»")
								«val vars = variables.filter[!constExpr]»
								«FOR v : vars SEPARATOR '\n'».def_property_readonly("«v.name»", &«className»::«globalContextName»::get_«v.name»)«ENDFOR»
								.def("__str__", [](«className»::«globalContextName» &self)
									{
										std::ostringstream oss;
										oss << self.name;
										return oss.str();
									})
								.def("__repr__", [](«className»::«globalContextName» &self)
									{
										std::ostringstream oss;
										oss << self.name;
										return oss.str();
									});
							«FOR job : jobs.filter[j|j.hasLocals]»
							«val varDecs = job.eAllContents.filter(VariableDeclaration).filter[v|isUserDefined(v.variable)].toList»
							«val jobContextName = '''«job.codeName.toFirstUpper»Context'''»
							py::class_<«jobContextName», «className»::«globalContextName»>(«className.toLowerCase»_module, "«jobContextName»")«IF varDecs.empty»;«ENDIF»
								«IF !varDecs.empty»
								«FOR local : varDecs SEPARATOR '\n'».def_property_readonly("«local.variable.name»", &«jobContextName»::get_«local.variable.name»)«ENDFOR»;
								«ENDIF»
							«ENDFOR»
							«FOR typeShapeEntry : typeShapes.entrySet»
							«FOR shape : typeShapeEntry.value»
							«val type = typeShapeEntry.key»
							«val cppType = getCppTypeForShape(type, shape)»
							py::class_<«cppType»>(«className.toLowerCase»_module, "«getPythonTypeForShape(type, shape)»")
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
						});
			}
		'''
	}
	
	def getInstrumentation(int event)
	'''
		monilog.trigger(«event», scope);
	'''
	
	def wrapWithGILGuard(EObject it, String guardedContent, String unguardedContent)
	'''
		#ifdef NABLAB_DEBUG
		{
			const bool shouldReleaseGIL = !(«FOR event : #[true, false].flatMap[b|getWriteEvents(b)] SEPARATOR ' && '»!monilog.has_registered_moniloggers(«event»)«ENDFOR»);
			if (shouldReleaseGIL)
			{
				py::gil_scoped_release release;
				«guardedContent»
				py::gil_scoped_acquire acquire;
			}
			else
			{
				«unguardedContent»
			}
		}
		#else
		«unguardedContent»
		#endif
	'''
	
	def getGetSimulateProlog()
	'''
		#ifdef NABLAB_DEBUG
		pythonInitialize();
		#endif
	'''
	
}

@Data
class KokkosPythonEmbeddingContentProvider extends PythonEmbeddingContentProvider
{
	
	override getLocalScopeDefinition(Job it)
	'''
		«name.toFirstUpper»Context scope(this);
		«name.toFirstUpper»Context *scopeRef = &scope;
	'''

	protected def List<String> getArguments(Job it) { #[] }
}

@Data
class KokkosTeamThreadPythonEmbeddingContentProvider extends KokkosPythonEmbeddingContentProvider
{
	override getArguments(Job it)
	{
		// JobCaller never in a team
		if (!hasIterable || it instanceof JobCaller) #[]
		else #["const member_type& teamMember"]
	}
}