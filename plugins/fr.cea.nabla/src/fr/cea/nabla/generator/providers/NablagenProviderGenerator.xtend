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

import com.google.inject.Inject
import fr.cea.nabla.generator.BackendFactory
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher.MessageType
import fr.cea.nabla.generator.StandaloneGeneratorBase
import fr.cea.nabla.generator.ir.IrFunctionFactory
import fr.cea.nabla.ir.generator.cpp.CppProviderGenerator
import fr.cea.nabla.ir.generator.java.JavaProviderGenerator
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.transformers.ReplaceUtf8Chars
import fr.cea.nabla.nabla.DefaultExtension
import fr.cea.nabla.nablagen.NablagenProvider
import fr.cea.nabla.nablagen.NablagenProviderList
import fr.cea.nabla.nablagen.TargetType

import static extension fr.cea.nabla.ir.ExtensionProviderExtensions.*

class NablagenProviderGenerator extends StandaloneGeneratorBase
{
	@Inject BackendFactory backendFactory
	@Inject IrFunctionFactory irFunctionFactory

	def generateProviders(NablagenProviderList providerList, String wsPath)
	{
		val startTime = System.currentTimeMillis

		for (provider : providerList.elements)
		{
			if (provider.extension instanceof DefaultExtension)
			{
				val generator = getCodeGenerator(provider.target)
				val outputFolderName = wsPath + provider.outputPath
				val fsa = getConfiguredFileSystemAccess(outputFolderName, false)
				dispatcher.post(MessageType::Exec, "Starting " + provider.target.literal + " code generator: " + provider.outputPath)
				val installDir = '' // unused to generate JNI functions
				val irProvider = toIrDefaultExtensionProvider(provider, installDir)
				generate(fsa, generator.getGenerationContents(irProvider), irProvider.dirName)
			}
			else
			{
				dispatcher.post(MessageType::Warning, "No code generator for mesh provider: " + provider.name)
			}
		}

		val endTime = System.currentTimeMillis
		dispatcher.post(MessageType.Exec, "Code generation ended in " + (endTime-startTime)/1000.0 + "s")
	}

	private def getCodeGenerator(TargetType targetType)
	{
		if (targetType == TargetType::JAVA)
			new JavaProviderGenerator
		else
			new CppProviderGenerator(backendFactory.getCppBackend(targetType))
	}

	private def toIrDefaultExtensionProvider(NablagenProvider provider, String installationDir)
	{
		IrFactory::eINSTANCE.createDefaultExtensionProvider =>
		[
			extensionName = provider.extension.name
			providerName = provider.name
			outputPath = provider.outputPath
			linearAlgebra = (provider.extension as DefaultExtension).linearAlgebra
			functions += (provider.extension as DefaultExtension).irFunctions
		]
	}

	private def getIrFunctions(DefaultExtension it)
	{
		functions.filter[external].map[x | 
			val irFunction = irFunctionFactory.toIrExternFunction(x)
			irFunction.name = ReplaceUtf8Chars.getNoUtf8(irFunction.name)
			return irFunction
		]
	}
}
