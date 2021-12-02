/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.sirius

import fr.cea.nabla.ir.ir.Job
import org.eclipse.core.expressions.PropertyTester
import org.eclipse.gef.EditPart
import org.eclipse.gmf.runtime.notation.Diagram
import org.eclipse.gmf.runtime.notation.Node
import org.eclipse.sirius.diagram.DSemanticDiagram

class BackToParentNablaIrDiagramPropertyTester extends PropertyTester
{
	override boolean test(Object receiver, String property, Object[] args, Object expectedValue)
	{
		var DSemanticDiagram diagram = null
		if (receiver instanceof EditPart)
		{
			var model = receiver.model
			if (model instanceof Diagram)
			{
				var element = model.element
				if (element instanceof DSemanticDiagram)
					diagram = element
			}
			else if (model instanceof Node)
			{
				var nodeDiagram = model.diagram
				if (nodeDiagram !== null)
				{
					var element = nodeDiagram.element
					if (element instanceof DSemanticDiagram)
						diagram = element
				}
			}
			if (diagram !== null)
			{
				return (diagram.target instanceof Job)
			}
		}
		return false
	}
}
