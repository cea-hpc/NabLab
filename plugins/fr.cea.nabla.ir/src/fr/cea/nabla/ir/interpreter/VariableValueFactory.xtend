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

import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.Expression
import fr.cea.nabla.ir.ir.LinearAlgebraType
import fr.cea.nabla.ir.ir.PrimitiveType

import static fr.cea.nabla.ir.interpreter.BaseTypeValueFactory.*
import static fr.cea.nabla.ir.interpreter.ExpressionInterpreter.*
import static fr.cea.nabla.ir.interpreter.IrTypeExtensions.*
import static fr.cea.nabla.ir.interpreter.NablaValueFactory.*
import static fr.cea.nabla.ir.interpreter.NablaValueSetter.*

import static extension fr.cea.nabla.ir.IrTypeExtensions.*

class VariableValueFactory
{
	static def dispatch NablaValue createValue(BaseType type, String name, Expression defaultValue, Context context)
	{
		if (type.sizes.empty)
		{
			val nv = createValue(type, name, context)
			if (defaultValue !== null)
				setValue(nv, #[], interprete(defaultValue, context))
			return nv
		}
		else
		{
			if (defaultValue === null)
				createValue(type, name, context)
			else
				interprete(defaultValue, context)
		}
	}

	static def dispatch NablaValue createValue(ConnectivityType type, String name, Expression defaultValue, Context context)
	{
		val sizes = getIntSizes(type, context)
		val p = type.primitive
		switch sizes.size
		{
			case 1: createValue(p, name, sizes.get(0), null)
			case 2: createValue(p, name, sizes.get(0), sizes.get(1), null)
			case 3: createValue(p, sizes.get(0), sizes.get(1), sizes.get(2))
			case 4: createValue(p, sizes.get(0), sizes.get(1), sizes.get(2), sizes.get(3))
			default: throw new RuntimeException("Dimension not yet implemented: " + sizes.size)
		}
	}

	static def dispatch NablaValue createValue(LinearAlgebraType type, String name, Expression defaultValue, Context context)
	{
		val sizes = getIntSizes(type, context)
		val p = PrimitiveType.REAL
		val provider = ExtensionProviderCache.Instance.get(type.provider)
		switch sizes.size
		{
			case 1: createValue(p, name, sizes.get(0), provider)
			case 2: createValue(p, name, sizes.get(0), sizes.get(1), provider)
			default: throw new RuntimeException("Dimension not yet implemented: " + sizes.size)
		}
	}
}