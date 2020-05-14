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

import fr.cea.nabla.ir.ir.Job
import org.eclipse.draw2d.ColorConstants
import org.eclipse.zest.core.viewers.ISelfStyleProvider
import org.eclipse.zest.core.widgets.GraphConnection
import org.eclipse.zest.core.widgets.GraphNode

import static extension fr.cea.nabla.ir.JobExtensions.*

class LabelProvider
extends org.eclipse.jface.viewers.LabelProvider 
implements ISelfStyleProvider
{
	// Label Provider
	override getText(Object o)
	{
		if (o instanceof Job)
			o.name
	}

	// ISelfStyleProvider
	override selfStyleConnection(Object connection, GraphConnection gc)
	{
	}

	override selfStyleNode(Object element, GraphNode node)
	{
		println("selfStyleNode: " + element)
		if (element instanceof Job)
		{
			if (element.previousJobs.empty) node.backgroundColor = ColorConstants.lightGreen
			else if (element.nextJobs.empty) node.backgroundColor = ColorConstants.lightBlue
			else node.backgroundColor = ColorConstants.white
		}
	}
}