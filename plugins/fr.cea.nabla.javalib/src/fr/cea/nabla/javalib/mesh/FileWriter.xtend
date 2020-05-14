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

abstract class FileWriter 
{
	protected val String moduleName
	protected val String directoryName

	def isDisabled() { directoryName.nullOrEmpty }

	protected new(String moduleName, String directoryName)
	{ 
		this.moduleName = moduleName
		this.directoryName = directoryName

		if (!disabled)
		{
			val outputDir = new File(directoryName)
			if (!outputDir.exists) outputDir.mkdir
		}
	}

	abstract def void writeFile(VtkFileContent content)
}