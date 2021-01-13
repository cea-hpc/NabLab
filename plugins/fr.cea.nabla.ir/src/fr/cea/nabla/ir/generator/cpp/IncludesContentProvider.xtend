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

import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.IrRootExtensions.*
import static extension fr.cea.nabla.ir.generator.ExtensionProviderExtensions.*
import static extension fr.cea.nabla.ir.generator.Utils.*

abstract class IncludesContentProvider
{
	protected def Iterable<String> getAdditionalSystemIncludes(IrModule m, String levelDBPath) { #[] }
	protected def Iterable<String> getAdditionalUserIncludes(IrModule m, String levelDBPath) { #[] }

	def getContentFor(IrModule m, String levelDBPath)
	'''
	«FOR include : getSystemIncludesFor(m, levelDBPath)»
	#include <«include»>
	«ENDFOR»
	«FOR include : getUserIncludesFor(m, levelDBPath)»
	#include "«include»"
	«ENDFOR»
	'''

	private def getSystemIncludesFor(IrModule m, String levelDBPath)
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
		systemIncludes += getAdditionalSystemIncludes(m, levelDBPath)

		return systemIncludes
	}

	private def getUserIncludesFor(IrModule m, String levelDBPath)
	{
		val userIncludes = new LinkedHashSet<String>
		userIncludes += "mesh/CartesianMesh2DFactory.h"
		userIncludes += "mesh/CartesianMesh2D.h"
		userIncludes +=  "utils/Utils.h"
		userIncludes +=  "utils/Timer.h"
		userIncludes +=  "types/Types.h"

		for (provider : m.extensionProviders.filter[x | x.extensionName != "LinearAlgebra"])
			userIncludes += provider.namespaceName + '/' + provider.className + ".h"

		if (!m.main)
			userIncludes += m.irRoot.name.toLowerCase + "/" + m.irRoot.mainModule.className + ".h"

		userIncludes += getAdditionalUserIncludes(m, levelDBPath)
		return userIncludes
	}
}

class StlThreadIncludesContentProvider extends IncludesContentProvider
{
	override getAdditionalUserIncludes(IrModule m, String levelDBPath)
	{
		val includes = new LinkedHashSet<String>
		if (m.irRoot.postProcessing !== null) includes += "mesh/stl/PvdFileWriter2D.h"
		includes += "utils/stl/Parallel.h"
		if (m.linearAlgebra) includes += "linearalgebra/stl/LinearAlgebraFunctions.h"
		if (!levelDBPath.nullOrEmpty) includes += "utils/stl/Serializer.h"
		return includes
	}
}

class KokkosIncludesContentProvider extends IncludesContentProvider
{
	override getAdditionalSystemIncludes(IrModule m, String levelDBPath)
	{
		#["Kokkos_Core.hpp", "Kokkos_hwloc.hpp"]
	}

	override getAdditionalUserIncludes(IrModule m, String levelDBPath)
	{
		val includes = new LinkedHashSet<String>
		if (m.irRoot.postProcessing !== null) includes += "mesh/kokkos/PvdFileWriter2D.h"
		includes += "utils/kokkos/Parallel.h"
		if (m.linearAlgebra) includes += "linearalgebra/kokkos/LinearAlgebraFunctions.h"
		if (!levelDBPath.nullOrEmpty) includes += "utils/kokkos/Serializer.h"
		return includes
	}
}

class SequentialIncludesContentProvider extends IncludesContentProvider
{
	override getAdditionalUserIncludes(IrModule m, String levelDBPath)
	{
		val includes = new LinkedHashSet<String>
		if (m.irRoot.postProcessing !== null) includes += "mesh/stl/PvdFileWriter2D.h"
		if (m.linearAlgebra) includes += "linearalgebra/stl/LinearAlgebraFunctions.h"
		if (!levelDBPath.nullOrEmpty) includes += "utils/stl/Serializer.h"
		return includes
	}
}

class OpenMpIncludesContentProvider extends IncludesContentProvider
{
	override getAdditionalSystemIncludes(IrModule m, String levelDBPath)
	{
		#["omp.h"]
	}

	override getAdditionalUserIncludes(IrModule m, String levelDBPath)
	{
		val includes = new LinkedHashSet<String>
		if (m.irRoot.postProcessing !== null) includes += "mesh/stl/PvdFileWriter2D.h"
		if (m.linearAlgebra) includes += "linearalgebra/stl/LinearAlgebraFunctions.h"
		if (!levelDBPath.nullOrEmpty) includes += "utils/stl/Serializer.h"
		return includes
	}
}

