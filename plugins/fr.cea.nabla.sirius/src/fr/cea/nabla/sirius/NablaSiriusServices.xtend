/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
 package fr.cea.nabla.sirius

import fr.cea.nabla.ir.ir.IrAnnotable
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.JobCaller
import java.util.Collection
import java.util.Collections
import org.eclipse.emf.ecore.EObject
import org.eclipse.sirius.diagram.DSemanticDiagram

@SuppressWarnings("restriction")
class NablaSiriusServices
{
	def int getAtBackgroundColor(Double at)
	{
		if (at !== null && at > 0)
		{
			return 255 - (at.intValue - 1) * 10
		}
		return 255
	}

	def int getAtLabelColor(Double at)
	{
		if (at !== null && at >= 10)
		{
			return 255
		}
		return 50
	}

	def Collection<Job> getJobs(IrAnnotable annotable)
	{
		if (annotable instanceof JobCaller)
		{
			return annotable.calls
		}
		else if (annotable instanceof IrRoot)
		{
			return annotable.main.calls
		}
		return Collections.emptyList()
	}

	def boolean isNotRootDiagram(EObject graphicalElement)
	{
		if (graphicalElement instanceof DSemanticDiagram)
		{
			return !(graphicalElement.target instanceof IrModule)
		}
		return false
	}
}
