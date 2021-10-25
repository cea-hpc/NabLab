/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ui.hovers

import com.google.inject.Inject
import fr.cea.nabla.LabelServices
import fr.cea.nabla.nabla.ArgOrVar
import fr.cea.nabla.nabla.Expression
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.Instruction
import fr.cea.nabla.nabla.Job
import fr.cea.nabla.nabla.NablaRoot
import fr.cea.nabla.typing.ArgOrVarTypeProvider
import fr.cea.nabla.typing.ExpressionTypeProvider
import org.eclipse.emf.ecore.EObject
import org.eclipse.jface.internal.text.html.HTMLPrinter
import org.eclipse.jface.text.IRegion
import org.eclipse.jface.text.ITextViewer
import org.eclipse.xtext.resource.EObjectAtOffsetHelper
import org.eclipse.xtext.ui.editor.XtextSourceViewer
import org.eclipse.xtext.ui.editor.hover.html.DefaultEObjectHoverProvider
import org.eclipse.xtext.ui.editor.hover.html.XtextBrowserInformationControlInput
import org.eclipse.xtext.ui.editor.model.IXtextDocument
import fr.cea.nabla.nabla.BaseType
import fr.cea.nabla.typing.BaseTypeTypeProvider

/**
 * Xtext supports hovers only for identifying features of model artifacts, i.e. the name of an object or crosslinks to other objects.
 * If you put the cursor on a binary operation operator for example, getFirstLine will not be called.
 * That is the reason why the method XtextBrowserInformationControlInput getHoverInfo is overriden.
 */
class NablaEObjectHoverProvider extends DefaultEObjectHoverProvider
{
	@Inject extension ExpressionTypeProvider
	@Inject extension ArgOrVarTypeProvider
	@Inject extension BaseTypeTypeProvider
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
			if(document instanceof IXtextDocument)
				resolvedContainedObject = document.readOnly([state |
						eObjectAtOffsetHelper.resolveContainedElementAt(state, region.offset)
				])
		}
		super.getHoverInfo(object, viewer, region)
	}

	private def EObject getFirstDisplayableObject(EObject o)
	{
		switch o
		{
			Expression, ArgOrVar, Function: o
			NablaRoot, Job, Instruction: null
			case (o.eContainer === null): null
			default: o.eContainer.firstDisplayableObject
		}
	}

	private def buildLabel(EObject e)
	{
		'<b>' + e.text + '</b> of type <b>' + e.typeText + '</b>'
	}

	private def String getText(EObject o)
	{
		switch o
		{
			Expression: LabelServices.getLabel(o)
			ArgOrVar: o.name
			Function: o.name + '(' + o.typeDeclaration.inTypes.map[typeText].join(', ') + ')'
		}
	}

	private def String getTypeText(EObject o)
	{
		switch o
		{
			Expression: o.typeFor?.label
			ArgOrVar: o.typeFor?.label
			Function: o.typeDeclaration.returnType.typeFor?.label
			BaseType: o.typeFor?.label
		}
	}
}