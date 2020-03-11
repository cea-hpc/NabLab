package fr.cea.nabla.generator.ir

import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.ConnectivityVar
import fr.cea.nabla.nabla.SpaceIteratorRef
import org.eclipse.xtend.lib.annotations.Data

import static extension fr.cea.nabla.generator.ir.SpaceIteratorRefExtensions.getName

@Data
class IndexInfo 
{
	val ArgOrVarRef varRef
	val SpaceIteratorRef iteratorRef
	val int iteratorIndexInVarIterators

	new(ArgOrVarRef varRef, SpaceIteratorRef iteratorRef)
	{
		this.varRef = varRef
		this.iteratorRef = iteratorRef
		this.iteratorIndexInVarIterators = varRef.spaceIterators.indexOf(iteratorRef)
		if (iteratorIndexInVarIterators == -1) throw new RuntimeException("** Ooops: iterator does not belong to variable")
	}

	def getName() 
	{
		iteratorRef.name + container.name.toFirstUpper + args.map[x | getName(x).toFirstUpper].join
	}

	def getDirectIterator()
	{
		iteratorRef.target
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