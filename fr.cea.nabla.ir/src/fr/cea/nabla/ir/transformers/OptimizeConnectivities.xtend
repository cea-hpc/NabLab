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
package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.ir.IrModule
import java.util.List

class OptimizeConnectivities implements IrTransformationStep 
{
	static val DefaultConnectivities = #['cells', 'nodes', 'faces']

	val List<String> connectivities

	new()
	{
		connectivities = DefaultConnectivities
	}
	
	new(List<String> connectivities)
	{
		this.connectivities = connectivities
	}

	override getDescription() 
	{
		'Annotate connectivities when Id and Index are equals (ex: cells)'
	}
	
	override transform(IrModule m) 
	{
		m.connectivities.forEach[c | if (connectivities.contains(c.name)) c.indexEqualId = true]
		return true
	}
	
	override getOutputTraces() 
	{
		#[]
	}
}