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
import java.util.ArrayList
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.Data

@Data
abstract class IrTransformationStep
{
	@Accessors val traceListeners = new ArrayList<(String) => void>
	val String description

	def void trace(String msg)
	{
		traceListeners.forEach[apply(msg)]
	}

	def void transformIr(IrRoot ir) throws RuntimeException
	{
		transformIr(ir, null)
	}

	def void transformIr(IrRoot ir, (String)=>void traceNotifier) throws RuntimeException
	{
		if (traceNotifier !== null) traceListeners += traceNotifier
		val ok = transform(ir)
		if (traceNotifier !== null) traceListeners -= traceNotifier
		if (!ok) throw new RuntimeException('Exception in IR transformation step: ' + description)
	}

	protected abstract def boolean transform(IrRoot ir)
}
