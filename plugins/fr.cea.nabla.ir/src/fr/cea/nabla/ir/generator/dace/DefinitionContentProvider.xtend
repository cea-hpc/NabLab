package fr.cea.nabla.ir.generator.dace

import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.BaseTypeConstant
import fr.cea.nabla.ir.ir.Expression
import fr.cea.nabla.ir.ir.IrType
import fr.cea.nabla.ir.ir.Variable
import fr.cea.nabla.ir.ir.IntConstant
import fr.cea.nabla.ir.ir.RealConstant
import fr.cea.nabla.ir.ir.VectorConstant

class DefinitionContentProvider
{
	static def getDefinitionContent(Variable v)
	'''
		«v.name» = dp.«getTypeContent(v.type, v.name)»
		«IF v.defaultValue !== null»«v.name» = «getDefaultValueContent(v.defaultValue)»«ENDIF»
	'''

	private static def getTypeContent(IrType t, String varName)
	{
		switch t
		{
			BaseType:
			{
				if (t.sizes.size == 0)
					'''np.(«Utils.getDaceType(t.primitive)»)'''
				else
					'''ndarray(«FOR s: t.sizes»[«Utils.getDaceType(s)»], «Utils.getDaceType(t.primitive)»«ENDFOR»)'''
			}
			default: throw new RuntimeException("Not yet implemented")
		}
	}

	private static def CharSequence getDefaultValueContent(Expression e)
	{
		switch e
		{
			IntConstant: '''«e.value»'''
			RealConstant: '''«e.value»'''
			VectorConstant: '''[«FOR innerE : e.values SEPARATOR ','»«getDefaultValueContent(innerE)»«ENDFOR»]'''
			BaseTypeConstant:
			{
				val t = e.type as BaseType
				'''[«Utils.getDaceType(e.value)»]«FOR s : t.sizes» * «getDefaultValueContent(s)»«ENDFOR»'''
//				'''«FOR sizeIndex:0..<t.sizes.size SEPARATOR ','»«Utils.getDaceType(t.primitive)»(«Utils.getDaceType(e.value)»)«ENDFOR»'''
			}
			default: throw new RuntimeException("Not yet implemented")
		}
	}
}