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
import java.util.ArrayList
import org.eclipse.emf.ecore.EObject
import org.eclipse.gmf.runtime.diagram.ui.editparts.IGraphicalEditPart
import org.eclipse.jface.viewers.ISelection
import org.eclipse.jface.viewers.IStructuredSelection
import org.eclipse.sirius.viewpoint.DRepresentationElement
import org.eclipse.swt.widgets.Display
import org.eclipse.ui.ISelectionListener
import org.eclipse.ui.IWorkbenchPart
import org.eclipse.xtend.lib.annotations.Accessors

class GraphicalEditPartSelectionListener implements ISelectionListener 
{
	@Inject extension IrAnnotationHelper
	// Event args: int offset, int length, String uri
	@Accessors val irAnnotatableSelectionListeners = new ArrayList<(int, int, String) => void>

	override selectionChanged(IWorkbenchPart part, ISelection selection)
	{
		val modelObject = selection.selectedEObject
		if (modelObject !== null && modelObject instanceof IrAnnotable)
		{
			val annotable = modelObject as IrAnnotable
			val annotation = annotable.annotations.findFirst[x | x.source == IrAnnotationHelper::ANNOTATION_NABLA_ORIGIN_SOURCE]
			if (annotation !== null)
			{
				val offset = Integer::parseInt(annotation.details.get(IrAnnotationHelper::ANNOTATION_OFFSET_DETAIL))
				val length = Integer::parseInt(annotation.details.get(IrAnnotationHelper::ANNOTATION_LENGTH_DETAIL))
				val uri = annotable.uriDetail
				if (Display::^default === null) irAnnotatableSelectionListeners.forEach[apply(offset, length, uri)]
				else Display::^default.asyncExec([irAnnotatableSelectionListeners.forEach[apply(offset, length, uri)]])
			}
		}
	}

	private def EObject getSelectedEObject(ISelection selection)
	{
		if (selection instanceof IStructuredSelection)
		{
			val firstElement = selection.firstElement
			if (firstElement instanceof IGraphicalEditPart)
			{
				val se = firstElement.resolveSemanticElement
				if (se instanceof DRepresentationElement)
					return se.semanticElements.head
			}
		}
		return null
	}
}