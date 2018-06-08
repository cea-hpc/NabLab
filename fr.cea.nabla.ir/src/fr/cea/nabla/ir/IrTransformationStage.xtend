package fr.cea.nabla.ir

import fr.cea.nabla.ir.ir.IrModule

interface IrTransformationStage 
{
	def String getDescription()
	def void transform(IrModule m)
}