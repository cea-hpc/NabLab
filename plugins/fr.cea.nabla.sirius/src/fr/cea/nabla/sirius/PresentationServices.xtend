/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.sirius

import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.nablagen.Cpp
import fr.cea.nabla.nablagen.Ir2CodeComponent
import fr.cea.nabla.nablagen.Java
import org.eclipse.core.resources.IFile
import org.eclipse.core.resources.IResource
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.Resource

import static extension fr.cea.nabla.ir.JobExtensions.*

class PresentationServices
{
	static def getWorkspaceImagePath(EObject it, String imagePath)
	{
		val f = eResource.toEclipseFile
		if (f === null) null
		else '/' + f.project.name + '/' + imagePath
	}

	static def String getTooltip(Job it)
	{
		val inVarNames = "[" + inVars.map[name].join(', ') + "]"
		val outVarNames = "[" + outVars.map[name].join(', ') + "]"
		inVarNames + "  \u21E8  " + name + "  \u21E8  " + outVarNames
	}

	static def String getIconPath(Ir2CodeComponent o)
	{
		val prefix = '/fr.cea.nabla.sirius/icons/'
		val l = o.language
		prefix + switch l
		{
			Java: "java.png"
			Cpp: switch l.programmingModel
			{
				case SEQUENTIAL: "sequentialcpp.png"
				case OPEN_MP: "openmp.png"
				case STL_THREAD: "stl.png"
				case KOKKOS: "kokkos.png"
				case KOKKOS_TEAM_THREAD: "kokkos.png"
			}
		}
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