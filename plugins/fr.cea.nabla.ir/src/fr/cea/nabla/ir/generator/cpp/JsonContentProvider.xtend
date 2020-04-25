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

	def getJsonContent(SimpleVariable it)
	'''
		// «name»
		assert(d.HasMember("«name»"));
		const rapidjson::Value& valueof_«name» = d["«name»"];
		«getJsonContent(type.sizes, type.primitive, name)»
	'''

	private def CharSequence getJsonContent(Iterable<Expression> sizes, PrimitiveType primitive, String varName)
	{
		if (sizes.empty)
		'''
			assert(valueof_«varName».Is«primitive.jsonType»());
			«varName» = valueof_«varName».Get«primitive.jsonType»();
		'''
		else
		'''
			assert(valueof_«varName».IsArray());
			assert(valueof_«varName».Size() == «sizes.head.content»);
			«val indexName = 'i' + sizes.size»
			for (size_t «indexName»=0 ; «indexName»<«sizes.head.content» ; «indexName»++)
			{
				«getJsonContent(sizes.tail, primitive, varName + "[" + indexName + "]")»
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