package fr.cea.nabla.ir.generator.java

import fr.cea.nabla.ir.ir.Function

import static extension fr.cea.nabla.ir.generator.java.InstructionContentProvider.*
import static extension fr.cea.nabla.ir.generator.java.Ir2JavaUtils.*
import fr.cea.nabla.ir.ir.DimensionSymbol
import fr.cea.nabla.ir.ir.DimensionSymbolRef

class FunctionContentProvider 
{
	static def getContent(Function it)
	'''
		private «returnType.javaType» «name.toFirstLower»(«FOR a : inArgs SEPARATOR ', '»«a.type.javaType» «a.name»«ENDFOR») 
		{
			«FOR dimVar : dimensionVars»
			final int «dimVar.name» = «getSizeOf(dimVar)»;
			«ENDFOR»
			«body.innerContent»
		}		
	'''

	private static def getSizeOf(Function it, DimensionSymbol symbol)
	{
		for (a : inArgs)
		{
			var skippedDimensions = ""
			for (dimension : a.type.sizes)
			{
				if (dimension instanceof DimensionSymbolRef && (dimension as DimensionSymbolRef).target == symbol)
					return a.name + skippedDimensions + '.length'
				skippedDimensions += "[0]"
			}
		}
		throw new RuntimeException("No arg corresponding to dimension symbol " + symbol.name)
	}
}