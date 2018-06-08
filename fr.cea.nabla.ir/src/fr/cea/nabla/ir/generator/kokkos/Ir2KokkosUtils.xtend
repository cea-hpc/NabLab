package fr.cea.nabla.ir.generator.kokkos

import com.google.inject.Inject
import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.ir.BasicType
import fr.cea.nabla.ir.ir.IteratorRange
import fr.cea.nabla.ir.ir.IteratorRef

class Ir2KokkosUtils 
{
	@Inject extension Utils

	def getKokkosType(BasicType t)
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

	def CharSequence getAccessor(IteratorRange it) 
	'''mesh->get«connectivity.name.toFirstUpper»(«args.map[rangeArgName].join(',')»)'''

	private def dispatch getRangeArgName(IteratorRange it) { accessor }
	private def dispatch getRangeArgName(IteratorRef it) { prefix(iterator.name + 'Id') }
}