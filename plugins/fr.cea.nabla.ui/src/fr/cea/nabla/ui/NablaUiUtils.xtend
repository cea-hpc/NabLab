/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ui

import org.eclipse.core.resources.IFile
import org.eclipse.core.resources.IResource
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.jface.resource.ResourceLocator
import org.eclipse.ui.PlatformUI

class NablaUiUtils
{
	static def getImageDescriptor(String path)
	{
		ResourceLocator::imageDescriptorFromBundle("fr.cea.nabla.ui", path)
	}

	static def createImage(String path)
	{
		val imageDescriptor = getImageDescriptor(path)
		if (imageDescriptor.present) imageDescriptor.get.createImage
	}

	static def getActiveNablaDslEditor()
	{
		val w = PlatformUI::workbench.activeWorkbenchWindow
		if (w !== null && w.activePage !== null && w.activePage.activeEditor !== null && w.activePage.activeEditor instanceof NablaDslEditor)
			w.activePage.activeEditor as NablaDslEditor
		else
			null
	}

	static def IFile toEclipseFile(Resource emfResource)
	{
		val uri = emfResource.URI
		if (uri !== null && uri.platformResource)
		{
			val ws = ResourcesPlugin::workspace.root
			val platformString = uri.toPlatformString(true)
			val resource = ws.findMember(platformString)
			if (resource !== null && resource.exists && resource.type == IResource::FILE)
				return resource as IFile
		}
		return null
	}
}