/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.generator.providers

import fr.cea.nabla.generator.StandaloneGeneratorBase
import fr.cea.nabla.ir.UnzipHelper
import fr.cea.nabla.ir.generator.CMakeUtils
import fr.cea.nabla.ir.generator.GenerationContent
import fr.cea.nabla.ir.generator.jni.Jniable
import fr.cea.nabla.ir.ir.DefaultExtensionProvider
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.nablagen.Target
import fr.cea.nabla.nablagen.TargetVar
import java.util.ArrayList
import java.util.HashSet
import java.util.LinkedHashSet
import org.eclipse.emf.ecore.util.EcoreUtil

import static extension fr.cea.nabla.ir.ExtensionProviderExtensions.*
import static extension fr.cea.nabla.ir.IrRootExtensions.*

class JniProviderGenerator extends StandaloneGeneratorBase
{
	val providers = new HashSet<DefaultExtensionProvider>

	def transformProvider(Jniable jniContentProvider, DefaultExtensionProvider provider, String wsPath, String targetOutputPath, boolean generate)
	{
		// Transform the C+ provider in a JNI provider
		val cppProvider = EcoreUtil.copy(provider)
		provider.providerName = provider.providerName + 'JNI'
		provider.outputPath = targetOutputPath
		providers += provider

		// Generate the file
		if (generate)
		{
			val generator = new fr.cea.nabla.ir.generator.jni.JniProviderGenerator(jniContentProvider)
			val outputFolderName = wsPath + targetOutputPath
			val fsa = getConfiguredFileSystemAccess(outputFolderName, false)
			generate(fsa, generator.getGenerationContents(provider, cppProvider, wsPath), provider.dirName)
		}
	}

	def generateGlobalCMakeIfNecessary(IrRoot ir, Target target, String wsPath)
	{
		if (!providers.empty)
		{
			val outputFolderName = wsPath + target.outputPath
			val fsa = getConfiguredFileSystemAccess(outputFolderName, false)

			// Set WS_PATH variables in CMake and unzip NRepository if necessary
			val cMakeVars = new LinkedHashSet<Pair<String, String>>
			target.variables.forEach[x | cMakeVars += new Pair(x.key, x.value)]
			cMakeVars += new Pair(CMakeUtils.WS_PATH, wsPath)
			UnzipHelper::unzipNRepository(wsPath)

			val content = new GenerationContent('CMakeLists.txt', getCMakeContent(ir.name, wsPath, target.variables), false)
			generate(fsa, #[content], ir.dirName)
		}
	}

	private def getCMakeContent(String projectName, String wsPath, Iterable<TargetVar> variables)
	'''
		«CMakeUtils.getFileHeader(false)»

		«CMakeUtils.setVariables(getNeededVariables(wsPath, variables), providers)»

		# PROJECT
		project(«projectName»Project CXX)

		«CMakeUtils.checkCompiler»

		«CMakeUtils.addSubDirectories(false, providers)»

		«CMakeUtils.fileFooter»
	'''

	private def getNeededVariables(String wsPath, Iterable<TargetVar> variables)
	{
		val neededVars = new ArrayList<Pair<String, String>>
		neededVars += new Pair(CMakeUtils.WS_PATH, wsPath)
		variables.forEach[x | neededVars += new Pair(x.key, x.value)]
		return neededVars
	}
}