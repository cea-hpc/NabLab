/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ui

import com.google.inject.Inject
import fr.cea.nabla.generator.ir.IrAnnotationHelper
import fr.cea.nabla.ir.ir.IrAnnotable
import org.eclipse.gmf.runtime.diagram.ui.editparts.IGraphicalEditPart
import org.eclipse.jface.viewers.ISelection
import org.eclipse.jface.viewers.IStructuredSelection
import org.eclipse.sirius.viewpoint.DRepresentationElement
import org.eclipse.swt.widgets.Composite
import org.eclipse.ui.ISelectionListener
import org.eclipse.ui.IWorkbenchPart
import org.eclipse.xtext.ui.editor.XtextEditor

class NablaDslEditor extends XtextEditor
{
	@Inject IrAnnotationHelper annotationHelper
	@Inject NabLabConsoleFactory consoleFactory

	val listener = new NablaDslListener(this)

	def getAnnotationHelper() { annotationHelper }

	override createPartControl(Composite parent)
	{
		super.createPartControl(parent)
		site.page.addPostSelectionListener(listener)
		consoleFactory.openConsole
	}

	override dispose()
	{
		site.page.removePostSelectionListener(listener)
	}
}

class NablaDslListener implements ISelectionListener
{
	val NablaDslEditor editor

	new(NablaDslEditor editor) 
	{ 
		this.editor = editor
	}

	override selectionChanged(IWorkbenchPart part, ISelection selection) 
	{
		val modelObject = selection.modelObject

		if (modelObject !== null && modelObject instanceof IrAnnotable) 
			openInDslEditor(modelObject as IrAnnotable)
	}

	private def getModelObject(ISelection selection)
	{
		//println("selection : " + selection.class.name)
		if (selection instanceof IStructuredSelection)
		{
			val firstElement = selection.firstElement
			if (firstElement instanceof IGraphicalEditPart)
			{
				val se = firstElement.resolveSemanticElement
				if (se instanceof DRepresentationElement)
					return se.semanticElements.head
			} 
		}
		return null
	}

	/** 
	 * Select the any argument in the editor if it is present.
	 * Do not open the file if it is not: this action is reserved for double click.
	 */
	private def void openInDslEditor(IrAnnotable any) 
	{
		val annotation = any.annotations.findFirst[x | x.source == IrAnnotationHelper::ANNOTATION_NABLA_ORIGIN_SOURCE]
		if (annotation !== null)
		{
			val uri = editor.annotationHelper.getUriDetail(any)
			val editorResourceUri = editor.resource.fullPath.toString
			if (any !== null && uri.endsWith(editorResourceUri))
			{
				val offset = Integer::parseInt(annotation.details.get(IrAnnotationHelper::ANNOTATION_OFFSET_DETAIL))
				val length = Integer::parseInt(annotation.details.get(IrAnnotationHelper::ANNOTATION_LENGTH_DETAIL))
				editor.selectAndReveal(offset, length)
			}
			else
				editor.selectAndReveal(0,0)
		}
		else
			editor.selectAndReveal(0,0)
	}
}