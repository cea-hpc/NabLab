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

import fr.cea.nabla.ir.ir.ArgOrVar
import fr.cea.nabla.ir.ir.DefaultExtensionProvider
import fr.cea.nabla.ir.ir.Function
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.ReductionInstruction
import fr.cea.nabla.ir.ir.TimeVariable

import static extension fr.cea.nabla.ir.IrRootExtensions.*

class ReplaceUtf8Chars extends IrTransformationStep
{
	public static val UTF8Chars = #{
		'\u03B1' -> 'alpha',
		'\u03B2' -> 'beta',
		'\u03B3' -> 'gamma',
		'\u03B4' -> 'delta',
		'\u03B5' -> 'epsilon',
		'\u03B6' -> 'zeta',
		'\u03B7' -> 'eta',
		'\u03B8' -> 'theta',
		'\u03B9' -> 'iota',
		'\u03BA' -> 'kappa',
		'\u03BB' -> 'lambda',
		'\u03BC' -> 'mu',
		'\u03BD' -> 'nu',
		'\u03BE' -> 'xi',
		'\u03BF' -> 'omicron',
		'\u03C0' -> 'pi',
		'\u03C1' -> 'rho',
		'\u03C3' -> 'sigma',
		'\u03C4' -> 'tau',
		'\u03C5' -> 'upsilon',
		'\u03C6' -> 'phi',
		'\u03C7' -> 'chi',
		'\u03C8' -> 'psi',
		'\u03C9' -> 'omega',
		'\u2126' -> 'bigomega'
	}

	override getDescription()
	{
		"Replace UTF8 characters in function, variable and job names by ASCII characters"
	}

	override transform(IrRoot ir, (String)=>void traceNotifier)
	{
		for (v : ir.eAllContents.filter(ArgOrVar).toIterable)
		{
			v.name = v.name.noUtf8
			if (v instanceof TimeVariable)
				v.originName = v.originName.noUtf8
		}
		ir.eAllContents.filter(ReductionInstruction).forEach[x | x.result.name = x.result.name.noUtf8]
		ir.eAllContents.filter(Function).forEach[x | x.name = x.name.noUtf8]
		ir.jobs.forEach[x | x.name = x.name.noUtf8]
		ir.mesh.connectivities.forEach[x | x.name = x.name.noUtf8]
	}

	override transform(DefaultExtensionProvider dep, (String)=>void traceNotifier)
	{
		dep.functions.forEach[x | x.name = x.name.noUtf8]
	}

	private def getNoUtf8(String name)
	{
		var n = name
		for (c : UTF8Chars.entrySet)
			n = n.replace(c.key, c.value)

		n = n.replace('\u221A', 'sqrt')
		n = n.replace('\u2211', 'sum')
		n = n.replace('\u220f', 'prod')
		return n
	}
}
