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
import fr.cea.nabla.ui.NablaDslEditor
import fr.cea.nabla.ui.UiUtils
import org.eclipse.jface.viewers.DoubleClickEvent
import org.eclipse.jface.viewers.IDoubleClickListener
import org.eclipse.jface.viewers.StructuredSelection
import org.eclipse.swt.SWT
import org.eclipse.swt.events.MouseEvent
import org.eclipse.swt.events.MouseWheelListener
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Display
import org.eclipse.ui.IPartListener
import org.eclipse.ui.IWorkbenchPart
import org.eclipse.ui.part.ViewPart
import org.eclipse.zest.core.viewers.IZoomableWorkbenchPart

import static extension fr.cea.nabla.ir.Utils.*

class JobGraphView extends ViewPart implements IZoomableWorkbenchPart
{
	static class NablaDslEditorViewPartListener implements IPartListener
	{
		val JobGraphView view

		new(JobGraphView view) { this.view = view }

		override partActivated(IWorkbenchPart part)
		{
			if (part instanceof NablaDslEditor)
				view.displayIrModuleFrom(part)
		}

		override partDeactivated(IWorkbenchPart part) {}
		override partBroughtToTop(IWorkbenchPart part) {}
		override partOpened(IWorkbenchPart part) {}
		override partClosed(IWorkbenchPart part) {}
	}

	@Inject NablaGenerator nablaGenerator
	@Inject NabLabConsoleFactory consoleFactory
	@Inject NablaGeneratorMessageDispatcher dispatcher

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

	// Listen to generation (CTRL-S on NabLab editor)
	val (IrModule) => void irModuleListener = [IrModule module |
			if (Display::^default === null) viewerJobContainer = module
			else Display::^default.asyncExec([viewerJobContainer = module])
		]

	// Listen to editor open/close
	val NablaDslEditorViewPartListener partListener = new NablaDslEditorViewPartListener(this)

	JobGraphViewer viewer
	JobContainer displayedContainer = null

	override setFocus() {}
	override getZoomableViewer() { viewer }

	override createPartControl(Composite parent)
	{
		viewer = new JobGraphViewer(parent)
		viewer.graphControl.addMouseWheelListener(mouseWheelListener)
		viewer.addDoubleClickListener(doubleClickListener)
		dispatcher.irModuleListeners += irModuleListener
		site.page.addPartListener(partListener)

		// When view is opening, if NabLab editor is open, IR is calculated and displayed
		displayIrModuleFrom(UiUtils.activeNablaDslEditor)
	}

	override dispose()
	{
		println("dispose")
		// seems to throw an exception...
		// viewer.graphControl.removeMouseWheelListener(mouseWheelListener)
		site.page.removePartListener(partListener)
		dispatcher.irModuleListeners -= irModuleListener
		viewer.removeDoubleClickListener(doubleClickListener)
		viewer = null
	}

	private def setViewerJobContainer(JobContainer container)
	{
		displayedContainer = container
		if (container === null) 
			contentDescription = ''
		else
			contentDescription = switch (container)
			{
				TimeLoopJob: container.irModule.name + '::' + container.name
				IrModule: container.name
			}
		viewer.input = container
	}

	private def void displayIrModuleFrom(NablaDslEditor editor)
	{
		if (editor !== null && editor.document !== null)
		{
			val obj = editor.document.readOnly([ state | state.contents.get(0)])
			if (obj !== null && obj instanceof NablaModule)
			{
				consoleFactory.printConsole(MessageType.Start, "Building IR to initialize job graph view")
				try 
				{
					val irModule = nablaGenerator.buildIrModule(obj as NablaModule)
					consoleFactory.printConsole(MessageType.End, "Job graph view initialized")
					viewerJobContainer = irModule
				}
				catch (Exception e)
				{
					// An exception can occured during IR building if environment is not configured,
					// for example compilation not done. Whatever... we will display the graph later
				}
			}
		}
	}
}

