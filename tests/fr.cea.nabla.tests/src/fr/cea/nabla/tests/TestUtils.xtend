/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.tests

import fr.cea.nabla.ir.interpreter.Context
import fr.cea.nabla.ir.interpreter.NV0Real
import fr.cea.nabla.ir.interpreter.NablaValue
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.SimpleVariable
import fr.cea.nabla.nabla.Affectation
import fr.cea.nabla.nabla.Connectivity
import fr.cea.nabla.nabla.ConnectivityCall
import fr.cea.nabla.nabla.SimpleVarDefinition
import fr.cea.nabla.nabla.Var
import fr.cea.nabla.nabla.VarGroupDeclaration
import java.nio.file.Files
import java.nio.file.Paths
import java.util.ArrayList
import org.eclipse.emf.ecore.EObject
import org.junit.Assert

import static extension fr.cea.nabla.ConnectivityCallExtensions.*
import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.interpreter.ExpressionInterpreter.*

class TestUtils 
{
	public static val DoubleTolerance = 1e-15

	def getAllVars(EObject it)
	{
		val allVariables = new ArrayList<Var>
		for (i : eAllContents.toIterable)
			switch i
			{
				VarGroupDeclaration : allVariables += i.variables
				SimpleVarDefinition : allVariables += i.variable
			}
		return allVariables
	}

	def getAllAffectations(EObject it)
	{
		eAllContents.filter(Affectation)
	}

	// ===== CharSequence utils =====

	def getVarByName(EObject it, String variableName)
	{
		allVars.findFirst[v | v.name == variableName]
	}

	def getVarAffectationByName(EObject it, String variableName)
	{
		allAffectations.findFirst[a | a.left.target.name == variableName]
	}

	def getConnectivityCallFor(EObject it, Connectivity connectivity)
	{
		eAllContents.filter(ConnectivityCall).findFirst[ cc | cc.connectivity == connectivity]
	}

	// ===== CharSequence utils =====
	private def String getEmptyTestModule()
	'''
	module Test;
	with Math.*;
	'''

	//TODO These options should be filled in nablagen
	private def String getMandatoryOptions(int xQuads, int yQuads)
	'''
	const ℝ X_EDGE_LENGTH = 0.01;
	const ℝ Y_EDGE_LENGTH = X_EDGE_LENGTH;
	const ℕ X_EDGE_ELEMS = «xQuads»;
	const ℕ Y_EDGE_ELEMS = «yQuads»;
	'''

	def String getSimulationVariables()
	'''
	ℝ t = 0.0;
	ℝ δt = 0.001;
	ℝ[2] X{nodes};
	'''

	def String getMandatoryOptions()
	{
		return getMandatoryOptions(10, 10)
	}

	def CharSequence getDefaultConnectivities()
	'''
	itemtypes { node, cell }

	set nodes: → {node};
	set cells: → {cell};
	set nodesOfCell: cell → {node};
	'''

	def CharSequence getNodesConnectivity()
	'''
	itemtypes { node }

	set nodes: → {node};
	'''

	def CharSequence getTestModule()
	{
		emptyTestModule + mandatoryOptions
	}

	def CharSequence getTestModuleForSimulation()
	{
		emptyTestModule + nodesConnectivity + mandatoryOptions + getSimulationVariables
	}

	def CharSequence getTestModule(CharSequence connectivities, CharSequence functions)
	{
		emptyTestModule + connectivities + functions + mandatoryOptions
	}

	def CharSequence getTestModule(int xQuads, int yQuads)
	{
		emptyTestModule + defaultConnectivities + getMandatoryOptions(xQuads, yQuads) + getSimulationVariables
	}

	def getTestGenModel()
	{
		'''
		with Test.*;

		workflow TestDefaultGenerationChain transforms Test
		{
			Nabla2Ir nabla2ir
			{
				timeVariable = t;
				deltatVariable = δt;
				nodeCoordVariable = X;
			}
			ReplaceUtf replaceUtf follows nabla2ir
			{
			}
			ReplaceReductions replaceReductions follows replaceUtf
			{
			}
			OptimizeConnectivities optimizeConnectivities follows replaceReductions
			{
				connectivities = nodes;
			}
			FillHLTs fillHlts follows optimizeConnectivities
			{
			}
		}
		'''
	}

	// Interpreter asserts
	def assertVariableDefaultValue(IrModule irModule, Context context, String variableName, NablaValue value)
	{
		Assert.assertEquals(value, (irModule.getVariableByName(variableName) as SimpleVariable).defaultValue.interprete(context))
	}

	def dispatch assertVariableValueInContext(IrModule irModule, Context context, String variableName, NablaValue value)
	{
		Assert.assertEquals(value, context.getVariableValue(irModule.getVariableByName(variableName)))
	}

	def dispatch assertVariableValueInContext(IrModule irModule, Context context, String variableName, NV0Real value)
	{
		val variableValue = context.getVariableValue(irModule.getVariableByName(variableName))
		Assert.assertNotNull(variableValue)
		Assert.assertTrue(variableValue instanceof NV0Real)
		Assert.assertEquals(value.data, (variableValue as NV0Real).data, TestUtils.DoubleTolerance)
	}

	//Read File to String
	def readFileAsString(String filePath)
	{
		new String(Files.readAllBytes(Paths.get(filePath)))
	}
}