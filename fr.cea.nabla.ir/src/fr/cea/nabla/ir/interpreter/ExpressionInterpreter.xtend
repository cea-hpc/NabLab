package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.Utils
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.BinaryExpression
import fr.cea.nabla.ir.ir.Constant
import fr.cea.nabla.ir.ir.ContractedIf
import fr.cea.nabla.ir.ir.ExpressionType
import fr.cea.nabla.ir.ir.FunctionCall
import fr.cea.nabla.ir.ir.MaxConstant
import fr.cea.nabla.ir.ir.MinConstant
import fr.cea.nabla.ir.ir.Parenthesis
import fr.cea.nabla.ir.ir.PrimitiveType
import fr.cea.nabla.ir.ir.UnaryExpression
import fr.cea.nabla.ir.ir.VarRef

class ExpressionInterpreter 
{
	static def dispatch ExpressionValue interprete(ContractedIf it)
	{
		val condContext = condition.interprete
		if (condContext.asBool) thenExpression.interprete
		else elseExpression.interprete 
	}
	
	static def dispatch ExpressionValue interprete(BinaryExpression it)	
	{
		BinaryOperationsInterpreter::interprete(left.interprete, right.interprete, operator)
	}
	
	static def dispatch ExpressionValue interprete(UnaryExpression it)
	{
		val context = expression.interprete
		switch context
		{
			BoolValue case operator == '!': new BoolValue(!context.value)
			IntValue case operator == '-': new IntValue(-context.value)
			RealValue case operator == '-': new RealValue(-context.value)
			IntArrayValue case operator == '-': new IntArrayValue(context.dimSizes, context.value.map[x|-x])
			RealArrayValue case operator == '-': new RealArrayValue(context.dimSizes, context.value.map[x|-x])
			default: throw new UnsupportedOperationException(operator, #[context])
		}
	}

	static def dispatch ExpressionValue interprete(Parenthesis it)
	{
		expression.interprete
	}

	static def dispatch ExpressionValue interprete(Constant it) 
	{ 
		switch type.root
		{
			case INT: new IntValue(Integer.parseInt(value)) 
			case REAL: new RealValue(Double.parseDouble(value))
			case BOOL: new BoolValue(Boolean.parseBoolean(value))
			default: throw new UnexpectedTypeException(#["Int", "Real", "Bool"], type.root.literal)
		}
	}
	
	static def dispatch ExpressionValue interprete(MinConstant it)
	{
		switch type.root
		{
			case INT: new IntValue(Integer.MIN_VALUE)
			case REAL: new RealValue(Double.MIN_VALUE)
			default: throw new UnexpectedTypeException(#["Int", "Real"], type.root.literal)
		}
	}
	
	static def dispatch ExpressionValue interprete(MaxConstant it)
	{
		switch type.root
		{
			case INT: new IntValue(Integer.MAX_VALUE)
			case REAL: new RealValue(Double.MAX_VALUE)
			default: throw new UnexpectedTypeException(#["Int", "Real"], type.root.literal)
		}
	}

	static def dispatch ExpressionValue interprete(FunctionCall it)
	{
		val providerClassName = function.provider + Utils::FunctionAndReductionproviderSuffix
		val providerClass = Class.forName(providerClassName)
		val types = args.map[x | x.type.javaType]
		val method = providerClass.getMethod(function.name, types)
		val argValues = args.map[x|x.interprete.boxedValue]
		val result = method.invoke(providerClass, argValues)
		return result.expressionValue
	}

	static def dispatch ExpressionValue interprete(VarRef it)
	{
		// TODO
	}
	
	private static def dispatch Class<?> getJavaType(BaseType it)
	{
		switch sizes.size
		{
			case 0: root.javaType
			case 1: typeof(double[])
			case 2: typeof(double[][])
			default: throw new RuntimeException('Invalid type')
		}
	}

	private static def dispatch Class<?> getJavaType(ExpressionType it)
	{
		val fullSizes = sizes.size + connectivities.size
		switch fullSizes
		{
			case 0: root.javaType
			case 1: typeof(double[])
			case 2: typeof(double[][])
			case 3: typeof(double[][][])
			case 4: typeof(double[][][][])
			default: throw new RuntimeException('Invalid type')
		}
	}
	
	private static def dispatch Class<?> getJavaType(PrimitiveType t)
	{
		switch t
		{
			case BOOL: typeof(boolean)
			case INT: typeof(int)
			case REAL: typeof(double)
			default: throw new RuntimeException('Invalid type')
		}
	}
	
	private static def getExpressionValue(Object o)
	{
		switch o
		{
			Boolean: new BoolValue(o as boolean)
			Integer: new IntValue(o as int)
			Double: new RealValue(o as double)
			default: throw new UnexpectedTypeException(#[boolean, int, double], o.class)
		}
	}	
}