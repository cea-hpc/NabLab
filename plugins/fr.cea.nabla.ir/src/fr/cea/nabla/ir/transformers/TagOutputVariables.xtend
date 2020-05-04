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

import static fr.cea.nabla.ir.Utils.getCurrentIrVariable

class TagOutputVariables extends IrTransformationStep
{
	public static val ANNOTATION_SOURCE = "output"
	public static val ANNOTATION_DETAIL = "output-name"

	val HashMap<String, String> outputVariables // variable name, output name
	val double periodValue
	val String periodVariableName

	new(HashMap<String, String> outputVariables, double periodValue, String periodVariableName)
	{
		super('Tag output variables')
		this.outputVariables = outputVariables
		this.periodValue = periodValue
		this.periodVariableName = periodVariableName
	}

	override transform(IrModule m)
	{
		trace('IR -> IR: ' + description + '\n')
		val ppInfo = IrFactory.eINSTANCE.createPostProcessingInfo
		ppInfo.periodValue = periodValue

		val periodVariable = getCurrentIrVariable(m, periodVariableName)
		if (periodVariable === null) return false
		ppInfo.periodVariable = periodVariable as SimpleVariable

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
		val periodVariableType = (periodVariable as SimpleVariable).type
		val lastDumpVariable = IrFactory.eINSTANCE.createSimpleVariable =>
		[
			name = "lastDump"
			type = EcoreUtil::copy(periodVariableType)
			defaultValue = periodVariableType.primitive.defaultValue
		]
		m.variables += lastDumpVariable
		ppInfo.lastDumpVariable = lastDumpVariable

		return true
	}

	private def getDefaultValue(PrimitiveType t)
	{
		val f =  IrFactory.eINSTANCE
		switch t
		{
			case BOOL: f.createBoolConstant => [ value = false ]
			default: f.createMinConstant => [ type = f.createBaseType => [ primitive = t] ]
		}
	}
}