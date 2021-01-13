package fr.cea.nabla.generator.providers

import com.google.inject.Inject
import fr.cea.nabla.generator.BackendFactory
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher.MessageType
import fr.cea.nabla.generator.StandaloneGeneratorBase
import fr.cea.nabla.nablaext.ExtensionProvider
import fr.cea.nabla.nablaext.TargetType

class JniProviderGenerator extends StandaloneGeneratorBase
{
	@Inject BackendFactory backendFactory
	@Inject extension ProvidersUtils

	def generate(String projectHome, ExtensionProvider provider)
	{
		val fsa = getConfiguredFileSystemAccess(projectHome, false)
		dispatcher.post(MessageType::Exec, "Generating JNI extension provider: " + provider.name + "Jni")
		val generator = getCodeGenerator(provider.target)
		generate(fsa, generator.getGenerationContents(provider.toIrExtensionProvider, provider.extension.irFunctions), 'providers')
	}

	private def getCodeGenerator(TargetType targetType)
	{
		val backend = backendFactory.getCppBackend(targetType)
		new fr.cea.nabla.ir.generator.jni.JniProviderGenerator(backend)
	}
}