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
import fr.cea.nabla.ir.ir.Container
import fr.cea.nabla.ir.ir.Connectivity

class ContainerExtensions 
{
	static def getConnectivityCall(Container it)
	{
		switch it
		{
			ConnectivityCall: it
			SetRef: target.value
		}
	}

	static def getUniqueName(Container it)
	{
		switch it
		{
			ConnectivityCall: connectivity.name + args.map[x | x.itemName.toFirstUpper].join('')
			SetRef: target.name
		}
	}

	static def getNbElemsVar(Container it)
	{
		if (connectivityCall.args.empty)
			connectivityCall.connectivity.nbElemsVar
		else
			'nb' + uniqueName.toFirstUpper
	}

	static def getNbElemsVar(Connectivity it)
	{
		'nb' + name.toFirstUpper
	}

	static def getAccessor(ConnectivityCall it)
	'''get«connectivity.name.toFirstUpper»(«args.map[name].join(', ')»)'''
}