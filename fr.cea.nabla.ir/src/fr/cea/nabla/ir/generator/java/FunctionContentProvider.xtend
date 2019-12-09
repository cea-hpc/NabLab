/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.java

import fr.cea.nabla.ir.ir.Function
import fr.cea.nabla.ir.ir.SizeTypeSymbol
import fr.cea.nabla.ir.ir.SizeTypeSymbolRef

import static extension fr.cea.nabla.ir.generator.java.InstructionContentProvider.*
import static extension fr.cea.nabla.ir.generator.java.Ir2JavaUtils.*

class FunctionContentProvider
{
	static def getContent(Function it)
	'''
		private «returnType.javaType» «name.toFirstLower»(«FOR a : inArgs SEPARATOR ', '»«a.type.javaType» «a.name»«ENDFOR»)
		{
			«FOR dimVar : variables»
			final int «dimVar.name» = «getSizeOf(dimVar)»;
			«ENDFOR»
			«body.innerContent»
		}
	'''

	private static def getSizeOf(Function it, SizeTypeSymbol symbol)
	{
		for (a : inArgs)
		{
			var skippedDimensions = ""
			for (dimension : a.type.sizes)
			{
				if (dimension instanceof SizeTypeSymbolRef && (dimension as SizeTypeSymbolRef).target == symbol)
					return a.name + skippedDimensions + '.length'
				skippedDimensions += "[0]"
			}
		}
		throw new RuntimeException("No arg corresponding to dimension symbol " + symbol.name)
	}
}