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
import fr.cea.nabla.generator.ir.IrFunctionFactory
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.transformers.ReplaceUtf8Chars
import fr.cea.nabla.nabla.DefaultExtension
import fr.cea.nabla.nablagen.NablagenProvider

class ProvidersUtils
{
	@Inject IrFunctionFactory irFunctionFactory

	def toIrDefaultExtensionProvider(NablagenProvider provider, String installationDir)
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
