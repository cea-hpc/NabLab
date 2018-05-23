package fr.cea.nabla.ir

import fr.cea.nabla.ir.ir.IrModule

interface Ir2IrPass 
{
	def String getDescription()
	def void transform(IrModule m)
}