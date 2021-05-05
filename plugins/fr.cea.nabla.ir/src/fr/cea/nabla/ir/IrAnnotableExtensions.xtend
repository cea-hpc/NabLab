/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir

import fr.cea.nabla.ir.ir.IrAnnotable

class IrAnnotableExtensions
{
	public static val ANNOTATION_NABLA_ORIGIN_SOURCE = "nabla-origin"
	public static val ANNOTATION_URI_DETAIL = 'uri'
	public static val ANNOTATION_OFFSET_DETAIL = 'offset'
	public static val ANNOTATION_LENGTH_DETAIL = 'length'

	static def getUriDetail(IrAnnotable it)
	{
		annotations.head.details.get(ANNOTATION_URI_DETAIL)
	}

	static def int getOffset(IrAnnotable it)
	{
		val annotation = annotations.findFirst[x | x.source == ANNOTATION_NABLA_ORIGIN_SOURCE]
		Integer::parseInt(annotation.details.get(ANNOTATION_OFFSET_DETAIL))
	}

	static def int getLength(IrAnnotable it)
	{
		val annotation = annotations.findFirst[x | x.source == ANNOTATION_NABLA_ORIGIN_SOURCE]
		Integer::parseInt(annotation.details.get(ANNOTATION_LENGTH_DETAIL))
	}
}
