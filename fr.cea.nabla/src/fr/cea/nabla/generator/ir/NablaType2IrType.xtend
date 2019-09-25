package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.IrType
import fr.cea.nabla.typing.NablaType
import fr.cea.nabla.typing.NablaConnectivityType
import fr.cea.nabla.typing.NablaSimpleType
import fr.cea.nabla.typing.NSTScalar
import fr.cea.nabla.typing.NSTArray1D
import fr.cea.nabla.typing.NSTArray2D

class NablaType2IrType 
{
	@Inject extension Nabla2IrUtils
	@Inject extension IrConnectivityFactory

	def IrType toIrType(NablaType t)
	{
		switch t
		{
			case null: null // Undefined type
			NablaSimpleType: t.toIrBaseType
			NablaConnectivityType: t.toIrConnectivityType
		}
	}

	def dispatch BaseType toIrBaseType(NSTScalar t)
	{
		IrFactory.eINSTANCE.createScalar =>
		[
			primitive = t.primitive.toIrPrimitiveType
		]
	}
	
	def dispatch BaseType toIrBaseType(NSTArray1D t)
	{
		IrFactory.eINSTANCE.createArray1D =>
		[
			primitive = t.primitive.toIrPrimitiveType
			size = t.size
		]
	}
	
	def dispatch BaseType toIrBaseType(NSTArray2D t)
	{
		IrFactory.eINSTANCE.createArray2D =>
		[
			primitive = t.primitive.toIrPrimitiveType
			nbRows = t.nbRows
			nbCols = t.nbCols
		]
	}

	private def ConnectivityType toIrConnectivityType(NablaConnectivityType t)
	{
		IrFactory.eINSTANCE.createConnectivityType =>
		[
			base = t.simple.toIrBaseType
			t.supports.forEach[x | connectivities += x.toIrConnectivity]
		]
	}
}