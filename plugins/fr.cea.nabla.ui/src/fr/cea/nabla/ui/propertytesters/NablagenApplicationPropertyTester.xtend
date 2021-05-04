package fr.cea.nabla.ui.propertytesters

import com.google.inject.Inject
import com.google.inject.Provider
import fr.cea.nabla.nablagen.NablagenApplication
import org.eclipse.core.expressions.PropertyTester
import org.eclipse.core.resources.IFile
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.ResourceSet

class NablagenApplicationPropertyTester extends PropertyTester
{
	@Inject Provider<ResourceSet> rSetProvider

	override test(Object receiver, String property, Object[] args, Object expectedValue)
	{
		if (receiver instanceof IFile)
		{
			// check if file contains a NablagenApplication (not a NablagenProviderList) 
			val path = receiver.fullPath.toString
			val uri = URI.createPlatformResourceURI(path, true)
			val rSet = rSetProvider.get
			val r = rSet.getResource(uri, true)
			val roots = r.contents.filter(NablagenApplication)
			return (roots !== null && !roots.empty)
		}
		else
			return false
	}
}