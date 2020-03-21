package fr.cea.nabla

import fr.cea.nabla.nabla.Item
import fr.cea.nabla.nabla.ItemDefinition
import fr.cea.nabla.nabla.ItemType
import fr.cea.nabla.nabla.SpaceIterator
import fr.cea.nabla.nabla.SingletonDefinition

class ItemExtensions
{
	def ItemType getType(Item it)
	{
		val c = eContainer
		switch c
		{
			ItemDefinition: c.type
			SpaceIterator: c.container.connectivity.returnType
			SingletonDefinition: c.value.connectivity.returnType
		}
	}
}