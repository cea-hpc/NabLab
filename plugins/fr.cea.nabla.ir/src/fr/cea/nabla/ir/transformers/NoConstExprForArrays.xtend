/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.SimpleVariable

class NoConstExprForArrays extends IrTransformationStep
{
	new()
	{
		super('Set constExpr attribute value to false for arrays of fr.cea.nabla.cpplib (cstr constraint)')
	}

	override transform(IrModule m)
	{
		trace('IR -> IR: ' + description)
		for (v : m.eAllContents.filter(SimpleVariable).toIterable)
		{
			if (!v.type.sizes.empty)
				v.constExpr = false
		}
		return true
	}
}