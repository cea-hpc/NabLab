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

import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.ui.UiUtils
import org.eclipse.core.resources.IResource
import org.eclipse.core.resources.IResourceChangeEvent
import org.eclipse.core.resources.IResourceChangeListener
import org.eclipse.core.resources.IResourceDelta
import org.eclipse.core.runtime.CoreException
import org.eclipse.swt.widgets.Display
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtext.ui.editor.model.IXtextDocument

class NablaResourceChangeListener implements IResourceChangeListener
{
	@Accessors var (NablaModule)=>void nablaModuleChangeNotifier

	/* fire an event when a resource in save in the NabLab editor */
	override resourceChanged(IResourceChangeEvent event) 
	{
		try
		{
			if (nablaModuleChangeNotifier !== null && event !== null && event.delta !== null)
			{
				event.delta.accept([ IResourceDelta delta |
					val r = delta.resource
					// Is the changed resource in the NabLab editor ?
					if (r !== null && r.type == IResource::FILE && r.fileExtension == 'nabla') 
					{
						val editor = UiUtils.activeNablaEditor
						if (editor !== null && editor.resource == r)
							editor.document.objectAndFireNotification
						return false
					}
					else return true
				])	
			}
		}
		catch (CoreException e)
		{
			e.printStackTrace
		}
	}

	private def getObjectAndFireNotification(IXtextDocument doc)
	{
		val obj = doc.readOnly([ state | state.contents.get(0)])
		if (obj !== null && obj instanceof NablaModule)
		{
			val module = obj as NablaModule
			if (Display::^default === null) nablaModuleChangeNotifier.apply(module)
			else Display::^default.asyncExec([nablaModuleChangeNotifier.apply(module)])
		}
	}
}