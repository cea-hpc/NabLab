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
import fr.cea.nabla.ir.generator.IndexHelper
import fr.cea.nabla.ir.generator.IndexHelper.IndexFactory
import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.generator.kokkos.InstructionContentProvider
import fr.cea.nabla.ir.generator.kokkos.Ir2KokkosUtils
import fr.cea.nabla.ir.generator.kokkos.VariableExtensions
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.Loop
import org.eclipse.emf.ecore.EObject

import static extension fr.cea.nabla.ir.JobExtensions.*
import fr.cea.nabla.ir.ir.ArrayVariable

class HierarchicalInstructionContentProvider extends InstructionContentProvider
{
	@Inject extension Utils
	@Inject extension VariableExtensions
	@Inject extension Ir2KokkosUtils
	@Inject extension IndexHelper

	override protected addParallelLoop(Iterator it, Loop l) 
	'''
		const auto team_work(computeTeamWorkRange(team_member, «call.connectivity.nbElems»));
		if (!team_work.second)
			return;

		«FOR inVar : job.inVars.filter(ArrayVariable)»
		const Kokkos::View<const «inVar.kokkosType»> const_«inVar.name» = «inVar.name»;
		«ENDFOR»
		
		«val itIndex = IndexFactory::createIndex(it)»
		«IF !call.connectivity.indexEqualId»auto «itIndex.containerName»(«call.accessor»);«ENDIF»
		Kokkos::parallel_for(Kokkos::TeamThreadRange(team_member, team_work.second), KOKKOS_LAMBDA(const int& «itIndex.label»Team)
		{
			int «itIndex.label»(«itIndex.label»Team + team_work.first);
			«IF needIdFor(l)»int «name»Id(«indexToId(itIndex)»);«ENDIF»
			«FOR index : getRequiredIndexes(l)»
			int «index.label»(«idToIndex(index, name+'Id')»);
			«ENDFOR»
			«l.body.innerContent»
		});
	'''
	
	private def Job getJob(EObject o)
	{
		if (o === null) null
		else if (o instanceof Job) o as Job
		else o.eContainer.job
	}
}