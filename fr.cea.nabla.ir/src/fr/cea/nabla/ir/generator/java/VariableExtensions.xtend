package fr.cea.nabla.ir.generator.java

import com.google.inject.Inject
import fr.cea.nabla.ir.ir.ArrayVariable
import fr.cea.nabla.ir.ir.ScalarVariable

class VariableExtensions 
{
	@Inject extension Ir2JavaUtils
	
	def dispatch getJavaType(ScalarVariable it) 
	{ 
		type.javaType
	}
	
	def dispatch getJavaType(ArrayVariable it)
	{
		var t = getType.javaType 
		for (d : dimensions) t += '[]'
		return t
	}

	def getJavaAllocation(ArrayVariable it)
	{
		throw new Exception("Not yet implemented")
//		var alloc = 'new ' + getType.javaType + '[nb' + support.literal.toFirstUpper + 's]'
//		if (innerSupport != ItemType::NONE) alloc = alloc + '[' + getInnerMaxAccessor(support, innerSupport) + ']'
//		return alloc
	}
}