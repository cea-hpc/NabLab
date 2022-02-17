/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.python

import fr.cea.nabla.ir.IrTypeExtensions
import fr.cea.nabla.ir.UnzipHelper
import fr.cea.nabla.ir.generator.GenerationContent
import fr.cea.nabla.ir.generator.IrCodeGenerator
import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.ir.DefaultExtensionProvider
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.transformers.PreventFunctionOverloading
import fr.cea.nabla.ir.transformers.ReplaceReductions
import fr.cea.nabla.ir.transformers.SetPythonOperatorNames
import java.util.ArrayList
import java.util.LinkedHashSet

import static extension fr.cea.nabla.ir.ExtensionProviderExtensions.*

class PythonGenerator implements IrCodeGenerator
{
	val boolean hasLevelDB
	val envVars = new LinkedHashSet<Pair<String, String>>

	new(String wsPath, boolean hasLevelDB, Iterable<Pair<String, String>> envVars)
	{
		this.hasLevelDB = hasLevelDB
		envVars.forEach[x | this.envVars += x]

		// Set WS_PATH variables and unzip NRepository if necessary
		this.envVars += new Pair("PYTHONPATH", wsPath + "/.nablab/mesh/cartesianmesh2dnumpy:" + wsPath + "/.nablab/linearalgebra/linearalgebranumpy")
		UnzipHelper::unzipNRepository(wsPath)
	}

	override getName() { "Python" }

	override getIrTransformationSteps()
	{
		#[
			new ReplaceReductions(true), // parallel loops and reductions not yet implemented
			new SetPythonOperatorNames,
			new PreventFunctionOverloading
		]
	}

	override getGenerationContents(IrRoot ir, (String)=>void traceNotifier)
	{
		val fileContents = new ArrayList<GenerationContent>
		for (module : ir.modules)
		{
			val fileName = module.name.toLowerCase + '.py'
			fileContents += new GenerationContent(fileName, IrModuleContentProvider.getFileContent(module, hasLevelDB), false)
			if (module.main)
				fileContents += new GenerationContent("launch.sh", getShellScriptContent(fileName), false)
		}
		return fileContents
	}

	override getGenerationContents(DefaultExtensionProvider provider, (String)=>void traceNotifier)
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

	private def getShellScriptContent(String pyFileName)
	'''
	# «Utils::doNotEditWarning»
	#
	#!/bin/sh
	#
	«FOR v : envVars»
	«v.key»=«v.value»
	«ENDFOR»
	python3 «pyFileName» $*
	'''
}