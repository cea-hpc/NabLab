/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ui.views

import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher.MessageType
import fr.cea.nabla.ui.console.NabLabConsoleFactory
import org.eclipse.swt.SWT
import org.eclipse.swt.widgets.Composite
import org.eclipse.zest.core.viewers.GraphViewer
import org.eclipse.zest.core.widgets.ZestStyles
import org.eclipse.zest.layouts.LayoutStyles
import org.eclipse.zest.layouts.algorithms.TreeLayoutAlgorithm

class JobGraphViewer extends GraphViewer
{
	NabLabConsoleFactory consoleFactory

	new(Composite composite, NabLabConsoleFactory console)
	{
		super(composite, SWT.BORDER)
		configure
		consoleFactory = console
	}

	override getZoomManager() { super.zoomManager }

	private def configure()
	{
		contentProvider = new ContentProvider
		labelProvider = new LabelProvider
		nodeStyle = ZestStyles::NODES_NO_ANIMATION
		connectionStyle = ZestStyles::CONNECTIONS_DIRECTED
		setLayoutAlgorithm(new TreeLayoutAlgorithm(LayoutStyles::NO_LAYOUT_NODE_RESIZING), true)
	}

	override protected inputChanged(Object input, Object oldInput)
	{
		val start = System.nanoTime()
		super.inputChanged(input, oldInput)
		val stop = System.nanoTime()
		consoleFactory.printConsole(MessageType.End, "IR displayed (" + ((stop - start) / 1000000) + " ms)")
		
	}
}
