/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ui.views

import fr.cea.nabla.ir.JobDependencies
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.JobContainer
import org.eclipse.jface.viewers.ArrayContentProvider
import org.eclipse.zest.core.viewers.IGraphEntityContentProvider

class ContentProvider
extends ArrayContentProvider
implements IGraphEntityContentProvider
{
	static val extension JobDependencies = new JobDependencies

	override Object[] getElements(Object inputElement)
	{
		if (inputElement instanceof JobContainer)
			inputElement.innerJobs
	}

	/**
	 * Gets the elements this object is connected to
	 * @param entity
	 * @return
	 */
	override Object[] getConnectedTo(Object entity)
	{
		if (entity instanceof Job)
			entity.nextJobs.filter[x | x.jobContainer == entity.jobContainer]
	}
}