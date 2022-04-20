/*******************************************************************************
 * Copyright (c) 2022 CEA
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
import java.util.jar.JarInputStream
import java.util.zip.ZipInputStream
import org.eclipse.core.runtime.FileLocator

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
			!outputDirectory.list.contains(resourceName))
		{
			// c++ resources not available => unzip them
			// For JunitTests, launched from dev environment, copy is not possible
			val nzipFile = System.getProperty("NZIP_FILE")
			val nzipFileUri = if (nzipFile.nullOrEmpty)
			{
				val cppResources = UnzipHelper.classLoader.getResource("resources/" + resourceName.toLowerCase + ".zip")
				val nzipFileUrl = FileLocator.toFileURL(cppResources)
				// need to use a 3-arg constructor in order to properly escape file system chars
				new URI(nzipFileUrl.protocol, nzipFileUrl.path, null)
			}
			else
			{
				val f = new File(nzipFile)
				f.toURI
			}
			val outputFolderUri = outputDirectory.toURI
			unzip(nzipFileUri, outputFolderUri)
		}
	}

	def static void unzip(URI zipFilePath, URI destDir)
	{
		val dir = new File(destDir)
		// create output directory if it doesn't exist
		if (!dir.exists) dir.mkdirs

		// Buffer for read and write data to file
		val buffer = newByteArrayOfSize(1024)
		var is =  null as ZipInputStream
		if (zipFilePath.toString.startsWith("jar:"))
		{
			val os = zipFilePath.toURL.openStream
			is = new JarInputStream(os)
		}
		else
		{
			val fis = new FileInputStream(new File(zipFilePath))
			is = new ZipInputStream(fis)
		}
		var ze = is.nextEntry
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
				while ((len = is.read(buffer)) > 0)
					fos.write(buffer, 0, len)
				fos.close
			}
			ze = is.nextEntry
		}

		// Close last ZipEntry
		is.closeEntry
		is.close
	}
}