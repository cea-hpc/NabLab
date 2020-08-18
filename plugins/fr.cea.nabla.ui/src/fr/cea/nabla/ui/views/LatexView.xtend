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
import fr.cea.nabla.LatexImageServices
import fr.cea.nabla.LatexLabelServices
import fr.cea.nabla.nabla.Expression
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.Instruction
import fr.cea.nabla.nabla.InstructionBlock
import fr.cea.nabla.nabla.Job
import fr.cea.nabla.nabla.Reduction
import fr.cea.nabla.ui.NablaDslEditor
import fr.cea.nabla.ui.syntaxcoloring.NablaHighlightingConfiguration
import java.awt.Color
import java.io.ByteArrayInputStream
import org.eclipse.emf.ecore.EObject
import org.eclipse.jface.text.ITextSelection
import org.eclipse.jface.viewers.ISelection
import org.eclipse.swt.SWT
import org.eclipse.swt.custom.ScrolledComposite
import org.eclipse.swt.graphics.Image
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Display
import org.eclipse.swt.widgets.Label
import org.eclipse.ui.ISelectionListener
import org.eclipse.ui.IWorkbenchPart
import org.eclipse.ui.part.ViewPart
import org.eclipse.xtext.ui.editor.syntaxcoloring.TextAttributeProvider

class LatexView extends ViewPart
{
	@Inject TextAttributeProvider tap
	ScrolledComposite sc
	Label label

	// Listen to Nabla Editor selection
	val ISelectionListener selectionListener = 
		[IWorkbenchPart part, ISelection selection |
			if (part instanceof NablaDslEditor && selection instanceof ITextSelection)
			{
				val nablaDslEditor = part as NablaDslEditor
				val textSelection = selection as ITextSelection
				val display = Display::^default
				if (display !== null)
				{
					display.asyncExec
					([
						val o = nablaDslEditor.getObjectAtPosition(textSelection.offset)
						if (o !== null)
						{
							val displayableObject = nablaDslEditor.getObjectAtPosition(textSelection.offset).closestDisplayableNablaElt
							if (displayableObject !== null)
							{
								val image = displayableObject.latexImage
								label.image = image
								sc.setMinSize(label.computeSize(image.bounds.width, image.bounds.height))
							}
						}
					])
				}
			}
		]

	override createPartControl(Composite parent)
	{
		sc = new ScrolledComposite(parent, SWT.H_SCROLL.bitwiseOr(SWT.V_SCROLL))
		label = new Label(sc, SWT.WRAP)
		sc.setContent(label)
		sc.setExpandVertical(true)
		sc.setExpandHorizontal(true)
		site.page.addPostSelectionListener(selectionListener)
	}

	override dispose()
	{
		site.page.removePostSelectionListener(selectionListener)
	}

	override setFocus()
	{
		label.setFocus
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

	private def getLatexImage(EObject element)
	{
		if (element !== null && !element.eIsProxy)
		{
			val latexLabel = LatexLabelServices.getLatex(element)
			if (latexLabel !== null)
			{
				//println("LATEX : " + latexLabel)
				val image = LatexImageServices.createPngImage(latexLabel, 25, awtColor)
				val swtImage = new Image(Display.^default, new ByteArrayInputStream(image))
				return swtImage
			}
		}
		return null
	}

	private def getAwtColor()
	{
		val textAttr = tap.getAttribute(NablaHighlightingConfiguration.LATEX_ID)
		if (textAttr === null) return null
		val color = textAttr.foreground
		if (color === null) return null
		return new Color(color.red, color.green, color.blue, color.alpha)
	}
}