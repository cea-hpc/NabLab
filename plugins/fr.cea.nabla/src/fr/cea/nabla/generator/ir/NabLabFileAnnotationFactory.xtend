/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import fr.cea.nabla.ir.annotations.NabLabFileAnnotation
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.resource.ILocationInFileProvider

class NabLabFileAnnotationFactory
{
	@Inject ILocationInFileProvider locationProvider

	def toNabLabFileAnnotation(EObject o)
	{
		val region = locationProvider.getFullTextRegion(o)
		if (region === null) throw new RuntimeException('Annotation creation error for: ' + o)
		val uri = ((o.eResource === null || o.eResource.URI === null) ? null : o.eResource.URI.toString)
		NabLabFileAnnotation.create(uri, region.offset, region.length).irAnnotation
	}
}
