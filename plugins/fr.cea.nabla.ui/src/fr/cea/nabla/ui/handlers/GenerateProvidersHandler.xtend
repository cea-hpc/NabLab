package fr.cea.nabla.ui.handlers

import com.google.inject.Inject
import com.google.inject.Provider
import com.google.inject.Singleton
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher.MessageType
import fr.cea.nabla.generator.providers.JavaAndCppProviderGenerator
import fr.cea.nabla.ir.Utils
import fr.cea.nabla.nablaext.NablaextRoot
import org.eclipse.core.resources.IFile
import org.eclipse.core.resources.IResource
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.swt.widgets.Shell

@Singleton
class GenerateProvidersHandler extends AbstractGenerateHandler
{
	@Inject JavaAndCppProviderGenerator generator
	@Inject Provider<ResourceSet> resourceSetProvider

	override generate(IFile nablaextFile, Shell shell)
	{
		val project = nablaextFile.project

		consoleFactory.openConsole
		val traceFunction = [MessageType type, String msg | consoleFactory.printConsole(type, msg)]
		dispatcher.traceListeners += traceFunction

		new Thread
		([
			try
			{
				consoleFactory.clearAndActivateConsole
				consoleFactory.printConsole(MessageType.Start, "Starting generation process for: " + nablaextFile.name)
				consoleFactory.printConsole(MessageType.Exec, "Loading nabla resources")
				val plaftormUri = URI::createPlatformResourceURI(project.name + '/' + nablaextFile.projectRelativePath, true)
				val resourceSet = resourceSetProvider.get
				val uriMap = resourceSet.URIConverter.URIMap
				uriMap.put(URI::createURI('platform:/resource/fr.cea.nabla/'), URI::createURI('platform:/plugin/fr.cea.nabla/'))
				val emfResource = resourceSet.createResource(plaftormUri)
				EcoreUtil::resolveAll(resourceSet)
				emfResource.load(null)

				val startTime = System.currentTimeMillis
				val nablaextRoot = emfResource.contents.filter(NablaextRoot).head
				if (nablaextRoot !== null) generator.generate(nablaextRoot.providers, project)
				val endTime = System.currentTimeMillis
				consoleFactory.printConsole(MessageType.Exec, "Code generation ended in " + (endTime-startTime)/1000.0 + "s")

				project.refreshLocal(IResource::DEPTH_INFINITE, null)
				consoleFactory.printConsole(MessageType.End, "Generation ended successfully for: " + nablaextFile.name)
			}
			catch (Exception e)
			{
				consoleFactory.printConsole(MessageType.Error, "Generation failed for: " + nablaextFile.name)
				consoleFactory.printConsole(MessageType.Error, e.message)
				consoleFactory.printConsole(MessageType.Error, Utils.getStackTrace(e))
			}
		]).start

		dispatcher.traceListeners -= traceFunction
	}
}