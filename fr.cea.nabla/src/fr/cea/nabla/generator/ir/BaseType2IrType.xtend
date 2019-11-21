package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.nabla.BaseType
import fr.cea.nabla.nabla.Connectivity
import java.util.List
import com.google.inject.Singleton

@Singleton
class BaseType2IrType 
{
	@Inject extension Nabla2IrUtils
	@Inject extension IrConnectivityFactory
	@Inject extension IrDimensionFactory

	// No create method to ensure a new instance every time (for n+1 time variables)
	def toIrBaseType(BaseType t)
	{
		IrFactory::eINSTANCE.createBaseType => 
		[
			primitive = t.primitive.toIrPrimitiveType
			t.sizes.forEach[x | sizes += x.toIrDimension]
		]
	}

	def toIrConnectivityType(BaseType t, List<Connectivity> supports)
	{
		IrFactory::eINSTANCE.createConnectivityType => 
		[
			base = t.toIrBaseType
			supports.forEach[x | connectivities += x.toIrConnectivity]
		]
	}
}