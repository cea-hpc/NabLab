package fr.cea.nabla.typing

import fr.cea.nabla.nabla.BasicType
import org.eclipse.xtend.lib.annotations.Data

@Data
class NablaType
{
	public static val NablaType UNDEFINED = null
	
	val BasicType base
	val int dimension

	static def boolean isBasicType(NablaType t)
	{
		t!==NablaType::UNDEFINED && t.dimension==0	
	}
	
	static def String getLabel(NablaType t)
	{
		if (t === UNDEFINED) return 'undefined'

		var tName = t.base.literal
		for (i : 0..<t.dimension) tName += '[]'
		return tName
	}
	
	def match(NablaType b) 
	{ 
		if (b===UNDEFINED) false
		else (base==b.base && dimension==b.dimension) 
	}
}
