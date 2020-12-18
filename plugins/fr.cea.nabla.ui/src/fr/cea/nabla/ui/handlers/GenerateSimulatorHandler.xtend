package fr.cea.nabla.ui.handlers

import com.google.inject.Inject
import com.google.inject.Provider
import com.google.inject.Singleton
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher.MessageType
import fr.cea.nabla.generator.NablagenInterpreter
import fr.cea.nabla.ir.Utils
import fr.cea.nabla.nablagen.NablagenRoot
import fr.cea.nabla.ui.NabLabConsoleFactory
import org.eclipse.core.commands.AbstractHandler
import org.eclipse.core.commands.ExecutionEvent
import org.eclipse.core.commands.ExecutionException
import org.eclipse.core.resources.IFile
import org.eclipse.core.resources.IProject
import org.eclipse.core.resources.IResource
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.jface.viewers.TreeSelection
import org.eclipse.swt.SWT
import org.eclipse.swt.widgets.Shell
import org.eclipse.ui.handlers.HandlerUtil

@Singleton
class GenerateSimulatorHandler extends AbstractHandler
{
	@Inject Provider<ResourceSet> resourceSetProvider
	@Inject Provider<NablagenInterpreter> interpreterProvider
	@Inject NabLabConsoleFactory consoleFactory

	override execute(ExecutionEvent event) throws ExecutionException
	{
		val selection = HandlerUtil::getActiveMenuSelection(event)
		if (selection !== null && selection instanceof TreeSelection)
		{
			val elt = (selection as TreeSelection).firstElement
			if (elt instanceof IFile)
			{
				// get the eResource content
				val plaftormUri = URI::createPlatformResourceURI(elt.project.name + '/' + elt.projectRelativePath, true)
				val resourceSet = resourceSetProvider.get
				val uriMap = resourceSet.URIConverter.URIMap
				uriMap.put(URI::createURI('platform:/resource/fr.cea.nabla/'), URI::createURI('platform:/plugin/fr.cea.nabla/'))
				val emfResource = resourceSet.createResource(plaftormUri)
				EcoreUtil::resolveAll(resourceSet)
				emfResource.load(null)

				// start the generation
				val shell = HandlerUtil::getActiveShell(event)
				val ngen = emfResource.contents.filter(NablagenRoot).head
				if (ngen !== null) generate(elt.project, ngen, shell)
			}
		}
		return selection
	}

	private def generate(IProject project, NablagenRoot ngen, Shell shell)
	{
		val interpreter = interpreterProvider.get

		consoleFactory.openConsole
		interpreter.traceListeners += [String msg | consoleFactory.printConsole(MessageType.Exec, msg)]

		new Thread
		([
			try
			{
				consoleFactory.clearAndActivateConsole
				consoleFactory.printConsole(MessageType.Start, "Starting generation process for: " + project.name)
				consoleFactory.printConsole(MessageType.Exec, "Loading nablagen and nabla resources")

				val baseDir = project.location.toString
				consoleFactory.printConsole(MessageType.Exec, "Starting NabLab to IR model transformation")
				val startTime = System.currentTimeMillis
				val ir = interpreter.buildIr(ngen, baseDir)
				val afterConvertionTime = System.currentTimeMillis
				consoleFactory.printConsole(MessageType.Exec, "NabLab to IR model transformation ended in " + (afterConvertionTime-startTime)/1000.0 + "s")

				consoleFactory.printConsole(MessageType.Exec, "Starting code generation")
				shell.display.syncExec([shell.cursor = shell.display.getSystemCursor(SWT.CURSOR_WAIT)])
				interpreter.generateCode(ir, ngen.targets, ngen.mainModule.iterationMax.name, ngen.mainModule.timeMax.name, baseDir, ngen.levelDB)
				shell.display.syncExec([shell.cursor = null])
				val afterGenerationTime = System.currentTimeMillis
				consoleFactory.printConsole(MessageType.Exec, "Code generation ended in " + (afterGenerationTime-afterConvertionTime)/1000.0 + "s")
				consoleFactory.printConsole(MessageType.Exec, "Total time: " + (afterGenerationTime-startTime)/1000.0 + "s");

				project.refreshLocal(IResource::DEPTH_INFINITE, null)
				consoleFactory.printConsole(MessageType.End, "Generation ended successfully for: " + project.name)
			}
			catch (Exception e)
			{
				consoleFactory.printConsole(MessageType.Error, "Generation failed for: " + project.name)
				consoleFactory.printConsole(MessageType.Error, e.message)
				consoleFactory.printConsole(MessageType.Error, Utils.getStackTrace(e))
			}
		]).start
	}
}