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
	@Inject LatexViewListener listener
	Label label

	override createPartControl(Composite parent) 
	{
		label = new Label(parent, SWT.NONE)

		// reaction a la selection dans l'editeur ou dans l'outline 
		listener.addNablaTextListener([x | label.image = x.latexImage])
		site.page.addPostSelectionListener(listener)
	}

	override setFocus() 
	{
		label.setFocus
	}

	private def getLatexImage(EObject element)
	{
		if (element !== null && !element.eIsProxy)
		{
			val latexLabel = LatexLabelServices.getLatex(element)
			if (latexLabel !== null) 
			{
				val image = LatexImageServices.createPngImage(latexLabel, 25)
				val swtImage = new Image(Display.^default, new ByteArrayInputStream(image))
				return swtImage
			}
		}
		return null
	}
}