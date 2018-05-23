package fr.cea.nabla.ir.generator.kmds

import com.google.inject.Inject
import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.ir.BasicType
import fr.cea.nabla.ir.ir.ItemType
import fr.cea.nabla.ir.ir.IteratorRange
import fr.cea.nabla.ir.ir.IteratorRef

class Ir2KmdsUtils 
{
	@Inject extension Utils

	def getKmdsType(BasicType t)
	{
		switch t
		{
			case VOID : 'void'
			case BOOL: 'bool'
			case INT: 'int'
			case REAL: 'double'
			case REAL2: 'Real2'
			case REAL2X2: 'Real2x2'
			case REAL3: 'Real3'
			case REAL3X3: 'Real3x3'
		}
	}	
	
	def getKmdsItemType(ItemType t)
	{
		switch t
		{
			case CELL: if (dimension==2) 'FACE' else 'REGION'
			case FACE: if (dimension==2) 'EDGE' else 'FACE'
			case NODE: 'NODE'
			case NONE: ''
		}
	}

	def CharSequence getAccessor(IteratorRange it) 
	'''mesh.get«connectivity.name.toFirstUpper»(«args.map[rangeArgName].join(',')»)'''

	private def dispatch getRangeArgName(IteratorRange it) { accessor }
	private def dispatch getRangeArgName(IteratorRef it) { prefix(iterator.name + 'Id') }
}