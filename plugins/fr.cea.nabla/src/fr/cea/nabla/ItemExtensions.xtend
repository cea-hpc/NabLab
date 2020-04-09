/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla

import fr.cea.nabla.nabla.Item
import fr.cea.nabla.nabla.ItemDefinition
import fr.cea.nabla.nabla.ItemType
import fr.cea.nabla.nabla.MultipleConnectivityCall
import fr.cea.nabla.nabla.SetRef
import fr.cea.nabla.nabla.SingletonDefinition
import fr.cea.nabla.nabla.SpaceIterator

class ItemExtensions
{
	def ItemType getType(Item it)
	{
		val c = eContainer
		switch c
		{
			ItemDefinition: c.value.connectivity.returnType
			SpaceIterator: c.container.connectivity.returnType
			SingletonDefinition: c.value.connectivity.returnType
		}
	}

	private def dispatch getConnectivity(MultipleConnectivityCall it) { connectivity }
	private def dispatch getConnectivity(SetRef it) { target.value.connectivity }
}