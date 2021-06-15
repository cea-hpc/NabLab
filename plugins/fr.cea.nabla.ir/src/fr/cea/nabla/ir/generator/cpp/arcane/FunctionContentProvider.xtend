/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.cpp.arcane

import fr.cea.nabla.ir.ir.ExternFunction
import fr.cea.nabla.ir.ir.Function
import fr.cea.nabla.ir.ir.InternFunction

import static extension fr.cea.nabla.ir.generator.cpp.arcane.InstructionContentProvider.*
import static extension fr.cea.nabla.ir.generator.cpp.arcane.TypeContentProvider.*

class FunctionContentProvider
{
	static def getDeclarationContent(Function it)
	{
		getDeclarationContent(it, name)
	}

	static def getDefinitionContent(InternFunction it)
	'''
		«getDeclarationContent»
		{
			«body.innerContent»
		}
	'''

	static def getDefinitionContent(String className, ExternFunction it)
	'''
		«getDeclarationContent(it, className + "::" + name)»
		{
			// Your code here
		}
	'''

	private static def getDeclarationContent(Function it, String name)
	'''«returnType.typeName» «name»(«FOR a : inArgs SEPARATOR ', '»«a.type.typeName» «a.name»«ENDFOR»)'''
}
