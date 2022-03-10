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
import fr.cea.nabla.ir.generator.CMakeUtils
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
		this.envVars += new Pair(CMakeUtils.WS_PATH, formatPath(wsPath))
		this.envVars += new Pair("PYTHONPATH", "$" + CMakeUtils.WS_PATH + "/.nablab/mesh/cartesianmesh2dnumpy:" + "$" + CMakeUtils.WS_PATH + "/.nablab/linearalgebra/linearalgebranumpy")
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
			{
				fileContents += new GenerationContent("run.sh", getRunContent(fileName), false)
				fileContents += new GenerationContent("runvenv.sh", getRunVenvContent(fileName), false)
			}
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

	private def getRunContent(String pyFileName)
	'''
	# «Utils::doNotEditWarning»
	#
	#!/bin/sh
	#
	#
	# Excute «pyFileName» with the installed python3.
	# Numpy and plyvel modules must be installed.
	# To reproduce results, use runvenv.sh.
	#
	«FOR v : envVars»
	export «v.key»=«v.value»
	«ENDFOR»
	python3 «pyFileName» $*
	'''

	private def getRunVenvContent(String pyFileName)
	'''
	# «Utils::doNotEditWarning»
	#
	#!/bin/sh
	#
	#
	# Execute «pyFileName» in a virtual environment.
	# Used by tests to reproduce results.
	#
	«FOR v : envVars»
	export «v.key»=«v.value»
	«ENDFOR»

	echo ==== Creating Python virtual environment
	python3 -m venv .venv
	.venv/bin/python -m pip install --upgrade pip
	.venv/bin/python -m pip install numpy plyvel

	echo 
	echo ===== Starting execution
	.venv/bin/python «pyFileName» $*
	'''

	private def formatPath(String path)
	{
		if (path.startsWith(CMakeUtils.userDir))
			path.replace(CMakeUtils.userDir, "$HOME")
		else
			path
	}
}