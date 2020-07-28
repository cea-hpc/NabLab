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
import fr.cea.nabla.ir.ir.ReductionInstruction
import fr.cea.nabla.ir.ir.Variable
import fr.cea.nabla.ir.ir.TimeLoopVariable

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

	new()
	{
		super('Replace UTF8 characters in function, variable and job names by ASCII characters')
	}

	override transform(IrModule m)
	{
		trace('IR -> IR: ' + description)
		m.eAllContents.filter(Variable).forEach[x | x.name = x.name.noUtf8]
		m.eAllContents.filter(TimeLoopVariable).forEach[x | x.name = x.name.noUtf8]
		m.eAllContents.filter(ReductionInstruction).forEach[x | x.result.name = x.result.name.noUtf8]
		m.connectivities.forEach[x | x.name = x.name.noUtf8]
		m.functions.forEach[x | x.name = x.name.noUtf8]
		m.jobs.forEach[x | x.name = x.name.noUtf8]
		return true
	}

	static def getNoUtf8(String name)
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