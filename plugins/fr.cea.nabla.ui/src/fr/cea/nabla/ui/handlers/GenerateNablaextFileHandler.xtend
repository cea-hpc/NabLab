package fr.cea.nabla.ui.handlers

import com.google.inject.Inject
import com.google.inject.Provider
import com.google.inject.Singleton
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher.MessageType
import fr.cea.nabla.generator.providers.NablaextFileGenerator
import fr.cea.nabla.ir.Utils
import fr.cea.nabla.nabla.NablaExtension
import org.eclipse.core.resources.IFile
import org.eclipse.core.resources.IResource
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.swt.widgets.Shell

@Singleton
class GenerateNablaextFileHandler extends AbstractGenerateHandler
{
	@Inject NablaextFileGenerator generator
	@Inject Provider<ResourceSet> resourceSetProvider

	override generate(IFile nablaFile, Shell shell)
	{
		val project = nablaFile.project

		consoleFactory.openConsole
		consoleFactory.clearAndActivateConsole
		val traceFunction = [MessageType type, String msg | consoleFactory.printConsole(type, msg)]
		dispatcher.traceListeners += traceFunction

		new Thread
		([
			try
			{
				consoleFactory.printConsole(MessageType.Start, "Starting generation process for: " + nablaFile.name)
				consoleFactory.printConsole(MessageType.Exec, "Loading nabla resources")
				val plaftormUri = URI::createPlatformResourceURI(project.name + '/' + nablaFile.projectRelativePath, true)
				val resourceSet = resourceSetProvider.get
				val uriMap = resourceSet.URIConverter.URIMap
				uriMap.put(URI::createURI('platform:/resource/fr.cea.nabla/'), URI::createURI('platform:/plugin/fr.cea.nabla/'))
				val emfResource = resourceSet.createResource(plaftormUri)
				EcoreUtil::resolveAll(resourceSet)
				emfResource.load(null)

				val startTime = System.currentTimeMillis
				val nablaExt = emfResource.contents.filter(NablaExtension).head
				generator.generate(nablaExt, project)
				val endTime = System.currentTimeMillis
				consoleFactory.printConsole(MessageType.Exec, "Code generation ended in " + (endTime-startTime)/1000.0 + "s")

				project.refreshLocal(IResource::DEPTH_INFINITE, null)
				consoleFactory.printConsole(MessageType.End, "Generation ended successfully for: " + nablaFile.name)
			}
			catch (Exception e)
			{
				consoleFactory.printConsole(MessageType.Error, "Generation failed for: " + nablaFile.name)
				consoleFactory.printConsole(MessageType.Error, e.message)
				consoleFactory.printConsole(MessageType.Error, Utils.getStackTrace(e))
			}
		]).start

		dispatcher.traceListeners -= traceFunction
	}
}