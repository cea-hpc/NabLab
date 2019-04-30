/*******************************************************************************
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
package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import com.google.inject.Singleton
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.IteratorRef
import fr.cea.nabla.nabla.ConnectivityCall
import fr.cea.nabla.nabla.SingletonSpaceIterator
import fr.cea.nabla.nabla.SpaceIterator
import fr.cea.nabla.nabla.SpaceIteratorRef

/**
 * Attention : cette classe doit être un singleton car elle utilise des méthodes create.
 * Si elle n'est pas singleton, plusieurs instances d'un même objet seront créées lors
 * deu parcours du graphe d'origine (voir la documentation Xtext).
 */
@Singleton
class IrIteratorFactory 
{	
	@Inject extension IrAnnotationHelper
	@Inject extension IrConnectivityFactory
	
	def create IrFactory::eINSTANCE.createIterator toIrIterator(SpaceIterator si)
	{
		annotations += si.toIrAnnotation
		name = si.name
		container = si.container.toIrConnectivityCall
		singleton = (si instanceof SingletonSpaceIterator)
	}
	
	def create IrFactory::eINSTANCE.createConnectivityCall toIrConnectivityCall(ConnectivityCall range)
	{
		annotations += range.toIrAnnotation
		connectivity = range.connectivity.toIrConnectivity
		range.args.forEach[x | args += x.toIrConnectivityCallIteratorRef]
	}

	def create IrFactory::eINSTANCE.createVarRefIteratorRef toIrVarRefIteratorRef(SpaceIteratorRef ref, int index)
	{
		initIteratorRef(ref)
		indexInReferencerList = index
	}

	def create IrFactory::eINSTANCE.createConnectivityCallIteratorRef toIrConnectivityCallIteratorRef(SpaceIteratorRef ref)
	{
		initIteratorRef(ref)
	}
	
	private def initIteratorRef(IteratorRef it, SpaceIteratorRef ref)
	{
		annotations += ref.toIrAnnotation
		target = ref.target.toIrIterator
		if (ref.dec > 0) shift = -ref.dec
		else shift = ref.inc
	}
}