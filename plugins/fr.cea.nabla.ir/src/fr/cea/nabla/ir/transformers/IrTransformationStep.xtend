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
import java.util.ArrayList
import org.eclipse.xtend.lib.annotations.Data

@Data
abstract class IrTransformationStep
{
	val listeners = new ArrayList<(String) => void>
	val String description

	def void addTraceListener((String) => void listener)
	{
		listeners += listener
	}

	def void trace(String msg)
	{
		listeners.forEach[apply(msg)]
	}

	abstract def boolean transform(IrModule m)
}