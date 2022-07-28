/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.tests.ir.interpreter

import com.google.inject.Inject
import fr.cea.nabla.ir.IrUtils
import fr.cea.nabla.ir.UnzipHelper
import fr.cea.nabla.ir.interpreter.IrInterpreter
import fr.cea.nabla.tests.CompilationChainHelper
import fr.cea.nabla.tests.GitUtils
import fr.cea.nabla.tests.NablaInjectorProvider
import fr.cea.nabla.tests.TestUtils
import java.io.File
import java.nio.file.Files
import java.time.Duration
import java.time.LocalDateTime
import java.util.logging.FileHandler
import java.util.logging.Level
import java.util.logging.SimpleFormatter
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.After
import org.junit.Assert
import org.junit.Before
import org.junit.BeforeClass
import org.junit.Test
import org.junit.runner.RunWith
import java.util.regex.Pattern
import java.nio.file.Paths

@RunWith(XtextRunner)
@InjectWith(NablaInjectorProvider)
class NablaExamplesInterpreterTest
{
	static String wsPath = Files.createTempDirectory("nablabtest-interpreter-").toString
	static String pluginsPath
	static String testsProjectSubPath
	static String examplesProjectPath
	static GitUtils git
	LocalDateTime startTime
	static IrUtils.NonRegressionValues nonRegressionValue = IrUtils.NonRegressionValues.CompareToReference
	static double nonRegressionTolerance = 0.0

	@Inject CompilationChainHelper compilationHelper
	@Inject extension TestUtils

	@BeforeClass
	def static void setup()
	{
		val separatorPattern = Pattern.quote(File.separator);
		val testProjectPath = System.getProperty("user.dir")
		testsProjectSubPath = Paths.get(testProjectPath.split(separatorPattern).reverse.get(1), testProjectPath.split(separatorPattern).reverse.get(0)).toString
		val nablabPath = testProjectPath.replace("tests" + File.separator + "fr.cea.nabla.tests", "")
		pluginsPath = Paths.get(nablabPath, "plugins").toString

		// simulate a wsPath with nablab repository
		val nRepositoryPath = Paths.get(pluginsPath, "fr.cea.nabla.ir", "resources", ".nablab.zip").toString
		UnzipHelper.unzip(new File(nRepositoryPath).toURI, new File(wsPath).toURI)

		examplesProjectPath = Paths.get(pluginsPath, "fr.cea.nabla.ui", "examples", "NabLabExamples").toString
		git = new GitUtils(nablabPath)

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
		println("\ntest" + moduleName)
		val modelFile = String.format("%1$ssrc/%2$s/%3$s.n", examplesProjectPath + File.separator, moduleName.toLowerCase, moduleName)
		val model = readFileAsString(modelFile)
		val genmodelFile = String.format("%1$ssrc/%2$s/%3$s.ngen", examplesProjectPath + File.separator, moduleName.toLowerCase, moduleName)
		val genmodel = readFileAsString(genmodelFile)
		// We use the example json datafile provided by example source code
		val jsonOptionsFile = String.format("%1$ssrc/%2$s/%3$s.json", examplesProjectPath + File.separator, moduleName.toLowerCase, moduleName)
		var jsonContent = readFileAsString(jsonOptionsFile)

		jsonContent = IrUtils.addNonRegressionTagsToJsonFile(moduleName, jsonContent, nonRegressionValue.toString, nonRegressionTolerance)

		val ir = compilationHelper.getIrForInterpretation(model, genmodel)
		//val handler = new ConsoleHandler

		val logFile = String.format("results/interpreter/%1$s/Interprete%2$s.log", moduleName.toLowerCase, moduleName)
		val handler = new FileHandler(logFile, false)

		val formatter = new SimpleFormatter
		handler.setFormatter(formatter)
		handler.level = Level::FINE
		val irInterpreter = new IrInterpreter(handler)
		val context = irInterpreter.interprete(ir, jsonContent, wsPath)
		handler.close

		Assert.assertTrue("LevelDB Compare Error", context.levelDBCompareResult)
		testNoGitDiff("/" + moduleName.toLowerCase)
	}

	private def testNoGitDiff(String moduleName)
	{
		Assert.assertTrue(git.noGitDiff(testsProjectSubPath, moduleName))
	}
}