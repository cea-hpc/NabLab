package fr.cea.nabla

import fr.cea.nabla.nabla.BaseType
import fr.cea.nabla.nabla.PrimitiveType

import static extension fr.cea.nabla.ir.Utils.*

class BaseTypeExtensions 
{
	static def isScalar(BaseType it) { dimSizes.empty }
	static def isInt(BaseType it) { scalar && root==PrimitiveType::INT }
	static def isReal(BaseType it) { scalar && root==PrimitiveType::REAL }
	static def isIntArray(BaseType it) { !scalar && root==PrimitiveType::INT }
	static def isRealArray(BaseType it) { !scalar && root==PrimitiveType::REAL }
	
	static def areEquals(BaseType a, BaseType b)
	{
		if (a.root != b.root || a.dimSizes.size != b.dimSizes.size)
			return false
		
		for (i : 0..<a.dimSizes.size)
			if (a.dimSizes.get(i) != b.dimSizes.get(i))
				return false

		return true
	}
	
	static def getLabel(BaseType it)
	{
		root.literal + dimSizes.map[utfExponent].join('\\u02E3')
	}
}