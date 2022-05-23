/*******************************************************************************
 * Copyright (c) 2021, 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ide.hover

import com.google.inject.Inject
import fr.cea.nabla.hover.HoverHelper
import org.eclipse.emf.ecore.EObject
import org.eclipse.lsp4j.MarkupContent
import org.eclipse.xtext.documentation.IEObjectDocumentationProvider
import org.eclipse.xtext.ide.labels.INameLabelProvider
import org.eclipse.xtext.ide.server.hover.HoverContext
import org.eclipse.xtext.ide.server.hover.HoverService
import org.eclipse.xtext.naming.IQualifiedNameProvider
import org.eclipse.xtext.resource.EObjectAtOffsetHelper

import static org.eclipse.xtext.util.Strings.isEmpty

import static extension org.apache.commons.lang.StringEscapeUtils.escapeHtml

class NablaIdeHoverService extends HoverService
{
	@Inject IQualifiedNameProvider nameProvider
	@Inject extension HoverHelper
	@Inject extension IEObjectDocumentationProvider
	@Inject INameLabelProvider nameLabelProvider
	@Inject EObjectAtOffsetHelper eObjectAtOffsetHelper

	override MarkupContent getMarkupContent(HoverContext ctx)
	{
		return toMarkupContent(getKind(ctx), getContents(ctx))
	}

	def String getContents(HoverContext context)
	{
		// Re-implementation of :
		// * fr.cea.nabla.ui.hovers.NablaEObjectHoverProvider.getHoverInfo(EObject, ITextViewer, IRegion)
		// * fr.cea.nabla.ui.hovers.NablaEObjectHoverProvider.getHoverInfo(EObject, IRegion, XtextBrowserInformationControlInput)
		// * fr.cea.nabla.ui.hovers.NablaEObjectHoverProvider.getFirstLine(EObject)
		val EObject resolvedContainedObject = eObjectAtOffsetHelper.resolveContainedElementAt(context.resource, context.offset)
		if(resolvedContainedObject !== null && !resolvedContainedObject.eIsProxy)
		{
			val element = resolvedContainedObject.firstDisplayableObject
			if(element !== null && !element.eIsProxy)
			{
				val documentation = element.documentation
				var content = getFirstLine(element)
				if(documentation !== null)
				{
					content += "  \n" + documentation
				}
				return content
			}

		}
		val element = context.element
		
		// Port from org.eclipse.xtext.ui.editor.hover.html.DefaultEObjectHoverProvider.getHoverInfoAsHtml(EObject)
		if (hasHover(element))
		{
			return element.defaultFirstLine
		}
		
		return ""
	}

	private def boolean hasHover(EObject o)
	{
		return o !== null && nameProvider.getFullyQualifiedName(o) !== null
	}

	private def String getFirstLine(EObject o)
	{
		return o.buildLabel
	}

	private def String getDefaultFirstLine(EObject o)
	{
		val label = o.label
		return o.eClass().getName() + ((label !== null) ? " <b>" + label + "</b>" : "")
	}

	private def String getLabel(EObject o)
	{
		val String text = nameLabelProvider.getNameLabel(o)
		if(!isEmpty(text))
		{
			return text.escapeHtml
		}
		else
		{
			return null
		}
	}

}
