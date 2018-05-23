package fr.cea.nabla.typing

import fr.cea.nabla.nabla.BasicType

class MulTypeProvider implements BinaryOperatorTypeProvider
{
	override NablaType typeFor(NablaType leftType, NablaType rightType)
	{		
		if (!NablaType::isBasicType(leftType) || !NablaType::isBasicType(rightType)) return NablaType::UNDEFINED
		if (leftType.base==BasicType::BOOL || rightType==BasicType::BOOL)  return NablaType::UNDEFINED

		switch leftType.base
		{
			case INT:
				switch rightType.base
				{
					case INT, case REAL, case REAL2, case REAL3, case REAL2X2, case REAL3X3: rightType 
					default: NablaType::UNDEFINED 
				}
			case REAL:
				switch rightType.base
				{
					case INT: return leftType
					case REAL, case REAL2, case REAL3, case REAL2X2, case REAL3X3: rightType 
					default: NablaType::UNDEFINED 
				}
			case REAL2, case REAL3:
				switch rightType.base
				{
					case INT, case REAL: return leftType
					default: NablaType::UNDEFINED 
				}
			case REAL2X2:
				switch rightType.base
				{
					case INT, case REAL, case REAL2X2: return leftType
					default: NablaType::UNDEFINED 
				}
			case REAL3X3:
				switch rightType.base
				{
					case INT, case REAL, case REAL3X3: return leftType
					default: NablaType::UNDEFINED 
				}
			default: NablaType::UNDEFINED  
		}
	}
}