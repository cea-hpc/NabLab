/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ui.listeners

import org.eclipse.jface.viewers.DoubleClickEvent
import org.eclipse.jface.viewers.IDoubleClickListener
import org.eclipse.jface.viewers.StructuredSelection
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.ArrayList
import org.eclipse.swt.widgets.Display

class JobGraphViewerDoubleClickListener
extends IrAnnotableEvent
implements IDoubleClickListener
{
	@Accessors val nullDoubleClickListeners = new ArrayList<() => void>

	override doubleClick(DoubleClickEvent event)
	{
		val selection = event.selection
		if (selection instanceof StructuredSelection)
		{
			println("double click : " + selection.firstElement)
			if (selection.firstElement === null)
				if (Display::^default === null) nullDoubleClickListeners.forEach[apply()]
				else Display::^default.asyncExec([nullDoubleClickListeners.forEach[apply()]])
			else
				fireEvent(selection.firstElement)
		}
	}
}