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

import fr.cea.nabla.ir.generator.cpp.Backend
import fr.cea.nabla.ir.generator.cpp.KokkosBackend
import fr.cea.nabla.ir.generator.cpp.KokkosTeamThreadBackend
import fr.cea.nabla.ir.generator.cpp.OpenMpBackend
import fr.cea.nabla.ir.generator.cpp.OpenMpTargetBackend
import fr.cea.nabla.ir.generator.cpp.SequentialBackend
import fr.cea.nabla.ir.generator.cpp.StlThreadBackend
import fr.cea.nabla.nablagen.TargetType
import java.util.ArrayList

class BackendFactory
{
	def Backend getCppBackend(TargetType type, ArrayList<Pair<String, String>> options)
	{
		switch type
		{
			case CPP_SEQUENTIAL: new SequentialBackend(options)
			case STL_THREAD: new StlThreadBackend(options)
			case OPEN_MP: new OpenMpBackend(options)
			case OPEN_MP_TARGET: new OpenMpTargetBackend(options)
			case KOKKOS: new KokkosBackend(options)
			case KOKKOS_TEAM_THREAD: new KokkosTeamThreadBackend(options)
			default: throw new RuntimeException("No backend for type: " + type.literal)
		}
	}
}