/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.generator.providers

import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher.MessageType
import fr.cea.nabla.generator.StandaloneGeneratorBase
import fr.cea.nabla.nabla.NablaExtension
import fr.cea.nabla.nablagen.TargetType

class NablagenFileGenerator extends StandaloneGeneratorBase
{
	def generate(NablaExtension nablaExt, String genDir)
	{
		val fsa = getConfiguredFileSystemAccess(genDir, false)
		var fileName = nablaExt.name + ".ngen"
		// generated only once
		if ( !(fsa.isFile(fileName) ))
		{
			dispatcher.post(MessageType::Exec, "    Generating: " + fileName)
			fsa.generateFile(fileName, getContent(nablaExt))
		}
	}

	private def getContent(NablaExtension it)
	'''
	/*
	 * This file contains the providers for the «name» NabLab extension.
	 * The list is ordered: the first Provider is the default one for the specified target.
	 * For example, if you entered two «TargetType::STL_THREAD» Provider instances,
	 * the first one in the following list will be the default one during NabLab
	 * code generation for the target «TargetType::STL_THREAD».
	 */

	/*
	 * C++ Extension Provider
	 */
	Provider «name»Cpp : «name»
	{
		target = «TargetType::CPP_SEQUENTIAL.literal»;
		// compatibleTargets can be added here
		outputDir = "/«name»/src-cpp";
		facadeClass = "«name»Cpp";
		facadeNamespace = "«name.toLowerCase»";
		libName = "«name.toLowerCase»";
	}

	/* 
	 * Java Extension Provider
	 */
	Provider «name»Java : «name»
	{
		target = «TargetType::JAVA.literal»;
		// compatibleTargets can be added here
		outputDir = "/«name»/src-java";
		facadeClass = "«name»Java";
		facadeNamespace = "«name.toLowerCase»";
		libName = "«name.toLowerCase»";
	}
	'''
}