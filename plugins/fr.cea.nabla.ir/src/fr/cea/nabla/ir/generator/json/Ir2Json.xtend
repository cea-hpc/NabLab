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

import fr.cea.nabla.ir.generator.CodeGenerator
import fr.cea.nabla.ir.interpreter.Context
import fr.cea.nabla.ir.interpreter.ModuleInterpreter
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.SimpleVariable
import fr.cea.nabla.ir.transformers.TagOutputVariables
import java.util.logging.ConsoleHandler
import java.util.logging.Level
import fr.cea.nabla.ir.Utils

import static extension fr.cea.nabla.ir.IrModuleExtensions.*

class Ir2Json extends CodeGenerator 
{
	val extension NablaValueExtensions nve = new NablaValueExtensions
	val boolean levelDB

	new(boolean levelDB)
	{
		super('Json')
		this.levelDB = levelDB
	}

	override getFileContentsByName(IrModule it)
	{
		#{ name + 'DefaultOptions.json' -> jsonFileContent }
	}

	private def getJsonFileContent(IrModule it)
	{
		// Create the interpreter and interprete option values
		val context = interpreteDefinitions
		val options = allOptions

		// Create Json
		'''
		{
			"_comment": "Generated file - Do not overwrite",
			«IF postProcessingInfo !== null»
			"_outputPath_comment":"empty outputPath to disable output",
			"«TagOutputVariables.OutputPathNameAndValue.key»":"«TagOutputVariables.OutputPathNameAndValue.value»",
			«ENDIF»
			«IF levelDB»
			"_nonRegression_comment":"empty value to disable, CreateReference or CompareToReference to take action",
			"«Utils.NonRegressionNameAndValue.key»":"«Utils.NonRegressionNameAndValue.value»"«IF !options.empty»,«ENDIF»
			«ENDIF»
			«FOR o : options SEPARATOR ","»
			"«o.name»":«getValue(o, context).content»
			«ENDFOR»
		}
		'''
	}

	private def interpreteDefinitions(IrModule it)
	{
		val handler = new ConsoleHandler
		handler.level = Level::OFF
		val moduleInterpreter = new ModuleInterpreter(it, handler)
		moduleInterpreter.interpreteDefinitionsDefaultValues
		return moduleInterpreter.context
	}

	private def getValue(SimpleVariable option, Context context)
	{
		context.getVariableValue(option)
	}
}