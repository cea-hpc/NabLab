/*******************************************************************************
 * Copyright (c) 2022 CEA
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
import fr.cea.nabla.nabla.Affectation
import fr.cea.nabla.nabla.Connectivity
import fr.cea.nabla.nabla.ConnectivityCall
import fr.cea.nabla.nabla.NablaFactory
import java.nio.file.Files
import java.nio.file.Paths
import org.eclipse.emf.ecore.EObject
import org.junit.Assert

import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.interpreter.ExpressionInterpreter.*

class TestUtils
{
	public static val DoubleTolerance = 1e-15

	public static val TestProjectPath = System.getProperty("user.dir")
	public static val PluginsBasePath = TestProjectPath.replace("/tests/fr.cea.nabla.tests", "/plugins/fr.cea.nabla")
	public static val AssertPath = PluginsBasePath + "/nablalib/Assert.n"
	public static val MathPath = PluginsBasePath + "/nablalib/Math.n"
	public static val CartesianMesh2DPath = PluginsBasePath + "/nablalib/CartesianMesh2D.n"
	public static val LinearAlgebraPath = PluginsBasePath + "/nablalib/LinearAlgebra.n"
	public static val CartesianMesh2DGenPath = PluginsBasePath + "/nablalib/CartesianMesh2D.ngen"
	public static val LinearAlgebraGenPath = PluginsBasePath + "/nablalib/LinearAlgebra.ngen"

	def runningOnCI()
	{
		return isPush() || isPullRequest()
	}

	def isPush()
	{
		val event = System.getenv("GITHUB_EVENT_NAME") // $NON-NLS-1$
		return System.getenv("CI") !== null && event.equals("push") // $NON-NLS-1$ //$NON-NLS-2$
	}

	def isPullRequest()
	{
		val event = System.getenv("GITHUB_EVENT_NAME") // $NON-NLS-1$
		return System.getenv("CI") !== null && event.equals("pull_request") // $NON-NLS-1$ //$NON-NLS-2$
	}

	def getAllAffectations(EObject it)
	{
		eAllContents.filter(Affectation)
	}

	def getVarAffectationByName(EObject it, String variableName)
	{
		allAffectations.findFirst[a | a.left.target.name == variableName]
	}

	def getAllConnectivityCalls(EObject it)
	{
		eAllContents.filter(ConnectivityCall).toList
	}

	def String getJsonDefaultContent()
	{
		getJsonContent(10,10)
	}

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
		let real delta_t = 0.001;
		real t;
	'''

	def getEmptyTestModule()
	'''
		module Test;
		with Math.*;
	'''

	def getTestModule()
	'''
		«emptyTestModule»
		with CartesianMesh2D.*;
		«simulationVariables»
	'''

	def getTestGenModel()
	'''
		Application Test;

		MainModule Test test
		{
			nodeCoord = X;
			time = t;
			timeStep = delta_t;
		}
	'''

	// Interpreter asserts
	def assertVariableDefaultValue(IrModule irModule, Context context, String variableName, NablaValue value)
	{
		Assert.assertEquals(value, irModule.getVariableByName(variableName).defaultValue.interprete(context))
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
		path.replace("NabLabExamples/../NabLabExamples/", "NabLabExamples/")
		path.replace("//", "/")
	}
}