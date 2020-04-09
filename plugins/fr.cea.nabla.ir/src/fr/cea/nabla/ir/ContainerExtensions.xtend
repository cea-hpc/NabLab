/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir

import fr.cea.nabla.ir.ir.ConnectivityCall
import fr.cea.nabla.ir.ir.SetRef

class ContainerExtensions 
{
	static def dispatch getConnectivity(ConnectivityCall it)
	{
		connectivity
	}

	static def dispatch getConnectivity(SetRef it)
	{
		target.value.connectivity
	}

	static def dispatch getUniqueName(ConnectivityCall it)
	{
		connectivity.name + args.map[x | x.itemName.toFirstUpper].join('')
	}

	static def dispatch getUniqueName(SetRef it)
	{
		target.name
	}

	static def getAccessor(ConnectivityCall it)
	'''get«connectivity.name.toFirstUpper»(«args.map[name].join(', ')»)'''
}