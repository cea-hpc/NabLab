package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.Utils
import fr.cea.nabla.ir.ir.Array1D
import fr.cea.nabla.ir.ir.Array2D
import fr.cea.nabla.ir.ir.BaseTypeConstant
import fr.cea.nabla.ir.ir.BinaryExpression
import fr.cea.nabla.ir.ir.Constant
import fr.cea.nabla.ir.ir.ContractedIf
import fr.cea.nabla.ir.ir.FunctionCall
import fr.cea.nabla.ir.ir.IntMatrixConstant
import fr.cea.nabla.ir.ir.IntVectorConstant
import fr.cea.nabla.ir.ir.MaxConstant
import fr.cea.nabla.ir.ir.MinConstant
import fr.cea.nabla.ir.ir.Parenthesis
import fr.cea.nabla.ir.ir.RealMatrixConstant
import fr.cea.nabla.ir.ir.RealVectorConstant
import fr.cea.nabla.ir.ir.Scalar
import fr.cea.nabla.ir.ir.UnaryExpression
import fr.cea.nabla.ir.ir.VarRef
import java.util.Arrays

import static fr.cea.nabla.ir.interpreter.NablaValueGetter.*

import static extension fr.cea.nabla.ir.interpreter.NablaValueExtensions.*

class ExpressionInterpreter 
{
	static def dispatch NablaValue interprete(ContractedIf it, Context context)
	{
		println("Dans interprete de ContractedIf")
		val condValue = condition.interprete(context)
		if ((condValue as NV0Bool).data) thenExpression.interprete(context)
		else elseExpression.interprete(context) 
	}
	
	static def dispatch NablaValue interprete(BinaryExpression it, Context context)	
	{
		println("Dans interprete de BinaryExpression")
		val lValue = left.interprete(context)
		val rValue = right.interprete(context)
		BinaryOperationsInterpreter::getValueOf(lValue, rValue, operator)
	}
	
	static def dispatch NablaValue interprete(UnaryExpression it, Context context)
	{
		println("Dans interprete de UnaryExpression")
		val eValue = expression.interprete(context)
		switch eValue
		{
			NV0Bool case operator == '!': new NV0Bool(!eValue.data)
			NV0Int case operator == '-': new NV0Int(-eValue.data)
			NV0Real case operator == '-': new NV0Real(-eValue.data)
			NV1Int case operator == '-': new NV1Int(eValue.data.map[x|-x])
			NV1Real case operator == '-': new NV1Real(eValue.data.map[x|-x])
			NV2Int case operator == '-': computeUnaryMinus(eValue)
			NV2Real case operator == '-': computeUnaryMinus(eValue)
			default: throw new RuntimeException('Wrong unary operator: ' + operator)
		}
	}
	
	private static def computeUnaryMinus(NV2Int a)
	{
		val int[][] res = newArrayOfSize(a.nbRows).map[x | newIntArrayOfSize(a.nbCols)]
		for (i : 0..<a.nbRows)
			for (j : 0..<a.nbCols)
				res.get(i).set(j, -a.data.get(i).get(j))
		return new NV2Int(res)		
	}

	private static def computeUnaryMinus(NV2Real a)
	{
		val double[][] res = newArrayOfSize(a.nbRows).map[x | newDoubleArrayOfSize(a.nbCols)]
		for (i : 0..<a.nbRows)
			for (j : 0..<a.nbCols)
				res.get(i).set(j, -a.data.get(i).get(j))
		return new NV2Real(res)		
	}

	static def dispatch NablaValue interprete(Parenthesis it, Context context)
	{
		println("Dans interprete de Parenthesis")
		expression.interprete(context)
	}

	static def dispatch NablaValue interprete(Constant it, Context context) 
	{ 
		println("Dans interprete de Constant")
		val t = type as Scalar
		switch t.primitive
		{
			case BOOL: new NV0Bool(Boolean.parseBoolean(value))
			case INT: new NV0Int(Integer.parseInt(value))
			case REAL: new NV0Real(Double.parseDouble(value))
		}
	}
	
	static def dispatch NablaValue interprete(MinConstant it, Context context)
	{
		println("Dans interprete de MinConstant")
		val t = type as Scalar
		switch t.primitive
		{
			case BOOL: throw new RuntimeException('No min constant on bool')
			case INT: new NV0Int(Integer.MIN_VALUE)
			case REAL: new NV0Real(Double.MIN_VALUE)
		}
	}
	
	static def dispatch NablaValue interprete(MaxConstant it, Context context)
	{
		println("Dans interprete de MaxConstant")
		val t = type as Scalar
		switch t.primitive
		{
			case BOOL: throw new RuntimeException('No max constant on bool')
			case INT: new NV0Int(Integer.MAX_VALUE)
			case REAL: new NV0Real(Double.MAX_VALUE)
		}
	}

	static def dispatch NablaValue interprete(BaseTypeConstant it, Context context)
	{
		println("Dans interprete de BaseTypeConstant")
		val expressionValue = value.interprete(context)
		val t = type
		switch t
		{
			Scalar : expressionValue
			Array1D : buildArrayValue(t.size, expressionValue)
			Array2D : buildArrayValue(t.nbRows, t.nbCols, expressionValue)
			default: throw new RuntimeException('Wrong path...')
		}
	}
	
	static def dispatch NablaValue interprete(IntVectorConstant it, Context context) { println("Dans interprete de IntVectorConstant") new NV1Int(values) }
	static def dispatch NablaValue interprete(IntMatrixConstant it, Context context) { println("Dans interprete de IntMatrixConstant") new NV2Int(toArray) }
	static def dispatch NablaValue interprete(RealVectorConstant it, Context context) { println("Dans interprete de RealVectorConstant") new NV1Real(values) }
	static def dispatch NablaValue interprete(RealMatrixConstant it, Context context) { println("Dans interprete de RealMatrixConstant") new NV2Real(toArray) }

	static def dispatch NablaValue interprete(FunctionCall it, Context context)
	{
		println("Dans interprete de FunctionCall")

		//TODO : correct this
		val providerClassName = "fr.cea.nabla.tests." + function.provider + Utils::FunctionAndReductionproviderSuffix
		val providerClass = Class.forName(providerClassName)
		val argValues = args.map[x|x.interprete(context)]
		val javaTypes = argValues.map[x | FunctionCallHelper.getJavaType(x) ]
		val method = providerClass.getDeclaredMethod(function.name, javaTypes)
		method.setAccessible(true)
		val javaValues = argValues.map[x | FunctionCallHelper.getJavaValue(x)].toArray
		val result = method.invoke(null, javaValues)
		return FunctionCallHelper.createNablaValue(result)
	}

	static def dispatch NablaValue interprete(VarRef it, Context context)
	{
		println("Dans interprete de VarRef")
		val value = context.getVariableValue(variable)
		val allIndices = iterators.map[x | context.getIndexValue(x)] + indices
		getValue(value, allIndices.toList)
	}
	
	private static def dispatch NablaValue buildArrayValue(int size, NV0Bool value)
	{
		val values = newBooleanArrayOfSize(size)
		Arrays.fill(values, value.data)
		return new NV1Bool(values)
	}
	
	private static def dispatch NablaValue buildArrayValue(int size, NV0Int value)
	{
		val values = newIntArrayOfSize(size)
		Arrays.fill(values, value.data)
		return new NV1Int(values)
	}

	private static def dispatch NablaValue buildArrayValue(int size, NV0Real value)
	{
		val values = newDoubleArrayOfSize(size)
		Arrays.fill(values, value.data)
		return new NV1Real(values)
	}
	
	private static def dispatch NablaValue buildArrayValue(int nbRows, int nbCols, NV0Bool value)
	{
		//TODO If we don't precise type for values, Arrays.fill does not work ...
		val boolean[][]values = newArrayOfSize(nbRows).map[newBooleanArrayOfSize(nbCols)]
		values.forEach[x | Arrays.fill(x, value.data)]
		return new NV2Bool(values)
	}

	private static def dispatch NablaValue buildArrayValue(int nbRows, int nbCols, NV0Int value)
	{
		//TODO If we don't precise type for values, Arrays.fill does not work ...
		val int[][] values = newArrayOfSize(nbRows).map[newIntArrayOfSize(nbCols)]
		values.forEach[x | Arrays.fill(x, value.data)]
		return new NV2Int(values)
	}

	private static def dispatch NablaValue buildArrayValue(int nbRows, int nbCols, NV0Real value)
	{
		//TODO If we don't precise type for values, Arrays.fill does not work ...
		val double[][] values = newArrayOfSize(nbRows).map[newDoubleArrayOfSize(nbCols)]
		values.forEach[x | Arrays.fill(x, value.data)]
		return new NV2Real(values)
	}
	
	private static def int[][] toArray(IntMatrixConstant it)
	{
		val nbRows = values.size
		val nbCols = values.get(0).values.size
		//TODO If we don't precise type for result, set does not work ...
		val int[][] result = newArrayOfSize(nbRows).map[newIntArrayOfSize(nbCols)]
		for (i : 0..<nbRows) 
			for (j : 0..<nbCols)
				result.get(i).set(j, values.get(i).values.get(j))			
		return result
	}

	private static def double[][] toArray(RealMatrixConstant it)
	{
		val nbRows = values.size
		val nbCols = values.get(0).values.size
		//TODO If we don't precise type for result, set does not work ...
		val double[][] result = newArrayOfSize(nbRows).map[newDoubleArrayOfSize(nbCols)]
		for (i : 0..<nbRows) 
			for (j : 0..<nbCols)
				result.get(i).set(j, values.get(i).values.get(j))
		return result
	}
}