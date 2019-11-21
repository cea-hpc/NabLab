package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.IterationBlock
import fr.cea.nabla.nabla.DimensionIterationBlock
import fr.cea.nabla.nabla.SpaceIterationBlock

class IrIterationBlockFactory 
{
	@Inject extension IrAnnotationHelper
	@Inject extension IrIteratorFactory
	@Inject extension IrDimensionFactory

	def dispatch IterationBlock create IrFactory::eINSTANCE.createSpaceIterationBlock toIrIterationBlock(SpaceIterationBlock b)
	{
		annotations += b.toIrAnnotation
		range = b.range.toIrIterator
		b.singletons.forEach[x | singletons += x.toIrIterator]
	}

	def dispatch IterationBlock create IrFactory::eINSTANCE.createDimensionIterationBlock toIrIterationBlock(DimensionIterationBlock b)
	{
		annotations += b.toIrAnnotation
		index = b.index.toIrDimensionSymbol
		from = b.from.toIrDimension
		to = b.to.toIrDimension
		toIncluded = b.toIncluded
	}
}