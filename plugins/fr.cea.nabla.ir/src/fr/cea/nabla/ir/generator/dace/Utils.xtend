package fr.cea.nabla.ir.generator.dace

import fr.cea.nabla.ir.ir.ArgOrVarRef
import fr.cea.nabla.ir.ir.BinaryExpression
import fr.cea.nabla.ir.ir.BoolConstant
import fr.cea.nabla.ir.ir.Expression
import fr.cea.nabla.ir.ir.IntConstant
import fr.cea.nabla.ir.ir.PrimitiveType
import fr.cea.nabla.ir.ir.RealConstant

class Utils
{
	static def getDaceType(PrimitiveType t)
	{
		switch t
		{
			case BOOL: "dp.bool"
			case INT: "dp.int64"
			case REAL: "dp.float64"
		}
	}
}