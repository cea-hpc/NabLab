/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.kokkos

import fr.cea.nabla.ir.ir.Function

import static extension fr.cea.nabla.ir.generator.kokkos.Ir2KokkosUtils.*

class FunctionContentProvider 
{
	extension InstructionContentProvider icp
	
	new(InstructionContentProvider icp) { this.icp = icp }

	def getContent(Function it)
	'''
		«FOR v : dimensionVars BEFORE "template<" SEPARATOR ", " AFTER ">"»size_t «v.name»«ENDFOR»
		KOKKOS_INLINE_FUNCTION
		«returnType.cppType» «name.toFirstLower»(«FOR a : inArgs SEPARATOR ', '»«a.type.cppType» «a.name»«ENDFOR») 
		{
			«body.innerContent»
		}
	'''
}