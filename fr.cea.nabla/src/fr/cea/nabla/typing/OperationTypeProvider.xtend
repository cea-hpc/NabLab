package fr.cea.nabla.typing

import com.google.inject.Inject
import fr.cea.nabla.nabla.BasicType
import java.util.HashMap

class OperationTypeProvider 
{
	@Inject extension BasicTypeProvider
	val expectedTypes = new HashMap<String, BasicType>

	new()
	{
		// INT
		addTypeFor(#['==', '!=', '>=', '<=', '>', '<'], BasicType::INT, BasicType::INT, BasicType::BOOL)
		addTypeFor(#['+', '-', '*', '/'], BasicType::INT, BasicType::INT, BasicType::INT)
		addTypeFor(#['+', '-', '*', '/'], BasicType::INT, BasicType::REAL, BasicType::REAL)
		addTypeFor(#['+', '*'], BasicType::INT, BasicType::REAL2, BasicType::REAL2)
		addTypeFor(#['+', '*'], BasicType::INT, BasicType::REAL3, BasicType::REAL3)
		addTypeFor(#['*'], BasicType::INT, BasicType::REAL2X2, BasicType::REAL2X2)
		addTypeFor(#['*'], BasicType::INT, BasicType::REAL3X3, BasicType::REAL3X3)

		// REAL
		addTypeFor(#['==', '!=', '>=', '<=', '>', '<'], BasicType::REAL, BasicType::REAL, BasicType::BOOL)
		addTypeFor(#['+', '-', '*', '/'], BasicType::REAL, BasicType::INT, BasicType::REAL)
		addTypeFor(#['+', '-', '*', '/'], BasicType::REAL, BasicType::REAL, BasicType::REAL)
		addTypeFor(#['+', '*'], BasicType::REAL, BasicType::REAL2, BasicType::REAL2)
		addTypeFor(#['+', '*'], BasicType::REAL, BasicType::REAL3, BasicType::REAL3)
		addTypeFor(#['*'], BasicType::REAL, BasicType::REAL2X2, BasicType::REAL2X2)
		addTypeFor(#['*'], BasicType::REAL, BasicType::REAL3X3, BasicType::REAL3X3)

		// REAL2
		addTypeFor(#['+', '-', '*', '/'], BasicType::REAL2, BasicType::INT, BasicType::REAL2)
		addTypeFor(#['+', '-', '*', '/'], BasicType::REAL2, BasicType::REAL, BasicType::REAL2)
		addTypeFor(#['+', '-', '*', '/'], BasicType::REAL2, BasicType::REAL2, BasicType::REAL2)

		// REAL3
		addTypeFor(#['+', '-', '*', '/'], BasicType::REAL3, BasicType::INT, BasicType::REAL3)
		addTypeFor(#['+', '-', '*', '/'], BasicType::REAL3, BasicType::REAL, BasicType::REAL3)
		addTypeFor(#['+', '-', '*', '/'], BasicType::REAL3, BasicType::REAL3, BasicType::REAL3)

		// REAL2x2
		addTypeFor(#['*', '/'], BasicType::REAL2X2, BasicType::INT, BasicType::REAL2X2)
		addTypeFor(#['*', '/'], BasicType::REAL2X2, BasicType::REAL, BasicType::REAL2X2)
		addTypeFor(#['+', '-', '*'], BasicType::REAL2X2, BasicType::REAL2X2, BasicType::REAL2X2)

		// REAL3x3
		addTypeFor(#['*', '/'], BasicType::REAL3X3, BasicType::INT, BasicType::REAL2X2)
		addTypeFor(#['*', '/'], BasicType::REAL3X3, BasicType::REAL, BasicType::REAL2X2)
		addTypeFor(#['+', '-', '*'], BasicType::REAL3X3, BasicType::REAL3X3, BasicType::REAL3X3)
	}

	def NablaType getTypeFor(String operator, NablaType unaryOpInType) 
	{ 
		getTypeFor(getKey(operator, unaryOpInType.base))
	}
		
	def NablaType getTypeFor(String operator, NablaType binaryOpLeftType, NablaType binaryOpRightType) 
	{ 
		getTypeFor(getKey(operator, binaryOpLeftType.base, binaryOpRightType.base))
	}
		
	private def void addTypeFor(String[] operators, BasicType binaryOpLeftType, BasicType binaryOpRightType, BasicType resultType) 
	{ 
		for (operator : operators)
		{
			val key = getKey(operator, binaryOpLeftType, binaryOpRightType)
			expectedTypes.put(key, resultType)	
		}
	}

	private def getKey(String operator, BasicType unaryOpInType) 
	{ 
		return operator + unaryOpInType.getName()
	}
	
	private def getKey(String operator, BasicType binaryOpLeftType, BasicType binaryOpRightType) 
	{ 
		binaryOpLeftType.getName() + operator + binaryOpRightType.getName()
	}
	
	private def getTypeFor(String key)
	{
		val expectedType = expectedTypes.get(key)
		if (expectedType === null) NablaType::UNDEFINED
		else expectedType.typeFor
	}
}