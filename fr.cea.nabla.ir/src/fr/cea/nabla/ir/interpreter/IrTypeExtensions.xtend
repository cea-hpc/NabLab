package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.ir.Array1D
import fr.cea.nabla.ir.ir.Array2D
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.Scalar

class IrTypeExtensions 
{
	static def dispatch getPrimitive(BaseType it) { primitive }
	static def dispatch getPrimitive(ConnectivityType it) { base.primitive }
	
	static def dispatch int[] getSizes(Scalar it) { #[] }
	static def dispatch int[] getSizes(Array1D it) { #[size] }
	static def dispatch int[] getSizes(Array2D it) { #[nbRows, nbCols] }

	static def int[] getSizes(ConnectivityType it, Context context) 
	{ 
		connectivities.map[x | context.connectivitySizes.get(x)] + base.sizes
	}
}