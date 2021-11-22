/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.generator.python

import com.google.inject.Inject
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher.MessageType
import fr.cea.nabla.generator.StandaloneGeneratorBase
import fr.cea.nabla.generator.ir.IrRootBuilder
import fr.cea.nabla.ir.generator.GenerationContent
import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.Function
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.nablagen.NablagenApplication
import java.util.List
import java.util.Map

import static extension fr.cea.nabla.ir.IrRootExtensions.*
import fr.cea.nabla.ir.ir.ArgOrVar

class PythonModuleGenerator extends StandaloneGeneratorBase {
	@Inject IrRootBuilder irRootBuilder

	def void generatePythonModule(NablagenApplication ngenApp, String wsPath, String projectName) {
		try {
			val ir = irRootBuilder.buildGeneratorGenericIr(ngenApp)
			dispatcher.post(MessageType.Exec, "Starting instrumentation interface generation")
			val startTime = System.currentTimeMillis

			val srcDirPath = wsPath + '/' + projectName + '/src'
			var fsa = getConfiguredFileSystemAccess(srcDirPath, false)

			val content = getPythonModuleContent(ir)

			generate(fsa, content, ir.dirName)

			val endTime = System.currentTimeMillis
			dispatcher.post(MessageType.Exec,
				"Instrumentation interface generation ended in " + (endTime - startTime) / 1000.0 + "s")
		} catch (Exception e) {
			dispatcher.post(MessageType::Error, '\n***' + e.class.name + ': ' + e.message)
			if (e.stackTrace !== null && !e.stackTrace.empty) {
				val stack = e.stackTrace.head
				dispatcher.post(MessageType::Error,
					'at ' + stack.className + '.' + stack.methodName + '(' + stack.fileName + ':' + stack.lineNumber + ')')
			}
			throw (e)
		}
	}

	def List<GenerationContent> getPythonModuleContent(IrRoot ir) {
		val allJobs = ir.eAllContents.filter[o|o instanceof Job].map[o|o as Job].toList
		val allAssigns = ir.eAllContents.filter[o|o instanceof Affectation].map[o|(o as Affectation).left.target].toList
		val Map<Object, List<ArgOrVar>> allLocals = newHashMap
		allAssigns.filter[a|!(a.eContainer instanceof IrModule)].forEach[a|
			var c = a.eContainer
			var continue = true
			while (c !== null && continue) {
				if (c instanceof Function || c instanceof Job) {
					allLocals.computeIfAbsent(c, [newArrayList]).add(a)
					continue = false
				} else {
					c = c.eContainer
				}
			}
		]
		
		val fileContent =
			'''
				from singleton import *
				
				«FOR j : allJobs SEPARATOR '\n'»
				class «j.name.toFirstUpper»(metaclass=Singleton):
				    pass
				    
				    «FOR l : allLocals.getOrDefault(j, emptyList)»
				    
				    class «l.name.toFirstUpper»(metaclass=Singleton):
				        pass
				    
				    «ENDFOR»
				«ENDFOR»
				
				«FOR a : allAssigns.filter[assign|assign.eContainer instanceof IrModule] SEPARATOR '\n'»
				class «a.name.toFirstUpper»(metaclass=Singleton):
				    pass
				«ENDFOR»
			'''
		
		val content = new GenerationContent(ir.name.toLowerCase + ".py", fileContent, false)
		
		return #[content]
	}

}
