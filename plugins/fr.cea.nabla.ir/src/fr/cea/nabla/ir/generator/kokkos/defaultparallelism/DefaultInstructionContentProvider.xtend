/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.kokkos.defaultparallelism

import fr.cea.nabla.ir.generator.kokkos.InstructionContentProvider
import fr.cea.nabla.ir.ir.IntervalIterationBlock
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.ReductionInstruction
import fr.cea.nabla.ir.ir.SpaceIterationBlock

import static extension fr.cea.nabla.ir.generator.IteratorExtensions.*
import static extension fr.cea.nabla.ir.generator.SizeTypeContentProvider.*
import static extension fr.cea.nabla.ir.generator.Utils.*
import static extension fr.cea.nabla.ir.generator.kokkos.ArgOrVarExtensions.*

class DefaultInstructionContentProvider extends InstructionContentProvider
{
	override protected getParallelContent(Loop it, String kokkosName) { getParallelContent(iterationBlock, it, kokkosName) }

	override protected getHeader(ReductionInstruction it, String nbElems, String indexName)
	'''
		Kokkos::parallel_reduce("Reduction«result.name»", «nbElems», KOKKOS_LAMBDA(const int& «indexName», «result.cppType»& x)
	'''

	private def dispatch getParallelContent(SpaceIterationBlock it, Loop l, String kokkosName)
	'''
		«IF !range.container.connectivity.indexEqualId»
		{
			auto «range.containerName»(«range.accessor»);
			«getInternalParallelContent(l, kokkosName)»
		}
		«ELSE»
			«getInternalParallelContent(l, kokkosName)»
		«ENDIF»
	'''

	private def getInternalParallelContent(SpaceIterationBlock it, Loop l, String kokkosName)
	'''
		Kokkos::parallel_for(«IF kokkosName !== null»"«kokkosName»", «ENDIF»«range.container.connectivity.nbElems», KOKKOS_LAMBDA(const int& «range.indexName»)
		{
			«defineIndices»
			«l.body.innerContent»
		});
	'''

	private def dispatch getParallelContent(IntervalIterationBlock it, Loop l, String kokkosName)
	'''
		{
			const int from = «from.content»;
			const int to = «to.content»«IF toIncluded»+1«ENDIF»;
			const int nbElems = from-to;
			Kokkos::parallel_for(«IF kokkosName !== null»«kokkosName», «ENDIF»nbElems, KOKKOS_LAMBDA(const int& «index.name»)
			{
				«l.body.innerContent»
			});
		}
	'''
}