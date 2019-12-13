package fr.cea.nabla.ui.launchconfig

import com.google.inject.Inject
import com.google.inject.Provider
import com.google.inject.Singleton
import fr.cea.nabla.nablagen.NablagenModule
import fr.cea.nabla.nablagen.Workflow
import fr.cea.nabla.ui.UiUtils
import fr.cea.nabla.workflow.WorkflowInterpreter
import org.eclipse.core.resources.IResource
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.ui.console.ConsolePlugin
import org.eclipse.ui.console.MessageConsole
import org.eclipse.ui.console.MessageConsoleStream

@Singleton
class NablagenRunner 
{
	val MessageConsoleStream stream
	@Inject Provider<ResourceSet> resourceSetProvider
	@Inject Provider<WorkflowInterpreter> interpretorProvider

	new()
	{
		val imageDescriptor = UiUtils::getImageDescriptor("icons/Nabla.gif")
		val image = if (imageDescriptor.present) imageDescriptor.get else null
		val console = new MessageConsole("Nabla Console", image)
		console.activate
		ConsolePlugin.^default.consoleManager.addConsoles(#[console])
		stream = console.newMessageStream
	}

	def launch(Workflow workflow)
	{
		val interpretor = interpretorProvider.get
		interpretor.addWorkflowTraceListener([msg | stream.print(msg)])
		interpretor.launch(workflow)
	}

	package def launch(IResource eclipseResource)
	{
		val plaftormUri = URI::createPlatformResourceURI(eclipseResource.project.name + '/' + eclipseResource.projectRelativePath, true)
		val resourceSet = resourceSetProvider.get
		val uriMap = resourceSet.URIConverter.URIMap
		uriMap.put(URI::createURI('platform:/resource/fr.cea.nabla/'), URI::createURI('platform:/plugin/fr.cea.nabla/'))
		val emfResource = resourceSet.createResource(plaftormUri)
		EcoreUtil::resolveAll(resourceSet)
		emfResource.load(null)
		for (module : emfResource.contents.filter(NablagenModule))
			if (module.workflow !== null) 
				module.workflow.launch
	}
}