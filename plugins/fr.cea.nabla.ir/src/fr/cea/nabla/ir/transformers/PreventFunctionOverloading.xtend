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

import fr.cea.nabla.ir.ir.DefaultExtensionProvider
import fr.cea.nabla.ir.ir.Function
import fr.cea.nabla.ir.ir.IrRoot

class PreventFunctionOverloading extends IrTransformationStep
{
	override getDescription()
	{
		"Give a unique name to functions to prevent function overloading"
	}

	override transform(IrRoot ir, (String)=>void traceNotifier)
	{
		for (m : ir.modules)
			ensureUniqueNames(m.functions)

		for (p : ir.providers.filter(DefaultExtensionProvider))
			ensureUniqueNames(p.functions)
	}

	override transform(DefaultExtensionProvider dep, (String)=>void traceNotifier)
	{
		ensureUniqueNames(dep.functions)
	}

	private def ensureUniqueNames(Iterable<? extends Function> functions)
	{
		for (f : functions.filter[x | x.indexInName > 0])
			f.name = f.name + f.indexInName
	}
}
