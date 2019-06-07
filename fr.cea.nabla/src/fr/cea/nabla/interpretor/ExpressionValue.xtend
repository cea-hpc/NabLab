package fr.cea.nabla.interpretor

import fr.cea.nabla.nabla.BasicType
import java.lang.reflect.Type
import org.eclipse.xtend.lib.annotations.Data
import java.util.List
import fr.cea.nabla.javalib.types.Real2
import fr.cea.nabla.javalib.types.Real2x2
import fr.cea.nabla.javalib.types.Real3
import fr.cea.nabla.javalib.types.Real3x3

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
}

abstract class ExpressionValue 
{
	abstract def String getTypeName()

	def boolean asBool()
	{
		if (this instanceof BoolValue) (this as BoolValue).value
		else throw new UnexpectedTypeException(BoolValue, this.class)
	}

	def int asInt()
	{
		if (this instanceof IntValue) (this as IntValue).value
		else throw new UnexpectedTypeException(IntValue, this.class)
	}
}

@Data
class BoolValue extends ExpressionValue
{
	override getTypeName() { BasicType::BOOL.literal }
	val boolean value
}

@Data
class IntValue extends ExpressionValue
{
	override getTypeName() { BasicType::INT.literal }
	val int value
}

@Data
class RealValue extends ExpressionValue
{
	override getTypeName() { BasicType::REAL.literal }
	val double value
}

@Data
class Real2Value extends ExpressionValue
{
	override getTypeName() { BasicType::REAL2.literal }
	val Real2 value
}

@Data
class Real3Value extends ExpressionValue
{
	override getTypeName() { BasicType::REAL3.literal }
	val Real3 value
}

@Data
class Real2x2Value extends ExpressionValue
{
	override getTypeName() { BasicType::REAL2X2.literal }
	val Real2x2 value
}

@Data
class Real3x3Value extends ExpressionValue
{
	override getTypeName() { BasicType::REAL3X3.literal }
	val Real3x3 value
}
