/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.nabla.DefaultExtension
import fr.cea.nabla.nabla.MeshExtension
import fr.cea.nabla.nablagen.NablagenProvider

class IrExtensionProviderFactory
{
	@Inject IrFunctionFactory irFunctionFactory

	def create IrFactory::eINSTANCE.createMeshExtensionProvider toIrMeshExtensionProvider(MeshExtension ext)
	{
		extensionName = ext.name
	}

	def create IrFactory::eINSTANCE.createDefaultExtensionProvider toIrDefaultExtensionProvider(DefaultExtension ext)
	{
		extensionName = ext.name
	}

	def toIrDefaultExtensionProvider(NablagenProvider provider, String installationDir)
	{
		IrFactory::eINSTANCE.createDefaultExtensionProvider =>
		[
			extensionName = provider.extension.name
			providerName = provider.name
			outputPath = provider.outputPath
			linearAlgebra = (provider.extension as DefaultExtension).linearAlgebra
			for (f : (provider.extension as DefaultExtension).functions.filter[external])
				functions += irFunctionFactory.toIrExternFunction(f)
		]
	}
}