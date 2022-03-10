/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ui.hovers

import com.google.inject.Inject
import fr.cea.nabla.hover.HoverHelper
import org.eclipse.emf.ecore.EObject
import org.eclipse.jface.internal.text.html.HTMLPrinter
import org.eclipse.jface.text.IRegion
import org.eclipse.jface.text.ITextViewer
import org.eclipse.xtext.resource.EObjectAtOffsetHelper
import org.eclipse.xtext.ui.editor.XtextSourceViewer
import org.eclipse.xtext.ui.editor.hover.html.DefaultEObjectHoverProvider
import org.eclipse.xtext.ui.editor.hover.html.XtextBrowserInformationControlInput
import org.eclipse.xtext.ui.editor.model.IXtextDocument

/**
 * Xtext supports hovers only for identifying features of model artifacts, i.e. the name of an object or crosslinks to other objects.
 * If you put the cursor on a binary operation operator for example, getFirstLine will not be called.
 * That is the reason why the method XtextBrowserInformationControlInput getHoverInfo is overriden.
 */
class NablaEObjectHoverProvider extends DefaultEObjectHoverProvider
{
	@Inject extension HoverHelper
	@Inject EObjectAtOffsetHelper eObjectAtOffsetHelper
	EObject resolvedContainedObject

	override String getFirstLine(EObject o)
	{
		if (resolvedContainedObject === null)
			super.getFirstLine(o)
		else
		{
			val displayableObject = resolvedContainedObject.firstDisplayableObject
			if (displayableObject === null || displayableObject.eIsProxy)
				super.getFirstLine(o)
			else
				displayableObject.buildLabel
		}
	}

	override XtextBrowserInformationControlInput getHoverInfo(EObject object, IRegion region, XtextBrowserInformationControlInput prev)
	{
		if (resolvedContainedObject === null)
			super.getHoverInfo(object, region, prev)
		else
		{
			val displayableObject = resolvedContainedObject.firstDisplayableObject
			if (displayableObject === null || displayableObject.eIsProxy)
				super.getHoverInfo(object, region, prev)
			else
			{
				val buffer = new StringBuilder(displayableObject.buildLabel)
				HTMLPrinter.insertPageProlog(buffer, 0, getStyleSheet())
				HTMLPrinter.addPageEpilog(buffer)
				return new XtextBrowserInformationControlInput(prev, object, buffer.toString(), labelProvider)
			}
		}
	}

	override IInformationControlCreatorProvider getHoverInfo(EObject object, ITextViewer viewer, IRegion region)
	{
		if (viewer instanceof XtextSourceViewer)
		{
			val document = viewer.document
			if (document instanceof IXtextDocument)
				resolvedContainedObject = document.readOnly([ state |
					eObjectAtOffsetHelper.resolveContainedElementAt(state, region.offset)
				])
		}
		super.getHoverInfo(object, viewer, region)
	}

}
