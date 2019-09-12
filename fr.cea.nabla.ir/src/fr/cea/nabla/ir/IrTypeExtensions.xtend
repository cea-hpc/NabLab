package fr.cea.nabla.ir

import fr.cea.nabla.ir.ir.Array1D
import fr.cea.nabla.ir.ir.Array2D
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.Scalar

import static extension fr.cea.nabla.ir.Utils.*

class IrTypeExtensions 
{
	static def dispatch areEquals(BaseType a, BaseType b) { false }
	static def dispatch areEquals(Scalar a, Scalar b) { a.primitive == b.primitive }	
	static def dispatch areEquals(Array1D a, Array1D b) { a.primitive == b.primitive && a.size == b.size }
	static def dispatch areEquals(Array2D a, Array2D b) { a.primitive == b.primitive && a.nbRows == b.nbRows && a.nbCols == b.nbCols }
	
	static def dispatch String getLabel(ConnectivityType it)
	{
		if (it === null) null
		else base.label + '{' + connectivities.map[name].join(',') + '}'
	}
	
	static def dispatch String getLabel(BaseType it)
	{
		switch it
		{
			case null: 'Undefined'
			Scalar: primitive.literal
			Array1D: primitive.literal + size.utfExponent
			Array2D: primitive.literal + nbRows.utfExponent + '\\u02E3' + nbCols.utfExponent
		}
	}
}