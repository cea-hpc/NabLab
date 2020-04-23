/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.cpp

import fr.cea.nabla.ir.ir.Function
import org.eclipse.xtend.lib.annotations.Data

@Data
class FunctionContentProvider 
{
	protected val extension TypeContentProvider typeContentProvider
	protected val extension InstructionContentProvider instructionContentProvider
	protected def String getMacro() { null }

	def getContent(Function it)
	'''
		«FOR v : variables BEFORE "template<" SEPARATOR ", " AFTER ">"»size_t «v.name»«ENDFOR»
		«IF macro !== null»«macro»«ENDIF»
		«returnType.cppType» «name.toFirstLower»(«FOR a : inArgs SEPARATOR ', '»«a.type.cppType» «a.name»«ENDFOR»)
		{
			«body.innerContent»
		}
	'''
}

@Data
class KokkosFunctionContentProvider extends FunctionContentProvider
{
	override getMacro()
	{
		"KOKKOS_INLINE_FUNCTION"
	}
}