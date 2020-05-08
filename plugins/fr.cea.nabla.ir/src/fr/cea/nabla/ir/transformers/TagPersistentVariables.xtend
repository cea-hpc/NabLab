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
import java.util.ArrayList
import java.util.HashMap
import org.eclipse.emf.ecore.util.EcoreUtil

import static fr.cea.nabla.ir.IrModuleExtensions.getCurrentIrVariable

class TagPersistentVariables implements IrTransformationStep
{
	public static val OutputPathNameAndValue = new Pair<String, String>("outputPath", "output")

	val HashMap<String, String> dumpedVariables // variable name, persistence name (name displayed in visualisation)
	val String periodReferenceVarName
	val ArrayList<String> traces

	new(HashMap<String, String> dumpedVariables, String periodReferenceVarName)
	{
		this.dumpedVariables = dumpedVariables
		this.periodReferenceVarName = periodReferenceVarName
		this.traces = new ArrayList<String>
	}

	override getDescription()
	{
		'Tag variables as persistent'
	}

	override transform(IrModule m)
	{
		val f = IrFactory.eINSTANCE
		val ppInfo = f.createPostProcessingInfo
		val periodReferenceVar = getCurrentIrVariable(m, periodReferenceVarName)
		if (periodReferenceVar === null) return false
		ppInfo.periodReference = periodReferenceVar as SimpleVariable

		for (key : dumpedVariables.keySet)
		{
			val v = getCurrentIrVariable(m, key)
			if (v !== null) 
			{
				v.persistenceName = dumpedVariables.get(key)
				ppInfo.postProcessedVariables += v
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
		m.definitions += lastDumpVariable
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
		m.definitions.add(0, periodValueVariable)
		ppInfo.periodValue = periodValueVariable

		return true
	}

	override getOutputTraces()
	{
		traces
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