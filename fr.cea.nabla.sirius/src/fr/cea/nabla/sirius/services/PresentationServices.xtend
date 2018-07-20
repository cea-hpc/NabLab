/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 * 	Benoit Lelandais - initial implementation
 * 	Marie-Pierre Oudot - initial implementation
 * 	Jean-Sylvan Camier - Nabla generation support
 *******************************************************************************/
package fr.cea.nabla.sirius.services

import fr.cea.nabla.ir.ir.TimeIterationCopyJob
import fr.cea.nabla.ir.ir.Variable
import org.eclipse.core.resources.IFile
import org.eclipse.core.resources.IResource
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.Resource

import static extension fr.cea.nabla.ir.VariableExtensions.*

class PresentationServices 
{
	static def startsGraph(Variable it) { previousJobs.empty }
	static def endsGraph(Variable it) { nextJobs.empty }
	static def startsTimeLoop(Variable it) { previousJobs.exists[x|x instanceof TimeIterationCopyJob] }
	static def endsTimeLoop(Variable it) { nextJobs.exists[x|x instanceof TimeIterationCopyJob] }
	static def isOnCycle(Variable it) { previousJobs.exists[x|x.onCycle] }
	static def isInit(Variable it) { !previousJobs.exists[x|x.at>0] }	
	
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