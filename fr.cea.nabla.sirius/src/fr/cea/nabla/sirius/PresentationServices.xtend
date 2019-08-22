/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.sirius

import org.eclipse.core.resources.IFile
import org.eclipse.core.resources.IResource
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.Resource

class PresentationServices 
{	
	static def getWorkspaceImagePath(EObject it, String imagePath)
	{
		val f = eResource.toEclipseFile
		if (f === null) null
		else '/' + f.project.name + '/' + imagePath
	}
	
	private static def IFile toEclipseFile(Resource emfResource)
	{
	 	val uri = emfResource.URI
	 	if (uri.platformResource)
	 	{
			val ws = ResourcesPlugin::workspace.root
			val platformString = uri.toPlatformString(true)
			val resource = ws.findMember(platformString)
			if (resource !== null && resource.exists() && resource.type == IResource::FILE) return resource as IFile
		}		
		return null
	}
} 