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

import com.google.inject.Inject
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.Assert
import org.junit.BeforeClass
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(XtextRunner)
@InjectWith(NablaInjectorProvider)
class NablaExamplesTest
{
	static String wsPath
	static String examplesProjectSubPath
	static String examplesProjectPath
	static GitUtils git

	@Inject CompilationChainHelper compilationHelper
	@Inject extension TestUtils

	@BeforeClass
	def static void setup()
	{
		val testProjectPath = System.getProperty("user.dir")
		wsPath = testProjectPath + "/../../"
		examplesProjectSubPath = "plugins/fr.cea.nabla.ui/examples/NablaExamples/"
		examplesProjectPath = wsPath + examplesProjectSubPath
		git = new GitUtils(wsPath)
	}

	@Test
	def void testExplicitHeatEquation()
	{
		val model = readFileAsString(examplesProjectPath + "src/explicitheatequation/ExplicitHeatEquation.nabla")
		val genmodel = readFileAsString(examplesProjectPath + "src/explicitheatequation/ExplicitHeatEquation.nablagen")

		compilationHelper.getIrModule(model, genmodel)
		testNoGitDiff("explicitheatequation")
	}

	@Test
	def void testGenerateGlace2D()
	{
		val model = readFileAsString(examplesProjectPath + "src/glace2d/Glace2d.nabla")
		val genmodel = readFileAsString(examplesProjectPath + "src/glace2d/Glace2d.nablagen")

		compilationHelper.getIrModule(model, genmodel)
		testNoGitDiff("glace2d")
	}

	@Test
	def void testGenerateHeatEquation()
	{
		val model = readFileAsString(examplesProjectPath + "src/heatequation/HeatEquation.nabla")
		val genmodel = readFileAsString(examplesProjectPath + "src/heatequation/HeatEquation.nablagen")

		compilationHelper.getIrModule(model, genmodel)
		testNoGitDiff("/heatequation") // To avoid a false posiotiv on explicitheatequation fail or implicitheatequation
	}

	@Test
	def void testGenerateImplicitHeatEquation()
	{
		val model = readFileAsString(examplesProjectPath + "src/implicitheatequation/ImplicitHeatEquation.nabla")
		val genmodel = readFileAsString(examplesProjectPath + "src/implicitheatequation/ImplicitHeatEquation.nablagen")

		compilationHelper.getIrModule(model, genmodel)
		testNoGitDiff("implicitheatequation")
	}

	@Test
	def void testGenerateIterativeHeatEquation()
	{
		val model = readFileAsString(examplesProjectPath + "src/iterativeheatequation/IterativeHeatEquation.nabla")
		val genmodel = readFileAsString(examplesProjectPath + "src/iterativeheatequation/IterativeHeatEquation.nablagen")

		compilationHelper.getIrModule(model, genmodel)
		testNoGitDiff("iterativeheatequation")
	}

	private def testNoGitDiff(String projectName)
	{
		var diffs = git.getModifiedFiles(examplesProjectSubPath)
		diffs =	diffs.filter[d | d.newPath.contains(projectName)]
		for (diff : diffs)
		{
			println(diff.changeType + " " + diff.newPath)
			//git.printDiffFor(diff.newPath)
		}
		Assert.assertTrue(diffs.empty)
	}
}