/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 * 	Benoit Lelandais - initial implementation
 * 	Marie-Pierre Oudot - initial implementation
 * 	Jean-Sylvain Camier - Nabla generation support
 *******************************************************************************/
package fr.cea.nabla.ir.generator.java

import fr.cea.nabla.ir.ir.EndOfInitJob
import fr.cea.nabla.ir.ir.EndOfTimeLoopJob
import fr.cea.nabla.ir.ir.InstructionJob
import fr.cea.nabla.ir.ir.Job

import static extension fr.cea.nabla.ir.generator.Utils.*
import static extension fr.cea.nabla.ir.generator.java.InstructionContentProvider.*
import static extension fr.cea.nabla.ir.generator.java.VariableExtensions.*

class JobContentProvider 
{
	static def getContent(Job it)
	'''
		«comment»
		private void «name.toFirstLower»() 
		{
			«innerContent»
		}		
	'''
	
	private static def dispatch CharSequence getInnerContent(InstructionJob it)
	'''
		«instruction.innerContent»
	'''
	
	private static def dispatch CharSequence getInnerContent(EndOfTimeLoopJob it)
	'''
		«left.javaType» tmpSwitch = «left.name»;
		«left.name» = «right.name»;
		«right.name» = tmpSwitch;
	'''

	private static def dispatch CharSequence getInnerContent(EndOfInitJob it)
	'''
		IntStream.range(0, «left.name».length).parallel().forEach(i -> «left.name»[i] = «right.name»[i]);
	'''
}