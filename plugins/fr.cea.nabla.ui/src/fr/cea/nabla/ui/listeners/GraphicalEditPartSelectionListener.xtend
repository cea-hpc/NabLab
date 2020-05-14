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

import org.eclipse.gmf.runtime.diagram.ui.editparts.IGraphicalEditPart
import org.eclipse.jface.viewers.ISelection
import org.eclipse.jface.viewers.IStructuredSelection
import org.eclipse.sirius.viewpoint.DRepresentationElement
import org.eclipse.ui.ISelectionListener
import org.eclipse.ui.IWorkbenchPart

class GraphicalEditPartSelectionListener
extends IrAnnotableEvent
implements ISelectionListener
{
	override selectionChanged(IWorkbenchPart part, ISelection selection)
	{
		if (selection instanceof IStructuredSelection)
		{
			val firstElement = selection.firstElement
			if (firstElement instanceof IGraphicalEditPart)
			{
				val se = firstElement.resolveSemanticElement
				if (se instanceof DRepresentationElement)
					fireEvent(se.semanticElements.head)
			}
		}
	}
}