package fr.cea.nabla.generator.ir

import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.TimeIteratorRef
import fr.cea.nabla.nabla.TimeIteratorRefType

class TimeIteratorUtils 
{
	def getTimeSuffix(ArgOrVarRef it) 
	{ 
		if (timeIterators.empty) null
		else timeIterators.suffix
	}

	def getCurrentTimeSuffix(ArgOrVarRef it) 
	{
		var suffix = timeIterators.subList(0, timeIterators.size-2).suffix
		val ti = timeIterators.last
		suffix += '_' + ti.target.name + TimeIteratorRefType::CURRENT.suffix
		return suffix
	}

	def getOuterTimeSuffix(ArgOrVarRef it) 
	{
		if (timeIterators.size < 2) null
		else timeIterators.subList(0, timeIterators.size-2).suffix
	}

	private def getSuffix(Iterable<TimeIteratorRef> timeIterators)
	{
		if (timeIterators === null || timeIterators.empty) ''
		else timeIterators.map['_' + target.name + type.suffix].join('')
	}

	private def getSuffix(TimeIteratorRefType t)
	{
		switch t
		{
			case INIT: '0'
			case CURRENT: ''
			case NEXT: 'plus1'
		}
	}
}