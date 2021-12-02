/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.arcane

import fr.cea.nabla.ir.IrUtils
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.Job

import static extension fr.cea.nabla.ir.generator.Utils.*

class JobContentProvider
{
	static def getDeclarationContent(Job it)
	'''void «codeName»();'''

	static def getDefinitionContent(Job it)
	'''
		«comment»
		void «ArcaneUtils.getModuleName(IrUtils.getContainerOfType(it, IrModule))»::«codeName»()
		{
			«InstructionContentProvider.getInnerContent(instruction)»
		}
	'''
}
