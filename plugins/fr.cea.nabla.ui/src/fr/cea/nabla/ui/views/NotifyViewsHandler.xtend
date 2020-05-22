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

import fr.cea.nabla.ui.NablaDslEditor
import java.util.ArrayList
import org.eclipse.core.commands.AbstractHandler
import org.eclipse.core.commands.ExecutionEvent
import org.eclipse.core.commands.ExecutionException
import org.eclipse.emf.ecore.EObject
import org.eclipse.jface.text.TextSelection
import org.eclipse.ui.PlatformUI
import org.eclipse.xtend.lib.annotations.Accessors
import com.google.inject.Singleton

@Singleton
class NotifyViewsHandler extends AbstractHandler
{
	@Accessors val keyNotificationListeners = new ArrayList<(EObject)=>void>

	override execute(ExecutionEvent event) throws ExecutionException
	{
		val window = PlatformUI.workbench.activeWorkbenchWindow
		if (window !== null && window.activePage !== null)
		{
			val editor = window.activePage.activeEditor
			if (editor !== null && editor instanceof NablaDslEditor)
			{
				val nablaDslEditor = editor as NablaDslEditor
				val selection = nablaDslEditor.selectionProvider.selection
				if (selection !== null && selection instanceof TextSelection)
				{
					val textSelection = selection as TextSelection
					val object = nablaDslEditor.getObjectAtPosition(textSelection.offset)
					keyNotificationListeners.forEach[x | x.apply(object)]
				}
			}
		}
		return null
	}
}