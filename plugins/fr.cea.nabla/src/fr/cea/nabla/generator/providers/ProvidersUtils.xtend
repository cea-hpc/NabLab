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
import fr.cea.nabla.generator.ir.IrFunctionFactory
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.transformers.ReplaceUtf8Chars
import fr.cea.nabla.nabla.NablaExtension
import fr.cea.nabla.nablagen.NablagenProvider

class ProvidersUtils
{
	@Inject IrFunctionFactory irFunctionFactory

	def toIrExtensionProvider(NablagenProvider provider, String installationDir)
	{
		IrFactory::eINSTANCE.createExtensionProvider =>
		[
			extensionName = provider.extension.name
			providerName = provider.name
			outputPath = provider.outputPath
			linearAlgebra = provider.extension.linearAlgebra
			functions += provider.extension.irFunctions
		]
	}

	private def getIrFunctions(NablaExtension it)
	{
		functions.filter[external].map[x | 
			val irFunction = irFunctionFactory.toIrExternFunction(x)
			irFunction.name = ReplaceUtf8Chars.getNoUtf8(irFunction.name)
			return irFunction
		]
	}
}