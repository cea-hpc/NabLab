/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.cpp

import fr.cea.nabla.ir.ir.Expression
import fr.cea.nabla.ir.ir.PrimitiveType
import fr.cea.nabla.ir.ir.SimpleVariable
import org.eclipse.xtend.lib.annotations.Data

@Data
class JsonContentProvider
{
	val extension ExpressionContentProvider

	def getJsonName(SimpleVariable it) { name.jsonName }
	def getJsonName(String varName) { 'valueof_' + varName }

	def getJsonContent(SimpleVariable it)
	'''
		// «name»
		«IF defaultValue === null»
			assert(o.HasMember("«name»"));
			const rapidjson::Value& «jsonName» = o["«name»"];
			«getJsonContent(it, type.sizes, #[])»
		«ELSE»
			if (o.HasMember("«name»"))
			{
				const rapidjson::Value& «jsonName» = o["«name»"];
				«getJsonContent(it, type.sizes, #[])»
			}
			else
				«name» = «defaultValue.content»;
		«ENDIF»
	'''

	private def CharSequence getJsonContent(SimpleVariable v, Iterable<Expression> sizes, String[] indices)
	{
		val primitive = v.type.primitive
		if (sizes.empty)
		'''
			assert(«v.jsonName»«FOR i : indices»[«i»]«ENDFOR».Is«primitive.jsonType»());
			«v.name»«FOR i : indices»[«i»]«ENDFOR» = «v.jsonName»«FOR i : indices»[«i»]«ENDFOR».Get«primitive.jsonType»();
		'''
		else
		'''
			assert(«v.jsonName»«FOR i : indices»[«i»]«ENDFOR».IsArray());
			assert(«v.jsonName»«FOR i : indices»[«i»]«ENDFOR».Size() == «sizes.head.content»);
			«val indexName = 'i' + sizes.size»
			for (size_t «indexName»=0 ; «indexName»<«sizes.head.content» ; «indexName»++)
			{
				«getJsonContent(v, sizes.tail, indices + #[indexName])»
			}
		'''
	}

	private def getJsonType(PrimitiveType t)
	{
		switch t
		{
			case INT: 'Int'
			case REAL: 'Double'
			case BOOL: 'Bool'
		}
	}
}