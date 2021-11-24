/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.ir.BaseType

import static fr.cea.nabla.ir.interpreter.IrTypeExtensions.*

class BaseTypeValueFactory
{
	static def NablaValue createValue(BaseType t, String name, Context context)
	{
		val sizes = getIntSizes(t, context)
		switch sizes.size
		{
			case 0: NablaValueFactory::createValue(t.primitive)
			case 1: NablaValueFactory::createValue(t.primitive, name, sizes.get(0), null)
			case 2: NablaValueFactory::createValue(t.primitive, name, sizes.get(0), sizes.get(1), null)
			default: throw new RuntimeException('Unexpected dimension: ' + sizes.size)
		}
	}
}