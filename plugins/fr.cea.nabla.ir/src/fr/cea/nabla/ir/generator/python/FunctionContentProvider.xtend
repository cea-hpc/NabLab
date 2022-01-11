/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.python

import fr.cea.nabla.ir.ir.ArgOrVarRef
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.Function
import fr.cea.nabla.ir.ir.InternFunction
import fr.cea.nabla.ir.ir.IrType
import fr.cea.nabla.ir.ir.LinearAlgebraType
import fr.cea.nabla.ir.ir.Variable

import static extension fr.cea.nabla.ir.generator.python.InstructionContentProvider.*

class FunctionContentProvider
{
	static def getContent(InternFunction it)
	'''
		def __«getHeaderContent»:
			«body.innerContent»
	'''

	static def getHeaderContent(Function it)
	'''«name»(self«FOR a : inArgs», «a.name»«ENDFOR»)'''

	static def getSizeOf(Function it, Variable v)
	{
		for (a : inArgs)
		{
			var skippedDimensions = ""
			for (expr : a.type.sizes)
			{
				if (expr instanceof ArgOrVarRef && (expr as ArgOrVarRef).target === v)
					return 'len(' + a.name + skippedDimensions + ')'
				skippedDimensions += "[0]"
			}
		}
		throw new RuntimeException("No argument corresponding to dimension symbol: " + v.name)
	}

	private static def getSizes(IrType it)
	{
		switch it
		{
			BaseType: getSizes
			LinearAlgebraType: getSizes
			default: throw new RuntimeException("Unexpected type: " + class.name)
		}
	}
}
