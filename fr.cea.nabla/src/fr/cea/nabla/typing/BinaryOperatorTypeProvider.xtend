package fr.cea.nabla.typing

interface BinaryOperatorTypeProvider 
{
	def NablaType typeFor(NablaType leftType, NablaType rightType)
}
