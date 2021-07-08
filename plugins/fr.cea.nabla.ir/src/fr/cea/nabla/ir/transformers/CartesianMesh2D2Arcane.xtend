/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.ir.IrRoot

class CartesianMesh2D2Arcane extends IrTransformationStep
{
	public static val connectivities = #{
		'nodes' -> 'allNodes',
		'cells' -> 'allCells',
		'faces' -> 'allFaces',
		'nodesOfCell' -> 'nodes',
		'nodesOfFace' -> 'nodes',
		'cellsOfNode' -> 'cells',
		'cellsOfFace' -> 'cells',
		'facesOfCell' -> 'faces'
	}

	new()
	{
		super('Map CartesianMesh2D extension connectivities to Arcane connectivities')
	}

	override transform(IrRoot ir)
	{
		trace('    IR -> IR: ' + description)
		ir.mesh.connectivities.forEach[x | x.name = x.name.toArcaneName]
		return true
	}

	static def toArcaneName(String name)
	{
		val arcaneName = connectivities.get(name)
		if (arcaneName === null) "get" + name.toFirstUpper
		else arcaneName
	}
}
