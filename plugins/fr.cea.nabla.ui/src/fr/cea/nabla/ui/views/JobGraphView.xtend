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
import fr.cea.nabla.generator.NablaGeneratorMessageDispatcher
import fr.cea.nabla.ir.ir.IrAnnotable
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.JobContainer
import fr.cea.nabla.ir.ir.TimeLoopJob
import fr.cea.nabla.ui.NablaDslEditor
import fr.cea.nabla.ui.listeners.JobGraphViewerDoubleClickListener
import org.eclipse.swt.events.MouseEvent
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Display
import org.eclipse.ui.PlatformUI
import org.eclipse.ui.part.ViewPart
import org.eclipse.zest.core.viewers.IZoomableWorkbenchPart

class JobGraphView extends ViewPart implements IZoomableWorkbenchPart
{
	@Inject NablaGeneratorMessageDispatcher dispatcher
	@Inject JobGraphViewerDoubleClickListener doubleClickListener

	JobGraphViewer viewer
	JobContainer displayedContainer = null
	val irModuleChangedListener = [IrModule module | fireIrModuleChanged(module)]
	val irAnnotatableEventListener = [IrAnnotable annotable, int offset, int length, String uri | fireDoubleClick(annotable, offset, length, uri)]
	val containerDoubleClickListener = [ | fireJobContainerChanged]

	override setFocus() {}
	override getZoomableViewer() { viewer }

	override createPartControl(Composite parent)
	{
		// construction du viewer
		viewer = new JobGraphViewer(parent)

		// reaction au double click pour la navigation
		doubleClickListener.irAnnotatableEventListeners += irAnnotatableEventListener
		doubleClickListener.nullDoubleClickListeners += containerDoubleClickListener
		viewer.addDoubleClickListener(doubleClickListener)

		// fonctionnalite de zoom avec la molette de la souris
		viewer.graphControl.addMouseWheelListener([ MouseEvent event |
			//if (event.stateMask.bitwiseAnd(SWT::CTRL) != 0)
				if (event.count > 0) viewer.zoomManager.zoomOut()
				else viewer.zoomManager.zoomIn()
		])

		dispatcher.irModuleListeners += irModuleChangedListener
		// Si le Mood éditeur est ouvert, on affiche le diagramme de l'éditeur
//		val editor = UiUtils.activeNablaEditor
//		if (editor !== null)
//		{
//			// la resource affichee dans l'editeur a ete mise a jour => il faut la relire
//			val newDiagram = MoodUiUtils::getDiagram(editor.document)
//			if (parent.display === null) viewerInput = newDiagram
//			else parent.display.asyncExec([viewerInput = newDiagram])
//		}
	}

	override dispose()
	{
		dispatcher.irModuleListeners -= irModuleChangedListener
		viewer.removeDoubleClickListener(doubleClickListener)
		doubleClickListener.nullDoubleClickListeners -= containerDoubleClickListener
		doubleClickListener.irAnnotatableEventListeners -= irAnnotatableEventListener
		viewer = null
	}

	private def fireDoubleClick(IrAnnotable annotable, int offset, int length, String uri)
	{
		println("fireDoubleClick : " + annotable)
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

			if (containerToDisplay !== null) viewerJobContainer = containerToDisplay
		}
	}

	private def setViewerJobContainer(JobContainer container)
	{
		println("setJobContainer : " + container.displayName)
		displayedContainer = container
		contentDescription = container.displayName
		viewer.input = container
	}

	private dispatch def getDisplayName(TimeLoopJob it) { name }
	private dispatch def getDisplayName(IrModule it) { name }
}
