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

import fr.cea.nabla.ir.JobDependencies
import fr.cea.nabla.ir.ir.Job
import org.eclipse.draw2d.ColorConstants
import org.eclipse.zest.core.viewers.ISelfStyleProvider
import org.eclipse.zest.core.widgets.GraphConnection
import org.eclipse.zest.core.widgets.GraphNode

class LabelProvider
extends org.eclipse.jface.viewers.LabelProvider 
implements ISelfStyleProvider
{
	static val extension JobDependencies = new JobDependencies

	// Label Provider
	override getText(Object o)
	{
		if (o instanceof Job)
			Math.round(o.at) + ". " + o.name
	}

	// ISelfStyleProvider
	override selfStyleConnection(Object connection, GraphConnection gc)
	{
	}

	override selfStyleNode(Object element, GraphNode node)
	{
		if (element instanceof Job)
		{
			node.backgroundColor = ColorConstants.white
			node.tooltip = new JobTooltipFigure(element)

			if (element.previousJobs.empty) node.borderColor = ColorConstants.green
			else if (element.nextJobs.empty) node.borderColor = ColorConstants.blue

			if (element.onCycle) node.borderColor = ColorConstants.red
		}
	}
}