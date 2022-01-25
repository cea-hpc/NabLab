/*******************************************************************************
 * Copyright (c) 2022 CEA
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
import fr.cea.nabla.ir.ir.IrType
import fr.cea.nabla.ir.ir.LinearAlgebraType

import static fr.cea.nabla.ir.interpreter.ExpressionInterpreter.*

class IrTypeExtensions
{
	static def int[] getIntSizes(IrType t, Context context)
	{
		switch t
		{
			ConnectivityType: t.connectivities.map[x | context.mesh.getSize(x)] + getIntSizes(t.base, context)
			BaseType:
				if (t.isStatic)
					t.intSizes
				else
					computeDynamicSizes(t.sizes, t.intSizes, context)
			LinearAlgebraType:
				if (t.isStatic)
					t.intSizes
				else
					computeDynamicSizes(t.sizes, t.intSizes, context)
		}
	}

	private static def computeDynamicSizes(Iterable<Expression> sizes, int[] intSizes, Context context)
	{
		val values = newIntArrayOfSize(intSizes.size)
		for (i : 0..<intSizes.size)
		{
			if (intSizes.get(i) == fr.cea.nabla.ir.IrTypeExtensions::DYNAMIC_SIZE)
				values.set(i, interpreteSize(sizes.get(i), context))
			else
				values.set(i, intSizes.get(i))
		}
		return values
	}
}