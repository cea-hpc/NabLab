/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.PrimitiveType
import fr.cea.nabla.ir.ir.SimpleVariable
import java.util.HashMap
import org.eclipse.emf.ecore.util.EcoreUtil

import static fr.cea.nabla.ir.IrModuleExtensions.getCurrentIrVariable

class TagOutputVariables extends IrTransformationStep
{
	public static val OutputPathNameAndValue = new Pair<String, String>("outputPath", "output")

	val HashMap<String, String> outputVariables // variable name, output name
	val String periodReferenceVarName

	new(HashMap<String, String> outputVariables, String periodReferenceVarName)
	{
		super('Tag output variables')
		this.outputVariables = outputVariables
		this.periodReferenceVarName = periodReferenceVarName
	}

	override transform(IrModule m)
	{
		trace('IR -> IR: ' + description)
		val f = IrFactory.eINSTANCE
		val ppInfo = f.createPostProcessingInfo
		val periodReferenceVar = getCurrentIrVariable(m, periodReferenceVarName)
		if (periodReferenceVar === null) return false
		ppInfo.periodReference = periodReferenceVar as SimpleVariable

		for (key : outputVariables.keySet)
		{
			val v = getCurrentIrVariable(m, key)
			if (v !== null) 
			{
				v.outputName = outputVariables.get(key)
				ppInfo.outputVariables += v
			}
		}
		m.postProcessingInfo = ppInfo

		// Create a variable to store the last write time
		val periodVariableType = ppInfo.periodReference.type
		val lastDumpVariable = f.createSimpleVariable =>
		[
			name = "lastDump"
			type = EcoreUtil::copy(periodVariableType)
			const = false
			constExpr = false
			option = false
			defaultValue = periodVariableType.primitive.lastDumpDefaultValue
		]
		ppInfo.lastDumpVariable = lastDumpVariable

		// Create an option to store the output period
		val periodValueVariable = f.createSimpleVariable =>
		[
			name = "outputPeriod"
			type = EcoreUtil::copy(periodVariableType)
			const = false
			constExpr = false
			option = true
			defaultValue = periodVariableType.primitive.outputPeriodDefaultValue
		]
		ppInfo.periodValue = periodValueVariable

		return true
	}

	private def getLastDumpDefaultValue(PrimitiveType t)
	{
		val f =  IrFactory.eINSTANCE
		switch t
		{
			case BOOL: f.createBoolConstant => [ value = false ]
			default: f.createMinConstant => [ type = f.createBaseType => [ primitive = t] ]
		}
	}

	private def getOutputPeriodDefaultValue(PrimitiveType t)
	{
		val f =  IrFactory.eINSTANCE
		switch t
		{
			case INT: f.createIntConstant => [value = 1]
			case REAL: f.createRealConstant => [value = 1.0]
			default: throw new RuntimeException("Unsupported type for output period variable")
		}
	}
}