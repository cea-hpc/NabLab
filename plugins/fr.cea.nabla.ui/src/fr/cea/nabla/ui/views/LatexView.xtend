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
import java.io.ByteArrayInputStream
import org.eclipse.emf.ecore.EObject
import org.eclipse.swt.SWT
import org.eclipse.swt.graphics.Image
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Display
import org.eclipse.swt.widgets.Label
import org.eclipse.ui.part.ViewPart

class LatexView extends ViewPart
{
	@Inject NotifyViewsHandler notifyViewsHandler

	Label label
	val keyNotificationListener =
		[EObject selectedNablaObject |
			val display = Display::^default
			if (display !== null && selectedNablaObject !== null)
			{
				val displayableObject = selectedNablaObject.closestDisplayableNablaElt
				if (displayableObject !== null)
					display.asyncExec([label.image = displayableObject.latexImage])
			}
		]

	override createPartControl(Composite parent)
	{
		label = new Label(parent, SWT.NONE)
		notifyViewsHandler.keyNotificationListeners += keyNotificationListener
	}

	override dispose()
	{
		notifyViewsHandler.keyNotificationListeners -= keyNotificationListener
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
				val image = LatexImageServices.createPngImage(latexLabel, 25)
				val swtImage = new Image(Display.^default, new ByteArrayInputStream(image))
				return swtImage
			}
		}
		return null
	}
}