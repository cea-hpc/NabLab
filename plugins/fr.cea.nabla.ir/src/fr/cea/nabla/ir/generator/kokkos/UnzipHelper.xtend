package fr.cea.nabla.ir.generator.kokkos

import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream
import java.io.IOException
import java.util.zip.ZipInputStream

class UnzipHelper 
{
	def static void unzip(String zipFilePath, String destDir) 
	{
		val dir = new File(destDir)

		// create output directory if it doesn't exist
		if (!dir.exists) dir.mkdirs
		var FileInputStream fis

		// Buffer for read and write data to file
		val buffer = newByteArrayOfSize(1024)
		try 
		{
			fis = new FileInputStream(zipFilePath)
			val zis = new ZipInputStream(fis)
			var ze = zis.nextEntry
			while (ze !== null)
			{
				val fileName = ze.name
				val newFile = new File(destDir + File.separator + fileName)
				println("Unzipping to " + newFile.absolutePath)

				// Create directories for sub directories in zip
				new File(newFile.parent).mkdirs
				val fos = new FileOutputStream(newFile)
				var int len
				while ((len = zis.read(buffer)) > 0)
					fos.write(buffer, 0, len)
				fos.close

				// Close this ZipEntry
				zis.closeEntry
				ze = zis.nextEntry
			}

			// Close last ZipEntry
			zis.closeEntry
			zis.close
			fis.close
		} 
		catch (IOException e) 
		{
			e.printStackTrace
		}
	}
}