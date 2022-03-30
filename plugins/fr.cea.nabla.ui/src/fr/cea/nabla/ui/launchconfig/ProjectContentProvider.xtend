/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ui.launchconfig

import org.eclipse.core.resources.IProject
import org.eclipse.jface.viewers.ITreeContentProvider
import org.eclipse.ui.model.BaseWorkbenchContentProvider

class ProjectContentProvider extends BaseWorkbenchContentProvider implements ITreeContentProvider
{
	override Object[] getChildren(Object element)
	{
		if (element instanceof IProject)
			return #[]

		return super.getChildren(element)
	}
}