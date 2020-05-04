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

import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.SimpleVariable

import static fr.cea.nabla.ir.Utils.*

class SetSimulationVariables implements IrTransformationStep
{
	val String timeVariableName
	val String timeStepVariableName
	val String nodeCoordVariableName

	new(String timeVariableName, String timeStepVariableName, String nodeCoordVariableName)
	{
		this.timeVariableName = timeVariableName
		this.timeStepVariableName = timeStepVariableName
		this.nodeCoordVariableName = nodeCoordVariableName
	}

	override getDescription()
	{
		'Set simulation variables (time, time step and node coordinates)'
	}

	override transform(IrModule m)
	{
		m.initNodeCoordVariable = getInitIrVariable(m, nodeCoordVariableName) as ConnectivityVariable
		m.nodeCoordVariable = getCurrentIrVariable(m, nodeCoordVariableName) as ConnectivityVariable
		m.nodeCoordVariable.const = false
		m.timeVariable = getCurrentIrVariable(m, timeVariableName) as SimpleVariable
		m.deltatVariable = getCurrentIrVariable(m, timeStepVariableName) as SimpleVariable
		return true
	}

	override getOutputTraces()
	{
		#[]
	}
}