package fr.cea.nabla.ui.propertytesters

import com.google.inject.Inject
import com.google.inject.Provider
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
			// check if file contains at least one NablaRoot
			val path = receiver.fullPath.toString
			val uri = URI.createPlatformResourceURI(path, true)
			val rSet = rSetProvider.get
			val r = rSet.getResource(uri, true)
			val roots = r.contents.filter(NablaRoot)
			return (roots !== null && !roots.empty)
		}
		else
			return false
	}
}