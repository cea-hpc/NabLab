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

import static fr.cea.nabla.ir.Utils.getCurrentIrVariable

class TagPersistentVariables implements IrTransformationStep
{
	val HashMap<String, String> dumpedVariables // variable name, persistence name (name displayed in visualisation)
	val double periodValue
	val String periodVariableName
	val ArrayList<String> traces

	new(HashMap<String, String> dumpedVariables, double periodValue, String periodVariableName)
	{
		this.dumpedVariables = dumpedVariables
		this.periodValue = periodValue
		this.periodVariableName = periodVariableName
		this.traces = new ArrayList<String>
	}

	override getDescription()
	{
		'Tag variables as persistent'
	}

	override transform(IrModule m)
	{
		// Create InSituJob
		val inSituJob = IrFactory.eINSTANCE.createInSituJob
		inSituJob.name = 'dumpVariables'
		inSituJob.periodValue = periodValue

		val periodVariable = getCurrentIrVariable(m, periodVariableName)
		if (periodVariable === null) return false
		inSituJob.periodVariable = periodVariable as SimpleVariable

		for (key : dumpedVariables.keySet)
		{
			val v = getCurrentIrVariable(m, key)
			if (v !== null) 
			{
				v.persistenceName = dumpedVariables.get(key)
				inSituJob.dumpedVariables += v
			}
		}
		m.jobs += inSituJob

		// Create a variable to count the number of Calls
		val f = IrFactory.eINSTANCE
		val nbCallsVariable = f.createSimpleVariable =>
		[
			name = "nbCalls"
			type = f.createBaseType => [ primitive = PrimitiveType::INT ]
			defaultValue = f.createIntConstant => [ value = 0 ]
		]
		m.variables += nbCallsVariable
		inSituJob.nbCalls = nbCallsVariable

		// Create a variable to store the last write time
		val periodVariableType = (periodVariable as SimpleVariable).type
		val lastDumpVariable = f.createSimpleVariable =>
		[
			name = "lastDump"
			type = EcoreUtil::copy(periodVariableType)
			defaultValue = periodVariableType.primitive.defaultValue
		]
		m.variables += lastDumpVariable
		inSituJob.lastDumpVariable = lastDumpVariable

		return true
	}

	override getOutputTraces()
	{
		traces
	}

	private def getDefaultValue(PrimitiveType t)
	{
		switch t
		{
			case BOOL: IrFactory.eINSTANCE.createBoolConstant => [ value = false ]
			case INT: IrFactory.eINSTANCE.createIntConstant => [ value = 0 ]
			case REAL: IrFactory.eINSTANCE.createRealConstant => [ value = 0.0 ]
		}
	}
}