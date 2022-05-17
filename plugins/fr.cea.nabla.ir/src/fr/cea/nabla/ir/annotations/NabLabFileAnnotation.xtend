/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.annotations

import fr.cea.nabla.ir.ir.IrAnnotable
import fr.cea.nabla.ir.ir.IrAnnotation

class NabLabFileAnnotation
{
	public static val ANNOTATION_SOURCE = NabLabFileAnnotation.name
	public static val ANNOTATION_URI_DETAIL = "uri"
	public static val ANNOTATION_OFFSET_DETAIL = "offset"
	public static val ANNOTATION_LENGTH_DETAIL = "length"

	val IrAnnotation irAnnotation

	static def tryToGet(IrAnnotable object)
	{
		val o = object.annotations.findFirst[x | x.source == ANNOTATION_SOURCE]
		if (o === null) null
		else new NabLabFileAnnotation(o)
	}

	def getUri()
	{
		irAnnotation.details.get(ANNOTATION_URI_DETAIL)
	}

	def int getOffset()
	{
		Integer::parseInt(irAnnotation.details.get(ANNOTATION_OFFSET_DETAIL))
	}

	def int getLength()
	{
		Integer::parseInt(irAnnotation.details.get(ANNOTATION_LENGTH_DETAIL))
	}

	private new(IrAnnotation irAnnotation)
	{
		this.irAnnotation = irAnnotation
	}
}