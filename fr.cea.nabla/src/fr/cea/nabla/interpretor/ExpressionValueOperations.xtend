package fr.cea.nabla.interpretor

import fr.cea.nabla.nabla.BasicType

class UnsupportedOperationException extends RuntimeException
{
	new(String operationName, ExpressionValue[] arguments)
	{
		super("Unsupported operation " + operationName + " on types: " + arguments.map[typeName].join(', '))
	}

	new(String operationName, BasicType[] arguments)
	{
		super("Unsupported operation " + operationName + " on types: " + arguments.map[literal].join(', '))
	}
}

class ExpressionValueOperations 
{
	// BOOL
	def dispatch ExpressionValue eval(BoolValue a, BoolValue b, String op)
	{
		switch op
		{
			case '==': new BoolValue(a.value == b.value)
			case '!=': new BoolValue(a.value != b.value)
			default: throw new UnsupportedOperationException(op, #[a, b])
		}
	}
	
	// INT
	def dispatch ExpressionValue eval(IntValue a, IntValue b, String op)
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
			default: throw new UnsupportedOperationException(op, #[a, b])
		}
	}

	def dispatch ExpressionValue eval(IntValue a, RealValue b, String op)
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

	def dispatch ExpressionValue eval(IntValue a, Real2Value b, String op)
	{
		switch op
		{
			case '+': new Real2Value(b.value + a.value)
			case '*': new Real2Value(b.value * a.value)
			default: throw new UnsupportedOperationException(op, #[a, b])
		}
	}

	def dispatch ExpressionValue eval(IntValue a, Real3Value b, String op)
	{
		switch op
		{
			case '+': new Real3Value(b.value + a.value)
			case '*': new Real3Value(b.value * a.value)
			default: throw new UnsupportedOperationException(op, #[a, b])
		}
	}

	def dispatch ExpressionValue eval(IntValue a, Real2x2Value b, String op)
	{
		switch op
		{
			case '*': new Real2x2Value(b.value * a.value)
			default: throw new UnsupportedOperationException(op, #[a, b])
		}
	}

	def dispatch ExpressionValue eval(IntValue a, Real3x3Value b, String op)
	{
		switch op
		{
			case '*': new Real3x3Value(b.value * a.value)
			default: throw new UnsupportedOperationException(op, #[a, b])
		}
	}

	// REAL
	def dispatch ExpressionValue eval(RealValue a, IntValue b, String op)
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

	def dispatch ExpressionValue eval(RealValue a, RealValue b, String op)
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

	def dispatch ExpressionValue eval(RealValue a, Real2Value b, String op)
	{
		switch op
		{
			case '+': new Real2Value(b.value + a.value)
			case '*': new Real2Value(b.value * a.value)
			default: throw new UnsupportedOperationException(op, #[a, b])
		}
	}

	def dispatch ExpressionValue eval(RealValue a, Real3Value b, String op)
	{
		switch op
		{
			case '+': new Real3Value(b.value + a.value)
			case '*': new Real3Value(b.value * a.value)
			default: throw new UnsupportedOperationException(op, #[a, b])
		}
	}

	def dispatch ExpressionValue eval(RealValue a, Real2x2Value b, String op)
	{
		switch op
		{
			case '*': new Real2x2Value(b.value * a.value)
			default: throw new UnsupportedOperationException(op, #[a, b])
		}
	}

	def dispatch ExpressionValue eval(RealValue a, Real3x3Value b, String op)
	{
		switch op
		{
			case '*': new Real3x3Value(b.value * a.value)
			default: throw new UnsupportedOperationException(op, #[a, b])
		}
	}

	// REAL2
	def dispatch ExpressionValue eval(Real2Value a, IntValue b, String op)
	{
		switch op
		{
			case '+': new Real2Value(a.value + b.value)
			case '-': new Real2Value(a.value - b.value)
			case '*': new Real2Value(a.value * b.value)
			case '/': new Real2Value(a.value / b.value)
			default: throw new UnsupportedOperationException(op, #[a, b])
		}
	}

	def dispatch ExpressionValue eval(Real2Value a, RealValue b, String op)
	{
		switch op
		{
			case '+': new Real2Value(a.value + b.value)
			case '-': new Real2Value(a.value - b.value)
			case '*': new Real2Value(a.value * b.value)
			case '/': new Real2Value(a.value / b.value)
			default: throw new UnsupportedOperationException(op, #[a, b])
		}
	}

	def dispatch ExpressionValue eval(Real2Value a, Real2Value b, String op)
	{
		switch op
		{
			case '+': new Real2Value(a.value + b.value)
			case '-': new Real2Value(a.value - b.value)
			case '*': new Real2Value(a.value * b.value)
			case '/': new Real2Value(a.value / b.value)
			default: throw new UnsupportedOperationException(op, #[a, b])
		}
	}

	// REAL3
	def dispatch ExpressionValue eval(Real3Value a, IntValue b, String op)
	{
		switch op
		{
			case '+': new Real3Value(a.value + b.value)
			case '-': new Real3Value(a.value - b.value)
			case '*': new Real3Value(a.value * b.value)
			case '/': new Real3Value(a.value / b.value)
			default: throw new UnsupportedOperationException(op, #[a, b])
		}
	}

	def dispatch ExpressionValue eval(Real3Value a, RealValue b, String op)
	{
		switch op
		{
			case '+': new Real3Value(a.value + b.value)
			case '-': new Real3Value(a.value - b.value)
			case '*': new Real3Value(a.value * b.value)
			case '/': new Real3Value(a.value / b.value)
			default: throw new UnsupportedOperationException(op, #[a, b])
		}
	}

	def dispatch ExpressionValue eval(Real3Value a, Real3Value b, String op)
	{
		switch op
		{
			case '+': new Real3Value(a.value + b.value)
			case '-': new Real3Value(a.value - b.value)
			case '*': new Real3Value(a.value * b.value)
			case '/': new Real3Value(a.value / b.value)
			default: throw new UnsupportedOperationException(op, #[a, b])
		}
	}
	
	// REAL2X2
	def dispatch ExpressionValue eval(Real2x2Value a, IntValue b, String op)
	{
		switch op
		{
			case '*': new Real2x2Value(a.value * b.value)
			case '/': new Real2x2Value(a.value / b.value)
			default: throw new UnsupportedOperationException(op, #[a, b])
		}
	}

	def dispatch ExpressionValue eval(Real2x2Value a, RealValue b, String op)
	{
		switch op
		{
			case '*': new Real2x2Value(a.value * b.value)
			case '/': new Real2x2Value(a.value / b.value)
			default: throw new UnsupportedOperationException(op, #[a, b])
		}
	}

	def dispatch ExpressionValue eval(Real2x2Value a, Real2x2Value b, String op)
	{
		switch op
		{
			case '+': new Real2x2Value(a.value + b.value)
			case '-': new Real2x2Value(a.value - b.value)
			case '*': new Real2x2Value(a.value * b.value)
			default: throw new UnsupportedOperationException(op, #[a, b])
		}
	}

	// REAL3X3
	def dispatch ExpressionValue eval(Real3x3Value a, IntValue b, String op)
	{
		switch op
		{
			case '*': new Real3x3Value(a.value * b.value)
			case '/': new Real3x3Value(a.value / b.value)
			default: throw new UnsupportedOperationException(op, #[a, b])
		}
	}

	def dispatch ExpressionValue eval(Real3x3Value a, RealValue b, String op)
	{
		switch op
		{
			case '*': new Real3x3Value(a.value * b.value)
			case '/': new Real3x3Value(a.value / b.value)
			default: throw new UnsupportedOperationException(op, #[a, b])
		}
	}

	def dispatch ExpressionValue eval(Real3x3Value a, Real3x3Value b, String op)
	{
		switch op
		{
			case '+': new Real3x3Value(a.value + b.value)
			case '-': new Real3x3Value(a.value - b.value)
			case '*': new Real3x3Value(a.value * b.value)
			default: throw new UnsupportedOperationException(op, #[a, b])
		}
	}
}