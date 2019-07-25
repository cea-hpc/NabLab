package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.ir.PrimitiveType
import java.lang.reflect.Type
import java.util.List
import org.eclipse.xtend.lib.annotations.Data

import static extension fr.cea.nabla.ir.Utils.*

class UnexpectedTypeException extends RuntimeException
{
	new(Type expected, Type actual)
	{
		super('Unexpected type: expected ' + expected.typeName + ' but was ' + actual.typeName)
	}

	new(List<Type> expecteds, Type actual)
	{
		super('Unexpected type: expected ' + expecteds.map[typeName].join(', ') + ' but was ' + actual.typeName)
	}

	new(List<String> expecteds, String actual)
	{
		super('Unexpected type: expected ' + expecteds.join(', ') + ' but was ' + actual)
	}
}

abstract class ExpressionValue 
{
	abstract def String getLabel()
	abstract def Object getBoxedValue()

	def boolean asBool()
	{
		if (this instanceof BoolValue) (this as BoolValue).value
		else throw new UnexpectedTypeException(BoolValue, this.class)
	}
}

@Data
class BoolValue extends ExpressionValue
{
	override getLabel() { PrimitiveType::BOOL.literal }
	override getBoxedValue() { value }
	boolean value
}

@Data
class IntValue extends ExpressionValue
{
	override getLabel() { PrimitiveType::INT.literal }
	override getBoxedValue() { value }
	int value
}

@Data
class RealValue extends ExpressionValue
{
	override getLabel() { PrimitiveType::REAL.literal }
	override getBoxedValue() { value }
	double value
}

@Data
class BoolArrayValue extends ExpressionValue
{
	override getLabel() { PrimitiveType::BOOL.literal + dimSizes.map[utfExponent].join('\\u02E3') }
	override getBoxedValue() { value }
	int[] dimSizes
	boolean[] value
}

@Data
class IntArrayValue extends ExpressionValue
{
	override getLabel() { PrimitiveType::INT.literal + dimSizes.map[utfExponent].join('\\u02E3') }
	override getBoxedValue() { value }
	int[] dimSizes
	int[] value
}

@Data
class RealArrayValue extends ExpressionValue
{
	override getLabel() { PrimitiveType::REAL.literal + dimSizes.map[utfExponent].join('\\u02E3') }
	override getBoxedValue() { value }
	int[] dimSizes
	double[] value
}
