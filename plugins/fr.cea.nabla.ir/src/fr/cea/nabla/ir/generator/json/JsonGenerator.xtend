/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.json

import fr.cea.nabla.ir.generator.GenerationContent
import fr.cea.nabla.ir.generator.IrCodeGenerator
import fr.cea.nabla.ir.ir.DefaultExtensionProvider
import fr.cea.nabla.ir.ir.IrRoot
import org.eclipse.xtend.lib.annotations.Data

@Data
class JsonGenerator implements IrCodeGenerator
{
	val boolean hasLevelDB

	override getName() { "Json" }

	override getIrTransformationSteps() { #[] }

	override getGenerationContents(IrRoot ir)
	{
		#{ new GenerationContent(ir.name + 'Default.json', IrModuleContentProvider.getJsonFileContent(ir, hasLevelDB), false) }
	}
	
	override getGenerationContents(DefaultExtensionProvider provider)
	{
		// nothing to do
	}
}
