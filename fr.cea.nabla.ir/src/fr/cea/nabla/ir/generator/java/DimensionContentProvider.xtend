package fr.cea.nabla.ir.generator.java

import fr.cea.nabla.ir.ir.DimensionInt
import fr.cea.nabla.ir.ir.DimensionOperation
import fr.cea.nabla.ir.ir.DimensionSymbolRef

class DimensionContentProvider 
{
	static def dispatch CharSequence getContent(DimensionInt it) '''«value»'''
	static def dispatch CharSequence getContent(DimensionSymbolRef it) '''«target.name»'''
	static def dispatch CharSequence getContent(DimensionOperation it) '''«left.content» «operator» «right.content»'''
}