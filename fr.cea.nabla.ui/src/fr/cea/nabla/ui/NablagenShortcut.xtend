package fr.cea.nabla.ui

import com.google.inject.Inject
import com.google.inject.Provider
import fr.cea.nabla.nablagen.NablagenModule
import fr.cea.nabla.workflow.WorkflowInterpretor
import org.eclipse.core.resources.IResource
import org.eclipse.debug.ui.ILaunchShortcut
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.jface.viewers.ISelection
import org.eclipse.jface.viewers.TreeSelection
import org.eclipse.ui.IEditorPart
import org.eclipse.xtext.ui.editor.XtextEditor

class NablagenShortcut implements ILaunchShortcut 
{
	@Inject Provider<ResourceSet> resourceSetProvider
	@Inject WorkflowInterpretor interpretor
	
	override launch(ISelection selection, String mode) 
	{
		if (selection !== null && selection instanceof TreeSelection)
		{
			val elt = (selection as TreeSelection).firstElement
			if (elt !== null && elt instanceof IResource)
				launchGeneration(elt as IResource)
		}
	}
	
	override launch(IEditorPart editor, String mode) 
	{
		if (editor instanceof XtextEditor)
		{
			val resource = (editor as XtextEditor).resource
			if (resource !== null)
				launchGeneration(resource)
		}
	}
	
	private def launchGeneration(IResource eclipseResource)
	{
		val plaftormUri = URI::createPlatformResourceURI(eclipseResource.project.name + '/' + eclipseResource.projectRelativePath, true)
		val resourceSet = resourceSetProvider.get
		val emfResource = resourceSet.createResource(plaftormUri)
		EcoreUtil::resolveAll(resourceSet)
		emfResource.load(null)
		for (module : emfResource.contents.filter(NablagenModule))
		{
			if (module.workflow !== null)
				interpretor.launch(module.workflow)
		}	
	}
}