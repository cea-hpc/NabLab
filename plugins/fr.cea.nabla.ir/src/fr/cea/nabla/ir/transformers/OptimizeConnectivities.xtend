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
import java.util.List
import org.eclipse.xtend.lib.annotations.Data

import static extension fr.cea.nabla.ir.IrRootExtensions.*

@Data
class OptimizeConnectivities extends IrTransformationStep
{
	val List<String> connectivities

	override getDescription()
	{
		"Annotate connectivities when Id and Index are equals (ex: cells)"
	}

	override transform(IrRoot ir, (String)=>void traceNotifier)
	{
		for (c : ir.mesh.connectivities)
		{
			if (!c.multiple) c.indexEqualId = true
			else if (connectivities.contains(c.name)) c.indexEqualId = true
		}
	}

	override transform(DefaultExtensionProvider dep, (String)=>void traceNotifier)
	{
		// nothing to do
	}
}
