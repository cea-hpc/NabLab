/*******************************************************************************
 * Copyright (c) 2018 CEA
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
	protected static val OutputDir = 'output'
	protected val String moduleName

	protected new(String moduleName)
	{ 
		this.moduleName = moduleName
		val outputDir = new File(OutputDir)
		if (outputDir.exists)
			outputDir.listFiles.forEach[x | x.delete]
		else
			outputDir.mkdir
	}

	abstract def void writeFile(int iteration, double time, double[][] nodes, Quad[] cells, Map<String, double[]> cellVariables, Map<String, double[]> nodeVariables)	
}