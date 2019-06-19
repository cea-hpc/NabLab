package fr.cea.nabla.typing

class BinaryOperationsTypeProvider 
{
	def dispatch ExpressionType getTypeFor(ExpressionType a, ExpressionType b, String op)
	{
		new UndefinedType
	}	
	
	// INT
	def dispatch ExpressionType getTypeFor(IntType a, IntType b, String op)
	{
		switch op
		{
			case '+', case '-', case '*', case ' ', case '%': b
			default: new UndefinedType
		}
	}

	def dispatch ExpressionType getTypeFor(IntType a, RealType b, String op)
	{
		switch op
		{
			case '+', case '-', case '*', case '/': b
			default: new UndefinedType
		}
	}

	def dispatch ExpressionType getTypeFor(IntType a, IntArrayType b, String op)
	{
		switch op
		{
			case '+', case '*': b
			default: new UndefinedType
		}
	}

	def dispatch ExpressionType getTypeFor(IntType a, RealArrayType b, String op)
	{
		switch op
		{
			case '+', case '*': b
			default: new UndefinedType
		}
	}

	// REAL
	def dispatch ExpressionType getTypeFor(RealType a, IntType b, String op)
	{
		getTypeFor(a, new RealType, op)
	}

	def dispatch ExpressionType getTypeFor(RealType a, RealType b, String op)
	{
		switch op
		{
			case '+', case '-', case '*', case '/': b
			default: new UndefinedType
		}
	}

	def dispatch ExpressionType getTypeFor(RealType a, RealArrayType b, String op)
	{
		switch op
		{
			case '+', case '*': b
			default: new UndefinedType
		}
	}

	// INT ARRAY
	def dispatch ExpressionType getTypeFor(IntArrayType a, IntType b, String op)
	{
		switch op
		{
			case '+', case '-', case '*', case '/': a
			default: new UndefinedType
		}
	}

	def dispatch ExpressionType getTypeFor(IntArrayType a, RealType b, String op)
	{
		switch op
		{
			case '+', case '-', case '*', case '/': new RealArrayType(a.dimSizes)
			default: new UndefinedType
		}
	}

	def dispatch ExpressionType getTypeFor(IntArrayType a, IntArrayType b, String op)
	{
		switch op
		{
			case !haveSameDimensions(a.dimSizes, b.dimSizes): new UndefinedType
			case '+', case '-', case '*', case '/': b 
			default: new UndefinedType
		}
	}
	
	// REAL ARRAY
	def dispatch ExpressionType getTypeFor(RealArrayType a, IntType b, String op)
	{
		getTypeFor(a, new RealType, op)
	}

	def dispatch ExpressionType getTypeFor(RealArrayType a, RealType b, String op)
	{
		switch op
		{
			case '+', case '-', case '*', case '/': a
			default: new UndefinedType
		}
	}

	def dispatch ExpressionType getTypeFor(RealArrayType a, RealArrayType b, String op)
	{
		switch op
		{
			case !haveSameDimensions(a.dimSizes, b.dimSizes): new UndefinedType
			case '+', case '-', case '*', case '/': b
			default: new UndefinedType
		}
	}
	
	private def haveSameDimensions(int[] aDimSizes, int[] bDimSizes)
	{
		if (aDimSizes.size != bDimSizes.size) return false
		
		for (i : 0..<aDimSizes.size)
			if (aDimSizes.get(i) != bDimSizes.get(i)) 
				return false
				
		return true
	}
}