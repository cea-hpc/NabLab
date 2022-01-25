/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.arcane

import fr.cea.nabla.ir.UnzipHelper
import fr.cea.nabla.ir.generator.CMakeUtils
import fr.cea.nabla.ir.generator.GenerationContent
import fr.cea.nabla.ir.generator.IrCodeGenerator
import fr.cea.nabla.ir.ir.DefaultExtensionProvider
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.transformers.ReplaceReductions
import java.util.ArrayList
import java.util.LinkedHashSet

class ArcaneGenerator implements IrCodeGenerator
{
	val cMakeVars = new LinkedHashSet<Pair<String, String>>

	override getName() { "Arcane" }

	override getIrTransformationSteps()
	{
		#[new ReplaceReductions(true) /*, new AddOperatorsForArcaneRealNTypes */ ]
	}

	new(String wsPath, Iterable<Pair<String, String>> cmakeVars)
	{
		cmakeVars.forEach[x | this.cMakeVars += x]
		// Set WS_PATH variables in CMake and unzip NRepository if necessary
		this.cMakeVars += new Pair(CMakeUtils.WS_PATH, wsPath)
		UnzipHelper::unzipNRepository(wsPath)
	}

	override getGenerationContents(IrRoot ir, (String)=>void traceNotifier)
	{
		if (ir.postProcessing !== null)
			traceNotifier.apply(TracePrefix + "VtkOutput block ignored for Arcane target. Put post processing info in '.arc' data file")

		val fileContents = new ArrayList<GenerationContent>
		for (module : ir.modules)
		{
			fileContents += new GenerationContent(module.name.toFirstUpper + '.axl', AxlContentProvider.getContent(module), false)
			val className = ArcaneUtils.getModuleName(module)
			fileContents += new GenerationContent(className + '.h', IrModuleContentProvider.getHeaderFileContent(module, className), false)
			fileContents += new GenerationContent(className + '.cc', IrModuleContentProvider.getSourceFileContent(module, className), false)
		}
		fileContents += new GenerationContent('CMakeLists.txt', CMakeContentProvider.getContent(ir, cMakeVars), false)
		fileContents += new GenerationContent(ir.name + '.config', TimeLoopContentProvider.getContent(ir), false)
		fileContents += new GenerationContent('main.cc', MainContentProvider.getContent(ir), false)
		return fileContents
	}

	override getGenerationContents(DefaultExtensionProvider provider, (String)=>void traceNotifier)
	{
		throw new UnsupportedOperationException("Not yet implemented")
	}
}