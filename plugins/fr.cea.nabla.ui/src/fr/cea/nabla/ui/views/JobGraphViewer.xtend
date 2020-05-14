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

import org.eclipse.swt.SWT
import org.eclipse.swt.widgets.Composite
import org.eclipse.zest.core.viewers.GraphViewer
import org.eclipse.zest.core.widgets.ZestStyles
import org.eclipse.zest.layouts.LayoutStyles
import org.eclipse.zest.layouts.algorithms.SpringLayoutAlgorithm
import org.eclipse.zest.layouts.algorithms.HorizontalLayoutAlgorithm
import org.eclipse.zest.layouts.algorithms.DirectedGraphLayoutAlgorithm
import org.eclipse.zest.layouts.algorithms.TreeLayoutAlgorithm

class JobGraphViewer extends GraphViewer
{
	new(Composite composite)
	{
		super(composite, SWT.BORDER)
		configure
	}

	override getZoomManager() { super.zoomManager }

	private def configure()
	{
		contentProvider = new ContentProvider
		labelProvider = new LabelProvider
		nodeStyle = ZestStyles::NODES_NO_ANIMATION
		connectionStyle = ZestStyles::CONNECTIONS_DIRECTED
		//setLayoutAlgorithm(new SpringLayoutAlgorithm(LayoutStyles::NO_LAYOUT_NODE_RESIZING), true)
		layoutAlgorithm = new TreeLayoutAlgorithm(LayoutStyles::NO_LAYOUT_NODE_RESIZING)
	}
}
