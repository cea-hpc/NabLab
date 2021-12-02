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

class ReplaceOperatorNames extends IrTransformationStep
{
	public static val OperatorNames = #{
		'+' -> 'plus',
		'-' -> 'minus',
		'/' -> 'divide',
		'*' -> 'multiply'
	}

	new()
	{
		super('Replace operator symbols when not enable in function names')
	}

	override transform(IrRoot ir)
	{
		trace('    IR -> IR: ' + description)
		for (m : ir.modules)
			for (f : m.functions)
				for (opName : OperatorNames.entrySet)
					if (f.name == OperatorUtils.OperatorPrefix + opName.key)
						f.name = opName.value

		return true
	}
}
