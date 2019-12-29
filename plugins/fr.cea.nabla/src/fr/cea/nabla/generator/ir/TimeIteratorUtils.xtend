package fr.cea.nabla.generator.ir

import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.CurrentTimeIteratorRef
import fr.cea.nabla.nabla.InitTimeIteratorRef
import fr.cea.nabla.nabla.NextTimeIteratorRef
import fr.cea.nabla.nabla.TimeIteratorRef

class TimeIteratorUtils 
{
	def getIrTimeSuffix(ArgOrVarRef it) 
	{ 
		if (timeIterators.empty) ''
		else timeIterators.suffixes
	}

	def getIrCurrentTimeSuffix(ArgOrVarRef it) 
	{
		var suffix = timeIterators.subList(0, timeIterators.size-1).suffixes
		val ti = timeIterators.last
		suffix += '_' + ti.target.name
		return suffix
	}

	def getIrOuterTimeSuffix(ArgOrVarRef it) 
	{
		if (timeIterators.size < 2) null
		else timeIterators.subList(0, timeIterators.size-2).suffixes
	}

	private def getSuffixes(Iterable<TimeIteratorRef> timeIterators)
	{
		if (timeIterators === null || timeIterators.empty) ''
		else timeIterators.map['_' + target.name + suffix].join('')
	}

	private def dispatch getSuffix(CurrentTimeIteratorRef it) { '' }
	private def dispatch getSuffix(InitTimeIteratorRef it) { value.toString }
	private def dispatch getSuffix(NextTimeIteratorRef it) { 'plus' + value.toString }
}