/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 * 	Benoit Lelandais - initial implementation
 * 	Marie-Pierre Oudot - initial implementation
 * 	Jean-Sylvain Camier - Nabla generation support
 *******************************************************************************/
package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.nabla.NablaModule
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.resource.ILocationInFileProvider

class IrAnnotationHelper 
{
	@Inject ILocationInFileProvider locationProvider
	
	public static val ANNOTATION_NABLA_ORIGIN_SOURCE = "nabla-origin"
	public static val ANNOTATION_URI_DETAIL = 'uri'
	public static val ANNOTATION_OFFSET_DETAIL = 'offset'
	public static val ANNOTATION_LENGTH_DETAIL = 'length'
	
	def dispatch toIrAnnotation(NablaModule it)
	{
		val annotation = createIrAnnot
		annotation.details.put(ANNOTATION_URI_DETAIL, eResource.URI.toString)
		return annotation
	}
	
	def dispatch toIrAnnotation(EObject it)
	{
		createIrAnnot
	}
	
	def getUriDetail(EObject o)
	{
		val irFile = o.nablaIrModule
		if (irFile === null) null
		else irFile.annotations.head.details.get(ANNOTATION_URI_DETAIL)
	}
	
	private def IrModule getNablaIrModule(EObject o)
	{
		if (o === null) null
		else if (o instanceof IrModule) o as IrModule
		else o.eContainer.nablaIrModule
	}
	
	private def createIrAnnot(EObject nablaElt)
	{
		val region = locationProvider.getFullTextRegion(nablaElt)
		if (region === null) throw new Exception('Ooops : impossible de créer une annotation pour : ' + nablaElt)
		
		IrFactory::eINSTANCE.createIrAnnotation => 
		[
			source = ANNOTATION_NABLA_ORIGIN_SOURCE
			details.put(ANNOTATION_OFFSET_DETAIL, region.offset.toString)
			details.put(ANNOTATION_LENGTH_DETAIL, region.length.toString)
		]
	}
}
