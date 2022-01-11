/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.generator

import com.google.inject.Inject
import com.google.inject.Provider
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher.MessageType
import fr.cea.nabla.generator.JniProviderGenerator
import fr.cea.nabla.ir.ir.DefaultExtensionProvider
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.nabla.DefaultExtension
import fr.cea.nabla.nablagen.NablagenPackage
import fr.cea.nabla.nablagen.NablagenProvider
import fr.cea.nabla.nablagen.Target
import fr.cea.nabla.nablagen.TargetType
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.scoping.IScopeProvider

class NablagenExtensionHelper
{
	@Inject NablaGeneratorMessageDispatcher dispatcher
	@Inject BackendFactory backendFactory
	@Inject IScopeProvider scopeProvider
	@Inject Provider<JniProviderGenerator> jniGeneratorProvider

	def boolean setExtensionProviders(IrRoot ir, String wsPath, Target target, boolean generate)
	{
		val jniGenerator = jniGeneratorProvider.get

		// Browse IrRoot model providers which need to be filled with Ngen providers
		for (irProvider : ir.providers.filter[x | x.extensionName != "Math"])
		{
			val provider = getTargetProvider(target, irProvider.extensionName)
			if (provider === null)
			{
				dispatcher.post(MessageType::Warning, "    No provider found for extension: " + irProvider.extensionName)
				return false
			}

			irProvider.providerName = provider.name
			irProvider.outputPath = provider.outputPath
			if (provider.extension instanceof DefaultExtension && irProvider instanceof DefaultExtensionProvider)
			{
				(irProvider as DefaultExtensionProvider).linearAlgebra = (provider.extension as DefaultExtension).linearAlgebra

				if (provider.target != target.type && !provider.compatibleTargets.contains(target.type))
				{
					dispatcher.post(MessageType::Warning, "    The target of the provider differs from target (" + provider.target.literal + " != " + target.type.literal + ") for extension: " + irProvider.extensionName)
					if (target.type == TargetType::JAVA)
					{
						dispatcher.post(MessageType::Exec, "Starting JNI code generator: " + target.outputPath)
						jniGenerator.transformProvider(backendFactory.getCppBackend(provider.target), irProvider as DefaultExtensionProvider, wsPath, target.outputPath, generate)
					}
				}
			}
		}

		if (generate)
		{
			// JNI providers are generated for interpreter and Java code.
			// When some JNI providers are generated, a root CMake is created
			jniGenerator.generateGlobalCMakeIfNecessary(ir, target, wsPath)
		}

		return true
	}

	def getTargetProvider(Target target, String extensionName)
	{
		val extensionConfig = target.extensionConfigs.findFirst[x | x.extension.name == extensionName]
		(extensionConfig === null ? getDefaultProvider(target, target.type, extensionName) : extensionConfig.provider)
	}

	def NablagenProvider getDefaultProvider(EObject ngenContext, TargetType type, String extensionName)
	{
		val providerDescriptionScope = scopeProvider.getScope(ngenContext, NablagenPackage.Literals.EXTENSION_CONFIG__PROVIDER)
		for (providerDescription : providerDescriptionScope.allElements)
		{
			var o = providerDescription.EObjectOrProxy
			if (o !== null)
			{
				var NablagenProvider provider
				if (o.eIsProxy)
					provider = ngenContext.eResource.resourceSet.getEObject(providerDescription.EObjectURI, true) as NablagenProvider
				else
					provider = o as NablagenProvider

				if (provider.extension.name == extensionName && (provider.target == type || provider.compatibleTargets.contains(type)))
				{
					dispatcher.post(MessageType::Exec, '    Default provider found for extension ' + extensionName + ': ' + provider.name)
					return provider
				}
			}
		}
		return null
	}
}