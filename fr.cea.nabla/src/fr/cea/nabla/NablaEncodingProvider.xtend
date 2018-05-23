package fr.cea.nabla

import com.google.inject.Inject
import org.eclipse.emf.common.util.URI
import org.eclipse.xtext.parser.IEncodingProvider

class NablaEncodingProvider implements IEncodingProvider 
{
	@Inject IEncodingProvider.Runtime defaultProvider
	
	override getEncoding(URI uri) 
	{
		if (uri.lastSegment.endsWith('.nabla') || uri.lastSegment.endsWith('.n')) 'UTF-8'
		else defaultProvider.getEncoding(uri)
	}	
}