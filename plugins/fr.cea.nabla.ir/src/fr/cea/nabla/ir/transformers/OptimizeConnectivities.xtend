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
import java.util.List

import static extension fr.cea.nabla.ir.IrRootExtensions.*

class OptimizeConnectivities extends IrTransformationStep
{
	val List<String> connectivities

	new(List<String> connectivities)
	{
		super('Annotate connectivities when Id and Index are equals (ex: cells)')
		this.connectivities = connectivities
	}

	override transform(IrRoot ir)
	{
		trace('    IR -> IR: ' + description)
		for (c : ir.mesh.connectivities)
		{
			if (!c.multiple) c.indexEqualId = true
			else if (connectivities.contains(c.name)) c.indexEqualId = true
		}
		return true
	}
}
