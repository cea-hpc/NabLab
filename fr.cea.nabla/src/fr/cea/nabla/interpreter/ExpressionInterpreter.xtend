package fr.cea.nabla.interpreter

import com.google.inject.Inject
import fr.cea.nabla.DeclarationProvider
import fr.cea.nabla.Utils
import fr.cea.nabla.nabla.And
import fr.cea.nabla.nabla.BaseTypeConstant
import fr.cea.nabla.nabla.BoolConstant
import fr.cea.nabla.nabla.Comparison
import fr.cea.nabla.nabla.ContractedIf
import fr.cea.nabla.nabla.Equality
import fr.cea.nabla.nabla.Expression
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.IntConstant
import fr.cea.nabla.nabla.MaxConstant
import fr.cea.nabla.nabla.MinConstant
import fr.cea.nabla.nabla.Minus
import fr.cea.nabla.nabla.Modulo
import fr.cea.nabla.nabla.MulOrDiv
import fr.cea.nabla.nabla.Not
import fr.cea.nabla.nabla.Or
import fr.cea.nabla.nabla.Parenthesis
import fr.cea.nabla.nabla.Plus
import fr.cea.nabla.nabla.PrimitiveType
import fr.cea.nabla.nabla.RealConstant
import fr.cea.nabla.nabla.RealMatrixConstant
import fr.cea.nabla.nabla.RealVectorConstant
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.UnaryMinus
import fr.cea.nabla.nabla.VarRef
import fr.cea.nabla.typing.DefinedType
import fr.cea.nabla.typing.ExpressionType
import fr.cea.nabla.typing.RealArrayType
import fr.cea.nabla.typing.UndefinedType
import java.util.Arrays
import fr.cea.nabla.typing.IntArrayType

class ExpressionInterpreter 
{
	@Inject extension BinaryOperationsInterpreter
	@Inject extension DeclarationProvider
	
	def dispatch ExpressionValue interprete(ContractedIf it)
	{
		val condContext = condition.interprete
		if (condContext.asBool) then.interprete
		else ^else.interprete 
	}
	
	def dispatch ExpressionValue interprete(Or it) { eval(left, right ,op) }	
	def dispatch ExpressionValue interprete(And it) { eval(left, right ,op) }
	def dispatch ExpressionValue interprete(Equality it) { eval(left, right ,op) }
	def dispatch ExpressionValue interprete(Comparison it) { eval(left, right ,op) }
	def dispatch ExpressionValue interprete(Plus it) { eval(left, right ,op) }
	def dispatch ExpressionValue interprete(Minus it) { eval(left, right ,op) }
	def dispatch ExpressionValue interprete(MulOrDiv it)  { eval(left, right ,op) }
	def dispatch ExpressionValue interprete(Modulo it)  { eval(left, right ,op) }
	private def eval(Expression a, Expression b, String op) { interprete(a.interprete, b.interprete, op) }

	def dispatch ExpressionValue interprete(Parenthesis it)
	{
		expression.interprete
	}

	def dispatch ExpressionValue interprete(UnaryMinus it)
	{
		val context = expression.interprete
		switch context
		{
			IntValue: new IntValue(-context.value)
			RealValue: new RealValue(-context.value)
			IntArrayValue: new IntArrayValue(context.dimSizes, context.value.map[x|-x])
			RealArrayValue: new RealArrayValue(context.dimSizes, context.value.map[x|-x])
			default: throw new UnsupportedOperationException('-', #[context])
		}
	}

	def dispatch ExpressionValue interprete(Not it)
	{
		val context = expression.interprete
		new BoolValue(!context.asBool)
	}
	
	def dispatch ExpressionValue interprete(IntConstant it) { new IntValue(value) }
	def dispatch ExpressionValue interprete(RealConstant it) { new RealValue(value) }
	def dispatch ExpressionValue interprete(BoolConstant it)  { new BoolValue(value) }
	def dispatch ExpressionValue interprete(MinConstant it)
	{
		switch type
		{
			case BOOL: throw new UnsupportedOperationException('MinValue', #[PrimitiveType::BOOL])
			case INT: new IntValue(Integer::MIN_VALUE)
			case REAL: new RealValue(Double::MIN_VALUE)
		}
	}
	
	def dispatch ExpressionValue interprete(MaxConstant it)
	{
		switch type
		{
			case BOOL: throw new UnsupportedOperationException('MinValue', #[PrimitiveType::BOOL])
			case INT: new IntValue(Integer::MAX_VALUE)
			case REAL: new RealValue(Double::MAX_VALUE)
		}
	}
	
	def dispatch ExpressionValue interprete(RealVectorConstant it) 
	{
		new RealArrayValue(#[values.size], values)
	}
	
	def dispatch ExpressionValue interprete(RealMatrixConstant it) 
	{
		// TODO
	}
	
	def dispatch ExpressionValue interprete(BaseTypeConstant it) 
	{ 
		val initValue = value.interprete as RealValue
		if (type.sizes.empty)
			initValue
		else
		{
			var totalSize = 1
			for (s : type.sizes) totalSize *= s
			val values = newDoubleArrayOfSize(totalSize)
			Arrays::fill(values, initValue.value)
			new RealArrayValue(type.sizes, values)
		}
	}
	

	// PB: remplacement des utf8
	def dispatch ExpressionValue interprete(FunctionCall it)
	{
		val providerClassName = Utils::getNablaModule(function).name + fr.cea.nabla.ir.Utils::FunctionAndReductionproviderSuffix
		val providerClass = Class.forName(providerClassName)
		val types = declaration.inTypes.map[x|x.javaType]
		val method = providerClass.getMethod(function.name, types)
		val argValues = args.map[x|x.interprete.boxedValue]
		val result = method.invoke(providerClass, argValues)
		return result.expressionValue
	}

	def dispatch ExpressionValue interprete(ReductionCall it)
	{
//		val providerClassName = Utils::getNablaModule(reduction).name + fr.cea.nabla.ir.Utils::FunctionAndReductionproviderSuffix
//		val providerClass = Class.forName(providerClassName)
//		val d = declaration
//		val type = d.collectionType.javaType
//		val method = providerClass.getMethod(reduction.name, type)
//		var reductionValue = d.model.seed.interprete
		// comment gérer les itérateurs ?
		// PB : remplacement des UTF8
		return null
	}

	def dispatch ExpressionValue interprete(VarRef it)
	{
		// TODO
	}
	
//	private def getJavaType(BaseType t)
//	{
//		switch t.sizes
//		{
//			case 0: t.root.javaType
//			case 1: typeof(double[])
//			case 2: typeof(double[][])
//			default: throw new RuntimeException('Invalid type')
//		}
//	}

	private def getJavaType(ExpressionType t)
	{
		switch t
		{
			UndefinedType: throw new RuntimeException('Invalid type')
			RealArrayType case t.sizes==1: typeof(double[])
			RealArrayType case t.sizes==2: typeof(double[][])
			IntArrayType case t.sizes==1: typeof(int[])
			IntArrayType case t.sizes==2: typeof(int[][])
			DefinedType: t.root.javaType
		}
	}
	
	private def getJavaType(PrimitiveType t)
	{
		switch t
		{
			case BOOL: typeof(boolean)
			case INT: typeof(int)
			case REAL: typeof(double)
		}
	}
	
	private def getExpressionValue(Object o)
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