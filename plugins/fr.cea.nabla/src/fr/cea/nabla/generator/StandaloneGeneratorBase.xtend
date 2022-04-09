/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.generator

import com.google.common.base.Function
import com.google.inject.Inject
import com.google.inject.Provider
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher.MessageType
import fr.cea.nabla.ir.generator.GenerationContent
import java.io.File
import org.eclipse.xtext.generator.IOutputConfigurationProvider
import org.eclipse.xtext.generator.JavaIoFileSystemAccess
import org.eclipse.xtext.generator.OutputConfiguration

import static com.google.common.collect.Maps.uniqueIndex

abstract class StandaloneGeneratorBase
{
	@Inject public NablaGeneratorMessageDispatcher dispatcher
	@Inject protected Provider<JavaIoFileSystemAccess> fsaProvider
	@Inject protected IOutputConfigurationProvider outputConfigurationProvider

	protected def getConfiguredFileSystemAccess(String absoluteBasePath, boolean keepSrcGen)
	{
		val baseFolder = new File(absoluteBasePath)
		if (!baseFolder.exists || !(baseFolder.isDirectory))
			throw new RuntimeException('Invalid outputPath: ' + absoluteBasePath)

		val fsa = fsaProvider.get
		fsa.outputConfigurations = outputConfigurations
		fsa.outputConfigurations.values.forEach
		[
			if (keepSrcGen)
				outputDirectory = absoluteBasePath + '/' + outputDirectory
			else
				outputDirectory = absoluteBasePath
		]
		return fsa
	}

	protected def getOutputConfigurations()
	{
		val configurations = outputConfigurationProvider.outputConfigurations
		return uniqueIndex(configurations, new Function<OutputConfiguration, String>()
		{
			override apply(OutputConfiguration from) { return from.name }
		})
	}

	protected def generate(JavaIoFileSystemAccess fsa, Iterable<GenerationContent> generationContents, String applicationDir)
	{
		for (gc : generationContents)
		{
			val fullFileName = (applicationDir.nullOrEmpty ? gc.fileName : applicationDir + '/' + gc.fileName)
			// no generation if file already exists and generateOnce is true
			val isFileAndExists = fsa.isFile(fullFileName)
			if ( !(isFileAndExists && gc.generateOnce) )
			{
				if (isFileAndExists && isEqual(gc.fileContent, fsa, fullFileName))
				{
					// No generation if generated content is identical to file content.
					// Usefull to optimize compilation.
					dispatcher.post(MessageType::Exec, "    Generation and file contents identical, no overwrite: " + fullFileName)
				}
				else
				{
					dispatcher.post(MessageType::Exec, "    Generating: " + fullFileName)
					fsa.generateFile(fullFileName, gc.fileContent)
				}
			}
			else
			{
				dispatcher.post(MessageType::Exec, "    File already exists, no overwite: " + fullFileName)
			}
		}
	}

	/** Can be optimized in case of big files in using a BufferedReader to read the file */
	private def boolean isEqual(CharSequence newContent, JavaIoFileSystemAccess fsa, String fullFileName)
	{
		val oldContent = fsa.readTextFile(fullFileName)
		return (CharSequence.compare(newContent, oldContent) == 0)
	}
}