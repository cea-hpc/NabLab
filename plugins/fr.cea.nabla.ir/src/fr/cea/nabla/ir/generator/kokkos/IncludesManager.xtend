/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.kokkos

import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.IrModule
import java.util.LinkedHashSet

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.IrModuleExtensions.*

abstract class IncludesManager
{
	def getPragmasFor(IrModule m)
	{
		val pragmas = new LinkedHashSet<String>
		return pragmas
	}

	def getSystemIncludesFor(IrModule m)
	{
		val systemIncludes = new LinkedHashSet<String>

		systemIncludes += "iostream"
		systemIncludes += "iomanip"
		systemIncludes += "type_traits"
		systemIncludes += "limits"
		systemIncludes += "utility"
		systemIncludes += "cmath"
		systemIncludes += "cfenv"

		return systemIncludes
	}

	def getUserIncludesFor(IrModule m)
	{
		val userIncludes = new LinkedHashSet<String>

		if (m.withMesh)
		{
			userIncludes += "mesh/CartesianMesh2DGenerator.h"
			userIncludes += "mesh/CartesianMesh2D.h"
			userIncludes += "mesh/PvdFileWriter2D.h"
		}

		userIncludes +=  "utils/Utils.h"
		userIncludes +=  "utils/Timer.h"
		userIncludes +=  "types/Types.h"
		userIncludes +=  "types/MathFunctions.h"
		userIncludes +=  "types/ArrayOperations.h"

		if (m.functions.exists[f | f.body === null && f.provider == m.name]) 
			userIncludes += m.name.toLowerCase + "/" + m.name + Utils::FunctionReductionPrefix + ".h"

		val linearAlgebraVars = m.variables.filter(ConnectivityVariable).filter[linearAlgebra]
		if (!linearAlgebraVars.empty) userIncludes += "types/LinearAlgebraFunctions.h"

		return userIncludes
	}
}

class KokkosIncludeManager extends IncludesManager
{
	override getPragmasFor(IrModule m)
	{
		val pragmas = super.getPragmasFor(m)
		pragmas += "STDC FENV_ACCESS ON"
		return pragmas
	}

	override getSystemIncludesFor(IrModule m)
	{
		val includes = super.getSystemIncludesFor(m)
		includes += "Kokkos_Core.hpp"
		includes += "Kokkos_hwloc.hpp"
		return includes
	}
}

class OmpIncludeManager extends IncludesManager
{
	override getSystemIncludesFor(IrModule m)
	{
		val includes = super.getSystemIncludesFor(m)
		includes += "omp.h"
		return includes
	}
}

class StlThreadsIncludeManager extends IncludesManager
{
	override getUserIncludesFor(IrModule m)
	{
		val includes = super.getUserIncludesFor(m)
		includes += "utils/Parallel.h"
		return includes
	}
}