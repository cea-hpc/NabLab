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
import org.eclipse.swt.widgets.Display
import org.eclipse.xtend.lib.annotations.Accessors

class DoubleClickListener
extends IrAnnotableListener
implements IDoubleClickListener
{
	@Accessors var () => void nullDoubleClickNotifier

	override doubleClick(DoubleClickEvent event)
	{
		if (nullDoubleClickNotifier !== null)
		{
			val selection = event.selection
			if (selection instanceof StructuredSelection)
			{
				if (selection.firstElement === null)
					if (Display::^default === null) nullDoubleClickNotifier.apply()
					else Display::^default.asyncExec([nullDoubleClickNotifier.apply()])
				else
					fireEvent(selection.firstElement)
			}
		}
	}
}