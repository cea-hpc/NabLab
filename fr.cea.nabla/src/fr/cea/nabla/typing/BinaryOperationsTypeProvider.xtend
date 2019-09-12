package fr.cea.nabla.typing

class BinaryOperationsTypeProvider 
{
	def dispatch NTSimpleType getTypeFor(NTSimpleType a, NTSimpleType b, String op)
	{
		null
	}	
	
	// BOOL: useful for type validator (unused by type provider)
	def dispatch NTSimpleType getTypeFor(NTBoolScalar a, NTBoolScalar b, String op)
	{
		switch op
		{
			case '||', case '&&', case '==', case '!=', case '>=', case '<=', case '>', case'<': b
			default: null
		}
	}

	// INT
	def dispatch NTSimpleType getTypeFor(NTIntScalar a, NTIntScalar b, String op)
	{
		switch op
		{
			// useful for type validator (unused by type provider)
			case '==', case '!=', case '>=', case '<=', case '>', case'<': new NTBoolScalar
			case '+', case '-', case '*', case ' ', case '%': b
			default: null
		}
	}

	def dispatch NTSimpleType getTypeFor(NTIntScalar a, NTRealScalar b, String op)
	{
		switch op
		{
			// useful for type validator (unused by type provider)
			case '==', case '!=', case '>=', case '<=', case '>', case'<': new NTBoolScalar
			case '+', case '-', case '*', case '/': b
			default: null
		}
	}

	def dispatch NTSimpleType getTypeFor(NTIntScalar a, NTArray1D b, String op)
	{
		switch op
		{
			case '+', case '*': b
			default: null
		}
	}
	
	def dispatch NTSimpleType getTypeFor(NTIntScalar a, NTArray2D b, String op)
	{
		switch op
		{
			case '+', case '*': b
			default: null
		}
	}

	// REAL
	def dispatch NTSimpleType getTypeFor(NTRealScalar a, NTIntScalar b, String op)
	{
		getTypeFor(a, new NTRealScalar, op)
	}

	def dispatch NTSimpleType getTypeFor(NTRealScalar a, NTRealScalar b, String op)
	{
		switch op
		{
			// useful for type validator (unused by type provider)
			case '==', case '!=', case '>=', case '<=', case '>', case'<': new NTBoolScalar
			case '+', case '-', case '*', case '/', case ':': b
			default: null
		}
	}

	def dispatch NTSimpleType getTypeFor(NTRealScalar a, NTArray1D b, String op)
	{
		switch op
		{
			// RealScalar + RealArray1D -> RealArray1D , RealScalar + IntArray1D -> RealArray1D
			case '+', case '*': new NTRealArray1D(b.size)
			default: null
		}
	}

	def dispatch NTSimpleType getTypeFor(NTRealScalar a, NTArray2D b, String op)
	{
		switch op
		{
			// RealScalar + RealArray2D -> RealArray2D , RealScalar + IntArray2D -> RealArray2D
			case '+', case '*': new NTRealArray2D(b.nbRows, b.nbCols)
			default: null
		}
	}

	// INT ARRAYS 1D
	def dispatch NTSimpleType getTypeFor(NTIntArray1D a, NTIntScalar b, String op)
	{
		switch op
		{
			case '+', case '-', case '*', case '/': a
			default: null
		}
	}

	def dispatch NTSimpleType getTypeFor(NTIntArray1D a, NTRealScalar b, String op)
	{
		switch op
		{
			case '+', case '-', case '*', case '/': new NTRealArray1D(a.size)
			default: null
		}
	}

	def dispatch NTSimpleType getTypeFor(NTIntArray1D a, NTArray1D b, String op)
	{
		switch op
		{
			case !haveSameDimensions(a, b) : null
			case '+', case '-', case '*', case '/': b // IntArray1D + IntArray1D -> IntArray1D , IntArray1D + RealArray1D -> RealArray1D
			default: null
		}
	}
		
	// REAL ARRAYS 1D
	def dispatch NTSimpleType getTypeFor(NTRealArray1D a, NTIntScalar b, String op)
	{
		getTypeFor(a, new NTRealScalar, op)
	}

	def dispatch NTSimpleType getTypeFor(NTRealArray1D a, NTRealScalar b, String op)
	{
		switch op
		{
			case '+', case '-', case '*', case '/': a
			default: null
		}
	}

	def dispatch NTSimpleType getTypeFor(NTRealArray1D a, NTArray1D b, String op)
	{
		switch op
		{
			case !haveSameDimensions(a, b) :  null
			case '+', case '-', case '*', case '/': a
			default: null
		}
	}
	
	// INT ARRAYS 2D
	def dispatch NTSimpleType getTypeFor(NTIntArray2D a, NTIntScalar b, String op)
	{
		switch op
		{
			case '+', case '-', case '*', case '/': a
			default: null
		}
	}

	def dispatch NTSimpleType getTypeFor(NTIntArray2D a, NTRealScalar b, String op)
	{
		switch op
		{
			case '+', case '-', case '*', case '/': new NTRealArray2D(a.nbRows, a.nbCols)
			default: null
		}
	}
	
	// No operations for Array2D op Array2D for the moment
		
	// REAL ARRAYS 2D
	def dispatch NTSimpleType getTypeFor(NTRealArray2D a, NTIntScalar b, String op)
	{
		getTypeFor(a, new NTRealScalar, op)
	}

	def dispatch NTSimpleType getTypeFor(NTRealArray2D a, NTRealScalar b, String op)
	{
		switch op
		{
			case '+', case '-', case '*', case '/': a
			default: null
		}
	}

	def dispatch NTSimpleType getTypeFor(NTRealArray2D a, NTRealArray2D b, String op)
	{
		switch op
		{
			case '+', case '-', case '*': a
			default: null
		}
	}
	
	private def haveSameDimensions(NTArray1D a, NTArray1D b) { a.size == b.size }
	//private def haveSameDimensions(Array2D a, Array2D b) { a.nbRows == b.nbRows && a.nbCols == b.nbCols }
}