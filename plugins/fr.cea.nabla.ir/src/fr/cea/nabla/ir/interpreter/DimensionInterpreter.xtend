package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.ir.SizeTypeInt
import fr.cea.nabla.ir.ir.SizeTypeOperation
import fr.cea.nabla.ir.ir.SizeTypeSymbolRef

class DimensionInterpreter 
{
	static def dispatch int interprete(SizeTypeInt it, Context context)
	{
		value
	}

	static def dispatch int interprete(SizeTypeSymbolRef it, Context context)
	{
		context.getDimensionValue(target)
	}

	static def dispatch int interprete(SizeTypeOperation it, Context context)
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