package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.nabla.Array1D
import fr.cea.nabla.nabla.Array2D
import fr.cea.nabla.nabla.BaseType
import fr.cea.nabla.nabla.Connectivity
import fr.cea.nabla.nabla.Scalar
import java.util.List

class BaseType2IrType 
{
	@Inject extension Nabla2IrUtils
	@Inject extension IrConnectivityFactory
	
	// No create method to ensure a new instance every time (for n+1 time variables)
	def dispatch toIrBaseType(Scalar i)
	{
		IrFactory::eINSTANCE.createScalar => 
		[
			primitive = i.primitive.toIrPrimitiveType
		]
	}

	def dispatch toIrBaseType(Array1D i)
	{
		IrFactory::eINSTANCE.createArray1D => 
		[
			primitive = i.primitive.toIrPrimitiveType
			size = i.size
		]
	}

	def dispatch toIrBaseType(Array2D i)
	{
		IrFactory::eINSTANCE.createArray2D => 
		[
			primitive = i.primitive.toIrPrimitiveType
			nbRows = i.nbRows
			nbCols = i.nbCols
		]
	}
	
	def toIrConnectivityType(BaseType baseType, List<Connectivity> supports)
	{
		IrFactory::eINSTANCE.createConnectivityType => 
		[
			base = baseType.toIrBaseType
			supports.forEach[x | connectivities += x.toIrConnectivity]		
		]
	}
}