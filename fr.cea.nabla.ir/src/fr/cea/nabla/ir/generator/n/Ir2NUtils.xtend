package fr.cea.nabla.ir.generator.n

import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.Reduction
import fr.cea.nabla.ir.ir.BasicType

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
	'''«IF it!==null»∀ «range.connectivity.returnType.type.literal»s«ENDIF»'''

	def getOperator(Reduction it)
	{
		switch name
		{
			case 'sum' : '+='
			case 'min' : '<?='
			case 'max' : '>?='
			default : throw new Exception('Unsupported reduction function: ' + name)
		}
	}
}