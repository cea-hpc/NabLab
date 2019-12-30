/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.workflow

import fr.cea.nabla.nablagen.ChildComponent
import fr.cea.nabla.nablagen.Workflow
import fr.cea.nabla.nablagen.WorkflowComponent

import static extension fr.cea.nabla.Utils.*

class WorkflowComponentExtensions 
{
	static def getNexts(WorkflowComponent it)
	{
		workflow.components.filter(ChildComponent).filter[c | c.parent == it]
	}

	static def getEclipseProject(WorkflowComponent it)
	{
		eResource.toEclipseFile.project
	}

	private static def getWorkflow(WorkflowComponent it)
	{
		eContainer as Workflow
	}
}