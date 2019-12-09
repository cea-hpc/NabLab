package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.ConnectivityType

import static fr.cea.nabla.ir.interpreter.DimensionInterpreter.*

class IrTypeExtensions 
{
	static def dispatch getPrimitive(BaseType it) { primitive }
	static def dispatch getPrimitive(ConnectivityType it) { base.primitive }

	static def dispatch int[] getIntSizes(BaseType it, Context context)
	{
		sizes.map[x | interprete(x, context)]
	}

	static def dispatch int[] getIntSizes(ConnectivityType it, Context context) 
	{ 
		//context.showConnectivitySizes("Connectivities size")
		connectivities.map[x | context.connectivitySizes.get(x)] + getIntSizes(base, context)
	}
}