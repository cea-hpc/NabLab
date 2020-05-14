/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.generator

import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.transformers.IrTransformationStep

class IrModuleTransformer
{
	def void transformIr(IrTransformationStep step, IrModule module, (String)=>void traceNotifier) throws RuntimeException
	{
		step.traceListeners += traceNotifier
		val ok = step.transform(module)
		step.traceListeners -= traceNotifier
		if (!ok) throw new RuntimeException('Exception in IR transformation step: ' + step.description)
	}
}