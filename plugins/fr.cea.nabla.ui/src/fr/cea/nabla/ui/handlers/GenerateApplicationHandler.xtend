package fr.cea.nabla.ui.handlers

import com.google.inject.Inject
import com.google.inject.Provider
import com.google.inject.Singleton
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher.MessageType
import fr.cea.nabla.generator.NablagenInterpreter
import fr.cea.nabla.ir.Utils
import fr.cea.nabla.nablagen.NablagenRoot
import org.eclipse.core.resources.IFile
import org.eclipse.core.resources.IResource
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.swt.SWT
import org.eclipse.swt.widgets.Shell

@Singleton
class GenerateApplicationHandler extends AbstractGenerateHandler
{
	@Inject Provider<ResourceSet> resourceSetProvider
	@Inject Provider<NablagenInterpreter> interpreterProvider

	override generate(IFile nablagenFile, Shell shell)
	{
		val interpreter = interpreterProvider.get
		val project = nablagenFile.project

		consoleFactory.openConsole
		val traceFunction = [MessageType type, String msg | consoleFactory.printConsole(type, msg)]
		dispatcher.traceListeners += traceFunction

		new Thread
		([
			try
			{
				consoleFactory.clearAndActivateConsole
				shell.display.syncExec([shell.cursor = shell.display.getSystemCursor(SWT.CURSOR_WAIT)])
				consoleFactory.printConsole(MessageType.Start, "Starting generation process for: " + nablagenFile.name)
				consoleFactory.printConsole(MessageType.Exec, "Loading nablagen and nabla resources")
				val plaftormUri = URI::createPlatformResourceURI(project.name + '/' + nablagenFile.projectRelativePath, true)
				val resourceSet = resourceSetProvider.get
				val uriMap = resourceSet.URIConverter.URIMap
				uriMap.put(URI::createURI('platform:/resource/fr.cea.nabla/'), URI::createURI('platform:/plugin/fr.cea.nabla/'))
				val emfResource = resourceSet.createResource(plaftormUri)
				EcoreUtil::resolveAll(resourceSet)
				emfResource.load(null)
				val ngen = emfResource.contents.filter(NablagenRoot).head
				interpreter.generateCode(ngen, project.location.toString)
				project.refreshLocal(IResource::DEPTH_INFINITE, null)
				shell.display.syncExec([shell.cursor = null])
				consoleFactory.printConsole(MessageType.End, "Generation ended successfully for: " + nablagenFile.name)
			}
			catch (Exception e)
			{
				shell.display.syncExec([shell.cursor = null])
				consoleFactory.printConsole(MessageType.Error, "Generation failed for: " + nablagenFile.name)
				consoleFactory.printConsole(MessageType.Error, e.message)
				consoleFactory.printConsole(MessageType.Error, Utils.getStackTrace(e))
			}
		]).start

		dispatcher.traceListeners -= traceFunction
	}
}