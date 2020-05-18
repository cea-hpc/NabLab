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
		name.replace('\u03B1', 'alpha')
		.replace('\u03B2', 'beta')
		.replace('\u03B3', 'gamma') 
		.replace('\u03B4', 'delta')
		.replace('\u03B5', 'epsilon')
		.replace('\u03BB', 'lambda')
		.replace('\u03C1', 'rho')
		.replace('\u2126', 'omega')
		.replace('\u221A', 'sqrt')
		.replace('∑', 'sum')
		.replace('∏', 'prod')
	}
}