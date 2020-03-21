package fr.cea.nabla.generator.ir

import fr.cea.nabla.ConnectivityCallExtensions
import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.ConnectivityVar
import fr.cea.nabla.nabla.ItemRef
import org.eclipse.xtend.lib.annotations.Data

import static extension fr.cea.nabla.ItemRefExtensions.*

@Data
class IndexInfo
{
	val ArgOrVarRef varRef
	val ItemRef itemRef
	val int iteratorIndexInVarIterators

	new(ArgOrVarRef varRef, ItemRef itemRef)
	{
		this.varRef = varRef
		this.itemRef = itemRef
		this.iteratorIndexInVarIterators = varRef.spaceIterators.indexOf(itemRef)
		if (iteratorIndexInVarIterators == -1) throw new RuntimeException("** Ooops: iterator does not belong to variable")
	}

	def getName()
	{
		itemRef.name + ConnectivityCallExtensions::getUniqueName(container, args).toFirstUpper
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