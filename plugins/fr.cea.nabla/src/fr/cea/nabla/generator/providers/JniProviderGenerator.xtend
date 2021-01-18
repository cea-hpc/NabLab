package fr.cea.nabla.generator.providers

import com.google.inject.Inject
import fr.cea.nabla.generator.BackendFactory
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher.MessageType
import fr.cea.nabla.generator.StandaloneGeneratorBase
import fr.cea.nabla.ir.generator.CMakeUtils
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.nablaext.ExtensionProvider
import fr.cea.nabla.nablagen.Target
import fr.cea.nabla.nablagen.TargetVar
import java.util.ArrayList

class JniProviderGenerator extends StandaloneGeneratorBase
{
	@Inject BackendFactory backendFactory
	@Inject extension ProvidersUtils
	val jniProviderHomes = new ArrayList<String>

	def generate(String baseDir, String providerDir, String installDir, ExtensionProvider provider)
	{
		val fsa = getConfiguredFileSystemAccess(baseDir, false)
		jniProviderHomes += baseDir + '/' + providerDir
		dispatcher.post(MessageType::Exec, "Generating JNI extension provider: " + provider.name + "Jni")
		val backend = backendFactory.getCppBackend(provider.target)
		val generator = new fr.cea.nabla.ir.generator.jni.JniProviderGenerator(backend)
		generate(fsa, generator.getGenerationContents(toIrExtensionProvider(provider, installDir), provider.extension.irFunctions), providerDir + '/src')
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
		add_subdirectory(«jniProvider»/src ${CMAKE_BINARY_DIR}/«jniProviderName»)
		«ENDFOR»

		«CMakeUtils.fileFooter»
	'''
}