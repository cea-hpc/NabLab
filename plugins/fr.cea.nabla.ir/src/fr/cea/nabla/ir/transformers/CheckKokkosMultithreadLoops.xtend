/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.ArgOrVar
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.DefaultExtensionProvider
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.VariableDeclaration

/**
 * For each loop candidate to Arcane accelerator API: 
 * - create a block and tag it,
 * - create local variables representing views.
 */
class CheckKokkosMultithreadLoops extends IrTransformationStep
{
	override getDescription()
	{
		"Set loops to sequential if it contains an affectation to a non Kokkos container"
	}

	override transform(IrRoot ir, (String)=>void traceNotifier)
	{
		for (l : ir.eAllContents.filter(Loop).filter[multithreadable].toIterable)
			l.multithreadable = isMultithread(l)
	}

	override protected transform(DefaultExtensionProvider dep, (String)=>void traceNotifier)
	{
		for (l : dep.eAllContents.filter(Loop).filter[multithreadable].toIterable)
			l.multithreadable = isMultithread(l)
	}

	private def isMultithread(Loop l)
	{
		// no out variable if not a loop local variable or not a Kokkos type (= a BaseType)
		for (a : l.eAllContents.filter(Affectation).toIterable)
			// except if its in an inner loop
			if (!isInScope(a.left.target, l) && a.left.target.type instanceof BaseType)
					return false

		return true
	}

	private def isInScope(ArgOrVar v, Loop context)
	{
		context.eAllContents.filter(VariableDeclaration).exists[x | x.variable === v]
	}
}
