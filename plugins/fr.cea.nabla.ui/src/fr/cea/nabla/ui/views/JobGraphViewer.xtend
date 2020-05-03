/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ui.views

import java.util.List
import org.eclipse.swt.SWT
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Display
import org.eclipse.swt.widgets.Shell
import org.eclipse.zest.core.viewers.GraphViewer
import org.eclipse.zest.core.widgets.CGraphNode
import org.eclipse.zest.core.widgets.Graph
import org.eclipse.zest.core.widgets.GraphConnection
import org.eclipse.zest.core.widgets.GraphNode
import org.eclipse.zest.core.widgets.ZestStyles
import org.eclipse.zest.layouts.InvalidLayoutConfiguration
import org.eclipse.zest.layouts.LayoutStyles
import org.eclipse.zest.layouts.algorithms.SpringLayoutAlgorithm
import org.eclipse.zest.layouts.constraints.BasicEntityConstraint
import org.eclipse.zest.layouts.constraints.LayoutConstraint

class JogGraphViewer extends GraphViewer
{
	/** constructeur utilisé dans le fonctionnement 'normal' d'Eclipse */
	new(Composite composite) 
	{
		super(composite, SWT.BORDER)
		configure		
	}
	
	/** constructeur utilisé pour la fabrication des images et qui n'affiche jamais le graphe */
	new(Shell shell) 
	{
		super(shell, SWT.BORDER)
		setControl(new ElementViewerGraph(shell, SWT.BORDER))
		configure		
	}

	override getZoomManager() { super.zoomManager }

	private def configure()
	{
		// parametres divers
		contentProvider = new ContentProvider
		labelProvider = new LabelProvider
		nodeStyle = ZestStyles::NODES_NO_ANIMATION
		setLayoutAlgorithm(new SpringLayoutAlgorithm(LayoutStyles::NO_LAYOUT_NODE_RESIZING), true)
		
		// contrainte sur les noeuds
		addConstraintAdapter([ Object object, LayoutConstraint constraint | 
			if (object instanceof CGraphNode 
				&& (object as CGraphNode).data instanceof DiagramElement
				&& constraint instanceof BasicEntityConstraint)
			{
				val cgraphNode = object as CGraphNode
				val diagramElt = cgraphNode.data as DiagramElement
				(constraint as BasicEntityConstraint).hasPreferredLocation = true
				cgraphNode.setLocation(diagramElt.xpos, diagramElt.ypos)
			}
		])
	}
}

/**
 * Tant qu'on affiche pas les images dans une vue, la layout n'est pas déclenchée.
 * Il ne semble pas possible d'appeler applyLayoutInternal directement.
 * Donc, quand on crée des images sans afficher la vue, la layout n'est pas bonne.
 * Cette classe permet d'offrir une méthode pour forcer le déclenchement de la layout.
 */
class ElementViewerGraph extends Graph
{
	package new(Composite composite, int style) 
	{
		super(composite, style)
	}
	
	def forceLayoutForImage()
	{
		val connectionsToLayout = computeConnectionsToLayout(nodes)
		val nodesToLayout = computeNodesToLayout(nodes)
		val d = viewport.size
		d.width = d.width - 10;
		d.height = d.height - 10;
		try 
		{
			layoutAlgorithm.applyLayout(nodesToLayout, connectionsToLayout, 0, 0, d.width, d.height, false, false);
			getLightweightSystem().getUpdateManager().performUpdate();

		} catch (InvalidLayoutConfiguration e) 
		{
			e.printStackTrace();
		}
		
	}
	
	private def computeConnectionsToLayout(List<GraphNode> nodesToLayout)
	{
		val _connections = connections as List<GraphConnection>
		_connections.filter[c | nodesToLayout.contains(c.source) && nodesToLayout.contains(c.destination)].map[c | c.layoutRelationship]
	}

	private def computeNodesToLayout(List<GraphNode> nodes)
	{
		nodes.map[c | c.layoutEntity]
	}
}

class ViewerImageProvider implements IImageProvider
{
	override createImageFor(Diagram diagram)
	{
		if (Display::^default == null) createImageFor(diagram)
		else Display::^default.asyncExec([_createImageFor(diagram)])		
	}
	
	private def _createImageFor(Diagram diagram) 
	{
		val viewer = new ElementViewer(new Shell)
		viewer.graphControl.setSize(1024, 768)
		viewer.input = diagram.elements
		val graph = viewer.graphControl as ElementViewerGraph
		graph.forceLayoutForImage
		MoodUiUtils::createImage(viewer.graphControl, diagram)
	}
}