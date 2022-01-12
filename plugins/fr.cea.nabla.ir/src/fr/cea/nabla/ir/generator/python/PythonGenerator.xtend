/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.python

import fr.cea.nabla.ir.IrTypeExtensions
import fr.cea.nabla.ir.generator.GenerationContent
import fr.cea.nabla.ir.generator.IrCodeGenerator
import fr.cea.nabla.ir.ir.DefaultExtensionProvider
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.transformers.PreventFunctionOverloading
import fr.cea.nabla.ir.transformers.ReplaceReductions
import fr.cea.nabla.ir.transformers.SetPythonOperatorNames
import java.util.ArrayList

import static extension fr.cea.nabla.ir.ExtensionProviderExtensions.*

class PythonGenerator implements IrCodeGenerator
{
	override getName() { "Python" }

	override getIrTransformationSteps()
	{
		#[
			new ReplaceReductions(true), // parallel loops and reductions not yet implemented
			new SetPythonOperatorNames,
			new PreventFunctionOverloading
		]
	}

	override getGenerationContents(IrRoot ir)
	{
		val fileContents = new ArrayList<GenerationContent>
		for (module : ir.modules)
			fileContents += new GenerationContent(module.name.toLowerCase + '.py', IrModuleContentProvider.getFileContent(module), false)
		return fileContents
	}
	
	override getGenerationContents(DefaultExtensionProvider provider)
	{
		val fileContents = new ArrayList<GenerationContent>
		fileContents += new GenerationContent(provider.className.toLowerCase + ".py", DefaultExtensionProviderContentProvider.getClassFileContent(provider), true)
		if (provider.linearAlgebra)
		{
			fileContents += new GenerationContent(IrTypeExtensions.VectorClass.toLowerCase + ".py", DefaultExtensionProviderContentProvider.getVectorClassFileContent(provider), true)
			fileContents += new GenerationContent(IrTypeExtensions.MatrixClass.toLowerCase + ".py", DefaultExtensionProviderContentProvider.getMatrixClassFileContent(provider), true)
		}
		return fileContents
	}
}