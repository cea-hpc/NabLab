/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.cpp

import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.IrModule
import java.util.LinkedHashSet
import java.util.List

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.IrModuleExtensions.*

class IncludesContentProvider
{
	protected def List<String> getAdditionalPragmas() { #[] }
	protected def List<String> getAdditionalSystemIncludes() { #[] }
	protected def List<String> getAdditionalUserIncludes() { #[] }

	def getContentFor(IrModule m)
	'''
	«FOR pragma : getPragmasFor(m)»
	#pragma «pragma»
	«ENDFOR»
	«FOR include : getSystemIncludesFor(m)»
	#include <«include»>
	«ENDFOR»
	«FOR include : getUserIncludesFor(m)»
	#include "«include»"
	«ENDFOR»
	'''

	private def getPragmasFor(IrModule m)
	{
		additionalPragmas
	}

	private def getSystemIncludesFor(IrModule m)
	{
		val systemIncludes = new LinkedHashSet<String>

		systemIncludes += "iostream"
		systemIncludes += "iomanip"
		systemIncludes += "type_traits"
		systemIncludes += "limits"
		systemIncludes += "utility"
		systemIncludes += "cmath"
		systemIncludes += "cfenv"
		systemIncludes += additionalSystemIncludes

		return systemIncludes
	}

	private def getUserIncludesFor(IrModule m)
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

		userIncludes += additionalUserIncludes
		return userIncludes
	}
}

class KokkosIncludesContentProvider extends IncludesContentProvider
{
	override getAdditionalPragmas()
	{
		#["STDC FENV_ACCESS ON"]
	}

	override getAdditionalSystemIncludes()
	{
		#["Kokkos_Core.hpp", "Kokkos_hwloc.hpp"]
	}
}