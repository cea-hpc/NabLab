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
import fr.cea.nabla.generator.IrModuleTransformer
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher.MessageType
import fr.cea.nabla.generator.ir.Nabla2Ir
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.JobContainer
import fr.cea.nabla.ir.ir.TimeLoopJob
import fr.cea.nabla.ir.transformers.CompositeTransformationStep
import fr.cea.nabla.ir.transformers.FillJobHLTs
import fr.cea.nabla.ir.transformers.ReplaceReductions
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.ui.NabLabConsoleFactory
import fr.cea.nabla.ui.UiUtils
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

import static extension fr.cea.nabla.ir.Utils.*

class JobGraphView extends ViewPart implements IZoomableWorkbenchPart
{
	@Inject NotifyViewsHandler notifyViewsHandler
	@Inject NabLabConsoleFactory consoleFactory
	@Inject IrModuleTransformer transformer
	@Inject Provider<Nabla2Ir> nabla2IrProvider

	// F1 key pressed in NablaDslEditor
	val keyNotificationListener =
		[EObject selectedNablaObject |
			val display = Display::^default
			if (display !== null && selectedNablaObject !== null)
			{
				val nablaModule = EcoreUtil2.getContainerOfType(selectedNablaObject, NablaModule)
				if (nablaModule !== null)
				{
					display.asyncExec([displayIrModuleFrom(nablaModule)])
				}
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

	JobGraphViewer viewer
	JobContainer displayedContainer = null

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

	private def void displayIrModuleFrom(NablaModule nablaModule)
	{
		try 
		{
			consoleFactory.printConsole(MessageType.Start, "Building IR to initialize job graph view")
			val nabla2Ir = nabla2IrProvider.get // force a new instance to ensure a new IR
			val irModule = nabla2Ir.toIrModule(nablaModule)

			// buildIrModule can be call several times for the same nablaModule,
			// for example by a view. Transformations must not be done in this case
			if (irModule.jobs.forall[at == 0.0])
			{
				// IR -> IR
				val description = 'Minimal IR->IR transformations to check job cycles'
				val t = new CompositeTransformationStep(description, #[new ReplaceReductions(false), new FillJobHLTs])
				transformer.transformIr(t, irModule, [msg | consoleFactory.printConsole(MessageType.Exec, msg)])
			}
			consoleFactory.printConsole(MessageType.End, "Job graph view initialized")
			viewerJobContainer = irModule
		}
		catch (Exception e)
		{
			e.printStackTrace
			// An exception can occured during IR building if environment is not configured,
			// for example compilation not done. Whatever... we will display the graph later
		}
	}
}

