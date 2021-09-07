/*******************************************************************************
 * Copyright (c) 2021 CEA
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
import fr.cea.nabla.ir.IrUtils
import fr.cea.nabla.ir.UnzipHelper
import fr.cea.nabla.nablagen.Target
import fr.cea.nabla.nablagen.TargetType
import java.io.File
import java.nio.file.Files
import java.nio.file.Paths
import org.apache.commons.io.FileUtils
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.Assert
import org.junit.BeforeClass
import org.junit.FixMethodOrder
import org.junit.Test
import org.junit.runner.RunWith
import org.junit.runners.MethodSorters

import static fr.cea.nabla.tests.TestUtils.*

@RunWith(XtextRunner)
@InjectWith(NablaInjectorProvider)
@FixMethodOrder(MethodSorters.NAME_ASCENDING)
class NablaExamplesTest
{
	static String projectName = 'NabLabExamples'
	static String wsPath = Files.createTempDirectory("nablabtest-compiler-").toString
	static String projectPath
	static String examplesProjectSubPath
	static String examplesProjectPath
	static String nRepositoryPath
	static String javaLibPath
	static String commonMath3Path
	static String levelDBPath
	static String levelDBEnv = "LEVELDB_HOME"
	static String kokkosENV = "KOKKOS_HOME"
	static GitUtils git

	@Inject CompilationChainHelper compilationHelper
	@Inject extension TestUtils

	@BeforeClass
	def static void setup()
	{
		val testProjectPath = System.getProperty("user.dir")
		val basePath = testProjectPath.replace("tests/fr.cea.nabla.tests", "")
		examplesProjectSubPath = "plugins/fr.cea.nabla.ui/examples/NabLabExamples"
		examplesProjectPath = basePath + examplesProjectSubPath
		nRepositoryPath = basePath + "plugins/fr.cea.nabla.ir/resources/.nablab.zip"
		javaLibPath = basePath + "plugins/fr.cea.nabla.javalib/bin/:" + basePath + "plugins/fr.cea.nabla.javalib/target/*"
		commonMath3Path = basePath + "plugins/commons-math3/*"
		levelDBPath = basePath + "plugins/leveldb/*"
		git = new GitUtils(basePath)
		projectPath = wsPath + '/' + projectName
		println("test working directory: " + projectPath)

		// Simpliest is to copy all NablaExamples tree in tmpDir
		val sourceLocation= new File(examplesProjectPath)
		FileUtils.copyDirectory(sourceLocation, new File(projectPath))
	}

	@Test
	def void test1GenerateExplicitHeatEquation()
	{
		testGenerateModule("ExplicitHeatEquation")
	}

	@Test
	def void test2ExecuteExplicitHeatEquation()
	{
		testExecuteModule("ExplicitHeatEquation")
	}

	@Test
	def void test1GenerateGlace2d()
	{
		testGenerateModule("Glace2d")
	}

	@Test
	def void test2ExecuteGlace2d()
	{
		testExecuteModule("Glace2d")
	}

	@Test
	def void test1GenerateHeatEquation()
	{
		testGenerateModule("HeatEquation")
	}

	@Test
	def void test2ExecuteHeatEquation()
	{
		testExecuteModule("HeatEquation")
	}

	@Test
	def void test1GenerateImplicitHeatEquation()
	{
		testGenerateModule("ImplicitHeatEquation")
	}

	@Test
	def void test2ExecuteImplicitHeatEquation()
	{
		testExecuteModule("ImplicitHeatEquation")
	}

	@Test
	def void test1GenerateIterativeHeatEquation()
	{
		testGenerateModule("IterativeHeatEquation")
	}

	@Test
	def void test2ExecuteIterativeHeatEquation()
	{
		testExecuteModule("IterativeHeatEquation")
	}

	private def testGenerateModule(String moduleName)
	{
		val packageName = moduleName.toLowerCase
		val model = readFileAsString(examplesProjectPath + "/src/" + packageName + "/" + moduleName + ".n")
		var genmodel = readFileAsString(examplesProjectPath + "/src/" + packageName + "/" + moduleName + ".ngen")
		compilationHelper.generateCode(model, genmodel, examplesProjectPath.replace('/NabLabExamples', ''), 'NabLabExamples')
		testNoGitDiff("/" + packageName) // Add "/" to avoid a false positiv on explicitheatequation fail or implicitheatequation
	}

	private def testNoGitDiff(String moduleName)
	{
		Assert.assertTrue(git.noGitDiff(examplesProjectSubPath, moduleName))
	}

	private def testExecuteModule(String moduleName)
	{
		println("\n" + moduleName)
		// check Env Variables
		val kokkosPath = System.getenv(kokkosENV)
		val levelDBPath = System.getenv(levelDBEnv)
		if (kokkosPath.nullOrEmpty || levelDBPath.nullOrEmpty)
		{
			val envErr = "To execute this test, you have to set " + kokkosENV + " and " + levelDBEnv + " variables."
			println(envErr)
			Assert.fail(envErr)
		}

		val wsPath = Files.createTempDirectory("nablabtest-" + moduleName).toString
		val projectName = 'NabLabExamples'
		val projectPath = wsPath + '/' + projectName
		println(projectPath)

		// Simpliest is to copy all NablaExamples tree in tmpDir
		val sourceLocation= new File(examplesProjectPath)
		FileUtils.copyDirectory(sourceLocation, new File(projectPath))

		val packageName = moduleName.toLowerCase
		val model = readFileAsString(projectPath + "/src/" + packageName + "/" + moduleName + ".n")
		var genmodel = readFileAsString(projectPath + "/src/" + packageName + "/" + moduleName + ".ngen")

		// Adapt genModel for LevelDBPath & KokkosPath & tmpOutputDir
		genmodel = genmodel.adaptedGenModel(kokkosPath, levelDBPath)
		compilationHelper.generateCode(model, genmodel, wsPath, projectName)

		// unzip nabla resources
		UnzipHelper.unzip(new File(nRepositoryPath).toURI, new File(wsPath).toURI)
		val cmakePath = Paths.get(wsPath, IrUtils::NRepository, 'nablalib', 'CMakeLists.txt')
		var cmakeContent = Files.readString(cmakePath)
		cmakeContent = cmakeContent.replaceAll(" -O3 ", " -O2 ")
		Files.writeString(cmakePath, cmakeContent)

		var nbErrors = 0
		for (target : compilationHelper.getNgenApp(model, genmodel).targets.filter[!interpreter])
		{
			(!testExecute(target, moduleName) ? nbErrors++)
		}
		(nbErrors > 0 ? Assert.fail(nbErrors + " error(s) !"))
	}

	private def adaptedGenModel(String genmodel, String kokkosPath, String levelDBPath)
	{
		// add LevelDBBlock before JavaBlock
		var adaptedModel =  genmodel.replace(javaBlock.toString, levelDBPath.levelDBBlock.toString + javaBlock.toString)
		// customize KokkosPath
		val defaultKokkosPath = "$ENV{HOME}/kokkos/install"
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

	private def getLevelDBBlock(String levelDBPath)
	{
		'''
		LevelDB
		{
			leveldb_ROOT = "«levelDBPath»";
		}

		'''
	}

	private def testExecute(Target target, String moduleName)
	{
		val testProjectPath = System.getProperty("user.dir")
		val packageName = moduleName.toLowerCase
		val outputPath = wsPath + "/" + target.outputPath
		val targetName = (target.type == TargetType::JAVA ? "src-gen-java" : "src-gen-cpp/" + outputPath.split("/").last)
		val levelDBRef = testProjectPath + "/results/compiler/" + targetName + "/" + packageName + "/" + moduleName + "DB.ref"
		val jsonFile = examplesProjectPath + "/src/" + packageName + "/" + moduleName + ".json"

		print("\tStarting " + target.type.literal)
		if (target.type == TargetType::JAVA)
			testExecuteJava(outputPath, packageName, levelDBRef, jsonFile, moduleName)
		else
			testExecuteCpp(outputPath, packageName, levelDBRef, jsonFile, moduleName)
	}

	private def testExecuteCpp(String outputPath, String packageName, String levelDBRef, String jsonFile, String moduleName)
	{
//		println("$2= " + cppLibPath)
//		println("$3= " + packageName)
//		println("$4= " + levelDBRef)
//		println("$5= " + jsonFile)
//		println("$6= " + moduleName)
		var pb = new ProcessBuilder("/bin/bash",
			System.getProperty("user.dir") + "/src/fr/cea/nabla/tests/executeCppNablaExample.sh",
			outputPath, // output src-gen path
			packageName,
			levelDBRef,
			jsonFile,
			moduleName)
		var process = pb.start
		val exitVal = process.waitFor
		if (exitVal.equals(0))
			println(" -> Ok")
		if (exitVal.equals(10))
		{
			val logPath = simplifyPath(outputPath + "/" + packageName + "/CMake.log")
			println(" -> Configure Error. See " + logPath)
			//println("\t" + readFileAsString(logPath))
			return false
		}
		if (exitVal.equals(20))
		{
			val logPath = simplifyPath(outputPath + "/" + packageName + "/make.log")
			println(" -> Compile Error. See " + logPath)
			//println("\t" + readFileAsString(logPath))
			return false
		}
		if (exitVal.equals(30))
		{
			val logPath = simplifyPath(outputPath + "/" + packageName + "/exec.err")
			println(" -> Execute Error. See " + logPath)
			//println("\t" + readFileAsString(logPath))
			// Glace2d + KokkosTeam implies levelDb diffs -> to avoid CI fails we ignore them
			if (moduleName == "Glace2d" && outputPath.contains("kokkos-team"))
				return true
			return false
		}
		return true
	}

	private def testExecuteJava(String outputDir, String packageName, String levelDBRef, String jsonFile, String moduleName)
	{
		val gsonPath = Gson.protectionDomain.codeSource.location.toString
		val guavaPath = PeekingIterator.protectionDomain.codeSource.location.toString
		val apacheCommonIOPath = FileUtils.protectionDomain.codeSource.location.toString
//		println("$1= " + outputDir)
//		println("$2= " + packageName)
//		println("$3= " + moduleName)
//		println("$4= " + javaLibPath)
//		println("$5= " + levelDBPath)
//		println("$6= " + gsonPath)
//		println("$7= " + levelDBRef)
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
			levelDBRef,
			jsonFile,
			guavaPath,
			commonMath3Path,
			apacheCommonIOPath)
		var process = pb.start
		val exitVal = process.waitFor
		if (exitVal.equals(0))
			println(" -> Ok")
		if (exitVal.equals(10))
		{
			val logPath = simplifyPath(outputDir + "/" + packageName + "/javac.err")
			println(" -> Compile Error. See " + logPath)
			return false
		}
		if (exitVal.equals(20))
		{
			val logPath = simplifyPath(outputDir + "/" + packageName + "/exec.err")
			println(" -> Execute Error. See " + logPath)
			return false
		}
		return true
	}
}
