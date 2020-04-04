/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.ConnectivityType

import static fr.cea.nabla.ir.interpreter.ExpressionInterpreter.*

class IrTypeExtensions 
{
	static def dispatch getPrimitive(BaseType it) { primitive }
	static def dispatch getPrimitive(ConnectivityType it) { base.primitive }

	static def dispatch int[] getIntSizes(BaseType it, Context context)
	{
		interpreteDimensionExpressions(sizes, context)
	}

	static def dispatch int[] getIntSizes(ConnectivityType it, Context context) 
	{ 
		//context.showConnectivitySizes("Connectivities size")
		connectivities.map[x | context.connectivitySizes.get(x)] + getIntSizes(base, context)
	}
}