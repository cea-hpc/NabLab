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

class ConfigureNablaConnectivities implements IrTransformationStep 
{
	static val NablaConnectivities = #{'cellsOfNode' -> 'cells', 
		'nodesOfCell' -> 'nodes', 
		'nodesOfFace' -> 'nodes', 
		'innerNodes' -> 'inner nodes',
		'outerFaces' -> 'outer faces'}

	override getDescription() 
	{
		'Configure Nabla connectivities: ' + NablaConnectivities.values.join(', ') 
	}
	
	override transform(IrModule m) 
	{
		m.connectivities.forEach[c | c.name = NablaConnectivities.getOrDefault(c.name, c.name)]
		return true
	}
	
	override getOutputTraces() 
	{
		#[]
	}
}