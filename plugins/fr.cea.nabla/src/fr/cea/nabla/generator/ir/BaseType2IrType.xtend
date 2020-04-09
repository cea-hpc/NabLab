/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import com.google.inject.Singleton
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.nabla.BaseType
import fr.cea.nabla.nabla.Connectivity
import java.util.List

@Singleton
class BaseType2IrType 
{
	@Inject extension Nabla2IrUtils
	@Inject extension IrConnectivityFactory
	@Inject extension IrExpressionFactory

	// No create method to ensure a new instance every time (for n+1 time variables)
	def toIrBaseType(BaseType t)
	{
		IrFactory::eINSTANCE.createBaseType => 
		[
			primitive = t.primitive.toIrPrimitiveType
			t.sizes.forEach[x | sizes += x.toIrExpression]
		]
	}

	def toIrConnectivityType(BaseType t, List<? extends Connectivity> supports)
	{
		IrFactory::eINSTANCE.createConnectivityType => 
		[
			base = t.toIrBaseType
			supports.forEach[x | connectivities += x.toIrConnectivity]
		]
	}
}