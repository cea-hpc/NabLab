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

import fr.cea.nabla.ir.IrUtils
import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.Function
import fr.cea.nabla.ir.ir.Instruction
import fr.cea.nabla.ir.ir.InternFunction
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.ItemIndexDefinition
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.VariableDeclaration
import java.util.Collection
import java.util.List
import java.util.Map
import java.util.Set
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtend.lib.annotations.Data

import static fr.cea.nabla.ir.IrUtils.*

import static extension fr.cea.nabla.ir.IrModuleExtensions.*
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
			executionEvents.computeIfAbsent(jobEventName, [executionEvents.size])
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
					.forEach[v|
						val assignEventName = '''«jobEventName».«v.name.toFirstUpper»'''
						if (!executionEvents.containsKey(assignEventName))
						{
							val eventIndex = executionEvents.size
							executionEvents.put(assignEventName, eventIndex)
							if (v.eContainer instanceof IrModule)
							{
								globalVariableWriteEvents.computeIfAbsent(v.name.toFirstUpper, [newArrayList]).add(eventIndex)
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
	
	def dispatch int getExecutionEvent(Job it)
	{
		val eventName = name.toFirstUpper
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
	
	def dispatch int getExecutionEvent(VariableDeclaration it)
	{
		val container = getContainerName(it).toFirstUpper
		val eventName = '''«container».«variable.name.toFirstUpper»'''
		return executionEvents.get(eventName)
	}
	
	def dispatch int getExecutionEvent(Affectation it)
	{
		val container = getContainerName(it).toFirstUpper
		val eventName = '''«container».«left.target.name.toFirstUpper»'''
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
		const rapidjson::Value &valueof_pythonPath = options["pythonPath"];
		assert(valueof_pythonPath.IsString());
		pythonPath = valueof_pythonPath.GetString();
	}
	if (options.HasMember("pythonFile"))
	{
		const rapidjson::Value &valueof_pythonFile = options["pythonFile"];
		assert(valueof_pythonFile.IsString());
		pythonFile = valueof_pythonFile.GetString();
	}
	#endif
	'''
	
	
	def getWrapperDeclarationContent(Job it)
	'''
		void «codeName»Wrapper() noexcept;'''
	
	def getPointerDeclarationContent(Job it)
	'''
		void («getContainerOfType(it, IrModule).className»::*«codeName»Ptr)();'''
	
	def getGlobalScopeStructContent(IrModule it)
	'''
		struct «name.toFirstUpper»Context
		{
			«FOR v : variables»
			«IF !v.constExpr»
				«IF v.const»const «ENDIF»«getCppType(v.type)» get_«v.name»() const {return instance->«v.name»;}
			«ENDIF»
			«ENDFOR»
			
			«name.toFirstUpper» *instance = nullptr;
			
			«name.toFirstUpper»Context(«name.toFirstUpper» *instance) : instance(instance) {}
			«name.toFirstUpper»Context() : instance(nullptr) {}
			
			virtual ~«name.toFirstUpper»Context() = default;
		};
	'''
	
	def getLocalScopeStructContent(InternFunction it)
	{
		return getLocalScopeStructContent(it, name.toFirstUpper)
	}
	
	def getLocalScopeStructContent(Job it)
	{
		return getLocalScopeStructContent(it, name.toFirstUpper)
	}
	
	def getLocalScopeStructContent(EObject it, String name)
	{
		val moduleName = getContainerOfType(it, IrModule).name.toFirstUpper
		val locals = eAllContents.filter(VariableDeclaration).toMap[d|d.variable.name].values
		return getLocalScopeStructContent(name + "Context", moduleName, locals)
	}
	
	def getLocalScopeStructContent(String name, String moduleName, Collection<VariableDeclaration> locals)
	'''
		struct «name» : «moduleName»::«moduleName»Context
		{
			«IF !locals.empty»
			«FOR local : locals»
			const py::object get_«local.variable.name»() const { if («local.variable.name» != nullptr) return py::cast(*«local.variable.name»); else return py::cast<py::none>(Py_None); }
			«ENDFOR»
			
			«FOR local : locals»
			«IF local.variable.const»const «ENDIF»«local.variable.type.cppType» *«local.variable.name» = nullptr;
			«ENDFOR»
			
			«ENDIF»
			using «moduleName»::«moduleName»Context::«moduleName»Context;
		};
		
	'''
	
	def getWrapperDefinitionContent(Job it)
	'''
		«wrapperComment»
		void «IrUtils.getContainerOfType(it, IrModule).className»::«codeName»Wrapper() noexcept
		{
			«getBeforeInstrumentation(executionEvent, GLOBAL_SCOPE)»
			«codeName»();
			«getAfterInstrumentation(executionEvent, GLOBAL_SCOPE)»
		}
	'''
	
	def getLocalScopeDefinition(Job it)
	'''
		«name.toFirstUpper»Context scope(this);
	'''
	
	def getLocalScopeDefinition(InternFunction it)
	'''
		«name.toFirstUpper»Context scope(this);
	'''
	
	def getSetFunctionPtrContent(IrModule it)
	'''
		void «className»::setFunctionPtr(int idx, bool wrapper)
		{
			if (wrapper)
			{
				switch (idx)
				{
					«FOR e : callExecutionEvents.sortBy[k|executionEvents.get(k)]»
					case «executionEvents.get(e)»:
						«e.substring(e.lastIndexOf('.')+1).toFirstLower»Ptr = &«className»::«e.substring(e.lastIndexOf('.')+1).toFirstLower»Wrapper;
						break;
					«ENDFOR»
				}
			}
			else
			{
				switch (idx)
				{
					«FOR e : callExecutionEvents.sortBy[k|executionEvents.get(k)]»
					case «executionEvents.get(e)»:
						«e.substring(e.lastIndexOf('.')+1).toFirstLower»Ptr = &«className»::«e.substring(e.lastIndexOf('.')+1).toFirstLower»;
						break;
					«ENDFOR»
				}
			}
		}
	'''
	
	def getPythonInitializeContent(IrModule it)
	'''
		void «className»::pythonInitialize()
		{
			py::module_::import("sys").attr("path").attr("append")(pythonPath);
			py::module_ «className.toLowerCase»Module = py::module_::import("«className.toLowerCase»");
			«val globalContextName = '''«className»Context'''»
			py::class_<«className»::«globalContextName»>(«className.toLowerCase»Module, "«globalContextName»")
				«val vars = variables.filter[!constExpr]»
				«FOR v : vars SEPARATOR '\n'».def_property_readonly("«v.name»", &«className»::«globalContextName»::get_«v.name»)«ENDFOR»;
			«FOR job : jobs»
			«val varDecs = job.eAllContents.filter(VariableDeclaration).toList»
			«val jobContextName = '''«job.codeName.toFirstUpper»Context'''»
			py::class_<«jobContextName», «className»::«globalContextName»>(«className.toLowerCase»Module, "«jobContextName»")«IF varDecs.empty»;«ENDIF»
				«IF !varDecs.empty»
				«FOR local : varDecs SEPARATOR '\n'».def_property_readonly("«local.variable.name»", &«jobContextName»::get_«local.variable.name»)«ENDFOR»;
				«ENDIF»
			«ENDFOR»
			py::module_ monilogModule = py::module_::import("monilog");
			monilogModule.def("_register_before", [&](py::str event, py::function monilogger)
			{
				try
				{
					std::vector<int> indexes = executionEvents.at(event);
					for (auto idx : indexes)
					{
						std::list<py::function> beforeMoniloggers = before[idx];
						std::list<py::function>::iterator it = std::find(beforeMoniloggers.begin(), beforeMoniloggers.end(), monilogger);
						if (it == beforeMoniloggers.end())
						{
							before[idx].push_back(monilogger);
							setFunctionPtr(idx, true);
						}
					}
				}
				catch (const std::out_of_range& e)
				{
					std::cout << "No event named " << event << " was found." << std::endl;
				}
			});
			monilogModule.def("_register_after", [&](py::str event, py::function monilogger)
			{
				try
				{
					std::vector<int> indexes = executionEvents.at(event);
					for (auto idx : indexes)
					{
						std::list<py::function> afterMoniloggers = after[idx];
						std::list<py::function>::iterator it = std::find(afterMoniloggers.begin(), afterMoniloggers.end(), monilogger);
						if (it == afterMoniloggers.end())
						{
							after[idx].push_back(monilogger);
							setFunctionPtr(idx, true);
						}
					}
				}
				catch (const std::out_of_range& e)
				{
					std::cout << "No event named " << event << " was found." << std::endl;
				}
			});
			monilogModule.def("_stop", [&](py::str event, py::function monilogger)
			{
				try
				{
					std::vector<int> indexes = executionEvents.at(event);
					for (auto idx : indexes)
					{
						{
							std::list<py::function> beforeMoniloggers = before[idx];
							std::list<py::function>::iterator it = std::find(beforeMoniloggers.begin(), beforeMoniloggers.end(), monilogger);
							if (it != beforeMoniloggers.end())
							{
								beforeMoniloggers.erase(it);
								before[idx] = beforeMoniloggers;
								if (beforeMoniloggers.empty() && after[idx].empty())
								{
									setFunctionPtr(idx, false);
								}
							}
						}
						{
							std::list<py::function> afterMoniloggers = after[idx];
							std::list<py::function>::iterator it = std::find(afterMoniloggers.begin(), afterMoniloggers.end(), monilogger);
							if (it != afterMoniloggers.end())
							{
								afterMoniloggers.erase(it);
								after[idx] = afterMoniloggers;
								if (before[idx].empty() && afterMoniloggers.empty())
								{
									switch (idx)
									{
										setFunctionPtr(idx, false);
									}
								}
							}
						}
					}
				}
				catch (const std::out_of_range& e)
				{
					std::cout << "No event named " << event << " was found." << std::endl;
				}
			});
			if (pythonFile != "")
			{
				py::module_ pScript = py::module_::import(pythonFile.c_str());
			}
		}
	'''
	
	def getBeforeInstrumentation(int event, String scope)
	'''
		{
			std::list<py::function> beforeMoniloggers = before[«event»];
			for (py::function monilogger : beforeMoniloggers)
			{
				monilogger(«scope»);
			}
		}
	'''
	
	def getAfterInstrumentation(int event, String scope)
	'''
		{
			std::list<py::function> afterMoniloggers = after[«event»];
			for (py::function monilogger : afterMoniloggers)
			{
				monilogger(«scope»);
			}
		}
	'''
	
}