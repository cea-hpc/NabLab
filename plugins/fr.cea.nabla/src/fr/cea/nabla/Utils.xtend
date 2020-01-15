/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla

import org.eclipse.core.resources.IFile
import org.eclipse.core.resources.IResource
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl

class Utils 
{
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

	static def getFileNameWithoutExtension(Resource input)
	{
		input.resourceSet.resourceFactoryRegistry.extensionToFactoryMap.put(Resource.Factory.Registry.DEFAULT_EXTENSION, new XMIResourceFactoryImpl)
		return input.URI.trimFileExtension.lastSegment
	}
}