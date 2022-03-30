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

import com.google.inject.Inject
import com.google.inject.Singleton
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.JobCaller
import fr.cea.nabla.ui.NablaUiUtils
import fr.cea.nabla.ui.console.NabLabConsoleFactory
import org.eclipse.jface.viewers.DoubleClickEvent
import org.eclipse.jface.viewers.IDoubleClickListener
import org.eclipse.jface.viewers.StructuredSelection
import org.eclipse.swt.SWT
import org.eclipse.swt.events.MouseEvent
import org.eclipse.swt.events.MouseWheelListener
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Display
import org.eclipse.ui.part.ViewPart
import org.eclipse.zest.core.viewers.IZoomableWorkbenchPart

import static extension fr.cea.nabla.ir.JobCallerExtensions.*

@Singleton
class JobGraphView extends ViewPart implements IZoomableWorkbenchPart
{
	@Inject NabLabConsoleFactory consoleFactory

	// Zoom with mouse wheel
	val MouseWheelListener mouseWheelListener = [ MouseEvent event |
			if (event.stateMask.bitwiseAnd(SWT::CTRL) != 0)
			{
				if (event.count > 0) viewer.zoomManager.zoomOut()
				else viewer.zoomManager.zoomIn()
			}
		]

	// Listen to double click on jobs and background
	val IDoubleClickListener doubleClickListener =
		([DoubleClickEvent event |
			val selection = event.selection
			if (selection instanceof StructuredSelection)
			{
				if (selection.firstElement === null)
				{
					if (displayedCaller !== null && displayedCaller instanceof Job)
						viewerJobCaller = (displayedCaller as Job).caller
				}
				else if (selection.firstElement instanceof JobCaller)
				{
					viewerJobCaller = selection.firstElement as JobCaller
				}
				else if (selection.firstElement instanceof Job)
				{
					val editor = NablaUiUtils::activeNablaDslEditor
					val j = selection.firstElement as Job
					if (editor !== null) editor.selectIfDisplayed(j)
				}
			}
		])

	JobGraphViewer viewer
	JobCaller displayedCaller = null

	override setFocus() {}
	override getZoomableViewer() { viewer }

	override createPartControl(Composite parent)
	{
		viewer = new JobGraphViewer(parent, consoleFactory)
		viewer.graphControl.addMouseWheelListener(mouseWheelListener)
		viewer.addDoubleClickListener(doubleClickListener)
	}

	override dispose()
	{
		viewer.removeDoubleClickListener(doubleClickListener)
		// seems to throw an exception...
		// viewer.graphControl.removeMouseWheelListener(mouseWheelListener)
		viewer = null
	}

	def setViewerJobCaller(JobCaller jc)
	{
		val d = Display::^default
		d.asyncExec([
			displayedCaller = jc
			if (jc === null) 
				contentDescription = ''
			else
				contentDescription = jc.displayName
			viewer.input = jc
		])
	}
}

