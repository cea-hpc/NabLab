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
import fr.cea.nabla.ir.ir.DimensionIterationBlock
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.ReductionInstruction
import fr.cea.nabla.ir.ir.SpaceIterationBlock

import static extension fr.cea.nabla.ir.generator.DimensionContentProvider.*
import static extension fr.cea.nabla.ir.generator.IteratorExtensions.*
import static extension fr.cea.nabla.ir.generator.Utils.*
import static extension fr.cea.nabla.ir.generator.kokkos.ArgOrVarExtensions.*

class HierarchicalInstructionContentProvider extends InstructionContentProvider
{
	override protected getParallelContent(Loop it) { getParallelContent(iterationBlock, it) }

	override protected getHeader(ReductionInstruction it, String nbElems, String indexName)
	'''
		Kokkos::parallel_reduce(Kokkos::TeamThreadRange(team_member, «nbElems»), KOKKOS_LAMBDA(const int& «indexName», «result.cppType»& x)
	'''

	private def dispatch getParallelContent(SpaceIterationBlock it, Loop l) 
	'''
		const auto team_work(computeTeamWorkRange(team_member, «range.container.connectivity.nbElems»));
		if (!team_work.second)
			return;

		«IF !range.container.connectivity.indexEqualId»auto «range.containerName»(«range.accessor»);«ENDIF»
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& «range.indexName»Team)
		{
			int «range.indexName»(«range.indexName»Team + team_work.first);
			«defineIndices»
			«l.body.innerContent»
		});
	'''

	private def dispatch getParallelContent(DimensionIterationBlock it, Loop l) 
	'''
		const int from = «from.content»;
		const int to = «to.content»«IF toIncluded»+1«ENDIF»;
		const int nbElems = from-to;
		const auto team_work(computeTeamWorkRange(team_member, nbElems));
		if (!team_work.second)
			return;

		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& «index.name»Team)
		{
			int «index.name»(«index.name»Team + team_work.first);
			«l.body.innerContent»
		});
	'''
}