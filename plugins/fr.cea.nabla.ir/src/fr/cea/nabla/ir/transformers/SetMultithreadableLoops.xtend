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

import fr.cea.nabla.ir.IrUtils
import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.ArgOrVarRef
import fr.cea.nabla.ir.ir.DefaultExtensionProvider
import fr.cea.nabla.ir.ir.ExternFunction
import fr.cea.nabla.ir.ir.FunctionCall
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.IterableInstruction
import fr.cea.nabla.ir.ir.Loop

class SetMultithreadableLoops extends IrTransformationStep
{
	override getDescription()
	{
		"Set all multithreadable loops"
	}

	override transform(IrRoot ir, (String)=>void traceNotifier)
	{
		for (l : ir.eAllContents.filter(Loop).toIterable)
			l.multithreadable = isMultithread(l)
	}

	override transform(DefaultExtensionProvider dep, (String)=>void traceNotifier)
	{
		for (l : dep.eAllContents.filter(Loop).toIterable)
			l.multithreadable = isMultithread(l)
	}

	private def isMultithread(Loop l)
	{
		// top level loop
		val isTopLevelLoop = IrUtils.getContainerOfType(l.eContainer, IterableInstruction) === null
		if (!isTopLevelLoop) return false

		// no external function calls
		val externFunctions = l.eAllContents.filter(FunctionCall).map[function].filter(ExternFunction)
		val externFunctionCall = externFunctions.exists[x | x.provider.extensionName != "LinearAlgebra" && x.provider.extensionName != "Math"]
		if (externFunctionCall) return false

		// no variable in/out (only possible on local variable)
		for (a : l.eAllContents.filter(Affectation).toIterable)
		{
			// except if its in an inner loop
			if (IrUtils.getContainerOfType(a, IterableInstruction) === l)
			{
				val outVar = a.left.target
				// a.right.eAllContents.filter(ArgOrVarRef) will forget a simple ArgOrVarRef object
				// => a.eAllContents.filter(ArgOrVarRef) will not but l.left must be filtered
				for(r : a.eAllContents.filter(ArgOrVarRef).filter[x | x !== a.left].toIterable)
					if (r.target === outVar)
						return false
			}
		}

		return true
	}
}
