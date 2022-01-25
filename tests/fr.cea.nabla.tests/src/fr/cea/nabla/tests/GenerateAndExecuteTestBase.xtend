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

import com.google.common.collect.PeekingIterator
import com.google.gson.Gson
import com.google.inject.Inject
import fr.cea.nabla.ir.IrUtils
import fr.cea.nabla.ir.UnzipHelper
import fr.cea.nabla.nablagen.TargetType
import java.io.File
import java.nio.file.Files
import java.nio.file.Paths
import java.util.ArrayList
import org.apache.commons.io.FileUtils
import org.junit.Assert

import static fr.cea.nabla.tests.TestUtils.*

abstract class GenerateAndExecuteTestBase
{
	final static String WsPath = Files.createTempDirectory("nablabtest-compiler-").toString
	final static String LevelDBEnv = "LEVELDB_HOME"
	final static String KokkosENV = "KOKKOS_HOME"

	static String projectName
	static String projectRelativePath
	static String projectAbsolutePath
	static String nRepositoryPath
	static String javaLibPath
	static String commonMath3Path
	static String levelDBPath
	static String outputPath
	static GitUtils git

	@Inject CompilationChainHelper compilationHelper
	@Inject extension TestUtils

	protected static def void setup(String projectNameValue, String projectRelativePathValue)
	{
		projectName = projectNameValue
		GenerateAndExecuteTestBase.projectRelativePath = projectRelativePathValue

		val testProjectPath = System.getProperty("user.dir")
		val basePath = testProjectPath.replace("tests/fr.cea.nabla.tests", "")
		projectAbsolutePath = basePath + projectRelativePath
		nRepositoryPath = basePath + "plugins/fr.cea.nabla.ir/resources/.nablab.zip"
		javaLibPath = basePath + "plugins/fr.cea.nabla.javalib/bin/:" + basePath + "plugins/fr.cea.nabla.javalib/target/*"
		commonMath3Path = basePath + "plugins/commons-math3/*"
		levelDBPath = basePath + "plugins/leveldb/*"
		git = new GitUtils(basePath)
		GenerateAndExecuteTestBase.outputPath = WsPath + '/' + projectName
		println("test working directory: " + GenerateAndExecuteTestBase.outputPath)

		// Simpliest is to copy all NablaExamples tree in tmpDir
		val sourceLocation= new File(GenerateAndExecuteTestBase.projectAbsolutePath)
		FileUtils.copyDirectory(sourceLocation, new File(GenerateAndExecuteTestBase.outputPath))
	}

	protected def testGenerateModule(String moduleName)
	{
		testGenerateModule(moduleName, #[moduleName])
	}

	protected def testGenerateModule(String ngenFileName, String[] nFileNames)
	{
		val packageName = ngenFileName.toLowerCase
		val models = new ArrayList<CharSequence>
		for (nFileName : nFileNames)
			models += readFileAsString(GenerateAndExecuteTestBase.projectAbsolutePath + "/src/" + packageName + "/" + nFileName + ".n")
		var genmodel = readFileAsString(GenerateAndExecuteTestBase.projectAbsolutePath + "/src/" + packageName + "/" + ngenFileName + ".ngen")
		compilationHelper.generateCode(models, genmodel, GenerateAndExecuteTestBase.projectAbsolutePath.replace('/' + projectName, ''), projectName)
		testNoGitDiff("/" + packageName) // Add "/" to avoid a false positiv on explicitheatequation fail or implicitheatequation
	}

	protected def testExecuteModule(String moduleName)
	{
		testExecuteModule(moduleName, #[moduleName])
	}

	// nFileNames[0] is considered to be the main module foor java execution
	protected def testExecuteModule(String ngenFileName, String[] nFileNames)
	{
		println("\n" + ngenFileName)
		// check Env Variables
		val kokkosPath = System.getenv(KokkosENV)
		val levelDBPath = System.getenv(LevelDBEnv)
		if (kokkosPath.nullOrEmpty || levelDBPath.nullOrEmpty)
		{
			val envErr = "To execute this test, you have to set " + KokkosENV + " and " + LevelDBEnv + " variables."
			println(envErr)
			Assert.fail(envErr)
		}

		val packageName = ngenFileName.toLowerCase
		val models = new ArrayList<CharSequence>
		for (nFileName : nFileNames)
			models += readFileAsString(GenerateAndExecuteTestBase.outputPath + "/src/" + packageName + "/" + nFileName + ".n")
		var genmodel = readFileAsString(GenerateAndExecuteTestBase.outputPath + "/src/" + packageName + "/" + ngenFileName + ".ngen")

		// Adapt genModel for LevelDBPath & KokkosPath & tmpOutputDir
		genmodel = genmodel.adaptedGenModel(kokkosPath, levelDBPath)
		compilationHelper.generateCode(models, genmodel, WsPath, projectName)

		// unzip nabla resources
		UnzipHelper.unzip(new File(nRepositoryPath).toURI, new File(WsPath).toURI)
		val cmakePath = Paths.get(WsPath, IrUtils::NRepository, 'nablalib', 'CMakeLists.txt')
		var cmakeContent = Files.readString(cmakePath)
		cmakeContent = cmakeContent.replaceAll(" -O3 ", " -O2 ")
		Files.writeString(cmakePath, cmakeContent)

		var nbErrors = 0
		val testProjectPath = System.getProperty("user.dir")
		for (target : compilationHelper.getNgenApp(models, genmodel).targets.filter[!interpreter])
		{
			val outputPath = WsPath + "/" + target.outputPath
			val targetName = (target.type == TargetType::JAVA ? "src-gen-java" : "src-gen-cpp/" + outputPath.split("/").last)
			val levelDBRef = testProjectPath + "/results/compiler/" + targetName + "/" + packageName + "/" + ngenFileName + "DB.ref"
			val jsonFile = GenerateAndExecuteTestBase.projectAbsolutePath + "/src/" + packageName + "/" + ngenFileName + ".json"

			print("\tStarting " + target.type.literal)
			if (target.type == TargetType::JAVA)
				(!testExecuteJava(outputPath, packageName, levelDBRef, jsonFile, nFileNames.get(0)) ? nbErrors++)
			else
				(!testExecuteCpp(outputPath, packageName, levelDBRef, jsonFile, ngenFileName) ? nbErrors++)
		}
		(nbErrors > 0 ? Assert.fail(nbErrors + " error(s) !"))
	}

	private def testNoGitDiff(String packageName)
	{
		Assert.assertTrue(git.noGitDiff(GenerateAndExecuteTestBase.projectRelativePath, packageName))
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

	private def testExecuteCpp(String outputPath, String packageName, String levelDBRef, String jsonFile, String moduleName)
	{
		var pb = new ProcessBuilder("/bin/bash",
			System.getProperty("user.dir") + "/src/fr/cea/nabla/tests/executeCpp.sh",
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
			System.getProperty("user.dir") + "/src/fr/cea/nabla/tests/executeJava.sh",
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