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
import fr.cea.nabla.ir.interpreter.ModuleInterpreter
import java.time.Duration
import java.time.LocalDateTime
import java.util.logging.FileHandler
import java.util.logging.Level
import java.util.logging.SimpleFormatter
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.After
import org.junit.Before
import org.junit.BeforeClass
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(XtextRunner)
@InjectWith(NablaInjectorProvider)
class NablaExamplesInterpreterTest
{
	static String testsProjectSubPath
	static String examplesProjectPath
	static GitUtils git
	LocalDateTime startTime

	@Inject CompilationChainHelper compilationHelper
	@Inject extension TestUtils

	@BeforeClass
	def static void setup()
	{
		val testProjectPath = System.getProperty("user.dir")
		testsProjectSubPath = testProjectPath.split('/').reverse.get(1) + '/' + testProjectPath.split('/').reverse.get(0)

		val wsPath = testProjectPath + "/../../"
		val examplesProjectSubPath = "plugins/fr.cea.nabla.ui/examples/NablaExamples/"
		examplesProjectPath = wsPath + examplesProjectSubPath
		git = new GitUtils(wsPath)
		
		System.setProperty("java.util.logging.SimpleFormatter.format", "%4$s: %5$s %n")
		System.setProperty("java.util.logging.FileHandler.limit", "1024000")
		System.setProperty("java.util.logging.FileHandler.count", "3")
	}

	@Before
	def void initTimer()
	{
		startTime = LocalDateTime.now()
	}

	@After
	def void endTimer()
	{
		val endTime = LocalDateTime.now()
		val duration = Duration.between(startTime, endTime);
		println("  Elapsed time : " + duration.seconds + "s")
	}

	@Test
	def void testInterpreteGlace2d()
	{
		testInterpreteModule("Glace2d")
	}

	@Test
	def void testInterpreteHeatEquation()
	{
		testInterpreteModule("HeatEquation")
	}

	@Test
	def void testInterpreteExplicitHeatEquation()
	{
		testInterpreteModule("ExplicitHeatEquation")
	}

	@Test
	def void testInterpreteImplicitHeatEquation()
	{
		testInterpreteModule("ImplicitHeatEquation")
	}

	@Test
	def void testInterpreteIterativeHeatEquation()
	{
		testInterpreteModule("IterativeHeatEquation")
	}

	private def void testInterpreteModule(String moduleName)
	{
		println("test" + moduleName)
		val modelFile = String.format("%1$ssrc/%2$s/%3$s.nabla", examplesProjectPath, moduleName.toLowerCase, moduleName)
		val model = readFileAsString(modelFile)
		// We use a dedicated genmodel to replaceAllreductions and not to generate code
		val genmodelFile = String.format("src/%1$s/%2$s.nablagen", moduleName.toLowerCase, moduleName)
		val genmodel = readFileAsString(genmodelFile)

		val irModule = compilationHelper.getIrModule(model, genmodel)
		//val handler = new ConsoleHandler
		val logFile = String.format("src/%1$s/Interprete%2$s.log", moduleName.toLowerCase, moduleName)
		val handler = new FileHandler(logFile, false)

		val formatter = new SimpleFormatter
		handler.setFormatter(formatter)
		handler.level = Level::FINE
		val moduleInterpreter = new ModuleInterpreter(irModule, handler)
		moduleInterpreter.interprete
		handler.close

		testNoGitDiff("/"+moduleName.toLowerCase)
	}

	private def testNoGitDiff(String moduleName)
	{
		git.testNoGitDiff(testsProjectSubPath, moduleName)
	}
}