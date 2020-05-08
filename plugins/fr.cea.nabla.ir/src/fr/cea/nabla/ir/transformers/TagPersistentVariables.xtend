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
	val String periodValueVarName
	val String periodReferenceVarName
	val ArrayList<String> traces

	new(HashMap<String, String> dumpedVariables, String periodValueVarName, String periodReferenceVarName)
	{
		this.dumpedVariables = dumpedVariables
		this.periodValueVarName = periodValueVarName
		this.periodReferenceVarName = periodReferenceVarName
		this.traces = new ArrayList<String>
	}

	override getDescription()
	{
		'Tag variables as persistent'
	}

	override transform(IrModule m)
	{
		val ppInfo = IrFactory.eINSTANCE.createPostProcessingInfo

		val periodValueVar = getCurrentIrVariable(m, periodValueVarName)
		if (periodValueVar === null) return false
		ppInfo.periodValue = periodValueVar as SimpleVariable

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
		val lastDumpVariable = IrFactory.eINSTANCE.createSimpleVariable =>
		[
			name = "lastDump"
			type = EcoreUtil::copy(periodVariableType)
			const = false
			constExpr = false
			option = false
			defaultValue = periodVariableType.primitive.defaultValue
		]
		m.definitions += lastDumpVariable
		ppInfo.lastDumpVariable = lastDumpVariable

		return true
	}

	override getOutputTraces()
	{
		traces
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