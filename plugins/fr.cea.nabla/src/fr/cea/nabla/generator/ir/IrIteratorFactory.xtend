/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import com.google.inject.Singleton
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.IrIndex
import fr.cea.nabla.ir.ir.IteratorRef
import fr.cea.nabla.nabla.Connectivity
import fr.cea.nabla.nabla.ConnectivityCall
import fr.cea.nabla.nabla.SingletonSpaceIterator
import fr.cea.nabla.nabla.SpaceIterator
import fr.cea.nabla.nabla.SpaceIteratorRef
import java.util.List

@Singleton
class IrIteratorFactory
{
	@Inject extension IrAnnotationHelper
	@Inject extension IrConnectivityFactory
	@Inject extension SpaceIteratorExtensions
	@Inject extension IrIndexFactory
	@Inject extension IrUniqueIdFactory

	def create IrFactory::eINSTANCE.createIterator toIrIterator(SpaceIterator si)
	{
		annotations += si.toIrAnnotation
		name = si.name
		associatedIndex = si.toIrIndex
		container = si.container.toIrConnectivityCall
		singleton = (si instanceof SingletonSpaceIterator)
		neededIds += si.createNeededIds
		neededIndices += si.createNeededIndices
	}

	def create IrFactory::eINSTANCE.createConnectivityCall toIrConnectivityCall(ConnectivityCall range)
	{
		annotations += range.toIrAnnotation
		connectivity = range.connectivity.toIrConnectivity
		for (i : 0..<range.args.size)
			args += range.args.get(i).toIrConnectivityCallIteratorRef(i)
	}

	// index as arg because it is part of the primary key
	def create IrFactory::eINSTANCE.createIrConnectivityCall toIrNewConnectivityCall(IrIndex index, Connectivity c, List<SpaceIteratorRef> las)
	{
		annotations += c.toIrAnnotation
		connectivity = c.toIrConnectivity
		las.forEach[x | args += x.toIrUniqueId]
	}

	def create IrFactory::eINSTANCE.createArgOrVarRefIteratorRef toIrArgOrVarRefIteratorRef(SpaceIteratorRef ref, int index)
	{
		initIteratorRef(ref, index)
	}

	def create IrFactory::eINSTANCE.createConnectivityCallIteratorRef toIrConnectivityCallIteratorRef(SpaceIteratorRef ref, int index)
	{
		initIteratorRef(ref, index)
	}

	private def initIteratorRef(IteratorRef it, SpaceIteratorRef ref, int index)
	{
		annotations += ref.toIrAnnotation
		target = ref.target.toIrIterator
		if (ref.dec > 0) shift = -ref.dec
		else shift = ref.inc
		indexInReferencerList = index
	}
}