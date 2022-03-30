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

import fr.cea.nabla.ir.IrUtils
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.Variable
import org.eclipse.core.resources.IFile
import org.eclipse.core.resources.IResource
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.jface.resource.ResourceLocator
import org.eclipse.ui.PlatformUI

import static extension fr.cea.nabla.ir.JobExtensions.*

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

	static def String getTooltip(Job it)
	{
		val inVarNames = "[" + inVars.map[displayName].join(', ') + "]"
		val outVarNames = "[" + outVars.map[displayName].join(', ') + "]"
		inVarNames + "  \u21E8  " + displayName + "  \u21E8  " + outVarNames
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

	private static def String getDisplayName(Variable v)
	{
		val module = IrUtils.getContainerOfType(v, IrModule)
		val root = module.eContainer as IrRoot
		if (root.modules.size > 1)
			module.name + "::" + v.name
		else
			v.name
	}
}