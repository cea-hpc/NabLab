/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.arcane

import fr.cea.nabla.ir.IrTypeExtensions
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.Expression
import fr.cea.nabla.ir.ir.IntConstant
import fr.cea.nabla.ir.ir.IrType
import fr.cea.nabla.ir.ir.LinearAlgebraType
import fr.cea.nabla.ir.ir.PrimitiveType

class TypeContentProvider
{
	static def getTypeName(IrType it)
	{
		switch it
		{
			case null: null
			BaseType:
			{
				val t = typeNameAndDimension
				val dimension = t.value
				switch dimension
				{
					case 0: t.key
					case 1: '''ConstArrayView<«t.key»>'''
					default: '''ConstArray«dimension»View<«t.key»>'''
				}
			}
			ConnectivityType: getVariableTypeName(it)
			LinearAlgebraType: IrTypeExtensions.getLinearAlgebraClass(it)
			default: throw new RuntimeException("Unexpected type: " + class.name)
		}
	}

	static def dispatch getVariableTypeName(ConnectivityType it)
	{
		val support = connectivities.head.returnType.name.toFirstUpper
		val t = base.typeNameAndDimension
		val dimension = connectivities.size - 1 + t.value
		return "Variable" + support + getVariableDimensionName(dimension, true) + t.key
	}

	static def dispatch getVariableTypeName(BaseType it)
	{
		val t = typeNameAndDimension
		return "Variable" + getVariableDimensionName(t.value, false) + t.key
	}

	static def dispatch getVariableTypeName(LinearAlgebraType it)
	{
		throw new Exception("Not yet implemented")
	}

	static def Pair<String, Integer> getTypeNameAndDimension(BaseType it)
	{
		if (primitive == PrimitiveType.REAL)
		{
			if (sizes.size == 1)
			{
				val s = sizes.get(0).intValue
				if (s == 2) return 'Real2' -> 0
				if (s == 3) return 'Real3' -> 0
			}
			else if (sizes.size == 2)
			{
				val x = sizes.get(0).intValue
				val y = sizes.get(1).intValue
				if (x == 2 && y == 2) return 'Real2x2' -> 0
				if (x == 3 && y == 3) return 'Real3x3' -> 0
			}
		}

		// All the other cases
		val typeName = switch primitive
		{
			case BOOL: 'Bool'
			case INT: 'Integer'
			case REAL: 'Real'
		}
		return typeName -> sizes.size
	}

	private static def getVariableDimensionName(int dimension, boolean hasSupport)
	{
		switch dimension
		{
			case 0: (hasSupport ? "" : "Scalar")
			case 1: "Array"
			case 2: "Array2"
			default: throw new Exception("Unsupported dimension for variable type: " + dimension)
		}
	}

	private static def getIntValue(Expression e)
	{
		if (e instanceof IntConstant) e.value
		else -1
	}
}