package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.ir.IrModule

interface IrTransformationStep 
{
	def String getDescription()
	def void transform(IrModule m)
}