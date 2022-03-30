/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.dace

import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.Expression

import static extension fr.cea.nabla.ir.generator.dace.ExpressionContentProvider.*

class JsonContentProvider
{
	static def getJsonContent(String name, BaseType type)
	{
		getJsonContent(name, type.sizes, #[])
	}

	private static def CharSequence getJsonContent(String name, Iterable<Expression> sizes, String[] indices)
	{
		if (sizes.empty)
		'''
			self.«name»«FOR i : indices»[«i»]«ENDFOR» = jsonContent["«name»"]«FOR i : indices»[«i»]«ENDFOR»
		'''
		else
		'''
			«val indexName = 'i' + sizes.size»
			for «indexName» in range(«sizes.head.content»):
				«getJsonContent(name, sizes.tail, indices + #[indexName])»
		'''
	}
}