package fr.cea.nabla.interpreter

import fr.cea.nabla.nabla.PrimitiveType

class UnsupportedOperationException extends RuntimeException
{
	new(String operationName, ExpressionValue[] arguments)
	{
		super("Unsupported operation " + operationName + " on types: " + arguments.map[class.simpleName].join(', '))
	}

	new(String operationName, PrimitiveType[] arguments)
	{
		super("Unsupported operation " + operationName + " on types: " + arguments.map[literal].join(', '))
	}

	new(String operationName, int[] sizes)
	{
		super("Unsupported operation " + operationName + " on arrays with different sizes: " + sizes.join(', '))
	}
}

class BinaryOperationsInterpreter 
{
	def dispatch ExpressionValue interprete(ExpressionValue a, ExpressionValue b, String op)
	{
		throw new UnsupportedOperationException(op, #[a, b])
	}	
	
	// BOOL
	def dispatch ExpressionValue interprete(BoolValue a, BoolValue b, String op)
	{
		switch op
		{
			case '||': new BoolValue(a.value || b.value)
			case '&&': new BoolValue(a.value && b.value)
			case '==': new BoolValue(a.value == b.value)
			case '!=': new BoolValue(a.value != b.value)
			default: throw new UnsupportedOperationException(op, #[a, b])
		}
	}
	
	// INT
	def dispatch ExpressionValue interprete(IntValue a, IntValue b, String op)
	{
		switch op
		{
			case '==': new BoolValue(a.value == b.value)
			case '!=': new BoolValue(a.value != b.value)
			case '>=': new BoolValue(a.value >= b.value)
			case '<=': new BoolValue(a.value <= b.value)
			case '>':  new BoolValue(a.value > b.value)
			case '<':  new BoolValue(a.value < b.value)
			case '+': new IntValue(a.value + b.value)
			case '-': new IntValue(a.value - b.value)
			case '*': new IntValue(a.value * b.value)
			case '/': new IntValue(a.value / b.value)
			case '%': new IntValue(a.value % b.value)
			default: throw new UnsupportedOperationException(op, #[a, b])
		}
	}

	def dispatch ExpressionValue interprete(IntValue a, RealValue b, String op)
	{
		switch op
		{
			case '==': new BoolValue(a.value == b.value)
			case '!=': new BoolValue(a.value != b.value)
			case '>=': new BoolValue(a.value >= b.value)
			case '<=': new BoolValue(a.value <= b.value)
			case '>':  new BoolValue(a.value > b.value)
			case '<':  new BoolValue(a.value < b.value)
			case '+': new RealValue(a.value + b.value)
			case '-': new RealValue(a.value - b.value)
			case '*': new RealValue(a.value * b.value)
			case '/': new RealValue(a.value / b.value)
			default: throw new UnsupportedOperationException(op, #[a, b])
		}
	}

	def dispatch ExpressionValue interprete(IntValue a, IntArrayValue b, String op)
	{
		switch op
		{
			case '+': new IntArrayValue(b.dimSizes, b.value.map[x | a.value + x])
			case '*': new IntArrayValue(b.dimSizes, b.value.map[x | a.value * x])
			default: throw new UnsupportedOperationException(op, #[a, b])
		}
	}

	def dispatch ExpressionValue interprete(IntValue a, RealArrayValue b, String op)
	{
		switch op
		{
			case '+': new RealArrayValue(b.dimSizes, b.value.map[x | a.value + x])
			case '*': new RealArrayValue(b.dimSizes, b.value.map[x | a.value * x])
			default: throw new UnsupportedOperationException(op, #[a, b])
		}
	}

	// REAL
	def dispatch ExpressionValue interprete(RealValue a, IntValue b, String op)
	{
		interprete(a, new RealValue(b.value as double), op)
	}

	def dispatch ExpressionValue interprete(RealValue a, RealValue b, String op)
	{
		switch op
		{
			case '==': new BoolValue(a.value == b.value)
			case '!=': new BoolValue(a.value != b.value)
			case '>=': new BoolValue(a.value >= b.value)
			case '<=': new BoolValue(a.value <= b.value)
			case '>':  new BoolValue(a.value > b.value)
			case '<':  new BoolValue(a.value < b.value)
			case '+': new RealValue(a.value + b.value)
			case '-': new RealValue(a.value - b.value)
			case '*': new RealValue(a.value * b.value)
			case '/': new RealValue(a.value / b.value)
			default: throw new UnsupportedOperationException(op, #[a, b])
		}
	}

	def dispatch ExpressionValue interprete(RealValue a, RealArrayValue b, String op)
	{
		switch op
		{
			case '+': new RealArrayValue(b.dimSizes, b.value.map[x | a.value + x])
			case '*': new RealArrayValue(b.dimSizes, b.value.map[x | a.value * x])
			default: throw new UnsupportedOperationException(op, #[a, b])
		}
	}

	// INT ARRAY
	def dispatch ExpressionValue interprete(IntArrayValue a, IntValue b, String op)
	{
		switch op
		{
			case '+': new IntArrayValue(a.dimSizes, a.value.map[x | x + b.value])
			case '-': new IntArrayValue(a.dimSizes, a.value.map[x | x - b.value])
			case '*': new IntArrayValue(a.dimSizes, a.value.map[x | x * b.value])
			case '/': new IntArrayValue(a.dimSizes, a.value.map[x | x / b.value])
			default: throw new UnsupportedOperationException(op, #[a, b])
		}
	}

	def dispatch ExpressionValue interprete(IntArrayValue a, RealValue b, String op)
	{
		switch op
		{
			case '+': new RealArrayValue(a.dimSizes, a.value.map[x | x + b.value])
			case '-': new RealArrayValue(a.dimSizes, a.value.map[x | x - b.value])
			case '*': new RealArrayValue(a.dimSizes, a.value.map[x | x * b.value])
			case '/': new RealArrayValue(a.dimSizes, a.value.map[x | x / b.value])
			default: throw new UnsupportedOperationException(op, #[a, b])
		}
	}

	def dispatch ExpressionValue interprete(IntArrayValue a, IntArrayValue b, String op)
	{
		switch op
		{
			case a.value.size != b.value.size: throw new UnsupportedOperationException(op, #[a, b])
			case '+': 
			{
				val values = newIntArrayOfSize(a.value.size)
				for (i : 0..<a.value.size) values.set(i, a.value.get(i) + b.value.get(i))
				new IntArrayValue(a.dimSizes, values)
			}
			case '-': 
			{
				val values = newIntArrayOfSize(a.value.size)
				for (i : 0..<a.value.size) values.set(i, a.value.get(i) - b.value.get(i))
				new IntArrayValue(a.dimSizes, values)
			}
			case '*': 
			{
				val values = newIntArrayOfSize(a.value.size)
				for (i : 0..<a.value.size) values.set(i, a.value.get(i) * b.value.get(i))
				new IntArrayValue(a.dimSizes, values)
			}
			case '/': 
			{
				val values = newIntArrayOfSize(a.value.size)
				for (i : 0..<a.value.size) values.set(i, a.value.get(i) / b.value.get(i))
				new IntArrayValue(a.dimSizes, values)
			}
			default: throw new UnsupportedOperationException(op, #[a, b])
		}
	}
	
	// REAL ARRAY
	def dispatch ExpressionValue interprete(RealArrayValue a, IntValue b, String op)
	{
		interprete(a, new RealValue(b.value as double), op)
	}

	def dispatch ExpressionValue interprete(RealArrayValue a, RealValue b, String op)
	{
		switch op
		{
			case '+': new RealArrayValue(a.dimSizes, a.value.map[x | x + b.value])
			case '-': new RealArrayValue(a.dimSizes, a.value.map[x | x - b.value])
			case '*': new RealArrayValue(a.dimSizes, a.value.map[x | x * b.value])
			case '/': new RealArrayValue(a.dimSizes, a.value.map[x | x / b.value])
			default: throw new UnsupportedOperationException(op, #[a, b])
		}
	}

	def dispatch ExpressionValue interprete(RealArrayValue a, RealArrayValue b, String op)
	{
		switch op
		{
			case a.value.size != b.value.size: throw new UnsupportedOperationException(op, #[a, b])
			case '+': 
			{
				val values = newDoubleArrayOfSize(a.value.size)
				for (i : 0..<a.value.size) values.set(i, a.value.get(i) + b.value.get(i))
				new RealArrayValue(a.dimSizes, values)
			}
			case '-': 
			{
				val values = newDoubleArrayOfSize(a.value.size)
				for (i : 0..<a.value.size) values.set(i, a.value.get(i) - b.value.get(i))
				new RealArrayValue(a.dimSizes, values)
			}
			case '*': 
			{
				val values = newDoubleArrayOfSize(a.value.size)
				for (i : 0..<a.value.size) values.set(i, a.value.get(i) * b.value.get(i))
				new RealArrayValue(a.dimSizes, values)
			}
			case '/': 
			{
				val values = newDoubleArrayOfSize(a.value.size)
				for (i : 0..<a.value.size) values.set(i, a.value.get(i) / b.value.get(i))
				new RealArrayValue(a.dimSizes, values)
			}
			default: throw new UnsupportedOperationException(op, #[a, b])
		}
	}
}