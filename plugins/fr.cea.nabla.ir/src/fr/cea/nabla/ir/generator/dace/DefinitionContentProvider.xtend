package fr.cea.nabla.ir.generator.dace

import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.BaseTypeConstant
import fr.cea.nabla.ir.ir.Expression
import fr.cea.nabla.ir.ir.IrType
import fr.cea.nabla.ir.ir.Variable
import fr.cea.nabla.ir.ir.IntConstant
import fr.cea.nabla.ir.ir.RealConstant
import fr.cea.nabla.ir.ir.VectorConstant


class DefinitionContentProvider extends StateContentProvider
{
	static def getDefinitionContent(Variable v, String varName)
	'''
«««		«v.name» = dp.«getTypeContent(v.type, v.name)»
«««		«IF v.defaultValue !== null»«v.name» = «getDefaultValueContent(v.defaultValue)»«ENDIF»
«««		«IF v.defaultValue !== null»«v.name» = «getDefaultValueContent(v.defaultValue, varName)»«ENDIF»
		«IF v.defaultValue !== null»
			«v.name» = «getDefaultValueContent(v.defaultValue, varName)»
		«ENDIF»
		«IF  v.defaultValue === null»
		«v.name» = «getInitializationVariables(v.type, v.name)»
		«ENDIF»
		«v.name» = «getTypeContent(v.type, v.name)» 
	'''

	private static def getTypeContent(IrType t, String varName)
	{
		switch t
		{
			BaseType:
			{

				if (t.sizes.size == 0)
					'''
						[«varName»]
						«varName» = np.array(«varName» )
						«varName».astype(«Utils.getNumpyType(t.primitive)»)
					'''
				else
				{
					//'''ndarray(«FOR s: t.sizes»[«Utils.getDaceType(s)»], «Utils.getDaceType(t.primitive)»«ENDFOR»)'''
					''' 
						np.array(«varName» )
						«varName».astype(«Utils.getNumpyType(t.primitive)»)
					'''
				}

			}
			default: throw new RuntimeException("Not yet implemented")
		}
	}

	private static def CharSequence getDefaultValueContent(Expression e, String varName)
	{
		switch e
		{
			IntConstant: '''«e.value»'''
			RealConstant: '''«e.value»'''
			VectorConstant: 
			{
				'''[«FOR innerE : e.values SEPARATOR ','»«getDefaultValueContent(innerE, varName)» «ENDFOR»]'''
			

			}
			BaseTypeConstant:
			{
				val t = e.type as BaseType
				if(t.sizes.size==1)
				{
					'''
						[«Utils.getDaceType(e.value)»]«FOR s : t.sizes» * «getDefaultValueContent(s, varName)»«ENDFOR»
					'''
				}
				else if(t.sizes.size==2)
				{
					'''
						[[«Utils.getDaceType(e.value)»] * «Utils.getDaceType(t.sizes.get(1))» for _ in range(«Utils.getDaceType(t.sizes.get(0))»)]
					'''
				}
//				'''«FOR sizeIndex:0..<t.sizes.size SEPARATOR ','»«Utils.getDaceType(t.primitive)»(«Utils.getDaceType(e.value)»)«ENDFOR»'''
			}
			default: throw new RuntimeException("Not yet implemented")
		}
	}

	private static def getInitializationVariables(IrType t, String varName)
	{
		switch t
		{
			BaseType:
			{
				if(t.sizes.size == 0)
				{
					switch t.primitive
					{
						case BOOL: '''true'''
						case INT: ''' 0'''
						case REAL: '''0.0'''
					}
				}
				
				else if(t.sizes.size == 1)
				{
					switch t.primitive
					{
						case BOOL: '''true'''
						case INT: ''' [0]«FOR s : t.sizes» * «getDefaultValueContent(s, varName)»«ENDFOR»'''
						case REAL: '''[0.0]«FOR s : t.sizes» * «getDefaultValueContent(s, varName)»«ENDFOR»'''
					}
				}
				else if(t.sizes.size == 2)
				{
					switch t.primitive
					{
						case BOOL: '''true'''
						case INT: ''' [[0] * «Utils.getDaceType(t.sizes.get(1))» for _ in range(«Utils.getDaceType(t.sizes.get(0))»)]'''
						case REAL: '''[[0.0] * «Utils.getDaceType(t.sizes.get(1))» for _ in range(«Utils.getDaceType(t.sizes.get(0))»)]'''
					}
				}
			}
			default: throw new RuntimeException("Not yet implemented")
		}
	}

}