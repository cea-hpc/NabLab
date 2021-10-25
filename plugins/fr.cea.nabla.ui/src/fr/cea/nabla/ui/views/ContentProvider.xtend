/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ui.views

import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.JobCaller
import org.eclipse.jface.viewers.ArrayContentProvider
import org.eclipse.zest.core.viewers.IGraphEntityContentProvider

class ContentProvider
extends ArrayContentProvider
implements IGraphEntityContentProvider
{
	override Object[] getElements(Object inputElement)
	{
		switch inputElement
		{
			IrRoot case inputElement.hasCycle: inputElement.jobs.filter[onCycle]
			JobCaller: inputElement.calls
		}
	}

	/**
	 * Gets the elements this object is connected to
	 * @param entity
	 * @return
	 */
	override Object[] getConnectedTo(Object entity)
	{
		if (entity instanceof Job)
			entity.nextJobsWithSameCaller
	}

	private def hasCycle(IrRoot it)
	{
		jobs.exists[x | x.onCycle]
	}
}