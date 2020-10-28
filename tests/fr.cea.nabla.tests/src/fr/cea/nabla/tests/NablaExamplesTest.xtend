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

import com.google.common.collect.PeekingIterator
import com.google.gson.Gson
import com.google.inject.Inject
import fr.cea.nabla.nablagen.Cpp
import fr.cea.nabla.nablagen.Java
import java.io.File
import java.nio.file.Files
import org.apache.commons.io.FileUtils
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.Assert
import org.junit.BeforeClass
import org.junit.Test
import org.junit.runner.RunWith

import static fr.cea.nabla.tests.TestUtils.*

@RunWith(XtextRunner)
@InjectWith(NablaInjectorProvider)
class NablaExamplesTest
{
	static String examplesProjectSubPath
	static String examplesProjectPath
	static String cppLibPath
	static String javaLibPath
	static String levelDBPath
	static String commonMath3Path
	static String levelDbEnv = "LEVELDB_HOME"
	static String kokkosENV = "KOKKOS_HOME"
	static GitUtils git

	@Inject CompilationChainHelper compilationHelper
	@Inject extension TestUtils

	@BeforeClass
	def static void setup()
	{
		val testProjectPath = System.getProperty("user.dir")
		val wsPath = testProjectPath + "/../../"
		examplesProjectSubPath = "plugins/fr.cea.nabla.ui/examples/NablaExamples/"
		examplesProjectPath = wsPath + examplesProjectSubPath
		cppLibPath = wsPath + "plugins/fr.cea.nabla.ir/cppresources/libcppnabla.zip"
		javaLibPath = wsPath + "plugins/fr.cea.nabla.javalib/bin"
		levelDBPath = wsPath + "plugins/leveldb/*"
		commonMath3Path = wsPath + "plugins/commons-math3/*"
		git = new GitUtils(wsPath)
	}

	@Test
	def void testGenerateExplicitHeatEquation()
	{
		testGenerateModule("ExplicitHeatEquation")
	}

	@Test
	def void testExecuteExplicitHeatEquation()
	{
		testExecuteModule("ExplicitHeatEquation")
	}

	@Test
	def void testGenerateGlace2d()
	{
		testGenerateModule("Glace2d")
	}

	@Test
	def void testExecuteGlace2d()
	{
		testExecuteModule("Glace2d")
	}

	@Test
	def void testGenerateHeatEquation()
	{
		testGenerateModule("HeatEquation")
	}

	@Test
	def void testExecuteHeatEquation()
	{
		testExecuteModule("HeatEquation")
	}

	@Test
	def void testGenerateImplicitHeatEquation()
	{
		testGenerateModule("ImplicitHeatEquation")
	}

	@Test
	def void testExecuteImplicitHeatEquation()
	{
		testExecuteModule("ImplicitHeatEquation")
	}

	@Test
	def void testGenerateIterativeHeatEquation()
	{
		testGenerateModule("IterativeHeatEquation")
	}

	@Test
	def void testExecuteIterativeHeatEquation()
	{
		testExecuteModule("IterativeHeatEquation")
	}

	private def testGenerateModule(String moduleName)
	{
		val packageName = moduleName.toLowerCase
		val model = readFileAsString(examplesProjectPath + "src/" + packageName + "/" + moduleName + ".nabla")
		var genmodel = readFileAsString(examplesProjectPath + "src/" + packageName + "/" + moduleName + ".nablagen")
		compilationHelper.generateCode(model, genmodel, examplesProjectPath)
		testNoGitDiff("/" + packageName) // Add "/" to avoid a false positiv on explicitheatequation fail or implicitheatequation
	}

	private def testNoGitDiff(String moduleName)
	{
		Assert.assertTrue(git.noGitDiff(examplesProjectSubPath, moduleName))
	}

	private def testExecuteModule(String moduleName)
	{
		println("\nTest Execute " + moduleName)
		// check Env Variables
		val kokkosPath = System.getenv(kokkosENV)
		val levelDbPath = System.getenv(levelDbEnv)
		if (kokkosPath.nullOrEmpty || levelDbPath.nullOrEmpty)
			Assert.fail("To execute this test, you have to set " + kokkosENV + " and " + levelDbEnv + " variables.")

		val tmp = new File(Files.createTempDirectory("nablaTest-" + moduleName) + "/NablaExamples")
		println("TempDirectory : " + tmp)
		// We have to create output dir. Simpliest is to copy all NablaExamples tree in tmpDir
		val sourceLocation= new File(examplesProjectPath)
		FileUtils.copyDirectory(sourceLocation, tmp);

		val packageName = moduleName.toLowerCase
		val model = readFileAsString(tmp + "/src/" + packageName + "/" + moduleName + ".nabla")
		var genmodel = readFileAsString(tmp + "/src/" + packageName + "/" + moduleName + ".nablagen")

		// Adapt genModel for LevelDBPath & KokkosPath & tmpOutputDir
		genmodel = genmodel.adaptedGenModel(kokkosPath, levelDbPath)
		compilationHelper.generateCode(model, genmodel, tmp.toPath.toString)

		val targets = compilationHelper.getTargets(model, genmodel)

		for (target : targets)
		{
			testExecute(target, moduleName, tmp.toString)
		}
	}

	private def adaptedGenModel(String genmodel, String kokkosPath, String levelDbPath)
	{
		// add LevelDBBlock before JavaBlock
		var adaptedModel =  genmodel.replace(javaBlock.toString, levelDbPath.levelDbBlock.toString + javaBlock.toString)
		// customize KokkosPath
		val defaultKokkosPath = "$ENV{HOME}/kokkos/kokkos-install"
		adaptedModel = adaptedModel.replace(defaultKokkosPath, kokkosPath)

		return adaptedModel
	}

	private def getJavaBlock()
	{
		'''
		Java
		{
		'''
	}

	private def getLevelDbBlock(String levelDbPath)
	{
		'''
		LevelDB
		{
			levelDBPath = "«levelDbPath»";
		}

		'''
	}

	private def dispatch testExecute(Cpp target, String moduleName, String tmp)
	{
		val testProjectPath = System.getProperty("user.dir")
		val packageName = moduleName.toLowerCase
		val outputDir = tmp + "/.." + target.outputDir
		val targetName = outputDir.split("/").last
		val levelDbRef = testProjectPath + "/results/compiler/" + targetName + "/" + packageName + "/" + moduleName + "DB.ref"
		val jsonFile = examplesProjectPath + "src/" + packageName + "/" + moduleName + ".json"
		println("\n---------------------------------------------------------")
		println("Configuration, compilation and execution of " + target.eClass.name)
		println("---------------------------------------------------------")
//		println("$1= " + outputDir)
//		println("$2= " + cppLibPath)
//		println("$3= " + packageName)
//		println("$4= " + levelDbRef)
//		println("$5= " + jsonFile)
		var pb = new ProcessBuilder("/bin/bash",
			System.getProperty("user.dir") + "/src/fr/cea/nabla/tests/executeCppNablaExample.sh",
			outputDir, // output src-gen path
			cppLibPath, // cpp lib zip	 path
			packageName,
			levelDbRef,
			jsonFile)
		var process = pb.start
		val exitVal = process.waitFor
		if (exitVal.equals(0))
			println("	-> Execution Ok for " + target.eClass.name + ".")
		if (exitVal.equals(10))
		{
			val logPath = simplifyPath(outputDir + "/" + packageName + "/CMake.log")
			println("	-> Configure Error for " + target.eClass.name + ". See " + logPath)
			println(readFileAsString(logPath))
			Assert.fail()
		}
		if (exitVal.equals(20))
		{
			val logPath = simplifyPath(outputDir + "/" + packageName + "/make.log")
			println("	-> Compile Error for " + target.eClass.name + ". See " + logPath)
			println(readFileAsString(logPath))
			Assert.fail()
		}
		if (exitVal.equals(30))
		{
			val logPath = simplifyPath(outputDir + "/" + packageName + "/exec.err")
			println("	-> Execute Error for " + target.eClass.name + ". See " + logPath)
			println(readFileAsString(logPath))
			Assert.fail()
		}
	}

	private def dispatch testExecute(Java target, String moduleName, String tmp)
	{
		val testProjectPath = System.getProperty("user.dir")
		val packageName = moduleName.toLowerCase
		val outputDir = tmp + "/.." + target.outputDir
		val targetName = outputDir.split("/").last
		val gsonPath = Gson.protectionDomain.codeSource.location.toString
		val levelDbRef = testProjectPath + "/results/compiler/" + targetName + "/" + packageName + "/" + moduleName + "DB.ref"
		val guavaPath = PeekingIterator.protectionDomain.codeSource.location.toString
		val apacheCommonIOPath = FileUtils.protectionDomain.codeSource.location.toString
		val jsonFile = examplesProjectPath + "src/" + packageName + "/" + moduleName + ".json"
		println("\n---------------------------------------------------------")
		println("Configuration, compilation and execution of " + target.eClass.name)
		println("---------------------------------------------------------")
//		println("$1= " + outputDir)
//		println("$2= " + packageName)
//		println("$3= " + moduleName)
//		println("$4= " + javaLibPath)
//		println("$5= " + levelDBPath)
//		println("$6= " + gsonPath)
//		println("$7= " + levelDbRef)
//		println("$8= " + jsonFile)
//		println("$9= " + guavaPath)
//		println("$10= " + commonMath3Path)
//		println("$11= " + apacheCommonIOPath)
//		println("javac -classpath " + javaLibPath  + ":" + commonMath3Path + ":" + levelDBPath + ":" + gsonPath + " " + moduleName + ".java")
//		println("java -classpath " + javaLibPath + ":" + commonMath3Path + ":" + guavaPath + ":" + levelDBPath + ":" + gsonPath + ":" + apacheCommonIOPath + ":" + tmp 
//					+ "/" + targetName + " " + packageName + "." + moduleName + " " + "test.json")
		var pb = new ProcessBuilder("/bin/bash",
			System.getProperty("user.dir") + "/src/fr/cea/nabla/tests/executeJavaNablaExample.sh",
			outputDir, // output src-gen path
			packageName,
			moduleName,
			javaLibPath,
			levelDBPath,
			gsonPath,
			levelDbRef,
			jsonFile,
			guavaPath,
			commonMath3Path,
			apacheCommonIOPath)
		var process = pb.start
		val exitVal = process.waitFor
		if (exitVal.equals(0))
			println("	-> Execution Ok for " + target.eClass.name + ".")
		if (exitVal.equals(10))
		{
			val logPath = simplifyPath(tmp + "/" + targetName + "/" + packageName + "/javac.err")
			println("	-> Compile Error for " + target.eClass.name + ". See " + logPath)
			println(readFileAsString(logPath))
			Assert.fail()
		}
		if (exitVal.equals(20))
		{
			val logPath = simplifyPath(tmp + "/" + targetName + "/" + packageName + "/exec.err")
			println("	-> Execute Error for " + target.eClass.name + ". See " + logPath)
			println(readFileAsString(logPath))
			Assert.fail()
		}
	}
}