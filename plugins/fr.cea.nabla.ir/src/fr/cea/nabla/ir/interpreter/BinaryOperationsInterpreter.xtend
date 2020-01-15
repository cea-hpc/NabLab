/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.interpreter

import static extension fr.cea.nabla.ir.interpreter.NablaValueExtensions.*

class BinaryOperationsInterpreter
{
	static def dispatch NablaValue getValueOf(NablaValue a, NablaValue b, String op)
	{
		throw new RuntimeException('Wrong operator: ' + op + " for " + a.class.name + " and " + b.class.name)
	}

	// BOOL: useful for type validator (unused by type provider)
	static def dispatch NablaValue getValueOf(NV0Bool a, NV0Bool b, String op)
	{
		switch op
		{
			case '||': new NV0Bool(a.data || b.data)
			case '&&': new NV0Bool(a.data && b.data)
			case '==': new NV0Bool(a.data == b.data)
			case '!=': new NV0Bool(a.data != b.data)
			case '>=': new NV0Bool(a.data >= b.data)
			case '<=': new NV0Bool(a.data <= b.data)
			case '>': new NV0Bool(a.data > b.data)
			case'<': new NV0Bool(a.data < b.data)
			default: null
		}
	}

	// INT
	static def dispatch NablaValue getValueOf(NV0Int a, NV0Int b, String op)
	{
		switch op
		{
			case '==': new NV0Bool(a.data == b.data)
			case '!=': new NV0Bool(a.data != b.data)
			case '>=': new NV0Bool(a.data >= b.data)
			case '<=': new NV0Bool(a.data <= b.data)
			case '>':  new NV0Bool(a.data > b.data)
			case '<':  new NV0Bool(a.data < b.data) 
			case '+':  new NV0Int(a.data + b.data)
			case '-':  new NV0Int(a.data - b.data)
			case '*':  new NV0Int(a.data * b.data)
			case '/':  { if (b.data == 0)
							throw new RuntimeException('Dividing by 0 is not possible')
						else
							new NV0Int(a.data / b.data) }
			case '%':  new NV0Int(a.data % b.data)
			default: null
		}
	}

	static def dispatch NablaValue getValueOf(NV0Int a, NV0Real b, String op)
	{
		getValueOf(new NV0Real(a.data as double), b, op)
	}

	static def dispatch NablaValue getValueOf(NV0Int a, NV1Int b, String op)
	{
		switch op
		{
			case '+', case '*': getValueOf(b, a, op) // Commutative operations
			default: null
		}
	}

	static def dispatch NablaValue getValueOf(NV0Int a, NV1Real b, String op)
	{
		getValueOf(new NV0Real(a.data as double), b , op)
	}

	static def dispatch NablaValue getValueOf(NV0Int a, NV2Int b, String op)
	{
		switch op
		{
			case '+', case '*': getValueOf(b, a, op) // Commutative operations
			default: null
		}
	}

	static def dispatch NablaValue getValueOf(NV0Int a, NV2Real b, String op)
	{
		getValueOf(new NV0Real(a.data as double), b , op)
	}

	// REAL
	static def dispatch NablaValue getValueOf(NV0Real a, NV0Int b, String op)
	{
		getValueOf(a, new NV0Real(b.data as double), op)
	}

	static def dispatch NablaValue getValueOf(NV0Real a, NV0Real b, String op)
	{
		switch op
		{
			case '==': new NV0Bool(a.data == b.data)
			case '!=': new NV0Bool(a.data != b.data)
			case '>=': new NV0Bool(a.data >= b.data)
			case '<=': new NV0Bool(a.data <= b.data)
			case '>':  new NV0Bool(a.data > b.data)
			case '<':  new NV0Bool(a.data < b.data) 
			case '+':  new NV0Real(a.data + b.data)
			case '-':  new NV0Real(a.data - b.data)
			case '*':  new NV0Real(a.data * b.data)
			case '/':  { if (b.data == 0.0)
							throw new RuntimeException('Dividing by 0 is not possible') 
						else
							new NV0Real(a.data / b.data) }
			default: null
		}
	}

	static def dispatch NablaValue getValueOf(NV0Real a, NV1Int b, String op)
	{
		switch op
		{
			case '+', case '*': getValueOf(b, a, op) // Commutative operations 
			default: null
		}
	}

	static def dispatch NablaValue getValueOf(NV0Real a, NV1Real b, String op)
	{
		switch op
		{
			case '+': new NV1Real(b.data.map[x | x + a.data]) 
			case '*': new NV1Real(b.data.map[x | x * a.data]) 
			default: null
		}
	}

	static def dispatch NablaValue getValueOf(NV0Real a, NV2Int b, String op)
	{
		switch op
		{
			case '+', case '*': getValueOf(b, a, op) // Commutative operations 
			default: null
		}
	}

	static def dispatch NablaValue getValueOf(NV0Real a, NV2Real b, String op)
	{
		switch op
		{
			case '+', case '*': getValueOf(b, a, op) // Commutative operations 
			default: null
		}
	}

	// INT ARRAYS 1D
	static def dispatch NablaValue getValueOf(NV1Int a, NV0Int b, String op)
	{
		switch op
		{
			case '+': new NV1Int(a.data.map[x | x + b.data])
			case '-': new NV1Int(a.data.map[x | x - b.data])
			case '*': new NV1Int(a.data.map[x | x * b.data])
			case '/': new NV1Int(a.data.map[x | x / b.data])
			default: null
		}
	}

	static def dispatch NablaValue getValueOf(NV1Int a, NV0Real b, String op)
	{
		switch op
		{
			case '+': new NV1Real(a.data.map[x | x + b.data])
			case '-': new NV1Real(a.data.map[x | x - b.data])
			case '*': new NV1Real(a.data.map[x | x * b.data])
			case '/': new NV1Real(a.data.map[x | x / b.data])
			default: null
		}
	}

	static def dispatch NablaValue getValueOf(NV1Int a, NV1Int b, String op)
	{
		switch op
		{
			case a.size !== b.size: null
			case '+': computeValueOf(a, b, [x, y | x + y])
			case '-': computeValueOf(a, b, [x, y | x - y])
			case '*': computeValueOf(a, b, [x, y | x * y])
			case '/': computeValueOf(a, b, [x, y | x / y])
			default: null
		}
	}

	private static def computeValueOf(NV1Int a, NV1Int b, (int, int)=>int f)
	{
		val res = newIntArrayOfSize(a.size)
		for (i : 0..<a.size)
			res.set(i, f.apply(a.data.get(i), b.data.get(i)))
		return new NV1Int(res)
	}

	static def dispatch NablaValue getValueOf(NV1Int a, NV1Real b, String op)
	{
		switch op
		{
			case a.size !== b.size: null
			case '+': computeValueOf(a, b, [x, y | x + y])
			case '-': computeValueOf(a, b, [x, y | x - y])
			case '*': computeValueOf(a, b, [x, y | x * y])
			case '/': computeValueOf(a, b, [x, y | x / y])
			default: null
		}
	}

	private static def computeValueOf(NV1Int a, NV1Real b, (int, double)=>double f)
	{
		val res = newDoubleArrayOfSize(a.size)
		for (i : 0..<a.size)
			res.set(i, f.apply(a.data.get(i), b.data.get(i)))
		return new NV1Real(res)
	}

	// REAL ARRAYS 1D
	static def dispatch NablaValue getValueOf(NV1Real a, NV0Int b, String op)
	{
		getValueOf(a, new NV0Real(b.data as double), op)
	}

	static def dispatch NablaValue getValueOf(NV1Real a, NV0Real b, String op)
	{
		switch op
		{
			case '+': new NV1Real(a.data.map[x | x + b.data]) 
			case '-': new NV1Real(a.data.map[x | x - b.data])
			case '*': new NV1Real(a.data.map[x | x * b.data])
			case '/': new NV1Real(a.data.map[x | x / b.data])
			default: null
		}
	}

	static def dispatch NablaValue getValueOf(NV1Real a, NV1Int b, String op)
	{
		switch op
		{
			// !! Parameters have been switched to reuse private method defined before
			case a.size !== b.size: null
			case '+': computeValueOf(b, a, [x, y | y + x])
			case '-': computeValueOf(b, a, [x, y | y - x])
			case '*': computeValueOf(b, a, [x, y | y * x])
			case '/': computeValueOf(b, a, [x, y | y / x])
			default: null
		}
	}

	static def dispatch NablaValue getValueOf(NV1Real a, NV1Real b, String op)
	{
		switch op
		{
			case a.size !== b.size: null
			case '+': computeValueOf(a, b, [x, y | x + y])
			case '-': computeValueOf(a, b, [x, y | x - y])
			case '*': computeValueOf(a, b, [x, y | x * y])
			case '/': computeValueOf(a, b, [x, y | x / y])
			default: null
		}
	}

	private static def computeValueOf(NV1Real a, NV1Real b, (double, double)=>double f)
	{
		val res = newDoubleArrayOfSize(a.size)
		for (i : 0..<a.size)
			res.set(i, f.apply(a.data.get(i), b.data.get(i)))
		return new NV1Real(res)
	}

	// INT ARRAYS 2D
	static def dispatch NablaValue getValueOf(NV2Int a, NV0Int b, String op)
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

	private static def computeValueOf(NV2Int a, NV0Int b, (int, int)=>int f)
	{
		val int[][] res = newArrayOfSize(a.nbRows).map[x | newIntArrayOfSize(a.nbCols)]
		for (i : 0..<a.nbRows)
			for (j : 0..<a.nbCols)
				res.get(i).set(j, f.apply(a.data.get(i).get(j), b.data))
		return new NV2Int(res)
	}

	static def dispatch NablaValue getValueOf(NV2Int a, NV0Real b, String op)
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

	private static def computeValueOf(NV2Int a, NV0Real b, (int, double)=>double f)
	{
		val double[][] res = newArrayOfSize(a.nbRows).map[x | newDoubleArrayOfSize(a.nbCols)]
		for (i : 0..<a.nbRows)
			for (j : 0..<a.nbCols)
				res.get(i).set(j, f.apply(a.data.get(i).get(j), b.data))
		return new NV2Real(res)
	}

	static def dispatch NablaValue getValueOf(NV2Int a, NV2Int b, String op)
	{
		switch op
		{
			case a.nbRows!==b.nbRows || a.nbCols!==b.nbCols: null
			case '+': computeValueOf(a, b, [x, y | x + y])
			case '-': computeValueOf(a, b, [x, y | x - y])
			case '*': computeValueOf(a, b, [x, y | x * y])
			default: null
		}
	}

	private static def computeValueOf(NV2Int a, NV2Int b, (int, int)=>int f)
	{
		val int[][] res = newArrayOfSize(a.nbRows).map[x | newIntArrayOfSize(a.nbCols)]
		for (i : 0..<a.nbRows)
			for (j : 0..<a.nbCols)
				res.get(i).set(j, f.apply(a.data.get(i).get(j), b.data.get(i).get(j)))
		return new NV2Int(res)
	}

	// REAL ARRAYS 2D
	static def dispatch NablaValue getValueOf(NV2Real a, NV0Int b, String op)
	{
		getValueOf(a, new NV0Real(b.data as double), op)
	}

	static def dispatch NablaValue getValueOf(NV2Real a, NV0Real b, String op)
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

	private static def computeValueOf(NV2Real a, NV0Real b, (double, double)=>double f)
	{
		val double[][] res = newArrayOfSize(a.nbRows).map[x | newDoubleArrayOfSize(a.nbCols)]
		for (i : 0..<a.nbRows)
			for (j : 0..<a.nbCols)
				res.get(i).set(j, f.apply(a.data.get(i).get(j), b.data))
		return new NV2Real(res)
	}

	static def dispatch NablaValue getValueOf(NV2Real a, NV2Real b, String op)
	{
		switch op
		{
			case a.nbRows!==b.nbRows || a.nbCols!==b.nbCols: null
			case '+': computeValueOf(a, b, [x, y | x + y])
			case '-': computeValueOf(a, b, [x, y | x - y])
			case '*': computeValueOf(a, b, [x, y | x * y])
			default: null
		}
	}

	private static def computeValueOf(NV2Real a, NV2Real b, (double, double)=>double f)
	{
		val double[][] res = newArrayOfSize(a.nbRows).map[x | newDoubleArrayOfSize(a.nbCols)]
		for (i : 0..<a.nbRows)
			for (j : 0..<a.nbCols)
				res.get(i).set(j, f.apply(a.data.get(i).get(j), b.data.get(i).get(j)))
		return new NV2Real(res)
	}
}