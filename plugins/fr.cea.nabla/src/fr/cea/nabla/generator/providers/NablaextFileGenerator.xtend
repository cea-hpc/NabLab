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
		fsa.generateFile(fileName, getContent(nablaExt))
	}

	private def getContent(NablaExtension it)
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
	 * Source files (.h and .cc) in <projectDir>/src
	 *
	 * Build instructions:
	 *   - go into the <projectDir> directory and create a lib directory to build the project: mkdir lib; cd lib
	 *   - start cmake with in setting your compiler and compile: cmake -D CMAKE_CXX_COMPILER=/usr/bin/g++ ../src; make
	 */
	ExtensionProvider «name»Cpp : «name»
	{
		target = «TargetType::CPP_SEQUENTIAL.literal»;
		// compatibleTargets can be added here
		// projectDir is the parent directory of the «name»Cpp project relative to the NabLab workspace."
		projectDir = "/«name»Cpp";
		facadeClass = "«name»Cpp";
		facadeNamespace = "«name.toLowerCase»";
		libName = "«name.toLowerCase»";
	}

	/* 
	 * Java Extension Provider
	 * Source files (.h and .cc) in <projectDir>/src
	 */
	ExtensionProvider «name»Java : «name»
	{
		target = «TargetType::JAVA.literal»;
		// compatibleTargets can be added here
		// projectDir is the parent directory of the «name»Java project relative to the NabLab workspace."
		projectDir = "/«name»Java";
		facadeClass = "«name»Java";
		facadeNamespace = "«name.toLowerCase»";
		libName = "«name.toLowerCase»";
	}
	'''
}