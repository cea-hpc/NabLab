package fr.cea.nabla.ir

import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.DimensionInt
import fr.cea.nabla.ir.ir.DimensionOperation
import fr.cea.nabla.ir.ir.DimensionSymbolRef
import fr.cea.nabla.ir.ir.IrType

import static extension fr.cea.nabla.ir.Utils.*

class IrTypeExtensions
{
	static def dispatch String getLabel(ConnectivityType it)
	{
		if (it === null) null
		else base.label + '{' + connectivities.map[name].join(',') + '}'
	}

	static def dispatch String getLabel(BaseType it)
	{
		if (it === null)
			'Undefined'
		else if (sizes.empty) 
			primitive.literal
		else if (sizes.exists[x | !(x instanceof DimensionInt)])
			primitive.literal + '[' + sizes.map[x | x.dimensionLabel].join(',') + ']'
		else
			primitive.literal + sizes.map[x | (x as DimensionInt).value.utfExponent].join('\u02E3')
	}

	static def isScalar(IrType t)
	{
		(t instanceof BaseType) && (t as BaseType).sizes.empty
	}

	static def getPrimitive(IrType t)
	{
		switch t
		{
			ConnectivityType: t.base.primitive
			BaseType: t.primitive
		}
	}

	private static def dispatch String getDimensionLabel(DimensionOperation it) { left?.dimensionLabel + ' ' + operator + ' ' + right?.dimensionLabel }
	private static def dispatch String getDimensionLabel(DimensionInt it) { value.toString }
	private static def dispatch String getDimensionLabel(DimensionSymbolRef it) { target?.name }
}