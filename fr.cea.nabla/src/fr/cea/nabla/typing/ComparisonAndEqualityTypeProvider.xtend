package fr.cea.nabla.typing

class ComparisonAndEqualityTypeProvider implements BinaryOperatorTypeProvider 
{
	override NablaType typeFor(NablaType leftType, NablaType rightType) 
	{
		if (NablaType::isBasicType(leftType) && NablaType::isBasicType(rightType) && leftType.base == rightType.base) 
			BasicTypeProvider::BOOL
		else
			NablaType::UNDEFINED
	}	
}