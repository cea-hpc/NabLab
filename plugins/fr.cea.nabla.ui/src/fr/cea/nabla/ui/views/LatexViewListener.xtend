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
import fr.cea.nabla.ir.ir.IrAnnotable
import fr.cea.nabla.nabla.Expression
import fr.cea.nabla.nabla.Instruction
import fr.cea.nabla.nabla.InstructionBlock
import fr.cea.nabla.nabla.Job
import fr.cea.nabla.ui.NablaDslEditor
import fr.cea.nabla.ui.internal.NablaActivator
import java.util.ArrayList
import org.eclipse.emf.ecore.EObject
import org.eclipse.gmf.runtime.diagram.ui.editparts.GraphicalEditPart
import org.eclipse.jface.text.TextSelection
import org.eclipse.jface.viewers.ISelection
import org.eclipse.jface.viewers.StructuredSelection
import org.eclipse.sirius.diagram.DDiagramElement
import org.eclipse.sirius.diagram.ui.tools.api.editor.DDiagramEditor
import org.eclipse.ui.ISelectionListener
import org.eclipse.ui.IWorkbenchPart
import org.eclipse.ui.PlatformUI
import org.eclipse.xtext.resource.EObjectAtOffsetHelper
import org.eclipse.xtext.ui.editor.XtextEditor
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.Reduction

class LatexViewListener implements ISelectionListener
{
	@Inject EObjectAtOffsetHelper eObjectAtOffsetHelper
	@Inject extension IrAnnotationHelper

	val modelListeners = new ArrayList<(EObject)=>void>

	def void addNablaTextListener((EObject)=>void f)
	{
		modelListeners += f
	}

	/**
	 * If the selection happens in the NabLab editor, the model associated to 
	 * the selection is set to the viewer if its type is Diagram and if it is not
	 * already displayed in the view.
	 * Names are compared instead of object because of incremental build system
	 * and re-created objects.
	 */
	override selectionChanged(IWorkbenchPart part, ISelection selection)
	{
		if (selection instanceof StructuredSelection && part instanceof DDiagramEditor)
		{
			val structuredSelection = selection as StructuredSelection
			if (structuredSelection.firstElement instanceof GraphicalEditPart)
			{
				val gep = structuredSelection.firstElement as GraphicalEditPart
				val semanticElement = gep.resolveSemanticElement

				if (semanticElement instanceof DDiagramElement)
				{
					val irElement = semanticElement.target
					if (irElement instanceof IrAnnotable)
					{
						val annotation = irElement.annotations.findFirst[x | x.source == IrAnnotationHelper::ANNOTATION_NABLA_ORIGIN_SOURCE]
						if (annotation !== null)
						{
							val offset = Integer::parseInt(annotation.details.get(IrAnnotationHelper::ANNOTATION_OFFSET_DETAIL))
							val length = Integer::parseInt(annotation.details.get(IrAnnotationHelper::ANNOTATION_LENGTH_DETAIL))
							val uri = irElement.uriDetail
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
										getObjectAndFireNotification(nablaEditor, offset)
									}
								}
							}
						}
					}
				}
			}
		}
		else if (selection instanceof TextSelection && part instanceof XtextEditor)
		{
			val xtextEditor = part as XtextEditor
			val textSelection = selection as TextSelection
			if (xtextEditor.languageName == NablaActivator::FR_CEA_NABLA_NABLA)
				getObjectAndFireNotification(xtextEditor, textSelection.offset)
		}
	}

	private def getObjectAndFireNotification(XtextEditor editor, int offset)
	{
		val obj = editor.document.readOnly([state | eObjectAtOffsetHelper.resolveContainedElementAt(state, offset)])
		val nablaElt = obj.closestDisplayableNablaElt
		if (nablaElt !== null) modelListeners.forEach[x | x.apply(nablaElt)]
	}

	/** Return the highest displayable object, Job, Instruction or Expression */
	private def EObject getClosestDisplayableNablaElt(EObject elt)
	{
		switch elt
		{
			case null: null
			Job: elt
			Function: elt
			Reduction: elt
			InstructionBlock: null
			Instruction:
				if (elt.eContainer === null)
					null
				else 
					elt.eContainer.closestDisplayableNablaElt ?: elt
			Expression:
				if (elt.eContainer === null)
					null
				else 
					elt.eContainer.closestDisplayableNablaElt ?: elt
			default:
				if (elt.eContainer === null)
					null 
				else 
					elt.eContainer.closestDisplayableNablaElt
		}
	}
}