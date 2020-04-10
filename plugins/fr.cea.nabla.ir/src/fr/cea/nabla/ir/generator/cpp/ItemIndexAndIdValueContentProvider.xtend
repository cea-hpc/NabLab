/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.cpp

import fr.cea.nabla.ir.ir.ItemIdValueCall
import fr.cea.nabla.ir.ir.ItemIdValueIterator
import fr.cea.nabla.ir.ir.ItemIndexValueId

import static extension fr.cea.nabla.ir.ContainerExtensions.*
import static extension fr.cea.nabla.ir.generator.Utils.*

class ItemIndexAndIdValueContentProvider 
{
	static def dispatch getContent(ItemIndexValueId it)
	{
		if (container.connectivity.indexEqualId) 
			'''«id.name»'''
		else 
			'''utils::indexOf(mesh->«container.accessor», «id.name»)'''
	}

	static def dispatch getContent(ItemIdValueIterator it)
	{
		if (iterator.container.connectivity.indexEqualId) indexValue
		else iterator.container.uniqueName + '[' + indexValue + ']'
	}

	static def dispatch getContent(ItemIdValueCall it)
	'''mesh->«call.accessor»'''

	private static def getIndexValue(ItemIdValueIterator it)
	{
		val index = iterator.index.name
		val nbElems = iterator.container.connectivity.nbElemsVar
		switch shift
		{
			case shift < 0: '''(«index»«shift»+«nbElems»)%«nbElems»'''
			case shift > 0: '''(«index»+«shift»+«nbElems»)%«nbElems»'''
			default: '''«index»'''
		}
	}
}