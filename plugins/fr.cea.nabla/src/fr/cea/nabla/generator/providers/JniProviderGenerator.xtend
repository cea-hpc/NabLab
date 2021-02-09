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

import com.google.inject.Inject
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher.MessageType
import fr.cea.nabla.generator.StandaloneGeneratorBase
import fr.cea.nabla.ir.generator.CMakeUtils
import fr.cea.nabla.ir.generator.cpp.Backend
import fr.cea.nabla.ir.ir.ExtensionProvider
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.nabla.NablaExtension
import fr.cea.nabla.nablagen.Target
import fr.cea.nabla.nablagen.TargetVar
import java.nio.file.Files
import java.nio.file.Paths
import java.util.HashSet

class JniProviderGenerator extends StandaloneGeneratorBase
{
	@Inject extension ProvidersUtils
	val jniProviders = new HashSet<ExtensionProvider>

	def generateAndTransformProvider(Backend backend, NablaExtension ext, ExtensionProvider provider)
	{
		// The generator transforms the C++ provider in a JNI provider
		val generator = new fr.cea.nabla.ir.generator.jni.JniProviderGenerator(backend)
		val content = generator.getGenerationContents(provider, ext.irFunctions)
		jniProviders += provider

		dispatcher.post(MessageType::Exec, "Generating JNI code generator: " + provider.projectDir)
		val pph = Paths.get(provider.projectDir)
		if (!Files.exists(pph)) Files.createDirectories(pph)
		val fsa = getConfiguredFileSystemAccess(provider.projectDir, false)
		generate(fsa, content, '')
	}

	def void convertToJni(ExtensionProvider provider)
	{
		fr.cea.nabla.ir.generator.jni.JniProviderGenerator.convertToJni(provider)
	}

	def generateGlobalCMakeIfNecessary(IrRoot ir, Target target, String baseDir)
	{
		if (!jniProviders.empty)
		{
			val fsa = getConfiguredFileSystemAccess(baseDir + target.outputDir, false)
			val fullFileName = ir.name.toLowerCase + '/CMakeLists.txt'
			dispatcher.post(MessageType::Exec, "    Generating: " + fullFileName)
			fsa.generateFile(fullFileName, getCMakeContent(ir.name, target.variables))
		}
	}

	private def getCMakeContent(String projectName, Iterable<TargetVar> variables)
	'''
		«CMakeUtils.fileHeader»

		«FOR v : variables»
		set(«v.key» «v.value»)
		«ENDFOR»

		project(«projectName»Project LANGUAGES NONE)

		«CMakeUtils.setCompiler»

		«FOR jniProvider : jniProviders»
		add_subdirectory(«CMakeUtils.formatCMakePath(jniProvider.projectDir)» ${CMAKE_BINARY_DIR}/«jniProvider.providerName»)
		«ENDFOR»

		«CMakeUtils.fileFooter»
	'''
}