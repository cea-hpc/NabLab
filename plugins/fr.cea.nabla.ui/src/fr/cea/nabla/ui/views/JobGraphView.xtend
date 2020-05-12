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
import fr.cea.nabla.generator.ir.IrAnnotationHelper
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.JobContainer
import fr.cea.nabla.ir.ir.TimeLoopJob
import fr.cea.nabla.ui.NablaDslEditor
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.emf.ecore.EObject
import org.eclipse.jface.viewers.StructuredSelection
import org.eclipse.swt.events.MouseEvent
import org.eclipse.swt.widgets.Composite
import org.eclipse.ui.PlatformUI
import org.eclipse.ui.part.ViewPart
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.zest.core.viewers.IZoomableWorkbenchPart

class JobGraphView extends ViewPart implements IZoomableWorkbenchPart
{
	@Inject extension IrAnnotationHelper
	@Accessors(PUBLIC_GETTER,PRIVATE_SETTER) JobContainer jobContainer
	JogGraphViewer viewer

	override setFocus()  {}
	override getZoomableViewer() { viewer }
	
	override createPartControl(Composite parent) 
	{
		// construction du viewer
		viewer = new JogGraphViewer(parent)

		// reaction au double click pour la navigation
		viewer.addDoubleClickListener([ event | 
			if (event.selection instanceof StructuredSelection)
			{
				val selectionElt = ( event.selection as StructuredSelection).firstElement
				if (selectionElt !== null && selectionElt instanceof Job)
				{
					val irJob = selectionElt as Job
					val annotation = irJob.annotations.findFirst[x | x.source == IrAnnotationHelper::ANNOTATION_NABLA_ORIGIN_SOURCE]
					if (annotation !== null)
					{
						val offset = Integer::parseInt(annotation.details.get(IrAnnotationHelper::ANNOTATION_OFFSET_DETAIL))
						val length = Integer::parseInt(annotation.details.get(IrAnnotationHelper::ANNOTATION_LENGTH_DETAIL))
						val uri = irJob.uriDetail
						val w = PlatformUI::workbench.activeWorkbenchWindow
						if (uri !== null && w!==null && w.activePage!==null)
						{
							for (er : w.activePage.editorReferences)
							{
								val editor = er.getEditor(false)
								if (editor!==null && editor instanceof NablaDslEditor && uri.endsWith(er.name))
								{
									val nablaEditor = editor as NablaDslEditor
									nablaEditor.selectAndReveal(offset, length)
								}
							}
						}
					}
				}
			}
		])

		// fonctionnalite de zoom avec la molette de la souris
		viewer.graphControl.addMouseWheelListener([ MouseEvent event |
			//if (event.stateMask.bitwiseAnd(SWT::CTRL) != 0)
				if (event.count > 0) viewer.zoomManager.zoomOut()
				else viewer.zoomManager.zoomIn()
		])

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
		viewer = null
	}

	def setViewerInput(EObject o)
	{
		if (o !== null && o instanceof JobContainer)
		{
			jobContainer = o as JobContainer
			contentDescription = jobContainer.displayName
			viewer.input = jobContainer.innerJobs
		}
	}

	private dispatch def getDisplayName(TimeLoopJob it) { name }
	private dispatch def getDisplayName(IrModule it) { name }
}
