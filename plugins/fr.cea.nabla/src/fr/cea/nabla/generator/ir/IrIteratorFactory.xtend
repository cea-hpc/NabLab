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
import fr.cea.nabla.nabla.SingletonSpaceIterator
import fr.cea.nabla.nabla.SpaceIterator

@Singleton
class IrIteratorFactory
{
	@Inject extension IrAnnotationHelper
	@Inject extension SpaceIteratorExtensions
	@Inject extension IrIndexFactory

	def create IrFactory::eINSTANCE.createIterator toIrIterator(SpaceIterator si)
	{
		annotations += si.toIrAnnotation
		name = si.name
		index = si.toIrIndex
		singleton = (si instanceof SingletonSpaceIterator)
		neededIds += si.createNeededIds
		neededIndices += si.createNeededIndices
	}
}