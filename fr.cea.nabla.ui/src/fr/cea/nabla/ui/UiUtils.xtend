/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ui

import fr.cea.nabla.ui.internal.NablaActivator
import org.eclipse.jface.resource.ImageDescriptor
import org.eclipse.ui.PlatformUI
import org.eclipse.xtext.ui.editor.XtextEditor

class UiUtils 
{
	static def ImageDescriptor getImageDescriptor(String path)
	{
		NablaActivator::imageDescriptorFromPlugin("fr.cea.nabla.ui", path)
	}
	
	static def createImage(String path)
	{
		path.imageDescriptor.createImage
	}
	
	static def getActiveNablaEditor()
	{
		val w = PlatformUI::workbench.activeWorkbenchWindow
		if (w!==null && w.activePage!==null && w.activePage.activeEditor!==null 
			&& (w.activePage.activeEditor instanceof XtextEditor)
			&& (w.activePage.activeEditor as XtextEditor).languageName == NablaActivator::FR_CEA_NABLA_NABLA)
			w.activePage.activeEditor as XtextEditor
		else 
			null
	}
}