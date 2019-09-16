package fr.cea.nabla.typing

class BinaryOperationsTypeProvider 
{
	def dispatch NablaSimpleType getTypeFor(NablaSimpleType a, NablaSimpleType b, String op)
	{
		null
	}	
	
	// BOOL: useful for type validator (unused by type provider)
	def dispatch NablaSimpleType getTypeFor(NSTBoolScalar a, NSTBoolScalar b, String op)
	{
		switch op
		{
			case '||', case '&&', case '==', case '!=', case '>=', case '<=', case '>', case'<': b
			default: null
		}
	}

	// INT
	def dispatch NablaSimpleType getTypeFor(NSTIntScalar a, NSTIntScalar b, String op)
	{
		switch op
		{
			// useful for type validator (unused by type provider)
			case '==', case '!=', case '>=', case '<=', case '>', case'<': new NSTBoolScalar
			case '+', case '-', case '*', case ' ', case '%': b
			default: null
		}
	}

	def dispatch NablaSimpleType getTypeFor(NSTIntScalar a, NSTRealScalar b, String op)
	{
		switch op
		{
			// useful for type validator (unused by type provider)
			case '==', case '!=', case '>=', case '<=', case '>', case'<': new NSTBoolScalar
			case '+', case '-', case '*', case '/': b
			default: null
		}
	}

	def dispatch NablaSimpleType getTypeFor(NSTIntScalar a, NSTArray1D b, String op)
	{
		switch op
		{
			case '+', case '*': b
			default: null
		}
	}
	
	def dispatch NablaSimpleType getTypeFor(NSTIntScalar a, NSTArray2D b, String op)
	{
		switch op
		{
			case '+', case '*': b
			default: null
		}
	}

	// REAL
	def dispatch NablaSimpleType getTypeFor(NSTRealScalar a, NSTIntScalar b, String op)
	{
		getTypeFor(a, new NSTRealScalar, op)
	}

	def dispatch NablaSimpleType getTypeFor(NSTRealScalar a, NSTRealScalar b, String op)
	{
		switch op
		{
			// useful for type validator (unused by type provider)
			case '==', case '!=', case '>=', case '<=', case '>', case'<': new NSTBoolScalar
			case '+', case '-', case '*', case '/', case ':': b
			default: null
		}
	}

	def dispatch NablaSimpleType getTypeFor(NSTRealScalar a, NSTArray1D b, String op)
	{
		switch op
		{
			// RealScalar + RealArray1D -> RealArray1D , RealScalar + IntArray1D -> RealArray1D
			case '+', case '*': new NSTRealArray1D(b.size)
			default: null
		}
	}

	def dispatch NablaSimpleType getTypeFor(NSTRealScalar a, NSTArray2D b, String op)
	{
		switch op
		{
			// RealScalar + RealArray2D -> RealArray2D , RealScalar + IntArray2D -> RealArray2D
			case '+', case '*': new NSTRealArray2D(b.nbRows, b.nbCols)
			default: null
		}
	}

	// INT ARRAYS 1D
	def dispatch NablaSimpleType getTypeFor(NSTIntArray1D a, NSTIntScalar b, String op)
	{
		switch op
		{
			case '+', case '-', case '*', case '/': a
			default: null
		}
	}

	def dispatch NablaSimpleType getTypeFor(NSTIntArray1D a, NSTRealScalar b, String op)
	{
		switch op
		{
			case '+', case '-', case '*', case '/': new NSTRealArray1D(a.size)
			default: null
		}
	}

	def dispatch NablaSimpleType getTypeFor(NSTIntArray1D a, NSTArray1D b, String op)
	{
		switch op
		{
			case !haveSameDimensions(a, b) : null
			case '+', case '-', case '*', case '/': b // IntArray1D + IntArray1D -> IntArray1D , IntArray1D + RealArray1D -> RealArray1D
			default: null
		}
	}
		
	// REAL ARRAYS 1D
	def dispatch NablaSimpleType getTypeFor(NSTRealArray1D a, NSTIntScalar b, String op)
	{
		getTypeFor(a, new NSTRealScalar, op)
	}

	def dispatch NablaSimpleType getTypeFor(NSTRealArray1D a, NSTRealScalar b, String op)
	{
		switch op
		{
			case '+', case '-', case '*', case '/': a
			default: null
		}
	}

	def dispatch NablaSimpleType getTypeFor(NSTRealArray1D a, NSTArray1D b, String op)
	{
		switch op
		{
			case !haveSameDimensions(a, b) :  null
			case '+', case '-', case '*', case '/': a
			default: null
		}
	}
	
	// INT ARRAYS 2D
	def dispatch NablaSimpleType getTypeFor(NSTIntArray2D a, NSTIntScalar b, String op)
	{
		switch op
		{
			case '+', case '-', case '*', case '/': a
			default: null
		}
	}

	def dispatch NablaSimpleType getTypeFor(NSTIntArray2D a, NSTRealScalar b, String op)
	{
		switch op
		{
			case '+', case '-', case '*', case '/': new NSTRealArray2D(a.nbRows, a.nbCols)
			default: null
		}
	}
	
	// No operations for Array2D op Array2D for the moment
		
	// REAL ARRAYS 2D
	def dispatch NablaSimpleType getTypeFor(NSTRealArray2D a, NSTIntScalar b, String op)
	{
		getTypeFor(a, new NSTRealScalar, op)
	}

	def dispatch NablaSimpleType getTypeFor(NSTRealArray2D a, NSTRealScalar b, String op)
	{
		switch op
		{
			case '+', case '-', case '*', case '/': a
			default: null
		}
	}

	def dispatch NablaSimpleType getTypeFor(NSTRealArray2D a, NSTRealArray2D b, String op)
	{
		switch op
		{
			case '+', case '-', case '*': a
			default: null
		}
	}
	
	private def haveSameDimensions(NSTArray1D a, NSTArray1D b) { a.size == b.size }
	//private def haveSameDimensions(Array2D a, Array2D b) { a.nbRows == b.nbRows && a.nbCols == b.nbCols }
}