/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.nabla.Job
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.resource.ILocationInFileProvider

import static fr.cea.nabla.ir.IrAnnotableExtensions.*

class IrAnnotationHelper 
{
	@Inject ILocationInFileProvider locationProvider

	def dispatch toIrAnnotation(Job it)
	{
		val annotation = createIrAnnot
		annotation.details.put(ANNOTATION_URI_DETAIL, eResource.URI.toString)
		return annotation
	}

	def dispatch toIrAnnotation(EObject it)
	{
		createIrAnnot
	}

	private def createIrAnnot(EObject nablaElt)
	{
		val region = locationProvider.getFullTextRegion(nablaElt)
		if (region === null) throw new RuntimeException('Ooops : impossible de créer une annotation pour : ' + nablaElt)

		IrFactory::eINSTANCE.createIrAnnotation => 
		[
			source = ANNOTATION_NABLA_ORIGIN_SOURCE
			details.put(ANNOTATION_OFFSET_DETAIL, region.offset.toString)
			details.put(ANNOTATION_LENGTH_DETAIL, region.length.toString)
		]
	}
}
