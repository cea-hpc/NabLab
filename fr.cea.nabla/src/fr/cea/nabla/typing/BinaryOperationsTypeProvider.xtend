package fr.cea.nabla.typing

import fr.cea.nabla.nabla.Connectivity

class BinaryOperationsTypeProvider 
{
	def dispatch ExpressionType getTypeFor(ExpressionType a, ExpressionType b, String op)
	{
		new UndefinedType
	}	
	
	// BOOL: useful for type validator (unused by type provider)
	def dispatch ExpressionType getTypeFor(BoolType a, BoolType b, String op)
	{
		switch op
		{
			case '||', case '&&', case '==', case '!=', case '>=', case '<=', case '>', case'<': b
			default: new UndefinedType
		}
	}

	// INT
	def dispatch ExpressionType getTypeFor(IntType a, IntType b, String op)
	{
		switch op
		{
			// useful for type validator (unused by type provider)
			case '==', case '!=', case '>=', case '<=', case '>', case'<': new BoolType(#[])
			case '+', case '-', case '*', case ' ', case '%': b
			default: new UndefinedType
		}
	}

	def dispatch ExpressionType getTypeFor(IntType a, RealType b, String op)
	{
		switch op
		{
			// useful for type validator (unused by type provider)
			case '==', case '!=', case '>=', case '<=', case '>', case'<': new BoolType(#[])
			case '+', case '-', case '*', case '/': b
			default: new UndefinedType
		}
	}

	def dispatch ExpressionType getTypeFor(IntType a, ArrayType b, String op)
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
		getTypeFor(a, new RealType(#[]), op)
	}

	def dispatch ExpressionType getTypeFor(RealType a, RealType b, String op)
	{
		switch op
		{
			// useful for type validator (unused by type provider)
			case '==', case '!=', case '>=', case '<=', case '>', case'<': new BoolType(#[])
			case '+', case '-', case '*', case '/', case ':': b
			default: new UndefinedType
		}
	}

	def dispatch ExpressionType getTypeFor(RealType a, ArrayType b, String op)
	{
		switch op
		{
			// Real + RealArray -> RealArray , Real + IntArray -> RealArray
			case '+', case '*': new RealArrayType(b.connectivities, b.sizes)
			default: new UndefinedType
		}
	}
		
	// REAL ARRAYS
	def dispatch ExpressionType getTypeFor(RealArrayType a, IntType b, String op)
	{
		getTypeFor(a, new RealType(#[]), op)
	}

	def dispatch ExpressionType getTypeFor(RealArrayType a, RealType b, String op)
	{
		switch op
		{
			case '', case '+', case '-', case '*', case '/': a
			default: new UndefinedType
		}
	}

	def dispatch ExpressionType getTypeFor(RealArrayType a, ArrayType b, String op)
	{
		switch op
		{
			case !haveSameDimensions(a.sizes, b.sizes) || !haveSameConnectivities(a.connectivities, b.connectivities): new UndefinedType
			case '+', case '-', case '*', case '/': a
			default: new UndefinedType
		}
	}

	// REAL ARRAYS
	def dispatch ExpressionType getTypeFor(IntArrayType a, IntType b, String op)
	{
		switch op
		{
			case '', case '+', case '-', case '*', case '/': a
			default: new UndefinedType
		}
	}

	def dispatch ExpressionType getTypeFor(IntArrayType a, RealType b, String op)
	{
		switch op
		{
			case '', case '+', case '-', case '*', case '/': new RealArrayType(a.connectivities, a.sizes)
			default: new UndefinedType
		}
	}

	def dispatch ExpressionType getTypeFor(IntArrayType a, ArrayType b, String op)
	{
		switch op
		{
			case !haveSameDimensions(a.sizes, b.sizes) || !haveSameConnectivities(a.connectivities, b.connectivities): new UndefinedType
			case '+', case '-', case '*', case '/': b // IntArray + IntArray -> IntArray , IntArray + RealArray -> RealArray
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
	
	private def haveSameConnectivities(Connectivity[] aConnectivities, Connectivity[] bConnectivities)
	{
		if (aConnectivities.size != bConnectivities.size) return false
		
		for (i : 0..<aConnectivities.size)
			if (aConnectivities.get(i) != bConnectivities.get(i)) 
				return false
				
		return true
	}
}