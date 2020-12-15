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
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher.MessageType
import fr.cea.nabla.generator.ir.Nablagen2Ir
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.JobCaller
import fr.cea.nabla.ir.transformers.CompositeTransformationStep
import fr.cea.nabla.ir.transformers.FillJobHLTs
import fr.cea.nabla.ir.transformers.ReplaceReductions
import fr.cea.nabla.nablagen.NablagenRoot
import fr.cea.nabla.ui.NabLabConsoleFactory
import fr.cea.nabla.ui.NablaUiUtils
import javax.inject.Provider
import org.eclipse.emf.ecore.EObject
import org.eclipse.jface.viewers.DoubleClickEvent
import org.eclipse.jface.viewers.IDoubleClickListener
import org.eclipse.jface.viewers.StructuredSelection
import org.eclipse.swt.SWT
import org.eclipse.swt.events.MouseEvent
import org.eclipse.swt.events.MouseWheelListener
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Display
import org.eclipse.ui.part.ViewPart
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.zest.core.viewers.IZoomableWorkbenchPart

import static extension fr.cea.nabla.ir.JobCallerExtensions.*

class JobGraphView extends ViewPart implements IZoomableWorkbenchPart
{
	@Inject NotifyViewsHandler notifyViewsHandler
	@Inject NabLabConsoleFactory consoleFactory
	@Inject Provider<Nablagen2Ir> nablagen2IrProvider

	// F1 key pressed in NablaDslEditor
	val keyNotificationListener =
		[EObject selectedNablagenObject |
			if (selectedNablagenObject !== null)
			{
				val ngen = EcoreUtil2.getContainerOfType(selectedNablagenObject, NablagenRoot)
				if (ngen !== null) busyExec([displayIrFrom(ngen)])
			}
		]

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
						busyExec([viewerJobCaller = (displayedCaller as Job).caller])
				}
				else if (selection.firstElement instanceof JobCaller)
				{
					busyExec([viewerJobCaller = selection.firstElement as JobCaller])
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
		viewer = new JobGraphViewer(parent)
		viewer.graphControl.addMouseWheelListener(mouseWheelListener)
		viewer.addDoubleClickListener(doubleClickListener)
		notifyViewsHandler.keyNotificationListeners += keyNotificationListener
	}

	override dispose()
	{
		notifyViewsHandler.keyNotificationListeners -= keyNotificationListener
		viewer.removeDoubleClickListener(doubleClickListener)
		// seems to throw an exception...
		// viewer.graphControl.removeMouseWheelListener(mouseWheelListener)
		viewer = null
	}

	private def setViewerJobCaller(JobCaller jc)
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

	private def void displayIrFrom(NablagenRoot ngen)
	{
		var IrRoot ir = null
		consoleFactory.printConsole(MessageType.Start, "Building IR to initialize job graph view")

		try
		{
			val nablagen2Ir = nablagen2IrProvider.get // force a new instance to ensure a new IR
			ir = nablagen2Ir.toIrRoot(ngen)

			// IR -> IR
			val description = 'Minimal IR->IR transformations to check job cycles'
			val t = new CompositeTransformationStep(description, #[new ReplaceReductions(false), new FillJobHLTs])
			t.transformIr(ir, [msg | consoleFactory.printConsole(MessageType.Exec, msg)])
		}
		catch (Exception e)
		{
			// An exception can occured during IR building if environment is not configured,
			// for example compilation not done, or during transformation step. Whatever... 
			// irModule stays null. Error message printed below.
		}

		if (ir === null)
		{
			viewerJobCaller = null
			consoleFactory.printConsole(MessageType.Error, "IR can not be built. Try to clean and rebuild all projects and start again.")
		}
		else
		{
			viewerJobCaller = ir.main
			val name = (ir.main === null ? 'null' : ir.main.displayName)
			consoleFactory.printConsole(MessageType.End, "Job graph view initialized with: " + name)
		}
	}

	private def void busyExec(Runnable r)
	{
		new Thread([
			val d = Display::^default
			d.syncExec([
				val cursor = d.getSystemCursor(SWT.CURSOR_WAIT)
				viewer.control.cursor = cursor
			])
			r.run
			d.syncExec([viewer.control.cursor = null])
		]).start
	}
}

