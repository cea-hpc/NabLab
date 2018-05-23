package fr.cea.nabla

import fr.cea.nabla.nabla.NablaModule
import org.eclipse.core.resources.IFile
import org.eclipse.core.resources.IResource
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.Resource

class Utils 
{
	static def IFile toEclipseFile(Resource emfResource)
	{
		val uri = emfResource.URI
		if (uri !== null && uri.platformResource)
		{
			val ws = ResourcesPlugin::workspace.root
			val platformString = uri.toPlatformString(true)
			val resource = ws.findMember(platformString)
			if (resource !== null && resource.exists && resource.type == IResource::FILE)
				return resource as IFile
		}
		return null
	}	
	
	static def NablaModule getNablaModule(EObject it)
	{
		if (eContainer === null) null
		else if (eContainer instanceof NablaModule) eContainer as NablaModule
		else eContainer.nablaModule
	}
}