package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import fr.cea.nabla.ir.ir.ConnectivityCall
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.nabla.Connectivity
import fr.cea.nabla.nabla.ItemRef
import java.util.List

import static extension fr.cea.nabla.ConnectivityCallExtensions.*

class IrConnectivityCallFactory
{
	@Inject extension IrAnnotationHelper
	@Inject extension IrConnectivityFactory
	@Inject extension IrItemIdFactory

	// No create method: always an instance creation, always in containment true
	def ConnectivityCall toIrConnectivityCall(fr.cea.nabla.nabla.ConnectivityCall cc)
	{
		toIrConnectivityCall(cc.connectivity, cc.args)
	}

	def ConnectivityCall toIrConnectivityCall(Connectivity c, List<ItemRef> largs)
	{
		IrFactory::eINSTANCE.createConnectivityCall =>
		[
			annotations += c.toIrAnnotation
			connectivity = c.toIrConnectivity
			largs.forEach[x | args += x.toIrId]
		]
	}
}