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
import fr.cea.nabla.ir.interpreter.Context
import fr.cea.nabla.ir.interpreter.IrInterpreter
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.IrRoot
import java.util.ArrayList
import java.util.logging.ConsoleHandler
import java.util.logging.Level

import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.Utils.getInstanceName

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
		// Create the interpreter and interprete option values
		val context = ir.interpreteDefinitions
		#{ ir.name + 'Default.json' -> getJsonFileContent(context, ir) }
	}

	private def getJsonFileContent(Context context, IrRoot rootModel)
	'''
		{
			"_comment": "Generated file - Do not overwrite",
			«FOR irModule : rootModel.modules»
			"«irModule.name.toFirstLower»":
			{
				«FOR jsonValue : getJsonValues(context, irModule) SEPARATOR ","»
				"«jsonValue.key»":«jsonValue.value»
				«ENDFOR»
			},
			«ENDFOR»
			"mesh":
			{
			}
		}
	'''

	private def getJsonValues(Context context, IrModule irModule)
	{
		val values = new ArrayList<Pair<String, String>>
		if (irModule.postProcessing !== null)
		{
			values += new Pair('_outputPath_comment', '"empty outputPath to disable output"')
			values += new Pair(Utils.OutputPathNameAndValue.key, '"' + Utils.OutputPathNameAndValue.value + '"')
		}
		for (option : irModule.options)
			values += new Pair(option.name, context.getVariableValue(option).content)
		for (extensionProvider : irModule.extensionProviders)
			values += new Pair(extensionProvider.instanceName, '{}')
		if (irModule.main && levelDB)
		{
			val value = '"empty value to disable, " + Utils.NonRegressionValues.CreateReference.toString + " or " + Utils.NonRegressionValues.CompareToReference.toString + " to take action"'
			values += new Pair('_nonRegression_comment', value)
			values += Utils.NonRegressionNameAndValue
		}
		return values
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