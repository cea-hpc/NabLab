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

import fr.cea.nabla.ir.JobExtensions
import fr.cea.nabla.ir.ir.Job
import org.eclipse.draw2d.ColorConstants
import org.eclipse.draw2d.Figure
import org.eclipse.draw2d.Label
import org.eclipse.draw2d.MarginBorder
import org.eclipse.draw2d.OrderedLayout
import org.eclipse.draw2d.ToolbarLayout
import org.eclipse.draw2d.geometry.Dimension
import org.eclipse.swt.SWT
import org.eclipse.swt.graphics.Font

class JobTooltipFigure extends Figure
{
	new(Job job)
	{
		// layout
		val layout = new ToolbarLayout()
		layout.setSpacing(1)
		layout.setMinorAlignment(OrderedLayout::ALIGN_CENTER)
		setLayoutManager(layout)

		// colors
		foregroundColor = ColorConstants::darkGray
		backgroundColor = ColorConstants::white
		opaque = true

		// label avec nom et icone
		val label = new Label(JobExtensions.getTooltip(job) ?: '')
		label.font = new Font(null, "Arial", 8, SWT::NORMAL)
		label.border = new MarginBorder(1)
		add(label)

		size = preferredSize.expand(new Dimension(5, 5))
	}
}