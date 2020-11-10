package fr.cea.nabla.generator.ir

import fr.cea.nabla.nabla.AbstractTimeIterator
import fr.cea.nabla.nabla.TimeIterator
import fr.cea.nabla.nabla.TimeIteratorBlock
import fr.cea.nabla.nabla.TimeIteratorDefinition

class TimeIteratorExtensions
{
	def TimeIterator getParentTimeIterator(AbstractTimeIterator it)
	{
		switch eContainer
		{
			TimeIteratorDefinition: null
			TimeIterator: eContainer as TimeIterator
			TimeIteratorBlock: (eContainer as TimeIteratorBlock).parentTimeIterator
		}
	}

	def String getIrVarTimeSuffix(AbstractTimeIterator ti, String type)
	{
		val suffix = switch ti
		{
			TimeIterator: '_' + ti.name + type
			TimeIteratorBlock: ''
		}

		if (ti.eContainer !== null && ti.eContainer instanceof AbstractTimeIterator)
			getIrVarTimeSuffix(ti.eContainer as AbstractTimeIterator, nextTimeIteratorName) + suffix
		else
			suffix
	}

	def getCurrentTimeIteratorName() { '' }
	def getInitTimeIteratorName() { '0' }
	def getNextTimeIteratorName() { 'plus1' }
}