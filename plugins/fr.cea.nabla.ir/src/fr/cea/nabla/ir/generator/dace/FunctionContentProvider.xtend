/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.dace

import fr.cea.nabla.ir.ir.ArgOrVarRef
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.Function
import fr.cea.nabla.ir.ir.InternFunction
import fr.cea.nabla.ir.ir.IrType
import fr.cea.nabla.ir.ir.LinearAlgebraType
import fr.cea.nabla.ir.ir.Variable

import static fr.cea.nabla.ir.generator.dace.TypeContentProvider.*

import static extension fr.cea.nabla.ir.generator.dace.InstructionContentProvider.*
import fr.cea.nabla.ir.ir.ConnectivityCall
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.Iterator

import static extension fr.cea.nabla.ir.ContainerExtensions.*

class FunctionContentProvider
{
	static def getContent(InternFunction it)
	'''
		@dace.method
		def _«getHeaderContent»:
			«body.innerContent»
	'''

	static def getHeaderContent(Function it)
	'''«name»(self«FOR a : inArgs», «a.name»«ENDFOR»)'''

	static def getHeaderContentC(Function f, Loop it){
			'''
				«f.name»(«getContent()», «FOR a : f.inArgs SEPARATOR ', '»«a.name»: «getDaceType(a.type)»«ENDFOR»)
			'''
	}

	static def CharSequence getContent(Loop it)
	'''
		«IF iterationBlock instanceof Iterator»
			«val iter = iterationBlock as Iterator»
			«IF !iter.container.connectivityCall.indexEqualId»
				«val c = iter.container»
				«IF c instanceof ConnectivityCall»«getSetDefinitionContent(c.uniqueName, c as ConnectivityCall)»«ENDIF»
			«ENDIF»
		«ENDIF»
	'''

	static def getSizeOf(Function it, Variable v)
	{
		for (a : inArgs)
		{
			var skippedDimensions = ""
			for (expr : a.type.sizes)
			{
				if (expr instanceof ArgOrVarRef && (expr as ArgOrVarRef).target === v)
					return a.name + skippedDimensions + '.size'
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

	private static def getSetDefinitionContent(String setName, ConnectivityCall call)
	'''
		«setName» = mesh.«call.accessor»
	'''
}
