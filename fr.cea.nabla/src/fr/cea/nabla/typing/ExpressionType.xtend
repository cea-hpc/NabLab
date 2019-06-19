package fr.cea.nabla.typing

import fr.cea.nabla.nabla.PrimitiveType
import org.eclipse.xtend.lib.annotations.Data

import static extension fr.cea.nabla.ir.Utils.*

abstract class ExpressionType 
{
	def isUndefined() { this instanceof UndefinedType }
	abstract def String getLabel();
}

@Data
class UndefinedType extends ExpressionType
{
	override getLabel() { 'Undefined' }
}

@Data
class BoolType extends ExpressionType
{
	override getLabel() { PrimitiveType::BOOL.literal }
}

@Data
class IntType extends ExpressionType
{
	override getLabel() { PrimitiveType::INT.literal }
}

@Data
class RealType extends ExpressionType
{
	override getLabel() { PrimitiveType::REAL.literal }
}

@Data
class BoolArrayType extends ExpressionType
{
	override getLabel() { PrimitiveType::BOOL.literal + dimSizes.map[utfExponent].join('\\u02E3') }
	int[] dimSizes
}

@Data
class IntArrayType extends ExpressionType
{
	override getLabel() { PrimitiveType::INT.literal + dimSizes.map[utfExponent].join('\\u02E3') }
	int[] dimSizes
}

@Data
class RealArrayType extends ExpressionType
{
	override getLabel() { PrimitiveType::REAL.literal + dimSizes.map[utfExponent].join('\\u02E3') }
	int[] dimSizes
}
