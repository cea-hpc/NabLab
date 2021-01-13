package fr.cea.nabla.generator.providers

import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher.MessageType
import fr.cea.nabla.generator.StandaloneGeneratorBase
import fr.cea.nabla.nabla.NablaExtension
import fr.cea.nabla.nablaext.TargetType
import org.eclipse.core.resources.IProject

class NablaextFileGenerator extends StandaloneGeneratorBase
{
	def generate(NablaExtension nablaExt, IProject project)
	{
		// Generate .nablaext files in current project
		val projectHome = project.location.toString
		val fsa = getConfiguredFileSystemAccess(projectHome + "/src/" + nablaExt.name.toLowerCase, false)
		var fileName = nablaExt.name + ".nablaext"
		dispatcher.post(MessageType::Exec, "    Generating: " + fileName)
		fsa.generateFile(fileName, getContent(nablaExt, project.workspace.root.location.toString.formatCMakePath))
	}

	private def getContent(NablaExtension it, String workspaceRoot)
	'''
	/*
	 * This file contains the providers for the «name» NabLab extension.
	 * The list is ordered: the first ExtensionProvider is the default one for the specified target.
	 * For example, if you entered two «TargetType::STL_THREAD» ExtensionProvider instances,
	 * the first one in the following list will be the default one during NabLab
	 * code generation for the target «TargetType::STL_THREAD».
	 */

	/*
	 * C++ Extension Provider
	 *   - source files (.h and .cc) expected in projectRoot/«name»Cpp/src
	 *   - library file expected in projectRoot/«name»Cpp/lib
	 *
	 * Build instructions:
	 *   - go into the projectRoot/«name»Cpp project directory and create a lib directory to build the project: mkdir lib; cd lib
	 *   - start cmake with in setting your compiler and compile: cmake -D CMAKE_CXX_COMPILER=/usr/bin/g++ ../src; make
	 */
	ExtensionProvider «name»Cpp : «name»
	{
		target = «TargetType::CPP_SEQUENTIAL.literal»;
		// projectRoot is the parent directory of the «name»Cpp project. $ENV and other CMake keywords can be used."
		projectRoot = "«workspaceRoot»";
	}

	/* 
	 * Java Extension Provider
	 *   - source files (.h and .cc) expected in projectRoot/«name»Java/src
	 *   - jar file expected in projectRoot/«name»Java/lib
	 */
	ExtensionProvider «name»Java : «name»
	{
		target = «TargetType::JAVA.literal»;
		// projectRoot is the parent directory of the «name»Java project. $ENV and other CMake keywords can be used."
		projectRoot = "«workspaceRoot»";
	}
	'''
}