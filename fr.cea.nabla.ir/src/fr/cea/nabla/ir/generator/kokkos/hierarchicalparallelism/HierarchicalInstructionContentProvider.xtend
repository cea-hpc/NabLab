/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.kokkos.hierarchicalparallelism

import fr.cea.nabla.ir.generator.kokkos.InstructionContentProvider
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.ReductionInstruction

import static extension fr.cea.nabla.ir.generator.IteratorExtensions.*
import static extension fr.cea.nabla.ir.generator.Utils.*
import static extension fr.cea.nabla.ir.generator.kokkos.VariableExtensions.*

class HierarchicalInstructionContentProvider extends InstructionContentProvider
{
	override protected getParallelContent(Loop it) 
	'''
		const auto team_work(computeTeamWorkRange(team_member, «range.container.connectivity.nbElems»));
		if (!team_work.second)
			return;
		
		«IF !range.container.connectivity.indexEqualId»auto «range.containerName»(«range.accessor»);«ENDIF»
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& «range.indexName»Team)
		{
			int «range.indexName»(«range.indexName»Team + team_work.first);
			«defineIndices»
			«body.innerContent»
		});
	'''
	
	override protected getHeader(ReductionInstruction it) 
	'''
		Kokkos::parallel_reduce(Kokkos::TeamThreadRange(team_member, «range.container.connectivity.nbElems»), KOKKOS_LAMBDA(const int& «range.indexName», «result.kokkosType»& x)
	'''
}