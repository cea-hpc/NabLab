/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla

import fr.cea.nabla.nabla.Connectivity
import fr.cea.nabla.nabla.ConnectivityCall
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.ItemSetRef
import fr.cea.nabla.nabla.NablaRoot
import fr.cea.nabla.nabla.SpaceIteratorRef
import java.util.List
import org.eclipse.xtext.EcoreUtil2

import static extension fr.cea.nabla.SpaceIteratorRefExtensions.*

class UniqueNameHelper 
{
	static def dispatch getUniqueName(ItemSetRef it)
	{
		target.name
	}

	static def dispatch getUniqueName(ConnectivityCall it)
	{
		getUniqueName(connectivity, args)
	}

	static def getUniqueName(Connectivity c, List<SpaceIteratorRef> args)
	{
		c.name + args.map[x | x.name.toFirstUpper].join('')
	}

	static def getUniqueExtensionName(Function it)
	{
		EcoreUtil2.getContainerOfType(it, NablaRoot).name
	}
}