/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.json

import fr.cea.nabla.ir.Utils
import fr.cea.nabla.ir.generator.CodeGenerator
import fr.cea.nabla.ir.interpreter.IrInterpreter
import fr.cea.nabla.ir.ir.IrRoot
import java.util.logging.ConsoleHandler
import java.util.logging.Level

import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.IrRootExtensions.*

class Ir2Json extends CodeGenerator 
{
	val extension NablaValueExtensions nve = new NablaValueExtensions
	val boolean levelDB

	new(boolean levelDB)
	{
		super('Json')
		this.levelDB = levelDB
	}

	override getFileContentsByName(IrRoot ir)
	{
		#{ name + 'Default.json' -> ir.jsonFileContent }
	}

	private def getJsonFileContent(IrRoot ir)
	{
		// Create the interpreter and interprete option values
		val context = ir.interpreteDefinitions
		val options = ir.options

		// Create Json
		'''
		{
			"_comment": "Generated file - Do not overwrite",
			"options":
			{
				«IF ir.postProcessing !== null»
				"_outputPath_comment":"empty outputPath to disable output",
				"«Utils.OutputPathNameAndValue.key»":"«Utils.OutputPathNameAndValue.value»"«IF levelDB || !options.empty»,«ENDIF»
				«ENDIF»
				«FOR i : 0..<options.length»
				"«options.get(i).name»":«context.getVariableValue(options.get(i)).content»«IF i<options.length -1 || levelDB»,«ENDIF»
				«ENDFOR»
				«IF levelDB»
				"_nonRegression_comment":"empty value to disable, «Utils.NonRegressionValues.CreateReference.toString» or «Utils.NonRegressionValues.CompareToReference.toString» to take action",
				"«Utils.NonRegressionNameAndValue.key»":"«Utils.NonRegressionNameAndValue.value»"
				«ENDIF»
			},
			"mesh":{}«IF !ir.mainModule.allProviders.empty»,«ENDIF»
			«FOR s : ir.mainModule.allProviders SEPARATOR ","»
			"«s.toFirstLower»":{}
			«ENDFOR»
		}
		'''
	}

	private def interpreteDefinitions(IrRoot ir)
	{
		val handler = new ConsoleHandler
		handler.level = Level::OFF
		val irInterpreter = new IrInterpreter(ir, handler)
		irInterpreter.interpreteOptionsDefaultValues
		return irInterpreter.context
	}
}