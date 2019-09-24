package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.ir.Array1D
import fr.cea.nabla.ir.ir.Array2D
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.BaseTypeConstant
import fr.cea.nabla.ir.ir.BinaryExpression
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.Constant
import fr.cea.nabla.ir.ir.ContractedIf
import fr.cea.nabla.ir.ir.FunctionCall
import fr.cea.nabla.ir.ir.IntMatrixConstant
import fr.cea.nabla.ir.ir.IntVectorConstant
import fr.cea.nabla.ir.ir.MaxConstant
import fr.cea.nabla.ir.ir.MinConstant
import fr.cea.nabla.ir.ir.Parenthesis
import fr.cea.nabla.ir.ir.PrimitiveType
import fr.cea.nabla.ir.ir.RealMatrixConstant
import fr.cea.nabla.ir.ir.RealVectorConstant
import fr.cea.nabla.ir.ir.Scalar
import fr.cea.nabla.ir.ir.UnaryExpression
import fr.cea.nabla.ir.ir.VarRef
import java.util.Arrays

import static extension fr.cea.nabla.ir.IrTypeExtensions.*
import static extension fr.cea.nabla.ir.interpreter.Utils.*

class ExpressionInterpreter 
{
	static def dispatch NablaValue interprete(ContractedIf it)
	{
		val condValue = condition.interprete
		if ((condValue as NSVBoolScalar).value) thenExpression.interprete
		else elseExpression.interprete 
	}
	
	static def dispatch NablaValue interprete(BinaryExpression it)	
	{
		val lValue = left.interprete as NablaSimpleValue
		val rValue = left.interprete as NablaSimpleValue
		BinaryOperationsInterpreter::getValueOf(lValue, rValue, operator)
	}
	
	static def dispatch NablaValue interprete(UnaryExpression it)
	{
		val eValue = expression.interprete as NablaSimpleValue
		switch eValue
		{
			NSVBoolScalar case operator == '!': new NSVBoolScalar(!eValue.value)
			NSVIntScalar case operator == '-': new NSVIntScalar(-eValue.value)
			NSVRealScalar case operator == '-': new NSVRealScalar(-eValue.value)
			NSVIntArray1D case operator == '-': new NSVIntArray1D(eValue.values.map[x|-x])
			NSVRealArray1D case operator == '-': new NSVRealArray1D(eValue.values.map[x|-x])
			NSVIntArray2D case operator == '-': computeUnaryMinus(eValue)
			NSVRealArray2D case operator == '-': computeUnaryMinus(eValue)
			default: throw new UnsupportedOperationException(operator, #[eValue])
		}
	}
	
	private static def computeUnaryMinus(NSVIntArray2D a)
	{
		val res = newArrayOfSize(a.nbRows).map[x | newIntArrayOfSize(a.nbCols)]
		for (i : 0..<a.nbRows)
			for (j : 0..<a.nbCols)
				res.get(i).set(j, -a.values.get(i).get(j))
		return new NSVIntArray2D(res)		
	}

	private static def computeUnaryMinus(NSVRealArray2D a)
	{
		val res = newArrayOfSize(a.nbRows).map[x | newDoubleArrayOfSize(a.nbCols)]
		for (i : 0..<a.nbRows)
			for (j : 0..<a.nbCols)
				res.get(i).set(j, -a.values.get(i).get(j))
		return new NSVRealArray2D(res)		
	}

	static def dispatch NablaValue interprete(Parenthesis it)
	{
		expression.interprete
	}

	static def dispatch NablaValue interprete(Constant it) 
	{ 
		val t = type as Scalar
		switch t.primitive
		{
			case BOOL: new NSVBoolScalar(Boolean.parseBoolean(value))
			case INT: new NSVIntScalar(Integer.parseInt(value))
			case REAL: new NSVRealScalar(Double.parseDouble(value))
			default: throw new UnexpectedTypeException(#["Int", "Real", "Bool"], t.label)
		}
	}
	
	static def dispatch NablaValue interprete(MinConstant it)
	{
		val t = type as Scalar
		switch t.primitive
		{
			case INT: new NSVIntScalar(Integer.MIN_VALUE)
			case REAL: new NSVRealScalar(Double.MIN_VALUE)
			default: throw new UnexpectedTypeException(#["Int", "Real"], t.label)
		}
	}
	
	static def dispatch NablaValue interprete(MaxConstant it)
	{
		val t = type as Scalar
		switch t.primitive
		{
			case INT: new NSVIntScalar(Integer.MAX_VALUE)
			case REAL: new NSVRealScalar(Double.MAX_VALUE)
			default: throw new UnexpectedTypeException(#["Int", "Real"], t.label)
		}
	}

	static def dispatch NablaValue interprete(BaseTypeConstant it)
	{
		val expressionValue = value.interprete as NSVScalar
		val t = type
		switch t
		{
			Array1D : buildArrayValue(t.size, expressionValue)
			Array2D : buildArrayValue(t.nbRows, t.nbCols, expressionValue)
			default: throw new RuntimeException('Wrong path...')
		}
	}
	
	static def dispatch NablaValue interprete(IntVectorConstant it) { new NSVIntArray1D(values) }
	static def dispatch NablaValue interprete(IntMatrixConstant it) { new NSVIntArray2D(toArray) }
	static def dispatch NablaValue interprete(RealVectorConstant it) { new NSVRealArray1D(values) }
	static def dispatch NablaValue interprete(RealMatrixConstant it) { new NSVRealArray2D(toArray) }

	static def dispatch NablaValue interprete(FunctionCall it)
	{
		val providerClassName = function.provider + fr.cea.nabla.ir.Utils::FunctionAndReductionproviderSuffix
		val providerClass = Class.forName(providerClassName)
		val types = args.map[x | x.type.javaType]
		val method = providerClass.getMethod(function.name, types)
		val argValues = args.map[x|x.interprete]
		val result = method.invoke(providerClass, argValues)
		return result.expressionValue
	}

	static def dispatch NablaValue interprete(VarRef it)
	{
		// TODO
		throw new RuntimeException('Not yet implemented')	
	}
	
	private static def dispatch Class<?> getJavaType(NSVBoolScalar it, int inc) { getJavaBoolType(inc) }
	private static def dispatch Class<?> getJavaType(NSVIntScalar it, int inc) { getJavaIntType(inc) }
	private static def dispatch Class<?> getJavaType(NSVRealScalar it, int inc) { getJavaRealType(inc) }
	private static def dispatch Class<?> getJavaType(NSVBoolArray1D it, int inc) { getJavaBoolType(1 + inc) }
	private static def dispatch Class<?> getJavaType(NSVIntArray1D it, int inc) { getJavaIntType(1 + inc) }
	private static def dispatch Class<?> getJavaType(NSVRealArray1D it, int inc) { getJavaRealType(1 + inc) }
	private static def dispatch Class<?> getJavaType(NSVBoolArray2D it, int inc) { getJavaBoolType(2 + inc) }
	private static def dispatch Class<?> getJavaType(NSVIntArray2D it, int inc) { getJavaIntType(2 + inc) }
	private static def dispatch Class<?> getJavaType(NSVRealArray2D it, int inc) { getJavaRealType(2 + inc) }
	private static def dispatch Class<?> getJavaType(NablaConnectivityValue it) { values.get(0).getJavaType(values.size) }
	
	private static def Class<?> getJavaBoolType(int nbDimensions)
	{
		switch nbDimensions
		{
			case 0: boolean
			case 1: typeof(boolean[])
			case 2: typeof(boolean[][])
			case 3: typeof(boolean[][][])
			case 4: typeof(boolean[][][][])
			default: throw new RuntimeException('Invalid type')
		}
	}

	private static def Class<?> getJavaIntType(int nbDimensions)
	{
		switch nbDimensions
		{
			case 0: int
			case 1: typeof(int[])
			case 2: typeof(int[][])
			case 3: typeof(int[][][])
			case 4: typeof(int[][][][])
			default: throw new RuntimeException('Invalid type')
		}
	}

	private static def Class<?> getJavaRealType(int nbDimensions)
	{
		switch nbDimensions
		{
			case 0: double
			case 1: typeof(double[])
			case 2: typeof(double[][])
			case 3: typeof(double[][][])
			case 4: typeof(double[][][][])
			default: throw new RuntimeException('Invalid type')
		}
	}

	private static def getNablaValue(Object o)
	{
		switch o
		{
			Boolean: new BoolValue(o as boolean)
			Integer: new IntValue(o as int)
			Double: new RealValue(o as double)
			default: throw new UnexpectedTypeException(#[boolean, int, double], o.class)
		}
	}
	
	private static def dispatch NablaValue buildArrayValue(int size, NSVBoolScalar value)
	{
		val values = newBooleanArrayOfSize(size)
		Arrays.fill(values, value.value)
		return new NSVBoolArray1D(values)
	}
	
	private static def dispatch NablaValue buildArrayValue(int size, NSVIntScalar value)
	{
		val values = newIntArrayOfSize(size)
		Arrays.fill(values, value.value)
		return new NSVIntArray1D(values)
	}

	private static def dispatch NablaValue buildArrayValue(int size, NSVRealScalar value)
	{
		val values = newDoubleArrayOfSize(size)
		Arrays.fill(values, value.value)
		return new NSVRealArray1D(values)
	}
	
	private static def dispatch NablaValue buildArrayValue(int nbRows, int nbCols, NSVBoolScalar value)
	{
		val values = newArrayOfSize(nbRows).map[newBooleanArrayOfSize(nbCols)]
		values.forEach[x | Arrays.fill(x, value.value)]
		return new NSVBoolArray2D(values)
	}

	private static def dispatch NablaValue buildArrayValue(int nbRows, int nbCols, NSVIntScalar value)
	{
		val values = newArrayOfSize(nbRows).map[newIntArrayOfSize(nbCols)]
		values.forEach[x | Arrays.fill(x, value.value)]
		return new NSVIntArray2D(values)
	}

	private static def dispatch NablaValue buildArrayValue(int nbRows, int nbCols, NSVRealScalar value)
	{
		val values = newArrayOfSize(nbRows).map[newDoubleArrayOfSize(nbCols)]
		values.forEach[x | Arrays.fill(x, value.value)]
		return new NSVRealArray2D(values)
	}
	
	private static def int[][] toArray(IntMatrixConstant it)
	{
		val newRows = newArrayOfSize(values.size)
		for (i : 0..<newRows.size) 
		{
			val row = values.get(i)
			val newCols = newIntArrayOfSize(row.values.size)
			for (j: 0..<newCols.size) newCols.set(j, row.values.get(j))
			newRows.set(i, newCols)
		}
		return newRows
	}

	private static def double[][] toArray(RealMatrixConstant it)
	{
		val newRows = newArrayOfSize(values.size)
		for (i : 0..<newRows.size) 
		{
			val row = values.get(i)
			val newCols = newDoubleArrayOfSize(row.values.size)
			for (j: 0..<newCols.size) newCols.set(j, row.values.get(j))
			newRows.set(i, newCols)
		}
		return newRows
	}
}