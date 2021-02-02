package fr.cea.nabla.ui.propertytesters

import com.google.inject.Inject
import com.google.inject.Provider
import fr.cea.nabla.nabla.NablaExtension
import fr.cea.nabla.nabla.NablaRoot
import org.eclipse.core.expressions.PropertyTester
import org.eclipse.core.resources.IFile
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.ResourceSet

class NablaFileContentPropertyTester extends PropertyTester
{
	@Inject Provider<ResourceSet> rSetProvider

	override test(Object receiver, String property, Object[] args, Object expectedValue)
	{
		if (receiver instanceof IFile)
		{
			// check if file content is NablaExtension
			val path = receiver.fullPath.toString
			val uri = URI.createPlatformResourceURI(path, true)
			val rSet = rSetProvider.get
			val r = rSet.getResource(uri, true)
			val rootObject = r.contents.filter(NablaRoot).head
			return rootObject instanceof NablaExtension
		}
		else
			return false
	}
}