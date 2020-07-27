/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ui.syntaxcoloring

import org.eclipse.swt.SWT
import org.eclipse.swt.graphics.RGB
import org.eclipse.xtext.ui.editor.syntaxcoloring.DefaultHighlightingConfiguration
import org.eclipse.xtext.ui.editor.syntaxcoloring.IHighlightingConfigurationAcceptor
import org.eclipse.xtext.ui.editor.utils.TextStyle

class NablaHighlightingConfiguration extends DefaultHighlightingConfiguration
{
	public static val ID_ID = "ID"
	public static val REAL_ID = "REAL"
	public static val ITERATOR_ID = "Iterator"

	override configure(IHighlightingConfigurationAcceptor acceptor)
	{
		super.configure(acceptor)
		acceptor.acceptDefaultHighlighting(ID_ID, ID_ID, IDTextStyle)
		acceptor.acceptDefaultHighlighting(REAL_ID, REAL_ID, numberTextStyle)
		acceptor.acceptDefaultHighlighting(ITERATOR_ID, ITERATOR_ID, setIteratorTextStyle)
	}

	def TextStyle getIDTextStyle()
	{
		val textStyle = new TextStyle
		textStyle.style = SWT::BOLD
		textStyle
	}

	def TextStyle getSetIteratorTextStyle()
	{
		val textStyle = new TextStyle
		textStyle.color = new RGB(65,106,203)
		textStyle
	}
}