package fr.cea.nabla.generator.providers

import com.google.inject.Inject
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher.MessageType
import fr.cea.nabla.generator.StandaloneGeneratorBase
import fr.cea.nabla.ir.generator.CMakeUtils
import fr.cea.nabla.ir.generator.cpp.Backend
import fr.cea.nabla.ir.ir.ExtensionProvider
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.nabla.NablaExtension
import fr.cea.nabla.nablagen.Target
import fr.cea.nabla.nablagen.TargetVar
import java.nio.file.Files
import java.nio.file.Paths
import java.util.ArrayList

class JniProviderGenerator extends StandaloneGeneratorBase
{
	public static val JNI = 'Jni'

	@Inject extension ProvidersUtils
	val jniProviderHomes = new ArrayList<String>

	def generateAndTransformProvider(Backend backend, NablaExtension ext, ExtensionProvider provider)
	{
		// The generator transforms the C++ provider in a JNI provider
		val generator = new fr.cea.nabla.ir.generator.jni.JniProviderGenerator(backend)
		val content = generator.getGenerationContents(provider, ext.irFunctions)
		jniProviderHomes += provider.projectDir

		dispatcher.post(MessageType::Exec, "Generating JNI extension provider project: " + provider.providerName)
		val pph = Paths.get(provider.projectDir)
		if (!Files.exists(pph)) Files.createDirectories(pph)
		val fsa = getConfiguredFileSystemAccess(provider.projectDir, false)
		generate(fsa, content, '/src')
	}

	def void convertToJni(ExtensionProvider provider)
	{
		fr.cea.nabla.ir.generator.jni.JniProviderGenerator.convertToJni(provider)
	}

	def generateGlobalCMakeIfNecessary(IrRoot ir, Target target, String baseDir)
	{
		if (!jniProviderHomes.empty)
		{
			val fsa = getConfiguredFileSystemAccess(baseDir + target.outputDir, false)
			val fullFileName = ir.name.toLowerCase + '/CMakeLists.txt'
			dispatcher.post(MessageType::Exec, "    Generating: " + fullFileName)
			fsa.generateFile(fullFileName, getCMakeContent(ir.name, jniProviderHomes, target.variables))
		}
	}

	private def getCMakeContent(String projectName, Iterable<String> jniProviderHomes, Iterable<TargetVar> variables)
	'''
		«CMakeUtils.fileHeader»

		«FOR v : variables»
		set(«v.key» «v.value»)
		«ENDFOR»

		project(«projectName»Project LANGUAGES NONE)

		«CMakeUtils.setCompiler»

		«FOR jniProvider : jniProviderHomes»
		«val jniProviderName = jniProvider.split('/').last»
		add_subdirectory(«CMakeUtils.formatCMakePath(jniProvider)»/src ${CMAKE_BINARY_DIR}/«jniProviderName»)
		«ENDFOR»

		«CMakeUtils.fileFooter»
	'''
}