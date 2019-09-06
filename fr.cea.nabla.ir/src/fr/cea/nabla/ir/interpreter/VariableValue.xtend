package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.ir.PrimitiveType
import java.lang.reflect.Type
import java.util.List
import org.eclipse.xtend.lib.annotations.Data

import static extension fr.cea.nabla.ir.Utils.*

class UnexpectedValueException extends RuntimeException
{
	new(Type expected, Type actual)
	{
		super('Unexpected type: expected ' + expected.typeName + ' but was ' + actual.typeName)
	}

	new(List<Type> expecteds, Type actual)
	{
		super('Unexpected value type: expected ' + expecteds.map[typeName].join(', ') + ' but was ' + actual.typeName)
	}

	new(List<String> expecteds, String actual)
	{
		super('Unexpected value type: expected ' + expecteds.join(', ') + ' but was ' + actual)
	}
}

@Data
abstract class VariableValue 
{
	val int[] sizes	

	abstract def PrimitiveType getRootType()	
	def getLabel() { rootType.literal + sizes.map[utfExponent].join('\\u02E3') }
}

@Data
class BoolVariableValue extends VariableValue
{
	boolean[] data
	override getRootType() { PrimitiveType::BOOL }
}

@Data
class IntVariableValue extends VariableValue
{
	int[] data
	override getRootType() { PrimitiveType::INT }
}

@Data
class RealVariableValue extends VariableValue
{
	double[] data
	override getRootType() { PrimitiveType::REAL }
}
