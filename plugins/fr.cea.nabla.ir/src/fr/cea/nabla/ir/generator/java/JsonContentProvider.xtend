/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.java

import fr.cea.nabla.ir.ir.Expression
import fr.cea.nabla.ir.ir.PrimitiveType
import fr.cea.nabla.ir.ir.SimpleVariable
import org.eclipse.xtend.lib.annotations.Data

import static extension fr.cea.nabla.ir.generator.java.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.generator.java.ExpressionContentProvider.*

@Data
class JsonContentProvider
{
	static def getJsonName(SimpleVariable it) { name.jsonName }
	static def getJsonName(String varName) { 'valueof_' + varName }

	static def getJsonContent(SimpleVariable it)
	'''
		// «name»
		«IF defaultValue === null»
			assert(o.has("«name»"));
			final JsonElement «jsonName» = o.get("«name»");
			«getJsonContent(it, type.sizes, #[])»
		«ELSE»
			if (o.has("«name»"))
			{
				final JsonElement «name.jsonName» = o.get("«name»");
				«getJsonContent(it, type.sizes, #[])»
			}
			else
				«name» = «defaultValue.content»;
		«ENDIF»
	'''

	private static def CharSequence getJsonContent(SimpleVariable v, Iterable<Expression> sizes, String[] indices)
	{
		val primitive = v.type.primitive
		if (sizes.empty)
		'''
			assert(«v.jsonName»«FOR i : indices».getAsJsonArray().get(«i»)«ENDFOR».isJsonPrimitive());
			«v.name»«FOR i : indices»[«i»]«ENDFOR» = «v.jsonName»«FOR i : indices».getAsJsonArray().get(«i»)«ENDFOR».getAsJsonPrimitive().getAs«primitive.jsonType»();
		'''
		else
		'''
			assert(«v.jsonName»«FOR i : indices».getAsJsonArray().get(«i»)«ENDFOR».isJsonArray());
			assert(«v.jsonName».getAsJsonArray()«FOR i : indices».get(«i»).getAsJsonArray()«ENDFOR».size() == «sizes.head.content»);
			«IF indices.empty»«v.name»«v.javaAllocation»;«ENDIF»
			«val indexName = 'i' + sizes.size»
			for (int «indexName»=0 ; «indexName»<«sizes.head.content» ; «indexName»++)
			{
				«getJsonContent(v, sizes.tail, indices + #[indexName])»
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