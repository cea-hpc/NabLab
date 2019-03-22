/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 * 	Benoit Lelandais - initial implementation
 * 	Marie-Pierre Oudot - initial implementation
 * 	Jean-Sylvain Camier - Nabla generation support
 *******************************************************************************/
package fr.cea.nabla.ui.hovers

import com.google.inject.Inject
import fr.cea.nabla.LabelServices
import fr.cea.nabla.nabla.Expression
import fr.cea.nabla.typing.ExpressionTypeProvider
import fr.cea.nabla.typing.NablaType
import org.eclipse.emf.ecore.EObject
import org.eclipse.jface.text.IRegion
import org.eclipse.jface.text.ITextViewer
import org.eclipse.xtext.resource.EObjectAtOffsetHelper
import org.eclipse.xtext.ui.editor.XtextSourceViewer
import org.eclipse.xtext.ui.editor.hover.html.DefaultEObjectHoverProvider
import org.eclipse.xtext.ui.editor.model.IXtextDocument

class NablaEObjectHoverProvider extends DefaultEObjectHoverProvider 
{
	@Inject extension ExpressionTypeProvider
	@Inject EObjectAtOffsetHelper eObjectAtOffsetHelper	
	EObject resolvedContainedObject
	
	override String getFirstLine(EObject o) 
	{
		if (resolvedContainedObject === null) super.getFirstLine(o)
		else
		{
			val expression = resolvedContainedObject.expression
			if (expression === null || expression.eIsProxy) super.getFirstLine(o)
			else 
			{
				val eType = expression.typeFor
				'Expression <b>' + LabelServices.getLabel(expression) + '</b> of type <b>' + NablaType::getLabel(eType) + '</b>'
			}
		}
	}
	
	override IInformationControlCreatorProvider getHoverInfo(EObject object, ITextViewer viewer, IRegion region)
	{
		if (viewer instanceof XtextSourceViewer)
		{
			val document = (viewer as XtextSourceViewer).document
			if(document instanceof IXtextDocument)
				resolvedContainedObject = (document as IXtextDocument).readOnly([state | 
						eObjectAtOffsetHelper.resolveContainedElementAt(state, region.offset)	
				])		
		}	
		super.getHoverInfo(object, viewer, region)
	}
	
	private def Expression getExpression(EObject o)
	{
		if (o instanceof Expression) o as Expression
		else if (o.eContainer !== null) o.eContainer.expression
		else null
	}
}