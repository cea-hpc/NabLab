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


class AcceleratorAnnotation
{
	enum ViewDirection { In, Out }

	public static val ANNOTATION_SOURCE = AcceleratorAnnotation.name
	public static val ANNOTATION_VIEW_DIRECTION_DETAIL = "view_direction"

	val IrAnnotation irAnnotation

	static def tryToGet(IrAnnotable object)
	{
		val o = object.annotations.findFirst[x | x.source == ANNOTATION_SOURCE]
		if (o === null) null
		else new AcceleratorAnnotation(o)
	}

	def getViewDirection()
	{
		ViewDirection.valueOf(irAnnotation.details.get(ANNOTATION_VIEW_DIRECTION_DETAIL))
	}

	private new(IrAnnotation irAnnotation)
	{
		this.irAnnotation = irAnnotation
	}
}