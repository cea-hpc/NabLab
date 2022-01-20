/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.arcane

import fr.cea.nabla.ir.ir.ItemIdValue
import fr.cea.nabla.ir.ir.ItemIdValueContainer
import fr.cea.nabla.ir.ir.ItemIdValueIterator
import fr.cea.nabla.ir.ir.ItemIndexValue

import static extension fr.cea.nabla.ir.ContainerExtensions.*

class ItemIndexAndIdValueContentProvider 
{
	static def getContent(ItemIndexValue it)
	{
		if (container.connectivity.indexEqualId) 
			'''«id.name»'''
		else 
			'''indexOf(m_mesh->«container.accessor», «id.name»)'''
	}

	static def getContent(ItemIdValue it)
	{
		switch it
		{
			ItemIdValueIterator:
				if (iterator.container.connectivityCall.args.empty) '''*«iterator.index.name»'''
				else iterator.container.uniqueName + '[' + getIndexValue + ']'
			ItemIdValueContainer:
				getContent(container, "m_mesh->")
		}
	}

	private static def getIndexValue(ItemIdValueIterator it)
	{
		val index = iterator.index.name
		val nbElems = iterator.container.connectivityCall.nbElemsVar
		switch shift
		{
			case shift < 0: '''(«index»«shift»+«nbElems»)%«nbElems»'''
			case shift > 0: '''(«index»+«shift»+«nbElems»)%«nbElems»'''
			default: '''«index»'''
		}
	}
}
