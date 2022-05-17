/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.java

import fr.cea.nabla.ir.IrTypeExtensions
import fr.cea.nabla.ir.generator.GenerationContent
import fr.cea.nabla.ir.generator.IrCodeGenerator
import fr.cea.nabla.ir.ir.DefaultExtensionProvider
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.transformers.SetMultithreadableLoops
import java.util.ArrayList
import org.eclipse.xtend.lib.annotations.Data

import static extension fr.cea.nabla.ir.ExtensionProviderExtensions.*
import static extension fr.cea.nabla.ir.IrModuleExtensions.*

@Data
class JavaGenerator implements IrCodeGenerator
{
	val boolean hasLevelDB

	override getName() { "Java" }

	override getIrTransformationSteps() { #[new SetMultithreadableLoops] }

	override getGenerationContents(IrRoot ir, (String)=>void traceNotifier)
	{
		val fileContents = new ArrayList<GenerationContent>
		for (module : ir.modules)
			fileContents += new GenerationContent(module.className + '.java', IrModuleContentProvider.getFileContent(module, hasLevelDB), false)
		return fileContents
	}

	override getGenerationContents(DefaultExtensionProvider provider, (String)=>void traceNotifier)
	{
		val fileContents = new ArrayList<GenerationContent>
		// interface always
		fileContents += new GenerationContent(provider.interfaceName + ".java", DefaultExtensionProviderContentProvider.getInterfaceFileContent(provider), false)
		// class if they do not exists
		fileContents += new GenerationContent(provider.className + ".java", DefaultExtensionProviderContentProvider.getClassFileContent(provider), true)
		if (provider.linearAlgebra)
		{
			fileContents += new GenerationContent(IrTypeExtensions.VectorClass + ".java", DefaultExtensionProviderContentProvider.getVectorClassFileContent(provider), true)
			fileContents += new GenerationContent(IrTypeExtensions.MatrixClass + ".java", DefaultExtensionProviderContentProvider.getMatrixClassFileContent(provider), true)
		}
		return fileContents
	}
}