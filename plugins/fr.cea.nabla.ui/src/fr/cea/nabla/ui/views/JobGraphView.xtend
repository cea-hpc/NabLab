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

import com.google.inject.Inject
import fr.cea.nabla.generator.NablaGenerator
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher.MessageType
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.JobContainer
import fr.cea.nabla.ir.ir.TimeLoopJob
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.ui.NabLabConsoleFactory
import fr.cea.nabla.ui.UiUtils
import org.eclipse.jface.viewers.DoubleClickEvent
import org.eclipse.jface.viewers.IDoubleClickListener
import org.eclipse.jface.viewers.StructuredSelection
import org.eclipse.swt.SWT
import org.eclipse.swt.events.MouseEvent
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Display
import org.eclipse.ui.IPartListener
import org.eclipse.ui.IWorkbenchPart
import org.eclipse.ui.part.ViewPart
import org.eclipse.zest.core.viewers.IZoomableWorkbenchPart

class JobGraphView extends ViewPart implements IZoomableWorkbenchPart
{
	static class NablaDslEditorViewPartListener implements IPartListener
	{
		override partActivated(IWorkbenchPart part) { println("activated : " + part) }
		override partDeactivated(IWorkbenchPart part) { println("deactivated" + part) }
		override partBroughtToTop(IWorkbenchPart part) { println("brought to top" + part) }
		override partOpened(IWorkbenchPart part) { println("opened" + part) }
		override partClosed(IWorkbenchPart part) { println("closed" + part) }
	}

	@Inject NablaGenerator nablaGenerator
	@Inject NabLabConsoleFactory consoleFactory
	@Inject NablaGeneratorMessageDispatcher dispatcher

	// listeners
	IDoubleClickListener doubleClickListener
	(IrModule) => void irModuleListener
	NablaDslEditorViewPartListener partListener

	JobGraphViewer viewer
	JobContainer displayedContainer = null

	override setFocus() {}
	override getZoomableViewer() { viewer }

	override createPartControl(Composite parent)
	{
		viewer = new JobGraphViewer(parent)

		// Zoom with mouse wheel
		viewer.graphControl.addMouseWheelListener
		([ MouseEvent event |
			if (event.stateMask.bitwiseAnd(SWT::CTRL) != 0)
			{
				if (event.count > 0) viewer.zoomManager.zoomOut()
				else viewer.zoomManager.zoomIn()
			}
		])

		// Double click on jobs and background
		doubleClickListener = 
		([DoubleClickEvent event |
			val selection = event.selection
			if (selection instanceof StructuredSelection)
			{
				if (selection.firstElement === null)
				{
					if (displayedContainer !== null && displayedContainer instanceof Job)
						viewerJobContainer = (displayedContainer as Job).jobContainer
				}
				else if (selection.firstElement instanceof JobContainer)
				{
					viewerJobContainer = selection.firstElement as JobContainer
				}
				else if (selection.firstElement instanceof Job)
				{
					val editor = UiUtils::activeNablaDslEditor
					val j = selection.firstElement as Job
					if (editor !== null) editor.selectIfDisplayed(j)
				}
			}
		])
		viewer.addDoubleClickListener(doubleClickListener)

		// listen to generation (CTRL-S on NabLab editor)
		irModuleListener = 
		[IrModule module |
			if (Display::^default === null) viewerJobContainer = module
			else Display::^default.asyncExec([viewerJobContainer = module])
		]
		dispatcher.irModuleListeners += irModuleListener

		// listen to editor open/close
		partListener = new NablaDslEditorViewPartListener
		site.page.addPartListener(partListener)

		// When view is opening, if NabLab editor is open, IR is calculated and displayed
		val editor = UiUtils.activeNablaDslEditor
		if (editor !== null && editor.document !== null)
		{
			val obj = editor.document.readOnly([ state | state.contents.get(0)])
			if (obj !== null && obj instanceof NablaModule)
			{
				consoleFactory.printConsole(MessageType.Start, "Building IR to initialize job graph view")
				val irModule = nablaGenerator.buildIrModule(obj as NablaModule)
				consoleFactory.printConsole(MessageType.End, "Job graph view initialized")
				if (parent.display === null) viewerJobContainer = irModule
				else parent.display.asyncExec([viewerJobContainer = irModule])
			}
		}
	}

	override dispose()
	{
		site.page.removePartListener(partListener)
		dispatcher.irModuleListeners -= irModuleListener
		viewer.removeDoubleClickListener(doubleClickListener)
		viewer = null
	}

	private def setViewerJobContainer(JobContainer container)
	{
		displayedContainer = container
		contentDescription = switch (container)
		{
			TimeLoopJob: container.name
			IrModule: container.name
		}
		viewer.input = container
	}
}

