/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir

import fr.cea.nabla.ir.ir.IterableInstruction
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.Variable

class JobExtensions
{
	static def hasIterable(Job it)
	{
		!eAllContents.filter(IterableInstruction).empty
	}

	static def hasLoop(Job it)
	{
		!eAllContents.filter(Loop).empty
	}

	static def getIteratorByName(Job it, String itName)
	{
		var iterators = eAllContents.filter(Iterator).toList
		return iterators.findFirst[index.name == itName]
	}

	static def getVariableByName(Job it, String varName)
	{
		var variables = eAllContents.filter(Variable).toList
		return variables.findFirst[x | x.name == varName]
	}
}