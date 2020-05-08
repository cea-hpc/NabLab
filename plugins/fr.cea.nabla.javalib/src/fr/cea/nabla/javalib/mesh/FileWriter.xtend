/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.javalib.mesh

import java.io.File
import java.util.Map

abstract class FileWriter 
{
	protected val String moduleName
	protected val String outputDirName

	def isDisabled() { outputDirName.nullOrEmpty }

	protected new(String moduleName, String outputDirName)
	{ 
		this.moduleName = moduleName
		this.outputDirName = outputDirName

		if (!disabled)
		{
			val outputDir = new File(outputDirName)
			if (!outputDir.exists)
				throw new RuntimeException("Output directory does not exist: " + outputDir.absolutePath)
		}
	}

	abstract def void writeFile(int iteration, double time, double[][] nodes, Quad[] cells, Map<String, double[]> cellVariables, Map<String, double[]> nodeVariables)
}