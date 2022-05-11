/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ui

import com.google.inject.Inject
import fr.cea.nabla.ir.annotations.NabLabFileAnnotation
import fr.cea.nabla.ir.ir.IrAnnotable
import fr.cea.nabla.ui.console.NabLabConsoleFactory
import org.eclipse.emf.ecore.EObject
import org.eclipse.gmf.runtime.diagram.ui.editparts.IGraphicalEditPart
import org.eclipse.jface.viewers.ISelection
import org.eclipse.jface.viewers.IStructuredSelection
import org.eclipse.sirius.viewpoint.DRepresentationElement
import org.eclipse.swt.widgets.Composite
import org.eclipse.ui.ISelectionListener
import org.eclipse.ui.IWorkbenchPart
import org.eclipse.xtext.resource.EObjectAtOffsetHelper
import org.eclipse.xtext.ui.editor.XtextEditor

class NablaDslEditor 
extends XtextEditor
{
	@Inject NabLabConsoleFactory consoleFactory
	@Inject EObjectAtOffsetHelper eObjectAtOffsetHelper

	// Listen to the selection of an IrAnnotable object in the Sirius editor
	val ISelectionListener selectionListener = 
		[IWorkbenchPart part, ISelection selection |
			if (selection instanceof IStructuredSelection)
			{
				val firstElement = selection.firstElement
				if (firstElement instanceof IGraphicalEditPart)
				{
					val se = firstElement.resolveSemanticElement
					if (se instanceof DRepresentationElement)
					{
						val modelObject = se.semanticElements.get(0)
						if (modelObject !== null && modelObject instanceof IrAnnotable)
							selectIfDisplayed(modelObject as IrAnnotable)
					}
				}
			}
		]

	override createPartControl(Composite parent)
	{
		super.createPartControl(parent)
		site.page.addPostSelectionListener(selectionListener)
		consoleFactory.openConsole
	}

	override dispose()
	{
		site.page.removePostSelectionListener(selectionListener)
	}

	def EObject getObjectAtPosition(int offset)
	{
		// seems to be called between cstr and injection...
		if (eObjectAtOffsetHelper !== null)
			document.readOnly([state | eObjectAtOffsetHelper.resolveContainedElementAt(state, offset)])
	}

	def void selectIfDisplayed(IrAnnotable it)
	{
		val editorResourceUri = resource.fullPath.toString
		val annotation = NabLabFileAnnotation.tryToGet(it)
		if (annotation !== null && annotation.uri !== null && annotation.uri.endsWith(editorResourceUri))
			selectAndReveal(annotation.offset, annotation.length)
	}
}
