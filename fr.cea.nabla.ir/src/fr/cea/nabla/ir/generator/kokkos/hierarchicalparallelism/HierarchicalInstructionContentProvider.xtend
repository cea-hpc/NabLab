/*******************************************************************************
	private def getJavaName(ReductionCall it) '''«reduction.provider»Functions.«reduction.name»'''
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 * 	Benoit Lelandais - initial implementation
 * 	Marie-Pierre Oudot - initial implementation
 * 	Jean-Sylvain Camier - Nabla generation support
 *******************************************************************************/
package fr.cea.nabla.ir.generator.kokkos.hierarchicalparallelism

import com.google.inject.Inject
import fr.cea.nabla.ir.generator.IteratorExtensions
import fr.cea.nabla.ir.generator.kokkos.InstructionContentProvider
import fr.cea.nabla.ir.ir.Loop

import static extension fr.cea.nabla.ir.generator.Utils.*

class HierarchicalInstructionContentProvider extends InstructionContentProvider
{
	@Inject extension IteratorExtensions

	override protected getParallelContent(Loop it) 
	'''
		const auto team_work(computeTeamWorkRange(team_member, «range.container.connectivity.nbElems»));
		if (!team_work.second)
			return;
		
		«IF !range.container.connectivity.indexEqualId»auto «range.containerName»(«range.accessor»);«ENDIF»
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& «range.indexName»Team)
		{
			int «range.indexName»(jTeamCells + team_work.first);
			«defineIndices»
			«body.innerContent»
		});
	'''
}