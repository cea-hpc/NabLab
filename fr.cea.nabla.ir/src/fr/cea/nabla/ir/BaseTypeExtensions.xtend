package fr.cea.nabla.ir

import fr.cea.nabla.ir.ir.BaseType

import static extension fr.cea.nabla.ir.Utils.*

class BaseTypeExtensions 
{
	static def isScalar(BaseType it) { sizes.empty }
	
	static def areEquals(BaseType a, BaseType b)
	{
		if (a.root != b.root || a.sizes.size != b.sizes.size)
			return false
		
		for (i : 0..<a.sizes.size)
			if (a.sizes.get(i) != b.sizes.get(i))
				return false

		return true
	}
	
	static def getLabel(BaseType it)
	{
		root.literal + sizes.map[utfExponent].join('\\u02E3')
	}
}