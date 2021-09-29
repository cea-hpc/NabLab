package fr.cea.nabla.ir.generator.dace

import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.BaseTypeConstant
import fr.cea.nabla.ir.ir.Expression
import fr.cea.nabla.ir.ir.IntConstant
import fr.cea.nabla.ir.ir.IrType
import fr.cea.nabla.ir.ir.RealConstant
import fr.cea.nabla.ir.ir.Variable
import fr.cea.nabla.ir.ir.VectorConstant

class DefinitionContentProvider extends StateContentProvider
{
	static def getDefinitionContent(Variable v, String varName)
	'''
«««		«v.name» = dp.«getTypeContent(v.type, v.name)»
«««		«IF v.defaultValue !== null»«v.name» = «getDefaultValueContent(v.defaultValue)»«ENDIF»
«««		«IF v.defaultValue !== null»«v.name» = «getDefaultValueContent(v.defaultValue, varName)»«ENDIF»
		«IF  v.defaultValue === null»
			«varName» = np.full(«getNpArrayAllocation(v.type, varName)»)
		«ELSE»
			«varName» = «getDefaultValueContent(v.defaultValue, varName)»
			«varName» = [«varName»]
		«ENDIF»
		«getTypeContent(v.type, varName)»
	'''

	private static def getTypeContent(IrType t, String varName)
	{
		switch t
		{
			BaseType:
			'''
				«varName» = np.array(«varName»)
				«varName».astype(«Utils.getNumpyType(t.primitive)»)
			'''
			default: throw new RuntimeException("Not yet implemented")
		}
	}

	private static def CharSequence getDefaultValueContent(Expression e, String varName)
	{
		switch e
		{
			IntConstant: '''«e.value»'''
			RealConstant: '''«e.value»'''
			VectorConstant: '''[«FOR innerE : e.values SEPARATOR ','»«getDefaultValueContent(innerE, varName)» «ENDFOR»]'''
			BaseTypeConstant:
			{
				val t = e.type as BaseType
				if(t.sizes.size==1)
					'''[«Utils.getDaceType(e.value)»]«FOR s : t.sizes» * «getDefaultValueContent(s, varName)»«ENDFOR»'''
				else if(t.sizes.size==2)
					'''[[«Utils.getDaceType(e.value)»] * «Utils.getDaceType(t.sizes.get(1))» for _ in range(«Utils.getDaceType(t.sizes.get(0))»)]'''
//				'''«FOR sizeIndex:0..<t.sizes.size SEPARATOR ','»«Utils.getDaceType(t.primitive)»(«Utils.getDaceType(e.value)»)«ENDFOR»'''
			}
			default: throw new RuntimeException("Not yet implemented")
		}
	}

	private static def getNpArrayAllocation(IrType t, String varName)
	{
		switch t
		{
			BaseType:
			{
				if(t.sizes.size == 0)
					'''(1), «Utils.getDefaultValue(t.primitive)»'''
				else
					'''(«FOR s : t.sizes SEPARATOR ","»«getDefaultValueContent(s, varName)»«ENDFOR»), «Utils.getDefaultValue(t.primitive)»'''
			}
			default: throw new RuntimeException("Not yet implemented")
		}
	}


}