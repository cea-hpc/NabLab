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

import org.eclipse.core.resources.IFile
import org.eclipse.jface.viewers.ITreeContentProvider
import org.eclipse.ui.model.BaseWorkbenchContentProvider

class SourceFileContentProvider extends BaseWorkbenchContentProvider implements ITreeContentProvider
{
	val String fExtension

	new(String fExtension)
	{
		this.fExtension = fExtension
	}

	override Object[] getChildren(Object element)
	{
		// remove all file entries where extensions are rejected
		super.getChildren(element).filter[x | x.candidate]
	}

	/** Return true if o is not a file or a file with the 'ngen' extension */
	private def boolean isCandidate(Object o)
	{
		if (o instanceof IFile)
			o.fileExtension == fExtension
		else
			true
	}
}