package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.IrType
import fr.cea.nabla.typing.NTArray1D
import fr.cea.nabla.typing.NTArray2D
import fr.cea.nabla.typing.NTConnectivityType
import fr.cea.nabla.typing.NTScalar
import fr.cea.nabla.typing.NTSimpleType
import fr.cea.nabla.typing.NablaType

class IrTypeFactory 
{
	@Inject extension Nabla2IrUtils
	@Inject extension IrConnectivityFactory

	def IrType toIrType(NablaType t)
	{
		switch t
		{
			case null: null // Undefined type
			NTSimpleType: t.toIrBaseType
			NTConnectivityType: t.toIrConnectivityType
		}
	}

	def dispatch BaseType toIrBaseType(NTScalar t)
	{
		IrFactory.eINSTANCE.createScalar =>
		[
			primitive = t.primitive.toIrPrimitiveType
		]
	}
	
	def dispatch BaseType toIrBaseType(NTArray1D t)
	{
		IrFactory.eINSTANCE.createArray1D =>
		[
			primitive = t.primitive.toIrPrimitiveType
			size = t.size
		]
	}
	
	def dispatch BaseType toIrBaseType(NTArray2D t)
	{
		IrFactory.eINSTANCE.createArray2D =>
		[
			primitive = t.primitive.toIrPrimitiveType
			nbRows = t.nbRows
			nbCols = t.nbCols
		]
	}

	private def ConnectivityType toIrConnectivityType(NTConnectivityType t)
	{
		IrFactory.eINSTANCE.createConnectivityType =>
		[
			base = t.simple.toIrBaseType
			t.supports.forEach[x | connectivities += x.toIrConnectivity]
		]
	}
}