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

import fr.cea.nabla.ir.ir.ArgOrVarRef
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.BaseTypeConstant
import fr.cea.nabla.ir.ir.BinaryExpression
import fr.cea.nabla.ir.ir.BoolConstant
import fr.cea.nabla.ir.ir.Cardinality
import fr.cea.nabla.ir.ir.ContractedIf
import fr.cea.nabla.ir.ir.Expression
import fr.cea.nabla.ir.ir.ExternFunction
import fr.cea.nabla.ir.ir.Function
import fr.cea.nabla.ir.ir.FunctionCall
import fr.cea.nabla.ir.ir.IntConstant
import fr.cea.nabla.ir.ir.InternFunction
import fr.cea.nabla.ir.ir.IrType
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.LinearAlgebraType
import fr.cea.nabla.ir.ir.MaxConstant
import fr.cea.nabla.ir.ir.MinConstant
import fr.cea.nabla.ir.ir.Parenthesis
import fr.cea.nabla.ir.ir.RealConstant
import fr.cea.nabla.ir.ir.SimpleVariable
import fr.cea.nabla.ir.ir.UnaryExpression
import fr.cea.nabla.ir.ir.VectorConstant
import java.util.Arrays

import static fr.cea.nabla.ir.interpreter.InstructionInterpreter.*
import static fr.cea.nabla.ir.interpreter.IrTypeExtensions.*
import static fr.cea.nabla.ir.interpreter.NablaValueGetter.*
import static fr.cea.nabla.ir.interpreter.NablaValueSetter.*

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.ContainerExtensions.*
import static extension fr.cea.nabla.ir.interpreter.NablaValueExtensions.*

class ExpressionInterpreter
{

	// Switch to more efficient dispatch (also clearer for profiling)
	static def NablaValue interprete(Expression it, Context context) {
		if (it instanceof ArgOrVarRef) {
			return interpreteArgOrVarRef(context)
		} else if (it instanceof BaseTypeConstant) {
			return interpreteBaseTypeConstant(context)
		} else if (it instanceof BinaryExpression) {
			return interpreteBinaryExpression(context)
		} else if (it instanceof BoolConstant) {
			return interpreteBoolConstant(context)
		} else if (it instanceof ContractedIf) {
			return interpreteContractedIf(context)
		} else if (it instanceof FunctionCall) {
			return interpreteFunctionCall(context)
		} else if (it instanceof IntConstant) {
			return interpreteIntConstant(context)
		} else if (it instanceof MaxConstant) {
			return interpreteMaxConstant(context)
		} else if (it instanceof MinConstant) {
			return interpreteMinConstant(context)
		} else if (it instanceof Parenthesis) {
			return interpreteParenthesis(context)
		} else if (it instanceof RealConstant) {
			return interpreteRealConstant(context)
		} else if (it instanceof UnaryExpression) {
			return interpreteUnaryExpression(context)
		} else if (it instanceof VectorConstant) {
			return interpreteVectorConstant(context)
		} else if (it instanceof Cardinality) {
			return interpreteCardinality(context)
		} else {
			throw new IllegalArgumentException("Unhandled parameter types: " +
				Arrays.<Object>asList(it, context).toString())
		}
	}

	static def NablaValue interpreteContractedIf(ContractedIf it, Context context)
	{
		context.logFinest("Interprete ContractedIf")
		val condValue = condition.interprete(context)
		if ((condValue as NV0Bool).data) thenExpression.interprete(context)
		else elseExpression.interprete(context)
	}

	static def NablaValue interpreteBinaryExpression(BinaryExpression it, Context context)
	{
		context.logFinest("Interprete BinaryExpression")
		val lValue = left.interprete(context)
		val rValue = right.interprete(context)
		BinaryOperationsInterpreter::getValueOf(lValue, rValue, operator)
	}

	static def NablaValue interpreteUnaryExpression(UnaryExpression it, Context context)
	{
		context.logFinest("Interprete UnaryExpression")
		val eValue = expression.interprete(context)
		// Switch to more efficient dispatch
		if (eValue instanceof NV0Bool && it.operator == '!') {
			return new NV0Bool(!(eValue as NV0Bool).data)
		} else if (eValue instanceof NV0Int && it.operator == '-') {
			return new NV0Int(-(eValue as NV0Int).data)
		} else if (eValue instanceof NV0Real && it.operator == '-') {
			return new NV0Real(-(eValue as NV0Real).data)
		} else if (eValue instanceof NV1Int && it.operator == '-') {
			return new NV1Int((eValue as NV1Int).data.map[x|-x])
		} else if (eValue instanceof NV1Real && it.operator == '-') {
			return new NV1Real((eValue as NV1Real).data.map[x|-x])
		} else if (eValue instanceof NV2Int && it.operator == '-') {
			return computeUnaryMinus(eValue as NV2Int)
		} else if (eValue instanceof NV2Real && it.operator == '-') {
			return computeUnaryMinus(eValue as NV2Real)
		} else {
			throw new RuntimeException('Wrong unary operator: ' + operator)
		}
	}

	static def NablaValue interpreteParenthesis(Parenthesis it, Context context)
	{
		context.logFinest("Interprete Parenthesis")
		expression.interprete(context)
	}

	static def NablaValue interpreteIntConstant(IntConstant it, Context context)
	{
		context.logFinest("Interprete IntConstant")
		new NV0Int(value)
	}

	static def NablaValue interpreteRealConstant(RealConstant it, Context context)
	{
		context.logFinest("Interprete RealConstant")
		new NV0Real(value)
	}

	static def NablaValue interpreteBoolConstant(BoolConstant it, Context context)
	{
		context.logFinest("Interprete BoolConstant")
		new NV0Bool(value)
	}

	static def NablaValue interpreteMinConstant(MinConstant it, Context context)
	{
		context.logFinest("Interprete MinConstant")
		val t = type as BaseType
		switch t.primitive
		{
			case BOOL: throw new RuntimeException('No min constant on bool')
			case INT: new NV0Int(Integer.MIN_VALUE)
			// Be careful at MIN_VALUE which is a positive value for double.
			case REAL: new NV0Real(-Double.MAX_VALUE)
		}
	}

	static def NablaValue interpreteMaxConstant(MaxConstant it, Context context)
	{
		context.logFinest("Interprete MaxConstant")
		val t = type as BaseType
		switch t.primitive
		{
			case BOOL: throw new RuntimeException('No max constant on bool')
			case INT: new NV0Int(Integer.MAX_VALUE)
			case REAL: new NV0Real(Double.MAX_VALUE)
		}
	}

	static def NablaValue interpreteBaseTypeConstant(BaseTypeConstant it, Context context)
	{
		context.logFinest("Interprete BaseTypeConstant")
		val expressionValue = value.interprete(context)
		val t = type as BaseType
		val sizes = getIntSizes(t, context)
		switch sizes.size
		{
			case 0: expressionValue
			case 1: buildArrayValue(sizes.get(0), expressionValue)
			case 2: buildArrayValue(sizes.get(0), sizes.get(1), expressionValue)
			default: throw new RuntimeException('Wrong path...')
		}
	}

	static def NablaValue interpreteVectorConstant(VectorConstant it, Context context)
	{
		context.logFinest("Interprete VectorConstant")
		val expressionValues = values.map[x | interprete(x, context)]
		val t = type as BaseType
		val value = BaseTypeValueFactory.createValue(t, context, false)
		for (i : 0..<expressionValues.length)
			setValue(value, #[i], expressionValues.get(i))
		return value
	}

	static def NablaValue interpreteCardinality(Cardinality it, Context context)
	{
		context.logFinest("Interprete Cardinality")
		if (container.connectivity.multiple)
		{
			val container = context.getContainerValue(container)
			new NV0Int(container.size)
		}
		else
			new NV0Int(1)
	}

	static def NablaValue interpreteFunctionCall(FunctionCall it, Context context)
	{
		context.logFinest("Interprete FunctionCall " + function.name)
		val argValues = args.map[x|interprete(x, context)]
		val f = function
		switch f
		{
			ExternFunction:
			{
				// Use method cache instead of resolving on each iteration
				val javaValues = argValues.map[x|FunctionCallHelper.getJavaValue(x, context.linearAlgebra)].toArray
				val result = invokeMethod(context, f, javaValues)
				return FunctionCallHelper.createNablaValue(result, context.linearAlgebra)
			}
			InternFunction:
			{
				val innerContext = new Context(context)
				for (iArg : 0..<args.length)
				{
					// set DimensionSymbol values with argument types
					val callerArg = args.get(iArg)
					val calleeArg = f.inArgs.get(iArg)
					val callerArgTypeSizes = getIntSizes(callerArg.type, context)
					for (iSize : 0..<callerArgTypeSizes.length)
					{
						val callerArgTypeSize = callerArgTypeSizes.get(iSize)
						val calleeArgTypeDimension = calleeArg.type.sizes.get(iSize)
						if (calleeArgTypeDimension instanceof ArgOrVarRef)
							if (calleeArgTypeDimension.target instanceof SimpleVariable)
								innerContext.addVariableValue(calleeArgTypeDimension.target, new NV0Int(callerArgTypeSize))
					}
	
					// set argument value
					innerContext.addVariableValue(calleeArg, argValues.get(iArg))
				}
				return interprete(f.body, innerContext)
			}
		}
	}

	static def NablaValue interpreteArgOrVarRef(ArgOrVarRef it, Context context)
	{
		context.logFinest("Interprete VarRef " + target.name)
		val value = if (target.iteratorCounter)
				new NV0Int(context.getIndexValue((target.eContainer as Iterator).index))
			else
				context.getVariableValue(target)

		// Switch to more efficient implementation (avoid costly toList calls)
		val allIndices = newArrayList
		iterators.forEach[x|allIndices.add(context.getIndexValue(x))]
		allIndices.addAll(interpreteDimensionExpressions(indices, context))
		getValue(value, allIndices)
	}

	static def int[] interpreteDimensionExpressions(Iterable<Expression> dimensionExpressions, Context context)
	{
		val values = newIntArrayOfSize(dimensionExpressions.size)
		for (i : 0..<dimensionExpressions.size)
		{
			val value = interprete(dimensionExpressions.get(i), context)
			if (value instanceof NV0Int)
				values.set(i, value.data)
			else
				throw new RuntimeException("Unsupported type for Dimension: " + value.class)
		}
		return values
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
		//If we don't precise type for values, Arrays.fill does not work ...
		val boolean[][]values = newArrayOfSize(nbRows).map[newBooleanArrayOfSize(nbCols)]
		values.forEach[x | Arrays.fill(x, value.data)]
		return new NV2Bool(values)
	}

	private static def dispatch NablaValue buildArrayValue(int nbRows, int nbCols, NV0Int value)
	{
		//If we don't precise type for values, Arrays.fill does not work ...
		val int[][] values = newArrayOfSize(nbRows).map[newIntArrayOfSize(nbCols)]
		values.forEach[x | Arrays.fill(x, value.data)]
		return new NV2Int(values)
	}

	private static def dispatch NablaValue buildArrayValue(int nbRows, int nbCols, NV0Real value)
	{
		//If we don't precise type for values, Arrays.fill does not work ...
		val double[][] values = newArrayOfSize(nbRows).map[newDoubleArrayOfSize(nbCols)]
		values.forEach[x | Arrays.fill(x, value.data)]
		return new NV2Real(values)
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

	private static def Object invokeMethod(Context context, Function it, Object[] args)
	{
		val pair = context.functionToMethod.get(it)
		val providerInstance = pair.key
		val method = pair.value
		return method.invoke(providerInstance, args)
	}

	private static def getSizes(IrType it)
	{
		switch it
		{
			BaseType: sizes
			LinearAlgebraType: sizes
			default: throw new RuntimeException("Unsuported argument")
		}
	}
}