/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.generator

import fr.cea.nabla.ir.generator.cpp.backends.Backend
import fr.cea.nabla.ir.generator.cpp.backends.KokkosBackend
import fr.cea.nabla.ir.generator.cpp.backends.KokkosTeamThreadBackend
import fr.cea.nabla.ir.generator.cpp.backends.OpenMpBackend
import fr.cea.nabla.ir.generator.cpp.backends.SequentialBackend
import fr.cea.nabla.ir.generator.cpp.backends.StlThreadBackend
import fr.cea.nabla.nablagen.TargetType

class BackendFactory
{
	def Backend getCppBackend(TargetType type)
	{
		switch type
		{
			case CPP_SEQUENTIAL: new SequentialBackend
			case STL_THREAD: new StlThreadBackend
			case OPEN_MP: new OpenMpBackend
			case KOKKOS: new KokkosBackend
			case KOKKOS_TEAM_THREAD: new KokkosTeamThreadBackend
			default: throw new RuntimeException("No backend for type: " + type.literal)
		}
	}
}