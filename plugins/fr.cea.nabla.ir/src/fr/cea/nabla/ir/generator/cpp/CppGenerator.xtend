/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.cpp

import fr.cea.nabla.ir.IrTypeExtensions
import fr.cea.nabla.ir.UnzipHelper
import fr.cea.nabla.ir.generator.CMakeUtils
import fr.cea.nabla.ir.generator.GenerationContent
import fr.cea.nabla.ir.generator.IrCodeGenerator
import fr.cea.nabla.ir.ir.DefaultExtensionProvider
import fr.cea.nabla.ir.ir.IrRoot
import java.util.ArrayList
import java.util.LinkedHashSet

import static extension fr.cea.nabla.ir.ExtensionProviderExtensions.*
import static extension fr.cea.nabla.ir.IrModuleExtensions.*

class CppGenerator implements IrCodeGenerator
{
	val Backend backend
	val boolean hasLevelDB
	val boolean debug
	val cMakeVars = new LinkedHashSet<Pair<String, String>>

	new(Backend backend, String wsPath, boolean hasLevelDB, boolean debug, Iterable<Pair<String, String>> cmakeVars)
	{
		this.backend = backend
		this.hasLevelDB = hasLevelDB
		this.debug = debug
		cmakeVars.forEach[x | this.cMakeVars += x]

		// Set WS_PATH variables in CMake and unzip NRepository if necessary
		this.cMakeVars += new Pair(CMakeUtils.WS_PATH, wsPath)
		UnzipHelper::unzipNRepository(wsPath)
	}

	override getName() { backend.name }
	override getIrTransformationSteps() { backend.irTransformationSteps }

	override getGenerationContents(IrRoot ir, (String)=>void traceNotifier)
	{
		val fileContents = new ArrayList<GenerationContent>
		for (module : ir.modules)
		{
			if (debug)
			{
				backend.irModuleContentProvider.pythonEmbeddingContentProvider.computeExecutionEvents(module)
			}
			fileContents += new GenerationContent(module.className + '.h', backend.irModuleContentProvider.getHeaderFileContent(module, hasLevelDB), false)
			fileContents += new GenerationContent(module.className + '.cc', backend.irModuleContentProvider.getSourceFileContent(module, hasLevelDB), false)
		}
		fileContents += new GenerationContent('CMakeLists.txt', backend.cmakeContentProvider.getContentFor(ir, hasLevelDB, cMakeVars), false)
		if (debug)
		{
			fileContents += new GenerationContent('nablabdefs.h.in', '#cmakedefine NABLAB_DEBUG', false)
			fileContents += new GenerationContent(ir.name.toLowerCase + ".py", PythonModuleGenerator::getPythonModuleContent(ir), false)
		}
		return fileContents
	}

	override getGenerationContents(DefaultExtensionProvider provider, (String)=>void traceNotifier)
	{
		val fileContents = new ArrayList<GenerationContent>
		val dpe = backend.defaultExtensionProviderContentProvider
		fileContents += new GenerationContent(provider.interfaceName + ".h", dpe.getInterfaceHeaderFileContent(provider), false)
		fileContents += new GenerationContent("CMakeLists.txt", backend.cmakeContentProvider.getCMakeFileContent(provider), false)
		// Generates .h and .cc if they does not exists
		fileContents += new GenerationContent(provider.className + ".h", dpe.getHeaderFileContent(provider), true)
		fileContents += new GenerationContent(provider.className + ".cc", dpe.getSourceFileContent(provider), true)
		if (provider.linearAlgebra)
		{
			fileContents += new GenerationContent(IrTypeExtensions.VectorClass + ".h", dpe.getVectorHeaderFileContent(provider), true)
			fileContents += new GenerationContent(IrTypeExtensions.VectorClass + ".cc", dpe.getVectorSourceFileContent(provider), true)
			fileContents += new GenerationContent(IrTypeExtensions.MatrixClass + ".h", dpe.getMatrixHeaderFileContent(provider), true)
			fileContents += new GenerationContent(IrTypeExtensions.MatrixClass + ".cc", dpe.getMatrixSourceFileContent(provider), true)
		}
		return fileContents
	}
}