/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.ir.DefaultExtensionProvider
import fr.cea.nabla.ir.ir.IrRoot

import static extension fr.cea.nabla.ir.IrRootExtensions.*

class ConfigureMesh extends IrTransformationStep
{
	static val CM2D = "CartesianMesh2D"
	static val CM2DIndexIdConnectivities = #['cells', 'nodes', 'faces']
	static val CM2DGenerationVariables =
	#{
		"MaxNbNodesOfCell" -> 4,
		"MaxNbNodesOfFace" -> 2,
		"MaxNbCellsOfNode" -> 4,
		"MaxNbCellsOfFace" -> 2,
		"MaxNbFacesOfCell" -> 4,
		"MaxNbNeighbourCells" -> 4
	}

	override getDescription()
	{
		"Optimize connectivities (index == id) and set upper bounds to allocate arrays"
	}

	override transform(IrRoot ir, (String)=>void traceNotifier)
	{
		if (ir.mesh.extensionName == CM2D)
		{
			// Set "index == Id" for connectivities cells, nodes and faces
			for (c : ir.mesh.connectivities)
			{
				if (!c.multiple) c.indexEqualId = true
				else if (CM2DIndexIdConnectivities.contains(c.name)) c.indexEqualId = true
			}

			// Set generation variables to allocate 2D arrays
			for (gv : CM2DGenerationVariables.entrySet)
				ir.mesh.generationVariables.put(gv.key, gv.value.toString)
		}
		else
			throw new RuntimeException("Unmanaged mesh extension: " + ir.mesh.extensionName)
	}

	override transform(DefaultExtensionProvider dep, (String)=>void traceNotifier)
	{
		// nothing to do
	}
}
