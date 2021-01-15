package fr.cea.nabla.generator.providers

import com.google.inject.Inject
import fr.cea.nabla.generator.BackendFactory
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher.MessageType
import fr.cea.nabla.generator.StandaloneGeneratorBase
import fr.cea.nabla.ir.generator.CMakeUtils
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.nablaext.ExtensionProvider
import fr.cea.nabla.nablaext.TargetType
import fr.cea.nabla.nablagen.Target
import fr.cea.nabla.nablagen.TargetVar
import java.util.ArrayList

class JniProviderGenerator extends StandaloneGeneratorBase
{
	@Inject BackendFactory backendFactory
	@Inject extension ProvidersUtils
	val jniProviderHomes = new ArrayList<String>

	def generate(String baseDir, String projectDir, ExtensionProvider provider)
	{
		val fsa = getConfiguredFileSystemAccess(baseDir, false)
		jniProviderHomes += baseDir + '/' + projectDir
		dispatcher.post(MessageType::Exec, "Generating JNI extension provider: " + provider.name + "Jni")
		val generator = getCodeGenerator(provider.target)
		generate(fsa, generator.getGenerationContents(provider.toIrExtensionProvider, provider.extension.irFunctions), projectDir + '/src')
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

	private def getCodeGenerator(TargetType targetType)
	{
		val backend = backendFactory.getCppBackend(targetType)
		new fr.cea.nabla.ir.generator.jni.JniProviderGenerator(backend)
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

		message(STATUS "Do not forget '-Djava.library.path=${CMAKE_BINARY_DIR}' before executing java")

		«FOR jniProvider : jniProviderHomes»
		«val jniProviderName = jniProvider.split('/').last»
		ADD_CUSTOM_TARGET(link_jni_so ALL COMMAND ${CMAKE_COMMAND} -E create_symlink ./«jniProviderName»/lib«jniProviderName.toLowerCase».so ${CMAKE_BINARY_DIR}/lib«jniProviderName.toLowerCase».so)
		«ENDFOR»

		«CMakeUtils.fileFooter»
	'''
}