package fr.cea.nabla

import fr.cea.nabla.nabla.BaseType

class BaseTypeExtensions 
{
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
	
	private static def getUtfExponent(int x)
	{
		val xstring = x.toString
		var utfExponent = ''
		for (xchar : xstring.toCharArray)
		{
			val xValue = Character.getNumericValue(xchar)
			if (xValue < 3) utfExponent += '\\u00B' + xchar
			else utfExponent += '\\u207' + xchar
		}
		return utfExponent
	}
}