/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir

import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.SimpleVariable
import fr.cea.nabla.ir.ir.Variable
import fr.cea.nabla.ir.transformers.ReplaceUtf8Chars
import java.util.ArrayList

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*

class IrModuleExtensions
{
	static def getAllOptions(IrModule it)
	{
		val options = new ArrayList<SimpleVariable>
		if (postProcessingInfo !== null)
			options.add(postProcessingInfo.periodValue)
		options.addAll(definitions.filter[option])
		return options
	}

	static def getAllDefinitions(IrModule it)
	{
		val options = new ArrayList<SimpleVariable>
		options.addAll(definitions.filter[!option])
		if (postProcessingInfo !== null)
			options.add(postProcessingInfo.lastDumpVariable)
		return options
	}

	static def getJobByName(IrModule it, String jobName)
	{
		jobs.findFirst[j | j.name == jobName]
	}

	static def getVariablesWithDefaultValue(IrModule it)
	{
		definitions.filter[x | !x.option && x.defaultValue!==null]
	}

	static def isLinearAlgebra(IrModule it)
	{
		declarations.filter(ConnectivityVariable).exists[x | x.linearAlgebra]
	}

	static def getVariableByName(IrModule it, String irVarName)
	{
		var Variable variable = definitions.findFirst[j | j.name == irVarName]
		if (variable === null) variable = declarations.findFirst[j | j.name == irVarName]
		return variable
	}

	static def withMesh(IrModule it) { !itemTypes.empty }

	static def getCurrentIrVariable(IrModule m, String nablaVariableName) { getIrVariable(m, nablaVariableName, false) }
	static def getInitIrVariable(IrModule m, String nablaVariableName) { getIrVariable(m, nablaVariableName, true) }

	private static def getIrVariable(IrModule m, String nablaVariableName, boolean initTimeIterator)
	{
		val irVariableName = ReplaceUtf8Chars.getNoUtf8(nablaVariableName)
		var irVariable = getVariableByName(m, irVariableName)
		if (irVariable === null && m.mainTimeLoop !== null) 
		{
			val timeLoopVariable = m.mainTimeLoop.variables.findFirst[x | x.name == irVariableName]
			if (timeLoopVariable !== null) 
			{
				if (initTimeIterator && timeLoopVariable.init !== null) 
					irVariable = timeLoopVariable.init
				else
					irVariable = timeLoopVariable.current
			}
		}
		return irVariable
	}
}
