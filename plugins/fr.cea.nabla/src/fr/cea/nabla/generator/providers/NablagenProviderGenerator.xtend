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
import fr.cea.nabla.generator.BackendFactory
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher.MessageType
import fr.cea.nabla.generator.StandaloneGeneratorBase
import fr.cea.nabla.generator.UnzipHelper
import fr.cea.nabla.ir.generator.cpp.CppGeneratorUtils
import fr.cea.nabla.ir.generator.cpp.CppProviderGenerator
import fr.cea.nabla.ir.generator.java.JavaProviderGenerator
import fr.cea.nabla.ir.ir.Function
import fr.cea.nabla.nablagen.NablagenProviderList
import fr.cea.nabla.nablagen.TargetType
import java.io.File

class NablagenProviderGenerator extends StandaloneGeneratorBase
{
	@Inject BackendFactory backendFactory
	@Inject extension ProvidersUtils

	def generateProviders(NablagenProviderList providerList, String projectDir)
	{
		var Iterable<Function> functions = null
		val baseDir =  projectDir + "/.."
		val startTime = System.currentTimeMillis

		for (provider : providerList.elements)
		{
			val generator = getCodeGenerator(provider.target, baseDir)
			val outputFolderName = baseDir + provider.outputDir
			dispatcher.post(MessageType::Exec, "Starting " + provider.target.literal + " code generator: " + provider.outputDir)
			val fsa = getConfiguredFileSystemAccess(outputFolderName, false)
			if (functions === null)
			{
				// Functions are calculated only once.
				// A validator ensures all providers are for the same extension.
				functions = provider.extension.irFunctions
			}
			val installDir = '' // unused to generate JNI functions
			generate(fsa, generator.getGenerationContents(toIrExtensionProvider(provider, baseDir, installDir), functions), '')
		}

		val endTime = System.currentTimeMillis
		dispatcher.post(MessageType.Exec, "Code generation ended in " + (endTime-startTime)/1000.0 + "s")
	}

	private def getCodeGenerator(TargetType targetType, String baseDir)
	{
		if (targetType == TargetType::JAVA)
		{
			//UnzipHelper::unzipLibJavaNabla(new File(baseDir))
			new JavaProviderGenerator
		}
		else
		{
			val backend = backendFactory.getCppBackend(targetType)
			UnzipHelper::unzipLibCppNabla(new File(baseDir))
			val libCppNablaDir = baseDir + '/' + CppGeneratorUtils.CppLibName
			new CppProviderGenerator(backend, libCppNablaDir)
		}
	}
}
