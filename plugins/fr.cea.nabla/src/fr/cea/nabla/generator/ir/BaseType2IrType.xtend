package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import com.google.inject.Singleton
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.nabla.BaseType
import fr.cea.nabla.nabla.Connectivity
import java.util.List

@Singleton
class BaseType2IrType 
{
	@Inject extension Nabla2IrUtils
	@Inject extension IrConnectivityFactory
	@Inject extension IrSizeTypeFactory

	// No create method to ensure a new instance every time (for n+1 time variables)
	def toIrBaseType(BaseType t)
	{
		IrFactory::eINSTANCE.createBaseType => 
		[
			primitive = t.primitive.toIrPrimitiveType
			t.sizes.forEach[x | sizes += x.toIrSizeType]
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