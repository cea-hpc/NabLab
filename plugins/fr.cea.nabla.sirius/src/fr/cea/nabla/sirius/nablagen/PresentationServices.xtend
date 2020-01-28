/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.sirius.nablagen

import fr.cea.nabla.nablagen.ChildComponent

import static extension fr.cea.nabla.workflow.WorkflowComponentExtensions.*

class PresentationServices
{
	def replaceUpperCaseWithSpace(String it)
	{
		val separator = ' '

		if (contains('_'))
			replace('_', separator)
		else 
			// chaine de la forme monNom
			Character::toUpperCase(charAt(0)) + toCharArray.tail.map[c | if (Character::isUpperCase(c)) separator + c else c  ].join
	}

	def void disableBranch(ChildComponent it)
	{
		disabled = true
		nexts.forEach[disableBranch]
	}

	def void enableBranch(ChildComponent it)
	{
		disabled = false
		nexts.forEach[enableBranch]
	}
}