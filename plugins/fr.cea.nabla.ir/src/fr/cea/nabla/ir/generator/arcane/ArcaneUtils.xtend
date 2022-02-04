/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.arcane

import fr.cea.nabla.ir.ir.ArgOrVar
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.ExecuteTimeLoopJob
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.Variable

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.JobCallerExtensions.*

/**
 * @TODO Arcane - What about item types? Fixed in NabLab ? Mapping Arcane ?
 * @TODO Arcane - Linear Algebra with Alien
 * @TODO Arcane - Support module coupling
 * @TODO Arcane - Support composed time loops: n + m
 * @TODO Arcane - What happens if levelDB asked ?
 * @TODO Arcane - What to do with job updating global time ?
 */
class ArcaneUtils
{
	static def getModuleName(IrModule it)
	{
		name.toFirstUpper + "Module"
	}

	static def toAttributeName(String name)
	{
		"m_" + StringExtensions.separateWith(name, "_")
	}

	static def getComputeLoopEntryPointJobs(IrModule it)
	{
		jobs.filter(ExecuteTimeLoopJob).filter[x | x.caller.main]
	}

	static def isArcaneManaged(ArgOrVar it)
	{
		it instanceof Variable && global && !option && type instanceof ConnectivityType
	}
}