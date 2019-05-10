package fr.cea.nabla.sirius;

import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.core.runtime.IStatus;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.sirius.business.api.resource.strategy.AbstractResourceStrategyImpl;
import org.eclipse.sirius.business.api.resource.strategy.ResourceStrategy.ResourceStrategyType;
import org.eclipse.sirius.business.api.session.Session;

public class NablaResourceStrategy extends AbstractResourceStrategyImpl 
{
	@Override
	public boolean canHandle(Resource resource, ResourceStrategyType resourceStrategyType) {
		System.out.println("NablaResourceStrategy.canHandle()");
		return super.canHandle(resource, resourceStrategyType);
	}

	@Override
	public boolean isLoadableModel(URI uri, Session session) {
		System.out.println("NablaResourceStrategy.isLoadableModel()");
		return super.isLoadableModel(uri, session);
	}

	@Override
	public IStatus releaseResourceAtResourceSetDispose(Resource resource, IProgressMonitor monitor) {
		System.out.println("NablaResourceStrategy.releaseResourceAtResourceSetDispose()");
		return super.releaseResourceAtResourceSetDispose(resource, monitor);
	}

	@Override
	public boolean isPotentialSemanticResource(URI uri)
	{
		System.out.println("NablaResourceStrategy.isPotentialSemanticResource()");
		boolean result = super.isPotentialSemanticResource(uri);
		if (result && uri != null)
		{
			result = !uri.toString().startsWith("java:/Objects/");
		}
		return result;
	}

	@Override
	public boolean canHandle(URI resourceURI, ResourceStrategyType resourceStrategyType)
	{
		System.out.println("NablaResourceStrategy.canHandle()");
		//return ResourceStrategyType. SEMANTIC_RESOURCE.equals(resourceStrategyType);
		return true;
	}
}
