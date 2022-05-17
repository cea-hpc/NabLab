/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.generator

import fr.cea.nabla.ir.generator.cpp.Backend
import fr.cea.nabla.ir.generator.cpp.KokkosBackend
import fr.cea.nabla.ir.generator.cpp.KokkosTeamThreadBackend
import fr.cea.nabla.ir.generator.cpp.OpenMpBackend
import fr.cea.nabla.ir.generator.cpp.SequentialBackend
import fr.cea.nabla.ir.generator.cpp.StlThreadBackend
import fr.cea.nabla.nablagen.TargetType

class BackendFactory
{
	def Backend getCppBackend(TargetType type)
	{
		getCppBackend(type, false)
	}
	
	def Backend getCppBackend(TargetType type, boolean debug)
	{
		switch type
		{
			case CPP_SEQUENTIAL: new SequentialBackend(debug)
			case STL_THREAD: new StlThreadBackend(debug)
			case OPEN_MP: new OpenMpBackend(debug)
			case KOKKOS: new KokkosBackend
			case KOKKOS_TEAM_THREAD: new KokkosTeamThreadBackend
			default: throw new RuntimeException("No backend for: " + type.literal)
		}
	}
}