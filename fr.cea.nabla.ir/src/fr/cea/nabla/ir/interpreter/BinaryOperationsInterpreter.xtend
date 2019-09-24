package fr.cea.nabla.ir.interpreter

class BinaryOperationsInterpreter 
{
	static def dispatch NablaSimpleValue getValueOf(NablaSimpleValue a, NablaSimpleValue b, String op)
	{
		null
	}	
	
	// BOOL: useful for type validator (unused by type provider)
	static def dispatch NablaSimpleValue getValueOf(NSVBoolScalar a, NSVBoolScalar b, String op)
	{
		switch op
		{
			case '||', case '&&', case '==', case '!=', case '>=', case '<=', case '>', case'<': b
			default: null
		}
	}

	// INT
	static def dispatch NablaSimpleValue getValueOf(NSVIntScalar a, NSVIntScalar b, String op)
	{
		switch op
		{
			case '==': new NSVBoolScalar(a.value == b.value)
			case '!=': new NSVBoolScalar(a.value != b.value)
			case '>=': new NSVBoolScalar(a.value >= b.value)
			case '<=': new NSVBoolScalar(a.value <= b.value)
			case '>':  new NSVBoolScalar(a.value > b.value)
			case '<':  new NSVBoolScalar(a.value < b.value) 
			case '+':  new NSVIntScalar(a.value + b.value)
			case '-':  new NSVIntScalar(a.value - b.value)
			case '*':  new NSVIntScalar(a.value * b.value)
			case '/':  new NSVIntScalar(a.value / b.value)
			case '%':  new NSVIntScalar(a.value % b.value)
			default: null
		}
	}

	static def dispatch NablaSimpleValue getValueOf(NSVIntScalar a, NSVRealScalar b, String op)
	{
		getValueOf(new NSVRealScalar(a.value as double), b, op)
	}

	static def dispatch NablaSimpleValue getValueOf(NSVIntScalar a, NSVIntArray1D b, String op)
	{
		switch op
		{
			case '+', case '*': getValueOf(b, a, op) // Commutative operations
			default: null
		}
	}
	
	static def dispatch NablaSimpleValue getValueOf(NSVIntScalar a, NSVRealArray1D b, String op)
	{
		getValueOf(new NSVRealScalar(a.value as double), b , op)
	}
		
	static def dispatch NablaSimpleValue getValueOf(NSVIntScalar a, NSVIntArray2D b, String op)
	{
		switch op
		{
			case '+', case '*': getValueOf(b, a, op) // Commutative operations
			default: null
		}
	}

	static def dispatch NablaSimpleValue getValueOf(NSVIntScalar a, NSVRealArray2D b, String op)
	{
		getValueOf(new NSVRealScalar(a.value as double), b , op)
	}

	// REAL
	static def dispatch NablaSimpleValue getValueOf(NSVRealScalar a, NSVIntScalar b, String op)
	{
		getValueOf(a, new NSVRealScalar(b.value as double), op)
	}

	static def dispatch NablaSimpleValue getValueOf(NSVRealScalar a, NSVRealScalar b, String op)
	{
		switch op
		{
			case '==': new NSVBoolScalar(a.value == b.value)
			case '!=': new NSVBoolScalar(a.value != b.value)
			case '>=': new NSVBoolScalar(a.value >= b.value)
			case '<=': new NSVBoolScalar(a.value <= b.value)
			case '>':  new NSVBoolScalar(a.value > b.value)
			case '<':  new NSVBoolScalar(a.value < b.value) 
			case '+':  new NSVRealScalar(a.value + b.value)
			case '-':  new NSVRealScalar(a.value - b.value)
			case '*':  new NSVRealScalar(a.value * b.value)
			case '/':  new NSVRealScalar(a.value / b.value)
			case '%':  new NSVRealScalar(a.value % b.value)
			default: null
		}
	}

	static def dispatch NablaSimpleValue getValueOf(NSVRealScalar a, NSVIntArray1D b, String op)
	{
		switch op
		{
			case '+', case '*': getValueOf(b, a, op) // Commutative operations 
			default: null
		}
	}

	static def dispatch NablaSimpleValue getValueOf(NSVRealScalar a, NSVRealArray1D b, String op)
	{
		switch op
		{
			case '+': new NSVRealArray1D(b.values.map[x | x + a.value]) 
			case '*': new NSVRealArray1D(b.values.map[x | x * a.value]) 
			default: null
		}
	}

	static def dispatch NablaSimpleValue getValueOf(NSVRealScalar a, NSVIntArray2D b, String op)
	{
		switch op
		{
			case '+', case '*': getValueOf(b, a, op) // Commutative operations 
			default: null
		}
	}

	static def dispatch NablaSimpleValue getValueOf(NSVRealScalar a, NSVRealArray2D b, String op)
	{
		switch op
		{
			case '+', case '*': getValueOf(b, a, op) // Commutative operations 
			default: null
		}
	}

	// INT ARRAYS 1D
	static def dispatch NablaSimpleValue getValueOf(NSVIntArray1D a, NSVIntScalar b, String op)
	{
		switch op
		{
			case '+': new NSVIntArray1D(a.values.map[x | x + b.value]) 
			case '-': new NSVIntArray1D(a.values.map[x | x - b.value]) 
			case '*': new NSVIntArray1D(a.values.map[x | x * b.value]) 
			case '/': new NSVIntArray1D(a.values.map[x | x / b.value]) 			
			default: null
		}
	}

	static def dispatch NablaSimpleValue getValueOf(NSVIntArray1D a, NSVRealScalar b, String op)
	{
		switch op
		{
			case '+': new NSVRealArray1D(a.values.map[x | x + b.value]) 
			case '-': new NSVRealArray1D(a.values.map[x | x - b.value])
			case '*': new NSVRealArray1D(a.values.map[x | x * b.value])
			case '/': new NSVRealArray1D(a.values.map[x | x / b.value])
			default: null
		}
	}

	static def dispatch NablaSimpleValue getValueOf(NSVIntArray1D a, NSVIntArray1D b, String op)
	{
		switch op
		{
			case !haveSameDimensions(a, b) : null
			case '+': computeValueOf(a, b, [x, y | x + y])
			case '-': computeValueOf(a, b, [x, y | x - y])
			case '*': computeValueOf(a, b, [x, y | x * y])
			case '/': computeValueOf(a, b, [x, y | x / y])
			default: null
		}
	}
	
	private static def computeValueOf(NSVIntArray1D a, NSVIntArray1D b, (int, int)=>int f)
	{
		val res = newIntArrayOfSize(a.size)
		for (i : 0..<a.size)
			res.set(i, f.apply(a.values.get(i), b.values.get(i)))
		return new NSVIntArray1D(res)		
	}
	
	static def dispatch NablaSimpleValue getValueOf(NSVIntArray1D a, NSVRealArray1D b, String op)
	{
		switch op
		{
			case !haveSameDimensions(a, b) : null
			case '+': computeValueOf(a, b, [x, y | x + y])
			case '-': computeValueOf(a, b, [x, y | x - y])
			case '*': computeValueOf(a, b, [x, y | x * y])
			case '/': computeValueOf(a, b, [x, y | x / y])
			default: null
		}
	}
	
	private static def computeValueOf(NSVIntArray1D a, NSVRealArray1D b, (int, double)=>double f)
	{
		val res = newDoubleArrayOfSize(a.size)
		for (i : 0..<a.size)
			res.set(i, f.apply(a.values.get(i), b.values.get(i)))
		return new NSVRealArray1D(res)		
	}
		
	// REAL ARRAYS 1D
	static def dispatch NablaSimpleValue getValueOf(NSVRealArray1D a, NSVIntScalar b, String op)
	{
		getValueOf(a, new NSVRealScalar(b.value as double), op)
	}

	static def dispatch NablaSimpleValue getValueOf(NSVRealArray1D a, NSVRealScalar b, String op)
	{
		switch op
		{
			case '+': new NSVRealArray1D(a.values.map[x | x + b.value]) 
			case '-': new NSVRealArray1D(a.values.map[x | x - b.value])
			case '*': new NSVRealArray1D(a.values.map[x | x * b.value])
			case '/': new NSVRealArray1D(a.values.map[x | x / b.value])
			default: null
		}
	}

	static def dispatch NablaSimpleValue getValueOf(NSVRealArray1D a, NSVIntArray1D b, String op)
	{
		switch op
		{
			// !! Parameters have been switched to reuse private method defined before
			case !haveSameDimensions(a, b) : null
			case '+': computeValueOf(b, a, [x, y | y + x])
			case '-': computeValueOf(b, a, [x, y | y - x])
			case '*': computeValueOf(b, a, [x, y | y * x])
			case '/': computeValueOf(b, a, [x, y | y / x])
			default: null
		}
	}
	
	static def dispatch NablaSimpleValue getValueOf(NSVRealArray1D a, NSVRealArray1D b, String op)
	{
		switch op
		{
			case !haveSameDimensions(a, b) : null
			case '+': computeValueOf(a, b, [x, y | x + y])
			case '-': computeValueOf(a, b, [x, y | x - y])
			case '*': computeValueOf(a, b, [x, y | x * y])
			case '/': computeValueOf(a, b, [x, y | x / y])
			default: null
		}
	}
	
	private static def computeValueOf(NSVRealArray1D a, NSVRealArray1D b, (double, double)=>double f)
	{
		val res = newDoubleArrayOfSize(a.size)
		for (i : 0..<a.size)
			res.set(i, f.apply(a.values.get(i), b.values.get(i)))
		return new NSVRealArray1D(res)		
	}
	
	// INT ARRAYS 2D
	static def dispatch NablaSimpleValue getValueOf(NSVIntArray2D a, NSVIntScalar b, String op)
	{
		switch op
		{
			case '+': computeValueOf(a, b, [x, y | x + y])
			case '-': computeValueOf(a, b, [x, y | x - y])
			case '*': computeValueOf(a, b, [x, y | x * y])
			case '/': computeValueOf(a, b, [x, y | x / y])
			default: null
		}
	}

	private static def computeValueOf(NSVIntArray2D a, NSVIntScalar b, (int, int)=>int f)
	{
		val res = newArrayOfSize(a.nbRows).map[x | newIntArrayOfSize(a.nbCols)]
		for (i : 0..<a.nbRows)
			for (j : 0..<a.nbCols)
				res.get(i).set(j, f.apply(a.values.get(i).get(j), b.value))
		return new NSVIntArray2D(res)		
	}

	static def dispatch NablaSimpleValue getValueOf(NSVIntArray2D a, NSVRealScalar b, String op)
	{
		switch op
		{
			case '+': computeValueOf(a, b, [x, y | x + y])
			case '-': computeValueOf(a, b, [x, y | x - y])
			case '*': computeValueOf(a, b, [x, y | x * y])
			case '/': computeValueOf(a, b, [x, y | x / y])
			default: null
		}
	}

	private static def computeValueOf(NSVIntArray2D a, NSVRealScalar b, (int, double)=>double f)
	{
		val res = newArrayOfSize(a.nbRows).map[x | newDoubleArrayOfSize(a.nbCols)]
		for (i : 0..<a.nbRows)
			for (j : 0..<a.nbCols)
				res.get(i).set(j, f.apply(a.values.get(i).get(j), b.value))
		return new NSVRealArray2D(res)		
	}
	
	static def dispatch NablaSimpleValue getValueOf(NSVIntArray2D a, NSVIntArray2D b, String op)
	{
		switch op
		{
			case !haveSameDimensions(a, b) : null
			case '+': computeValueOf(a, b, [x, y | x + y])
			case '-': computeValueOf(a, b, [x, y | x - y])
			case '*': computeValueOf(a, b, [x, y | x * y])
			default: null
		}
	}
	
	private static def computeValueOf(NSVIntArray2D a, NSVIntArray2D b, (int, int)=>int f)
	{
		val res = newArrayOfSize(a.nbRows).map[x | newIntArrayOfSize(a.nbCols)]
		for (i : 0..<a.nbRows)
			for (j : 0..<a.nbCols)
				res.get(i).set(j, f.apply(a.values.get(i).get(j), b.values.get(i).get(j)))
		return new NSVIntArray2D(res)		
	}
			
	// REAL ARRAYS 2D
	static def dispatch NablaSimpleValue getValueOf(NSVRealArray2D a, NSVIntScalar b, String op)
	{
		getValueOf(a, new NSVRealScalar(b.value as double), op)
	}

	static def dispatch NablaSimpleValue getValueOf(NSVRealArray2D a, NSVRealScalar b, String op)
	{
		switch op
		{
			case '+': computeValueOf(a, b, [x, y | x + y])
			case '-': computeValueOf(a, b, [x, y | x - y])
			case '*': computeValueOf(a, b, [x, y | x * y])
			case '/': computeValueOf(a, b, [x, y | x / y])
			default: null
		}
	}

	private static def computeValueOf(NSVRealArray2D a, NSVRealScalar b, (double, double)=>double f)
	{
		val res = newArrayOfSize(a.nbRows).map[x | newDoubleArrayOfSize(a.nbCols)]
		for (i : 0..<a.nbRows)
			for (j : 0..<a.nbCols)
				res.get(i).set(j, f.apply(a.values.get(i).get(j), b.value))
		return new NSVRealArray2D(res)		
	}

	static def dispatch NablaSimpleValue getValueOf(NSVRealArray2D a, NSVRealArray2D b, String op)
	{
		switch op
		{
			case !haveSameDimensions(a, b) : null
			case '+': computeValueOf(a, b, [x, y | x + y])
			case '-': computeValueOf(a, b, [x, y | x - y])
			case '*': computeValueOf(a, b, [x, y | x * y])
			default: null
		}
	}
	
	private static def computeValueOf(NSVRealArray2D a, NSVRealArray2D b, (double, double)=>double f)
	{
		val res = newArrayOfSize(a.nbRows).map[x | newDoubleArrayOfSize(a.nbCols)]
		for (i : 0..<a.nbRows)
			for (j : 0..<a.nbCols)
				res.get(i).set(j, f.apply(a.values.get(i).get(j), b.values.get(i).get(j)))
		return new NSVRealArray2D(res)		
	}
	
	private static def haveSameDimensions(NSVArray1D a, NSVArray1D b) { a.size == b.size }
	private static def haveSameDimensions(NSVArray2D a, NSVArray2D b) { a.nbRows == b.nbRows && a.nbCols == b.nbCols }
}