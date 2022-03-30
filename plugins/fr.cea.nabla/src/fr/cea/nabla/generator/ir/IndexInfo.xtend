/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.generator.ir

import fr.cea.nabla.UniqueNameHelper
import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.ConnectivityVar
import fr.cea.nabla.nabla.SpaceIterator
import fr.cea.nabla.nabla.SpaceIteratorRef
import java.util.Arrays
import org.eclipse.xtend.lib.annotations.Data

import static extension fr.cea.nabla.SpaceIteratorRefExtensions.*

/**
 * Class to store a list of items.
 * A list can not be used because the equals method is needed
 * to use Xtend create mechanisms.
 */
@Data
class DependentItemList
{
	val SpaceIterator[] items

	override boolean equals(Object obj)
	{
		if (this === obj) return true
		if (obj === null) return false
		if (getClass() !== obj.getClass()) return false
		val other = obj as DependentItemList
		if (this.items === null) 
		{
			if (other.items !== null) return false
		}
		else if (!Arrays.deepEquals(this.items, other.items))
			return false
		return true
	}
}

@Data
class IndexInfo
{
	val ArgOrVarRef varRef
	val SpaceIteratorRef itemRef
	val int iteratorIndexInVarIterators

	new(ArgOrVarRef varRef, SpaceIteratorRef itemRef)
	{
		this.varRef = varRef
		this.itemRef = itemRef
		this.iteratorIndexInVarIterators = varRef.spaceIterators.indexOf(itemRef)
		if (iteratorIndexInVarIterators == -1) throw new RuntimeException("Iterator does not belong to variable")
	}

	def getName()
	{
		itemRef.name + UniqueNameHelper::getUniqueName(container, args).toFirstUpper
	}

	def getDependentItems()
	{
		new DependentItemList(args.map[target])
	}

	def getContainer()
	{
		(varRef.target as ConnectivityVar).supports.get(iteratorIndexInVarIterators)
	}

	def getArgs()
	{
		val refLastArgIndex = iteratorIndexInVarIterators
		val refFirstArgIndex = iteratorIndexInVarIterators - container.inTypes.size
		if (refFirstArgIndex > refLastArgIndex) throw new IndexOutOfBoundsException()
		if (refFirstArgIndex == refLastArgIndex) #[] else varRef.spaceIterators.subList(refFirstArgIndex, refLastArgIndex)
	}
}