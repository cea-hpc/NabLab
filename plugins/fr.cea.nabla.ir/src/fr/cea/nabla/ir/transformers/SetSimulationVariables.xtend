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

import static fr.cea.nabla.ir.IrModuleExtensions.*

class SetSimulationVariables extends IrTransformationStep
{
	val String meshClassName
	val String timeVariableName
	val String timeStepVariableName
	val String nodeCoordVariableName

	new(String meshClassName, String timeVariableName, String timeStepVariableName, String nodeCoordVariableName)
	{
		super('Set simulation variables (time, time step and node coordinates)')
		this.meshClassName = meshClassName
		this.timeVariableName = timeVariableName
		this.timeStepVariableName = timeStepVariableName
		this.nodeCoordVariableName = nodeCoordVariableName
	}

	override transform(IrModule m)
	{
		trace('IR -> IR: ' + description)
		m.meshClassName = meshClassName
		m.initNodeCoordVariable = getInitIrVariable(m, nodeCoordVariableName) as ConnectivityVariable
		m.nodeCoordVariable = getCurrentIrVariable(m, nodeCoordVariableName) as ConnectivityVariable
		m.timeVariable = getCurrentIrVariable(m, timeVariableName) as SimpleVariable
		m.deltatVariable = getCurrentIrVariable(m, timeStepVariableName) as SimpleVariable
		return true
	}
}