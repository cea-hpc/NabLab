package fr.cea.nabla.ir

import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.IrType
import fr.cea.nabla.ir.ir.SizeTypeInt
import fr.cea.nabla.ir.ir.SizeTypeOperation
import fr.cea.nabla.ir.ir.SizeTypeSymbolRef

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
		else if (sizes.exists[x | !(x instanceof SizeTypeInt)])
			primitive.literal + '[' + sizes.map[x | x.sizeTypeLabel].join(',') + ']'
		else
			primitive.literal + sizes.map[x | (x as SizeTypeInt).value.utfExponent].join('\u02E3')
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

	private static def dispatch String getSizeTypeLabel(SizeTypeOperation it) { left?.sizeTypeLabel + ' ' + operator + ' ' + right?.sizeTypeLabel }
	private static def dispatch String getSizeTypeLabel(SizeTypeInt it) { value.toString }
	private static def dispatch String getSizeTypeLabel(SizeTypeSymbolRef it) { target?.name }
}