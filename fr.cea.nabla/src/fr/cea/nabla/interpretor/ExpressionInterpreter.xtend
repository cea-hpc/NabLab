package fr.cea.nabla.interpretor

import com.google.inject.Inject
import fr.cea.nabla.nabla.And
import fr.cea.nabla.nabla.Comparison
import fr.cea.nabla.nabla.ContractedIf
import fr.cea.nabla.nabla.Equality
import fr.cea.nabla.nabla.Minus
import fr.cea.nabla.nabla.Modulo
import fr.cea.nabla.nabla.MulOrDiv
import fr.cea.nabla.nabla.Not
import fr.cea.nabla.nabla.Or
import fr.cea.nabla.nabla.Parenthesis
import fr.cea.nabla.nabla.Plus
import fr.cea.nabla.nabla.UnaryMinus
import fr.cea.nabla.nabla.IntConstant
import fr.cea.nabla.nabla.RealConstant
import fr.cea.nabla.nabla.Real2Constant
import fr.cea.nabla.nabla.Real3Constant
import fr.cea.nabla.nabla.Real2x2Constant
import fr.cea.nabla.nabla.Real3x3Constant
import fr.cea.nabla.nabla.BoolConstant
import fr.cea.nabla.javalib.types.Real2
import fr.cea.nabla.javalib.types.Real3
import fr.cea.nabla.javalib.types.Real2x2
import fr.cea.nabla.javalib.types.Real3x3
import fr.cea.nabla.nabla.RealXCompactConstant
import fr.cea.nabla.nabla.BasicType
import fr.cea.nabla.nabla.MinConstant
import fr.cea.nabla.nabla.MaxConstant
import fr.cea.nabla.nabla.FunctionCall

class ExpressionInterpreter 
{
	@Inject extension ExpressionValueOperations
	
	def dispatch ExpressionValue interprete(ContractedIf it)
	{
		val condContext = condition.interprete
		if (condContext.asBool) then.interprete
		else ^else.interprete 
	}
	
	def dispatch ExpressionValue interprete(Or it)
	{
		val leftContext = left.interprete
		val rightContext = right.interprete
		new BoolValue(leftContext.asBool || rightContext.asBool)
	}
	
	def dispatch ExpressionValue interprete(And it)
	{
		val leftContext = left.interprete
		val rightContext = right.interprete
		new BoolValue(leftContext.asBool && rightContext.asBool)
	}

	def dispatch ExpressionValue interprete(Equality it)
	{
		eval(left.interprete, right.interprete, op)
	}

	def dispatch ExpressionValue interprete(Comparison it)
	{
		eval(left.interprete, right.interprete, op)
	}
	
	def dispatch ExpressionValue interprete(Plus it)
	{
		eval(left.interprete, right.interprete, op)
	}

	def dispatch ExpressionValue interprete(Minus it)
	{
		eval(left.interprete, right.interprete, op)
	}

	def dispatch ExpressionValue interprete(MulOrDiv it)
	{
		eval(left.interprete, right.interprete, op)
	}

	def dispatch ExpressionValue interprete(Modulo it)
	{
		val leftContext = left.interprete
		val rightContext = right.interprete
		new IntValue(leftContext.asInt % rightContext.asInt)
	}

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
			Real2Value: new Real2Value(-context.value)
			Real3Value: new Real3Value(-context.value)
			default: throw new UnsupportedOperationException('-', #[context])
		}
	}

	def dispatch ExpressionValue interprete(Not it)
	{
		val context = expression.interprete
		new BoolValue(!context.asBool)
	}
	
	def dispatch ExpressionValue interprete(IntConstant it) 
	{ 
		new IntValue(value)
	}
	
	def dispatch ExpressionValue interprete(RealConstant it) 
	{ 
		new RealValue(value)
	}
	
	def dispatch ExpressionValue interprete(Real2Constant it) 
	{ 
		new Real2Value(new Real2(x,y))
	}
	
	def dispatch ExpressionValue interprete(Real3Constant it) 
	{ 
		new Real3Value(new Real3(x,y,z))
	}
	
	def dispatch ExpressionValue interprete(Real2x2Constant it) 
	{
		val xContext = x.interprete as Real2Value
		val yContext = y.interprete as Real2Value
		new Real2x2Value(new Real2x2(xContext.value, yContext.value))
	}
	
	def dispatch ExpressionValue interprete(Real3x3Constant it) 
	{ 
		val xContext = x.interprete as Real3Value
		val yContext = y.interprete as Real3Value
		val zContext = z.interprete as Real3Value
		new Real3x3Value(new Real3x3(xContext.value, yContext.value, zContext.value))
	}

	def dispatch ExpressionValue interprete(BoolConstant it) 
	{ 
		new BoolValue(value)
	}
	
	def dispatch ExpressionValue interprete(RealXCompactConstant it) 
	{ 
		switch type
		{
			case BOOL: new BoolValue(value != 0.0)
			case INT: new IntValue(value as int)
			case REAL: new RealValue(value)
			case REAL2: new Real2Value(new Real2(value))
			case REAL3: new Real3Value(new Real3(value))
			case REAL2X2: new Real2x2Value(new Real2x2(value))
			case REAL3X3: new Real3x3Value(new Real3x3(value))
		}
	}
	
	def dispatch ExpressionValue interprete(MinConstant it)
	{
		switch type
		{
			case BOOL: throw new UnsupportedOperationException('MinValue', #[BasicType::BOOL])
			case INT: new IntValue(Integer::MIN_VALUE)
			case REAL: new RealValue(Double::MIN_VALUE)
			case REAL2: new Real2Value(new Real2(Double::MIN_VALUE))
			case REAL3: new Real3Value(new Real3(Double::MIN_VALUE))
			case REAL2X2: new Real2x2Value(new Real2x2(Double::MIN_VALUE))
			case REAL3X3: new Real3x3Value(new Real3x3(Double::MIN_VALUE))
		}
	}
	
	def dispatch ExpressionValue interprete(MaxConstant it)
	{
		switch type
		{
			case BOOL: throw new UnsupportedOperationException('MinValue', #[BasicType::BOOL])
			case INT: new IntValue(Integer::MAX_VALUE)
			case REAL: new RealValue(Double::MAX_VALUE)
			case REAL2: new Real2Value(new Real2(Double::MAX_VALUE))
			case REAL3: new Real3Value(new Real3(Double::MAX_VALUE))
			case REAL2X2: new Real2x2Value(new Real2x2(Double::MAX_VALUE))
			case REAL3X3: new Real3x3Value(new Real3x3(Double::MAX_VALUE))
		}
	}
	
	def dispatch ExpressionValue interprete(FunctionCall it)
	{
	}
}