package fr.cea.nabla.generator

import com.google.common.base.Function
import com.google.inject.Inject
import com.google.inject.Provider
import java.io.File
import org.eclipse.xtext.generator.IOutputConfigurationProvider
import org.eclipse.xtext.generator.JavaIoFileSystemAccess
import org.eclipse.xtext.generator.OutputConfiguration

import static com.google.common.collect.Maps.uniqueIndex
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher.MessageType
import fr.cea.nabla.ir.generator.GenerationContent

abstract class StandaloneGeneratorBase
{
	@Inject protected Provider<JavaIoFileSystemAccess> fsaProvider
	@Inject protected IOutputConfigurationProvider outputConfigurationProvider
	@Inject protected NablaGeneratorMessageDispatcher dispatcher
	val userDir = System.getProperty("user.home")

	protected def getConfiguredFileSystemAccess(String absoluteBasePath, boolean keepSrcGen)
	{
		val baseFolder = new File(absoluteBasePath)
		if (!baseFolder.exists || !(baseFolder.isDirectory))
			throw new RuntimeException('** Invalid outputDir: ' + absoluteBasePath)

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

	protected def formatCMakePath(String path)
	{
		if (path.startsWith(userDir))
			path.replace(userDir, "$ENV{HOME}")
		else
			path
	}

	protected def formatJavaPath(String path)
	{
		if (path.startsWith(userDir))
			'''System.getProperty("user.home") + "«path.replace(userDir, '')»"'''
		else
			path
	}

	protected def generate(JavaIoFileSystemAccess fsa, Iterable<GenerationContent> generationContents, String relativeBaseDir)
	{
		for (gc : generationContents)
		{
			val fullFileName = (relativeBaseDir.nullOrEmpty ? gc.fileName : relativeBaseDir + '/' + gc.fileName)
			if ( !(fsa.isFile(fullFileName) && gc.generateOnce) )
			{
				dispatcher.post(MessageType::Exec, "    Generating: " + fullFileName)
				fsa.generateFile(fullFileName, gc.fileContent)
			}
		}
	}
}