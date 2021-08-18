package fr.cea.nabla.generator.ir

import com.google.inject.Singleton
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.nabla.AbstractTimeIterator
import fr.cea.nabla.nabla.TimeIterator
import fr.cea.nabla.nabla.TimeIteratorBlock

@Singleton
class IrTimeIteratorFactory
{
	def Iterable<fr.cea.nabla.ir.ir.TimeIterator> createIrTimeIterators(AbstractTimeIterator nablaTi)
	{
		switch nablaTi
		{
			TimeIterator: #[toIrTimeIterator(nablaTi)]
			TimeIteratorBlock: nablaTi.iterators.map[x | toIrTimeIterator(x)]
		}
	}

	def create IrFactory::eINSTANCE.createTimeIterator toIrTimeIterator(TimeIterator nablaTi)
	{
		name = nablaTi.name
		if (nablaTi.innerIterator !== null) innerIterators += createIrTimeIterators(nablaTi.innerIterator)
	}
}