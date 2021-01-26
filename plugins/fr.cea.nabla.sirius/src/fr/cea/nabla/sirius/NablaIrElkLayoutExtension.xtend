/** 
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 */
package fr.cea.nabla.sirius

import java.util.Optional
import org.eclipse.elk.core.options.CoreOptions
import org.eclipse.elk.core.service.LayoutMapping
import org.eclipse.sirius.common.tools.api.util.StringUtil
import org.eclipse.sirius.diagram.DDiagram
import org.eclipse.sirius.diagram.elk.ElkDiagramLayoutConnector
import org.eclipse.sirius.diagram.elk.GmfLayoutCommand
import org.eclipse.sirius.diagram.elk.IELKLayoutExtension
import fr.cea.nabla.ir.ir.Job

class NablaIrElkLayoutExtension implements IELKLayoutExtension
{
	static final String NABLA_IR_DIAGRAM_ID = "NablaIrDiagram"

	override void beforeELKLayout(LayoutMapping layoutMapping)
	{
		var optionalDDiagram = getDDiagram(layoutMapping)
		if (optionalDDiagram.isPresent())
		{
			var String diagramDescriptionName = StringUtil.EMPTY_STRING
			val dDiagram = optionalDDiagram.get
			if(dDiagram.description !== null)
			{
				diagramDescriptionName = dDiagram.description.name
			}
			if (NABLA_IR_DIAGRAM_ID.equals(diagramDescriptionName))
			{
				beforeElkLayout_NablaIrDiagram(layoutMapping, dDiagram)
			}
		}
	}

	override void afterELKLayout(LayoutMapping layoutMapping)
	{
	}

	override void afterGMFCommandApplied(GmfLayoutCommand gmfLayoutCommand, LayoutMapping layoutMapping)
	{
	}

	def protected Optional<DDiagram> getDDiagram(LayoutMapping layoutMapping)
	{
		var diagramEditPart = layoutMapping.getProperty(ElkDiagramLayoutConnector.DIAGRAM_EDIT_PART)
		if (diagramEditPart !== null)
		{
			var gmfDiagram = diagramEditPart.diagramView
			if (gmfDiagram !== null)
			{
				var element = gmfDiagram.element
				if (element instanceof DDiagram) {
					return Optional.of((element as DDiagram))
				}
			}
		}
		return Optional.empty
	}

	def protected void beforeElkLayout_NablaIrDiagram(LayoutMapping layoutMapping, DDiagram dDiagram)
	{
		layoutMapping.layoutGraph.containedEdges.stream.forEach([edge|edge.sections.clear])
		
		layoutMapping.layoutGraph.children.forEach([ n |
			{
				var minimumSize = n.getProperty(CoreOptions.NODE_SIZE_MINIMUM)
				minimumSize.y = 10.0
				n.setProperty(CoreOptions.PARTITIONING_PARTITION, getLevel(dDiagram, n.labels.get(0).text, layoutMapping.graphMap.get(n)))
			}
		])
	}

	def protected Integer getLevel(DDiagram dDiagram, String nodeName, Object value)
	{
		for (node : dDiagram.containers) {
			if (nodeName.equals(node.name))
			{
				val semantic = node.target
				if (semantic instanceof Job) {
					return semantic.at.intValue
				}
			}
		}
		return 1
	}
}
