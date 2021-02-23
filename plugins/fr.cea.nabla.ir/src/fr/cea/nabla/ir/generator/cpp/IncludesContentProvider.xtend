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

import fr.cea.nabla.ir.ir.IrModule
import java.util.LinkedHashSet

import static extension fr.cea.nabla.ir.ExtensionProviderExtensions.*
import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.IrRootExtensions.*
import static extension fr.cea.nabla.ir.generator.Utils.*

abstract class IncludesContentProvider
{
	def getContentFor(IrModule m, String levelDBPath)
	'''
	«FOR include : getSystemIncludes(m, levelDBPath)»
	#include <«include»>
	«ENDFOR»
	«FOR include : getUserIncludes(m, levelDBPath)»
	#include "«include»"
	«ENDFOR»

	«FOR ns : getSystemNs(m, levelDBPath)»
	using namespace «ns»;
	«ENDFOR»
	«FOR ns : getUserNs(m, levelDBPath)»
	using namespace «ns»;
	«ENDFOR»
	'''

	protected def getSystemIncludes(IrModule m, String levelDBPath)
	{
		val systemIncludes = new LinkedHashSet<String>

		systemIncludes += "fstream"
		systemIncludes += "iomanip"
		systemIncludes += "type_traits"
		systemIncludes += "limits"
		systemIncludes += "utility"
		systemIncludes += "cmath"
		if (!levelDBPath.nullOrEmpty)
		{
			systemIncludes += "leveldb/db.h"
			systemIncludes += "leveldb/write_batch.h"
		}

		return systemIncludes
	}

	protected def getUserIncludes(IrModule m, String levelDBPath)
	{
		val userIncludes = new LinkedHashSet<String>
		userIncludes += "nablalib/mesh/CartesianMesh2DFactory.h"
		userIncludes += "nablalib/mesh/CartesianMesh2D.h"
		if (m.irRoot.postProcessing !== null) userIncludes += "nablalib/mesh/PvdFileWriter2D.h"
		userIncludes +=  "nablalib/utils/Utils.h"
		userIncludes +=  "nablalib/utils/Timer.h"
		userIncludes +=  "nablalib/types/Types.h"

		for (provider : m.extensionProviders)
			userIncludes += getNsPrefix(provider, '::').replace('::', '/') + provider.className + ".h"

		if (!m.main)
			userIncludes += m.irRoot.name.toLowerCase + "/" + m.irRoot.mainModule.className + ".h"

		return userIncludes
	}

	protected def getSystemNs(IrModule m, String levelDBPath)
	{
		return #[]
	}

	protected def getUserNs(IrModule m, String levelDBPath)
	{
		val userNs = new LinkedHashSet<String>
		userNs += "nablalib::mesh"
		userNs +=  "nablalib::utils"
		userNs +=  "nablalib::types"
		return userNs
	}
}

class StlThreadIncludesContentProvider extends IncludesContentProvider
{
	override getUserIncludes(IrModule m, String levelDBPath)
	{
		val includes = super.getUserIncludes(m, levelDBPath)
		includes += "nablalib/utils/stl/Parallel.h"
		if (!levelDBPath.nullOrEmpty) includes += "nablalib/utils/stl/Serializer.h"
		return includes
	}

	override getUserNs(IrModule m, String levelDBPath)
	{
		val userNs = super.getUserNs(m, levelDBPath)
		userNs +=  "nablalib::utils::stl"
		return userNs
	}
}

class KokkosIncludesContentProvider extends IncludesContentProvider
{
	override getSystemIncludes(IrModule m, String levelDBPath)
	{
		val includes = super.getSystemIncludes(m, levelDBPath)
		includes += "Kokkos_Core.hpp"
		includes += "Kokkos_hwloc.hpp"
		return includes
	}

	override getUserIncludes(IrModule m, String levelDBPath)
	{
		val includes = super.getUserIncludes(m, levelDBPath)
		includes += "nablalib/utils/kokkos/Parallel.h"
		if (!levelDBPath.nullOrEmpty) includes += "nablalib/utils/kokkos/Serializer.h"
		return includes
	}

	override getUserNs(IrModule m, String levelDBPath)
	{
		val userNs = super.getUserNs(m, levelDBPath)
		userNs +=  "nablalib::utils::kokkos"
		return userNs
	}
}

class SequentialIncludesContentProvider extends IncludesContentProvider
{
	override getUserIncludes(IrModule m, String levelDBPath)
	{
		val includes = super.getUserIncludes(m, levelDBPath)
		if (!levelDBPath.nullOrEmpty) includes += "nablalib/utils/stl/Serializer.h"
		return includes
	}

	override getUserNs(IrModule m, String levelDBPath)
	{
		val userNs = super.getUserNs(m, levelDBPath)
		if (!levelDBPath.nullOrEmpty) userNs += "nablalib::utils::stl"
		return userNs
	}
}

class OpenMpIncludesContentProvider extends SequentialIncludesContentProvider
{
	override getSystemIncludes(IrModule m, String levelDBPath)
	{
		val includes = super.getSystemIncludes(m, levelDBPath)
		includes += "omp.h"
		return includes
	}
}

