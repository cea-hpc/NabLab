/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.cpp.arcane

import fr.cea.nabla.ir.IrTypeExtensions
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.ConnectivityType
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
			BaseType case sizes.empty: primitive.typeName
			BaseType: '''ConstArray«IF sizes.size > 1»«sizes.size»«ENDIF»View<«primitive.typeName»>'''
			ConnectivityType: getVariableTypeName(it)
			LinearAlgebraType: IrTypeExtensions.getLinearAlgebraClass(it)
			default: throw new RuntimeException("Unexpected type: " + class.name)
		}
	}

	static def dispatch getVariableTypeName(ConnectivityType it)
	{
		val support = connectivities.head.returnType.name.toFirstUpper
		val dimension = connectivities.size - 1 + base.sizes.size
		val dimensionName = switch dimension
		{
			case 0: ""
			case 1: "Array"
			case 2: "Array2"
			default: throw new Exception("Unsupported dimension for variable type: " + dimension)
		}
		return "Variable" + support + dimensionName + base.primitive.typeName
	}

	static def dispatch getVariableTypeName(BaseType it)
	{
		val dimensionName = switch sizes.size
		{
			case 0: "Scalar"
			case 1: "Array"
			case 2: "Array2"
			default: throw new Exception("Unsupported dimension for variable type: " + sizes.size)
		}
		return "Variable" + dimensionName + primitive.typeName
	}

	static def dispatch getVariableTypeName(LinearAlgebraType it)
	{
		throw new Exception("Not yet implemented")
	}

	static def getPrimitiveTypeName(IrType it)
	{
		IrTypeExtensions.getPrimitive(it).typeName
	}

	static def getTypeName(PrimitiveType it)
	{
		switch it
		{
			case BOOL: 'Bool'
			case INT: 'Integer'
			case REAL: 'Real'
		}
	}
}