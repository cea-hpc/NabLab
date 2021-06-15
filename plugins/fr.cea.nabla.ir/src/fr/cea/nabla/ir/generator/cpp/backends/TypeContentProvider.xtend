/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.cpp.backends

import fr.cea.nabla.ir.IrTypeExtensions
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.Expression
import fr.cea.nabla.ir.ir.IrType
import fr.cea.nabla.ir.ir.LinearAlgebraType
import fr.cea.nabla.ir.ir.PrimitiveType
import java.util.ArrayList
import java.util.List
import org.eclipse.xtend.lib.annotations.Data

import static extension fr.cea.nabla.ir.ContainerExtensions.*

@Data
abstract class TypeContentProvider
{
	extension ExpressionContentProvider expressionContentProvider

	protected abstract def CharSequence getCppType(BaseType baseType, Iterable<Connectivity> connectivities)
	protected abstract def CharSequence getCstrInit(String name, BaseType baseType, Iterable<Connectivity> connectivities)

	def getCppType(IrType it)
	{
		switch it
		{
			case null: null
			BaseType case sizes.empty: primitive.cppType
			BaseType: getCppArrayType(primitive, sizes)
			ConnectivityType: getCppType(base, connectivities)
			LinearAlgebraType: IrTypeExtensions.getLinearAlgebraClass(it)
			default: throw new RuntimeException("Unexpected type: " + class.name)
		}
	}

	def getJniType(IrType it)
	{
		switch it
		{
			case null: "null"
			BaseType case sizes.empty: primitive.jniType
			BaseType case sizes.size == 1: primitive.jniType + "Array"
			BaseType: "jobjectArray"
			LinearAlgebraType: "jobject"
			default: throw new RuntimeException("Ooops. Can not be there, normally...")
		}
	}

	def getCppType(PrimitiveType it)
	{
		switch it
		{
			case null : 'void'
			case BOOL: 'bool'
			case INT: 'int'
			case REAL: 'double'
		}
	}

	def getJniType(PrimitiveType it)
	{
		switch it
		{
			case null: 'void'
			case BOOL: 'jboolean'
			case INT: 'jint'
			case REAL: 'jdouble'
		}
	}

	def CharSequence getCstrInit(IrType it, String name)
	{
		switch it
		{
			case null: null
			BaseType: ''''''
			ConnectivityType: getCstrInit(name, base, connectivities)
			LinearAlgebraType: '''"«name»", «FOR s : sizes SEPARATOR ', '»«expressionContentProvider.getContent(s)»«ENDFOR»'''
			default: throw new RuntimeException("Unexpected type: " + class.name)
		}
	}

	def initCppTypeContent(String name, IrType t)
	{
		switch t
		{
			BaseType: '''«name».initSize(«t.sizes.map[x | expressionContentProvider.getContent(x)].join(', ')»);'''
			ConnectivityType: initCppType(name, t, new ArrayList<String>, t.connectivities)
			LinearAlgebraType: '''«name».initSize(«t.sizes.map[x | expressionContentProvider.getContent(x)].join(', ')»);'''
		}
	}

	private def getCppArrayType(PrimitiveType t, Iterable<Expression> sizes)
	{
		switch t
		{
			case null, case BOOL : throw new RuntimeException('Not implemented')
			default: t.getName() + 'Array' + sizes.size + 'D' + '<' + sizes.map[e | (e.constExpr?e.content:'0')].join(',') + '>'
		}
	}

	private def CharSequence initCppType(String name, ConnectivityType t, List<String> accessors, Iterable<Connectivity> connectivities)
	{
		if (connectivities.empty)
			'''«name»«formatIterators(accessors)».initSize(«t.base.sizes.map[x | expressionContentProvider.getContent(x)].join(', ')»);'''
		else
		{
			val indexName = "i" + connectivities.size
			accessors += indexName
			'''
				for (size_t «indexName»=0; «indexName»<«connectivities.head.nbElemsVar»; «indexName»++)
					«initCppType(name, t, accessors, connectivities.tail)»
			'''
		}
	}
}

@Data
class DefaultTypeContentProvider extends TypeContentProvider
{
	override getCppType(BaseType baseType, Iterable<Connectivity> connectivities) 
	{
		if (connectivities.empty) baseType.cppType
		else 'std::vector<' + getCppType(baseType, connectivities.tail) + '>'
	}

	override getCstrInit(String name, BaseType baseType, Iterable<Connectivity> connectivities)
	{
		switch connectivities.size
		{
			case 0: throw new RuntimeException("Ooops. Can not be there, normally...")
			case 1: connectivities.get(0).nbElemsVar
			default: '''«connectivities.get(0).nbElemsVar», «getCppType(baseType, connectivities.tail)»(«getCstrInit(name, baseType, connectivities.tail)»)''' 
		}
	}
}

@Data
class KokkosTypeContentProvider extends TypeContentProvider
{
	override getCppType(BaseType baseType, Iterable<Connectivity> connectivities) 
	{
		'Kokkos::View<' + baseType.cppType + connectivities.map['*'].join + '>'
	}

	override getCstrInit(String name, BaseType baseType, Iterable<Connectivity> connectivities)
	'''"«name»", «FOR c : connectivities SEPARATOR ', '»«c.nbElemsVar»«ENDFOR»'''
}
