/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.java

import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.Expression
import fr.cea.nabla.ir.ir.PrimitiveType

import static extension fr.cea.nabla.ir.generator.java.ExpressionContentProvider.*

class JsonContentProvider
{
	static def getJsonName(String varName)
	{
		'valueof_' + varName
	}

	static def getJsonContent(String name, BaseType type)
	'''
		assert options.has("«name»") : "No «name» option";
		final JsonElement «name.jsonName» = options.get("«name»");
		«getJsonContent(name, type, type.sizes, #[])»
	'''

	private static def CharSequence getJsonContent(String name, BaseType type, Iterable<Expression> sizes, String[] indices)
	{
		val primitive = type.primitive
		if (sizes.empty)
		'''
			assert(«name.jsonName»«FOR i : indices».getAsJsonArray().get(«i»)«ENDFOR».isJsonPrimitive());
			«name»«FOR i : indices»[«i»]«ENDFOR» = «name.jsonName»«FOR i : indices».getAsJsonArray().get(«i»)«ENDFOR».getAsJsonPrimitive().getAs«primitive.jsonType»();
		'''
		else
		'''
			assert(«name.jsonName»«FOR i : indices».getAsJsonArray().get(«i»)«ENDFOR».isJsonArray());
			assert(«name.jsonName».getAsJsonArray()«FOR i : indices».get(«i»).getAsJsonArray()«ENDFOR».size() == «sizes.head.content»);
			«val indexName = 'i' + sizes.size»
			for (int «indexName»=0 ; «indexName»<«sizes.head.content» ; «indexName»++)
			{
				«getJsonContent(name, type, sizes.tail, indices + #[indexName])»
			}
		'''
	}

	private static def getJsonType(PrimitiveType t)
	{
		switch t
		{
			case INT: 'Int'
			case REAL: 'Double'
			case BOOL: 'Boolean'
		}
	}
}