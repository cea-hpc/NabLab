/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.ir.IrRoot

class PreventFunctionOverloading extends IrTransformationStep
{
	new()
	{
		super('Give a unique name to functions to prevent function overloading')
	}

	override transform(IrRoot ir)
	{
		trace('    IR -> IR: ' + description)

		for (m : ir.modules)
		{
			val functionByNames = m.functions.groupBy[name]
			for (name : functionByNames.keySet)
			{
				val functions = functionByNames.get(name)
				// if more than one function with the same name, add an index to the name
				if (functions.size > 1)
				{
					for (i : 0..<functions.size)
						functions.get(i).name = name + i
				}
			}
		}

		return true
	}
}
