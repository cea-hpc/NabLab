package fr.cea.nabla.typing

import fr.cea.nabla.nabla.Connectivity
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
abstract class DefinedType extends ExpressionType
{
	Connectivity[] connectivities
	abstract def PrimitiveType getRoot();
}

@Data
class BoolType extends DefinedType
{
	override getRoot() { PrimitiveType::BOOL }
	override getLabel() { root.literal }	
}

@Data
class IntType extends DefinedType
{
	override getRoot() { PrimitiveType::INT }
	override getLabel() { root.literal }
}

@Data
class RealType extends DefinedType
{
	override getRoot() { PrimitiveType::REAL }
	override getLabel() { root.literal }
}

@Data
class RealArrayType extends DefinedType
{
	override getRoot() { PrimitiveType::REAL }
	override getLabel() 
	{ 
		val l = PrimitiveType::REAL.literal + sizes.map[utfExponent].join('\u02E3')
		if (connectivities.empty) l
		else l + '{' + connectivities.map[name].join(',') + '}'
	}
	
	int[] sizes
}
