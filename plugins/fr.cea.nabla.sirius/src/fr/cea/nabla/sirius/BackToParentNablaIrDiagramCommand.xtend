/** 
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 */
package fr.cea.nabla.sirius

import fr.cea.nabla.ir.ir.Job
import org.eclipse.core.commands.AbstractHandler
import org.eclipse.core.commands.ExecutionEvent
import org.eclipse.core.commands.ExecutionException
import org.eclipse.jface.viewers.IStructuredSelection
import org.eclipse.sirius.diagram.DDiagram
import org.eclipse.sirius.diagram.DSemanticDiagram
import org.eclipse.sirius.diagram.ui.edit.api.part.AbstractBorderedDiagramElementEditPart
import org.eclipse.sirius.diagram.ui.edit.api.part.AbstractDDiagramEditPart
import org.eclipse.sirius.ext.base.Option
import org.eclipse.ui.handlers.HandlerUtil

class BackToParentNablaIrDiagramCommand extends AbstractHandler
{
	override Object execute(ExecutionEvent event) throws ExecutionException
	{
		var selection = HandlerUtil.getCurrentStructuredSelection(event)
		if (selection instanceof IStructuredSelection)
		{
			var element = selection.firstElement
			var DDiagram diagram = null
			if (element instanceof AbstractDDiagramEditPart)
			{
				var Option<DDiagram> diagramOption = ((element as AbstractDDiagramEditPart)).resolveDDiagram
				if (diagramOption.some)
				{
					diagram = diagramOption.get
				}
			}
			else if (element instanceof AbstractBorderedDiagramElementEditPart)
			{
				var diagramElement = ((element as AbstractBorderedDiagramElementEditPart)).resolveDiagramElement
				if (diagramElement !== null)
				{
					diagram = diagramElement.parentDiagram
				}
			}
			if (diagram instanceof DSemanticDiagram)
			{
				var semanticTarget = ((diagram as DSemanticDiagram)).target
				if (semanticTarget instanceof Job)
				{
					new NablaSiriusServices().backToParentDiagram((diagram as DSemanticDiagram))
				}
			}
		}
		return null
	}
}
