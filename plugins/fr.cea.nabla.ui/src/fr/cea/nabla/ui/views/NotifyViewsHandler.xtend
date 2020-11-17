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
import com.google.inject.Singleton
import fr.cea.nabla.ui.internal.NablaActivator
import java.util.ArrayList
import org.eclipse.core.commands.AbstractHandler
import org.eclipse.core.commands.ExecutionEvent
import org.eclipse.core.commands.ExecutionException
import org.eclipse.emf.ecore.EObject
import org.eclipse.jface.text.TextSelection
import org.eclipse.ui.PlatformUI
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtext.resource.EObjectAtOffsetHelper
import org.eclipse.xtext.ui.editor.XtextEditor

@Singleton
class NotifyViewsHandler extends AbstractHandler
{
	@Accessors val keyNotificationListeners = new ArrayList<(EObject)=>void>
	@Inject EObjectAtOffsetHelper eObjectAtOffsetHelper

	override execute(ExecutionEvent event) throws ExecutionException
	{
		val window = PlatformUI.workbench.activeWorkbenchWindow
		if (window !== null && window.activePage !== null)
		{
			val editor = window.activePage.activeEditor
			if (editor !== null && editor instanceof XtextEditor)
			{
				val xtextEditor = editor as XtextEditor
				if (xtextEditor.languageName == NablaActivator.FR_CEA_NABLA_NABLAGEN)
				{
					val selection = xtextEditor.selectionProvider.selection
					if (selection !== null && selection instanceof TextSelection)
					{
						val textSelection = selection as TextSelection
						val object = xtextEditor.document.readOnly([state | eObjectAtOffsetHelper.resolveContainedElementAt(state, textSelection.offset)])
						keyNotificationListeners.forEach[x | x.apply(object)]
					}
				}
			}
		}
		return null
	}
}