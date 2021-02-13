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
import fr.cea.nabla.nabla.NablaFactory
import fr.cea.nabla.nabla.SimpleVarDeclaration
import fr.cea.nabla.nabla.Var
import fr.cea.nabla.nabla.VarGroupDeclaration
import java.nio.file.Files
import java.nio.file.Paths
import java.util.ArrayList
import org.eclipse.emf.ecore.EObject
import org.junit.Assert

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
				SimpleVarDeclaration : allVariables += i.variable
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
	def String getJsonDefaultContent() { getJsonContent(10,10) }
	def String getJsonContent(int nbXQuads, int nbYQuads)
	'''
		{
			"test":
			{
			},
			"mesh":
			{
				"nbXQuads":«nbXQuads»,
				"nbYQuads":«nbYQuads»,
				"xSize":0.01,
				"ySize":0.01
			}
		}
	'''

	def getSimulationVariables()
	'''
		let ℝ δt = 0.001;
		ℝ t;
	'''

	def getDefaultConnectivities()
	'''
		itemtypes { node, cell }

		connectivity nodes: → {node};
		connectivity cells: → {cell};
		connectivity nodesOfCell: cell → {node};
	'''

	def getEmptyTestModule()
	'''
		module Test;
		with Math.*;
	'''

	def getTestModuleForSimulation()
	'''
		«emptyTestModule»
		«defaultConnectivities»
		«simulationVariables»
	'''

	def getTestGenModel()
	'''
		Application Test;

		MainModule Test test
		{
			meshClassName = "CartesianMesh2D";
			nodeCoord = X;
			time = t;
			timeStep = δt;
		}
	'''

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

	def createIntConstant(int v)
	{
		NablaFactory::eINSTANCE.createIntConstant =>
		[
			value = v
		]
	}

	def createCardExpression(Connectivity c)
	{
		val connectivityCall = NablaFactory.eINSTANCE.createConnectivityCall => [ connectivity = c ]
		NablaFactory.eINSTANCE.createCardinality => [ container = connectivityCall ]	
	}

	static def simplifyPath(String path)
	{
		path.replace("NablaExamples/../NablaExamples/", "NablaExamples/")
	}
}