/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ui.listeners

import com.google.inject.Inject
import fr.cea.nabla.generator.ir.IrAnnotationHelper
import fr.cea.nabla.ir.ir.IrAnnotable
import org.eclipse.swt.widgets.Display
import org.eclipse.xtend.lib.annotations.Accessors

abstract class IrAnnotableListener
{
	@Inject extension IrAnnotationHelper

	// Event args: IrAnnotable object, int offset, int length, String uri
	@Accessors var (IrAnnotable, int, int, String) => void annotableNotifier

	def fireEvent(Object object)
	{
		if (annotableNotifier !== null && object !== null && object instanceof IrAnnotable)
		{
			val annotable = object as IrAnnotable
			val annotation = annotable.annotations.findFirst[x | x.source == IrAnnotationHelper::ANNOTATION_NABLA_ORIGIN_SOURCE]
			if (annotation !== null)
			{
				val offset = Integer::parseInt(annotation.details.get(IrAnnotationHelper::ANNOTATION_OFFSET_DETAIL))
				val length = Integer::parseInt(annotation.details.get(IrAnnotationHelper::ANNOTATION_LENGTH_DETAIL))
				val uri = annotable.uriDetail
				if (Display::^default === null) annotableNotifier.apply(annotable, offset, length, uri)
				else Display::^default.asyncExec([annotableNotifier.apply(annotable, offset, length, uri)])
			}
		}
	}
}