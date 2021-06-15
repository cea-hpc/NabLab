package fr.cea.nabla.ir.generator.cpp

import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.IrType
import fr.cea.nabla.ir.ir.LinearAlgebraType

class IrTypeExtensions
{
	static def boolean isBaseTypeStatic(IrType it)
	{
		switch it
		{
			BaseType: sizes.empty || sizes.forall[x | x.constExpr]
			ConnectivityType: base.baseTypeStatic
			LinearAlgebraType: sizes.empty || sizes.forall[x | x.constExpr]
			default: throw new RuntimeException("Unhandled parameter")
		}
	}
}