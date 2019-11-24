package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.ir.DimensionInt
import fr.cea.nabla.ir.ir.DimensionOperation
import fr.cea.nabla.ir.ir.DimensionSymbolRef

class DimensionInterpreter 
{
	static def dispatch int interprete(DimensionInt it, Context context)
	{
		value
	}

	static def dispatch int interprete(DimensionSymbolRef it, Context context)
	{
		context.getDimensionValue(target)
	}

	static def dispatch int interprete(DimensionOperation it, Context context)
	{
		val leftValue = interprete(left, context)
		val rightValue = interprete(right, context)
		switch operator
		{
			case '+': leftValue + rightValue
			case '*': leftValue * rightValue
			default: throw new RuntimeException('Operator not implemented: ' + operator)
		}
	}
}