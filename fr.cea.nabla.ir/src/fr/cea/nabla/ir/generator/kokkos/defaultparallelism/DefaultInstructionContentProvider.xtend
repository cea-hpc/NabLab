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
package fr.cea.nabla.ir.generator.kokkos.defaultparallelism

import fr.cea.nabla.ir.generator.kokkos.InstructionContentProvider
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.ReductionInstruction

import static extension fr.cea.nabla.ir.generator.IteratorExtensions.*
import static extension fr.cea.nabla.ir.generator.Utils.*
import static extension fr.cea.nabla.ir.generator.kokkos.VariableExtensions.*

class DefaultInstructionContentProvider extends InstructionContentProvider
{
	override protected getParallelContent(Loop it) 
	'''
		«IF !range.container.connectivity.indexEqualId»auto «range.containerName»(«range.accessor»);«ENDIF»
		Kokkos::parallel_for(«range.container.connectivity.nbElems», KOKKOS_LAMBDA(const int& «range.indexName»)
		{
			«defineIndices»
			«body.innerContent»
		});
	'''
	
	override protected getHeader(ReductionInstruction it)
	'''
		Kokkos::parallel_reduce("Reduction«result.name»", «range.container.connectivity.nbElems», KOKKOS_LAMBDA(const int& «range.indexName», «result.kokkosType»& x)
	'''
}