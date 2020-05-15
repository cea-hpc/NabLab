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
import fr.cea.nabla.ir.ir.IrAnnotable
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.JobContainer
import fr.cea.nabla.ir.ir.TimeLoopJob
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.ui.NablaDslEditor
import fr.cea.nabla.ui.UiUtils
import fr.cea.nabla.ui.listeners.DoubleClickListener
import fr.cea.nabla.ui.listeners.TextSelectionListener
import org.eclipse.emf.ecore.EObject
import org.eclipse.swt.SWT
import org.eclipse.swt.events.MouseEvent
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Display
import org.eclipse.ui.IPartListener
import org.eclipse.ui.IWorkbenchPart
import org.eclipse.ui.PlatformUI
import org.eclipse.ui.part.ViewPart
import org.eclipse.zest.core.viewers.IZoomableWorkbenchPart

class JobGraphView extends ViewPart implements IZoomableWorkbenchPart
{
	@Inject NablaGeneratorMessageDispatcher dispatcher
	@Inject NablaGenerator nablaGenerator

	@Inject  val (IrModule)=>void irModuleChangedListener			// when generator is triggered
	@Inject  val JobGraphViewPartListener partListener				// when editor is open
	@Inject  val TextSelectionListener textSelectionListener		// when text is selected in outline or editor
	@Inject  val DoubleClickListener doubleClickListener			// when double click on node or background (selection is then null)

	JobGraphViewer viewer
	JobContainer displayedContainer = null


	override setFocus() {}
	override getZoomableViewer() { viewer }

	new()
	{
		irModuleChangedListener = [IrModule module | fireIrModuleChanged(module)]
		partListener = new JobGraphViewPartListener
		textSelectionListener = new TextSelectionListener
		textSelectionListener.nablaObjectSelectionNotifier = [EObject o | println("text selection " + o)]
		doubleClickListener = new DoubleClickListener
		doubleClickListener.nullDoubleClickNotifier = [ | fireJobContainerChanged]
		doubleClickListener.annotableNotifier = [IrAnnotable annotable, int offset, int length, String uri | fireDoubleClick(annotable, offset, length, uri)]
	}

	override createPartControl(Composite parent)
	{
		// construction du viewer
		viewer = new JobGraphViewer(parent)

		// reaction au double click pour la navigation
		viewer.addDoubleClickListener(doubleClickListener)

		// fonctionnalite de zoom avec la molette de la souris
		viewer.graphControl.addMouseWheelListener([ MouseEvent event |
			if (event.stateMask.bitwiseAnd(SWT::CTRL) != 0)
			{
				if (event.count > 0) viewer.zoomManager.zoomOut()
				else viewer.zoomManager.zoomIn()
			}
		])

		// listen to generation (CTRL-S on NabLab editor)
		dispatcher.irModuleListeners += irModuleChangedListener

		// listen to editor open/close
		site.page.addPartListener(partListener)

		// listen to editor selection
		site.page.addPostSelectionListener(textSelectionListener)

		// When view is opening, if NabLab editor is open, IR is calculated and displayed
		val editor = UiUtils.activeNablaEditor
		if (editor !== null && editor.document !== null)
		{
			val obj = editor.document.readOnly([ state | state.contents.get(0)])
			if (obj !== null && obj instanceof NablaModule)
			{
				val irModule = nablaGenerator.buildIrModule(obj as NablaModule)
				if (parent.display === null) viewerJobContainer = irModule
				else parent.display.asyncExec([viewerJobContainer = irModule])
			}
		}
	}

	override dispose()
	{
		site.page.removePostSelectionListener(textSelectionListener)
		site.page.removePartListener(partListener)
		dispatcher.irModuleListeners -= irModuleChangedListener
		viewer.removeDoubleClickListener(doubleClickListener)
		viewer = null
	}

	private def fireDoubleClick(IrAnnotable annotable, int offset, int length, String uri)
	{
		if (annotable instanceof JobContainer)
			setViewerJobContainer(annotable)
		else
		{
			val w = PlatformUI::workbench.activeWorkbenchWindow
			if (uri !== null && w !== null && w.activePage !== null)
			{
				for (er : w.activePage.editorReferences)
				{
					val editor = er.getEditor(false)
					if (editor !== null && editor instanceof NablaDslEditor && uri.endsWith(er.name))
					{
						val nablaEditor = editor as NablaDslEditor
						nablaEditor.selectAndReveal(offset, length)
					}
				}
			}
		}
	}

	private def void fireIrModuleChanged(IrModule module)
	{
		if (Display::^default === null) setViewerJobContainer(module)
		else Display::^default.asyncExec([setViewerJobContainer(module)])
	}

	private def void fireJobContainerChanged()
	{
		if (displayedContainer !== null)
		{
			val containerToDisplay = if (displayedContainer instanceof TimeLoopJob)
					displayedContainer.jobContainer
				else
					null

			if (containerToDisplay !== null)
				viewerJobContainer = containerToDisplay
		}
	}

	private def setViewerJobContainer(JobContainer container)
	{
		displayedContainer = container
		contentDescription = container.displayName
		viewer.input = container
	}

	private dispatch def getDisplayName(TimeLoopJob it) { name }
	private dispatch def getDisplayName(IrModule it) { name }
}

class JobGraphViewPartListener implements IPartListener
{
	override partActivated(IWorkbenchPart part) {}

	override partBroughtToTop(IWorkbenchPart part) {}

	override partClosed(IWorkbenchPart part) { println("ca ferme " + part) }

	override partDeactivated(IWorkbenchPart part) {}

	override partOpened(IWorkbenchPart part) { println("ca ferme " + part) }
}
