package fr.cea.nabla.typing

class BinaryOperationsTypeProvider 
{
	def dispatch AbstractType getTypeFor(AbstractType a, AbstractType b, String op)
	{
		new UndefinedType
	}	
	
	// BOOL: useful for type validator (unused by type provider)
	def dispatch AbstractType getTypeFor(BoolType a, BoolType b, String op)
	{
		switch op
		{
			case !checkNoConnectivities(a, b) : new UndefinedType
			case '||', case '&&', case '==', case '!=', case '>=', case '<=', case '>', case'<': b
			default: new UndefinedType
		}
	}

	// INT
	def dispatch AbstractType getTypeFor(IntType a, IntType b, String op)
	{
		switch op
		{
			case !checkNoConnectivities(a, b) : new UndefinedType
			// useful for type validator (unused by type provider)
			case '==', case '!=', case '>=', case '<=', case '>', case'<': new BoolType(#[])
			case '+', case '-', case '*', case ' ', case '%': b
			default: new UndefinedType
		}
	}

	def dispatch AbstractType getTypeFor(IntType a, RealType b, String op)
	{
		switch op
		{
			case !checkNoConnectivities(a, b) : new UndefinedType
			// useful for type validator (unused by type provider)
			case '==', case '!=', case '>=', case '<=', case '>', case'<': new BoolType(#[])
			case '+', case '-', case '*', case '/': b
			default: new UndefinedType
		}
	}

	def dispatch AbstractType getTypeFor(IntType a, ArrayType b, String op)
	{
		switch op
		{
			case !checkNoConnectivities(a, b) : new UndefinedType
			case '+', case '*': b
			default: new UndefinedType
		}
	}

	// REAL
	def dispatch AbstractType getTypeFor(RealType a, IntType b, String op)
	{
		getTypeFor(a, new RealType(#[]), op)
	}

	def dispatch AbstractType getTypeFor(RealType a, RealType b, String op)
	{
		switch op
		{
			case !checkNoConnectivities(a, b) : new UndefinedType
			// useful for type validator (unused by type provider)
			case '==', case '!=', case '>=', case '<=', case '>', case'<': new BoolType(#[])
			case '+', case '-', case '*', case '/', case ':': b
			default: new UndefinedType
		}
	}

	def dispatch AbstractType getTypeFor(RealType a, ArrayType b, String op)
	{
		switch op
		{
			case !checkNoConnectivities(a, b) : new UndefinedType
			// Real + RealArray -> RealArray , Real + IntArray -> RealArray
			case '+', case '*': new RealArrayType(b.connectivities, b.sizes)
			default: new UndefinedType
		}
	}
		
	// REAL ARRAYS
	def dispatch AbstractType getTypeFor(RealArrayType a, IntType b, String op)
	{
		getTypeFor(a, new RealType(#[]), op)
	}

	def dispatch AbstractType getTypeFor(RealArrayType a, RealType b, String op)
	{
		switch op
		{
			case !checkNoConnectivities(a, b) : new UndefinedType
			case '', case '+', case '-', case '*', case '/': a
			default: new UndefinedType
		}
	}

	def dispatch AbstractType getTypeFor(RealArrayType a, ArrayType b, String op)
	{
		switch op
		{
			case !haveSameDimensions(a, b) || !checkNoConnectivities(a, b): new UndefinedType
			case '+', case '-', case '*', case '/': a
			default: new UndefinedType
		}
	}

	// REAL ARRAYS
	def dispatch AbstractType getTypeFor(IntArrayType a, IntType b, String op)
	{
		switch op
		{
			case !checkNoConnectivities(a, b) : new UndefinedType
			case '', case '+', case '-', case '*', case '/': a
			default: new UndefinedType
		}
	}

	def dispatch AbstractType getTypeFor(IntArrayType a, RealType b, String op)
	{
		switch op
		{
			case !checkNoConnectivities(a, b) : new UndefinedType
			case '', case '+', case '-', case '*', case '/': new RealArrayType(a.connectivities, a.sizes)
			default: new UndefinedType
		}
	}

	def dispatch AbstractType getTypeFor(IntArrayType a, ArrayType b, String op)
	{
		switch op
		{
			case !haveSameDimensions(a, b) || !checkNoConnectivities(a, b): new UndefinedType
			case '+', case '-', case '*', case '/': b // IntArray + IntArray -> IntArray , IntArray + RealArray -> RealArray
			default: new UndefinedType
		}
	}
	
	private def haveSameDimensions(ArrayType a, ArrayType b)
	{
		if (a.sizes.size != b.sizes.size) return false
		
		for (i : 0..<a.sizes.size)
			if (a.sizes.get(i) != b.sizes.get(i)) 
				return false
				
		return true
	}

	private def checkNoConnectivities(DefinedType a, DefinedType b)
	{
		a.connectivities.empty && b.connectivities.empty
	}	
}