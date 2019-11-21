package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import com.google.inject.Singleton
import fr.cea.nabla.ir.ir.Dimension
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.nabla.DimensionInt
import fr.cea.nabla.nabla.DimensionOperation
import fr.cea.nabla.nabla.DimensionSymbol
import fr.cea.nabla.nabla.DimensionSymbolRef

/**
 * No create method for Dimension to ensure a new instance every time (for n+1 time variables)
 * but take care to keep a create method for DimensionSymbol (and to keep @Singleton)
 */
@Singleton
class IrDimensionFactory 
{
	@Inject extension IrAnnotationHelper

	def dispatch Dimension toIrDimension(DimensionInt d)
	{
		IrFactory::eINSTANCE.createDimensionInt =>
		[
			annotations += d.toIrAnnotation
			value = d.value
		]
	}

	def dispatch Dimension toIrDimension(DimensionOperation d)
	{
		IrFactory::eINSTANCE.createDimensionOperation =>
		[
			annotations += d.toIrAnnotation
			left = d.left.toIrDimension
			right = d.right.toIrDimension
			operator = d.op
		]
	}

	def dispatch Dimension toIrDimension(DimensionSymbolRef d)
	{
		IrFactory::eINSTANCE.createDimensionSymbolRef =>
		[
			annotations += d.toIrAnnotation
			target = d.target.toIrDimensionSymbol
		]
	}

	def create IrFactory::eINSTANCE.createDimensionSymbol toIrDimensionSymbol(DimensionSymbol d)
	{
		annotations += d.toIrAnnotation
		name = d.name
	}
}