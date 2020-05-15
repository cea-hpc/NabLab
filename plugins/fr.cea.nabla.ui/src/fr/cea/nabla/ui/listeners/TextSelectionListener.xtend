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

import com.google.inject.Inject
import fr.cea.nabla.ui.internal.NablaActivator
import org.eclipse.emf.ecore.EObject
import org.eclipse.jface.text.TextSelection
import org.eclipse.jface.viewers.ISelection
import org.eclipse.ui.ISelectionListener
import org.eclipse.ui.IWorkbenchPart
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtext.resource.EObjectAtOffsetHelper
import org.eclipse.xtext.ui.editor.XtextEditor

class TextSelectionListener implements ISelectionListener
{
	@Inject EObjectAtOffsetHelper eObjectAtOffsetHelper
	@Accessors var (EObject) => void nablaObjectSelectionNotifier

	override selectionChanged(IWorkbenchPart part, ISelection selection)
	{
		if (nablaObjectSelectionNotifier !== null && selection instanceof TextSelection && part instanceof XtextEditor)
		{
			val xtextEditor = part as XtextEditor
			val textSelection = selection as TextSelection
			if (xtextEditor.languageName == NablaActivator::FR_CEA_NABLA_NABLA)
				getObjectAndFireNotification(xtextEditor, textSelection.offset)
		}
	}

	private def getObjectAndFireNotification(XtextEditor editor, int offset)
	{
		val obj = editor.document.readOnly([state | eObjectAtOffsetHelper.resolveContainedElementAt(state, offset)])
		if (obj !== null) nablaObjectSelectionNotifier.apply(obj)
	}
}