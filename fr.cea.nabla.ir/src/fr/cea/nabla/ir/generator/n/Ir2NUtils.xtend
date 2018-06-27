package fr.cea.nabla.ir.generator.n

import fr.cea.nabla.ir.ir.BasicType
import fr.cea.nabla.ir.ir.Iterator

class Ir2NUtils 
{	
	def getNType(BasicType t)
	{
		switch t
		{
			case VOID : 'void'
			case BOOL: '\u213E'
			case INT: '\u2115'
			case REAL: '\u211D'
			case REAL2: '\u211D\u00B2'
			case REAL2X2: '\u211D\u00B2\u02E3\u00B2'
			case REAL3: '\u211D\u00B3'
			case REAL3X3: '\u211D\u00B3\u02E3\u00B3'
		}
	}

	def getContent(Iterator it)
	'''«IF it!==null»∀ «range.connectivity.name»«ENDIF»'''
}