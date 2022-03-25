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

import fr.cea.nabla.ir.ir.DefaultExtensionProvider
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.Loop
import org.eclipse.xtend.lib.annotations.Data

@Data
class SequentializeLoops extends IrTransformationStep
{
	override getDescription()
	{
		"Set all loops multithreadable attributes to false"
	}

	/**
	 * Replace inner reductions by a variable definition (accumulator) and a Loop.
	 * The loop contains an affectation with a call to the binary function of the reduction.
	 */
	override transform(IrRoot ir, (String)=>void traceNotifier)
	{
		for (l : ir.eAllContents.filter(Loop).toIterable)
			l.multithreadable = false
	}

	override transform(DefaultExtensionProvider dep, (String)=>void traceNotifier)
	{
		// nothing to do
	}
}
