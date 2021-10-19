/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.generator.ir

import com.google.inject.Singleton
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.nabla.AbstractTimeIterator
import fr.cea.nabla.nabla.TimeIterator
import fr.cea.nabla.nabla.TimeIteratorBlock

@Singleton
class IrTimeIteratorFactory
{
	def Iterable<fr.cea.nabla.ir.ir.TimeIterator> createIrTimeIterators(AbstractTimeIterator nablaTi)
	{
		switch nablaTi
		{
			TimeIterator: #[toIrTimeIterator(nablaTi)]
			TimeIteratorBlock: nablaTi.iterators.map[x | toIrTimeIterator(x)]
		}
	}

	def create IrFactory::eINSTANCE.createTimeIterator toIrTimeIterator(TimeIterator nablaTi)
	{
		name = nablaTi.name
		if (nablaTi.innerIterator !== null) innerIterators += createIrTimeIterators(nablaTi.innerIterator)
	}
}