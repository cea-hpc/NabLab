/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.cpp

import java.util.LinkedHashSet

class IncludesContentProvider
{
	def getIncludes(boolean hasLevelDB, boolean hasPostProcessing)
	'''
		«FOR include : getSystemIncludes(hasLevelDB)»
		#include <«include»>
		«ENDFOR»
		«FOR include : getUserIncludes(hasLevelDB, hasPostProcessing)»
		#include "«include»"
		«ENDFOR»
		'''

		def getUsings(boolean hasLevelDB)
		'''
		«FOR ns : getSystemNs(hasLevelDB)»
		using namespace «ns»;
		«ENDFOR»
		«FOR ns : getUserNs(hasLevelDB)»
		using namespace «ns»;
		«ENDFOR»
	'''

	protected def getSystemIncludes(boolean hasLevelDB)
	{
		val systemIncludes = new LinkedHashSet<String>

		systemIncludes += "fstream"
		systemIncludes += "iomanip"
		systemIncludes += "type_traits"
		systemIncludes += "limits"
		systemIncludes += "utility"
		systemIncludes += "cmath"
		if (hasLevelDB)
		{
			systemIncludes += "leveldb/db.h"
			systemIncludes += "leveldb/write_batch.h"
		}

		return systemIncludes
	}

	protected def getUserIncludes(boolean hasLevelDB, boolean hasPostProcessing)
	{
		val userIncludes = new LinkedHashSet<String>
		userIncludes +=  "nablalib/utils/Utils.h"
		userIncludes +=  "nablalib/utils/Timer.h"
		userIncludes +=  "nablalib/types/Types.h"
		if (hasLevelDB) userIncludes += "nablalib/utils/Serializer.h"
		return userIncludes
	}

	protected def getSystemNs(boolean hasLevelDB)
	{
		return #[]
	}

	protected def getUserNs(boolean hasLevelDB)
	{
		val userNs = new LinkedHashSet<String>
		userNs +=  "nablalib::utils"
		userNs +=  "nablalib::types"
		if (hasLevelDB) userNs +=  "nablalib::utils"
		return userNs
	}
}

class StlThreadIncludesContentProvider extends IncludesContentProvider
{
	override getUserIncludes(boolean hasLevelDB, boolean hasPostProcessing)
	{
		val includes = super.getUserIncludes(hasLevelDB, hasPostProcessing)
		includes += "nablalib/utils/stl/Parallel.h"
		return includes
	}

	override getUserNs(boolean hasLevelDB)
	{
		val userNs = super.getUserNs(hasLevelDB)
		userNs +=  "nablalib::utils::stl"
		return userNs
	}
}

class KokkosIncludesContentProvider extends IncludesContentProvider
{
	override getSystemIncludes(boolean hasLevelDB)
	{
		val includes = super.getSystemIncludes(hasLevelDB)
		includes += "Kokkos_Core.hpp"
		includes += "Kokkos_hwloc.hpp"
		return includes
	}

	override getUserIncludes(boolean hasLevelDB, boolean hasPostProcessing)
	{
		val includes = super.getUserIncludes(hasLevelDB, hasPostProcessing)
		includes += "nablalib/utils/kokkos/Parallel.h"
		if (hasLevelDB) includes += "nablalib/utils/kokkos/Serializer.h"
		return includes
	}

	override getUserNs(boolean hasLevelDB)
	{
		val userNs = super.getUserNs(hasLevelDB)
		userNs +=  "nablalib::utils::kokkos"
		return userNs
	}
}

class OpenMpIncludesContentProvider extends IncludesContentProvider
{
	override getSystemIncludes(boolean hasLevelDB)
	{
		val includes = super.getSystemIncludes(hasLevelDB)
		includes += "omp.h"
		return includes
	}
}

class OpenMpTaskIncludesContentProvider extends IncludesContentProvider
{
	override getSystemIncludes(boolean hasLevelDB)
	{
		val includes = super.getSystemIncludes(hasLevelDB)
		includes += "omp.h"
		return includes
	}
}