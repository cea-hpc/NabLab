/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.ir.IrModule
import org.eclipse.xtend.lib.annotations.Data

@Data
class CompositeTransformationStep extends IrTransformationStep
{
	val IrTransformationStep[] steps

	override transform(IrModule m) 
	{
		for (s : steps)
		{
			s.traceListeners += traceListeners
			val ok = s.transform(m)
			s.traceListeners -= traceListeners
			if (!ok) return false
		}
		return true
	}
}