/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir

import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream
import java.net.URI
import java.util.zip.ZipInputStream
import org.eclipse.core.runtime.FileLocator
import org.eclipse.core.runtime.Platform

class UnzipHelper
{
	def static void unzipNRepository(String outputPath)
	{
		unzipResource(new File(outputPath), IrUtils::NRepository)
	}

	private def static void unzipResource(File outputDirectory, String resourceName)
	{
		// check if c++ resources are available in the output folder
		if (outputDirectory.exists && outputDirectory.isDirectory &&
			!outputDirectory.list.contains(resourceName) && Platform.isRunning)
		{
			// c++ resources not available => unzip them
			// For JunitTests, launched from dev environment, copy is not possible
			val bundle = Platform.getBundle("fr.cea.nabla.ir")
			val cppResourcesUrl = bundle.getEntry("resources/" + resourceName.toLowerCase + ".zip")
			val tmpURI = FileLocator.toFileURL(cppResourcesUrl)
			// need to use a 3-arg constructor in order to properly escape file system chars
			val zipFileUri = new URI(tmpURI.protocol, tmpURI.path, null)
			val outputFolderUri = outputDirectory.toURI
			unzip(zipFileUri, outputFolderUri)
		}
	}

	def static void unzip(URI zipFilePath, URI destDir)
	{
		val dir = new File(destDir)
		// create output directory if it doesn't exist
		if (!dir.exists) dir.mkdirs

		// Buffer for read and write data to file
		val buffer = newByteArrayOfSize(1024)
		val zis = new ZipInputStream(new FileInputStream(new File(zipFilePath)))
		var ze = zis.nextEntry
		while (ze !== null)
		{
			val newFile = new File(dir, ze.name)
			//println("Unzipping to " + newFile.absolutePath)

			if (ze.directory)
			{
				newFile.mkdirs
			}
			else
			{
				val parent = new File(newFile.parent)
				if (!parent.exists) parent.mkdirs

				// Create directories for sub directories in zip
				if (!newFile.exists) newFile.createNewFile
				val fos = new FileOutputStream(newFile)
				var int len
				while ((len = zis.read(buffer)) > 0)
					fos.write(buffer, 0, len)
				fos.close
			}
			ze = zis.nextEntry
		}

		// Close last ZipEntry
		zis.closeEntry
		zis.close
	}
}