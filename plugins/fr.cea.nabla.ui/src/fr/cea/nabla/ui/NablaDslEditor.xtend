/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ui

import com.google.inject.Inject
import fr.cea.nabla.generator.ir.IrAnnotationHelper
import fr.cea.nabla.ir.ir.IrAnnotable
import fr.cea.nabla.ui.listeners.GraphicalEditPartSelectionListener
import org.eclipse.swt.widgets.Composite
import org.eclipse.xtext.ui.editor.XtextEditor

class NablaDslEditor extends XtextEditor
{
	@Inject IrAnnotationHelper annotationHelper
	@Inject GraphicalEditPartSelectionListener siriusListener

	def getAnnotationHelper() { annotationHelper }

	override createPartControl(Composite parent)
	{
		super.createPartControl(parent)
		siriusListener.irAnnotatableEventListeners += [annotable, offset, length, uri | openInEditor(annotable, offset, length, uri)]
		site.page.addPostSelectionListener(siriusListener)
	}

	override dispose()
	{
		site.page.removePostSelectionListener(siriusListener)
	}

	private def void openInEditor(IrAnnotable annotable, int offset, int length, String uri)
	{
		val editorResourceUri = resource.fullPath.toString
		if (uri.endsWith(editorResourceUri))
			selectAndReveal(offset, length)
		else
			selectAndReveal(0,0)
	}
}
