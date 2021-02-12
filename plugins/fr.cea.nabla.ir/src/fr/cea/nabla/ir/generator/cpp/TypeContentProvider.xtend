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

import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.Expression
import fr.cea.nabla.ir.ir.IrType
import fr.cea.nabla.ir.ir.LinearAlgebraType
import fr.cea.nabla.ir.ir.PrimitiveType
import java.util.ArrayList
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

import static extension fr.cea.nabla.ir.generator.Utils.*

abstract class TypeContentProvider
{
	@Accessors extension ExpressionContentProvider expressionContentProvider

	protected abstract def String getCppType(BaseType baseType, Iterable<Connectivity> connectivities)
	protected abstract def CharSequence getCstrInit(String varName, IrType type)
	protected abstract def String getLinearAlgebraType(int dimension)
	protected abstract def CharSequence formatIterators(IrType type, List<String> iterators)

	def String getCppType(IrType it)
	{
		switch it
		{
			case null: "null"
			BaseType case sizes.empty: primitive.cppType
			BaseType: getCppArrayType(primitive, sizes)
			ConnectivityType: getCppType(base, connectivities)
			LinearAlgebraType: getLinearAlgebraType(sizes.size)
		}
	}

	def String getCppType(PrimitiveType it)
	{
		switch it
		{
			case null : 'void'
			case BOOL: 'bool'
			case INT: 'int'
			case REAL: 'double'
		}
 	}

	def String getJniType(IrType it)
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

	def String getJniType(PrimitiveType it)
	{
		switch it
		{
			case null: 'void'
			case BOOL: 'jboolean'
			case INT: 'jint'
			case REAL: 'jdouble'
		}
	}

	def isMatrix(IrType it)
	{
		switch it
		{
			LinearAlgebraType: it.sizes.size == 2
			default: false
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

	def boolean isBaseTypeStatic(IrType it)
	{
		switch it
		{
			BaseType: sizes.empty || sizes.forall[x | x.constExpr]
			ConnectivityType: base.baseTypeStatic
			LinearAlgebraType: sizes.empty || sizes.forall[x | x.constExpr]
			default: throw new RuntimeException("Unhandled parameter")
		}
	}

	private def getCppArrayType(PrimitiveType t, Iterable<Expression> sizes)
	{
		switch t
		{
			case null, case BOOL : throw new RuntimeException('Not implemented')
			default: t.getName() + 'Array' + sizes.size + 'D' + '<' + sizes.map[arraySizeContent].join(',') + '>'
		}
	}

	private def getArraySizeContent(Expression e)
	{
		if (e.constExpr) e.content
		else '0'
	}

	private def CharSequence initCppType(String name, ConnectivityType t, List<String> accessors, Iterable<Connectivity> connectivities)
	{
		if (connectivities.empty)
			'''«name»«formatIterators(t, accessors)».initSize(«t.base.sizes.map[x | expressionContentProvider.getContent(x)].join(', ')»);'''
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

class StlTypeContentProvider extends TypeContentProvider
{
	override getCppType(BaseType baseType, Iterable<Connectivity> connectivities) 
	{
		if (connectivities.empty) baseType.cppType
		else 'std::vector<' + getCppType(baseType, connectivities.tail) + '>'
	}

	override protected getCstrInit(String varName, IrType type)
	{
		switch type
		{
			LinearAlgebraType case (type.sizes.size == 1):
				'''«expressionContentProvider.getContent(type.sizes.get(0))»'''
			LinearAlgebraType case (type.sizes.size == 2):
				'''"«varName»", «expressionContentProvider.getContent(type.sizes.get(0))», «expressionContentProvider.getContent(type.sizes.get(1))»'''
			ConnectivityType:
				getCstrInit(type.base, type.connectivities)
			default:
				throw new RuntimeException("Ooops. Can not be there, normally...")
		}
	}

	override protected formatIterators(IrType type, List<String> iterators)
	{
		switch type
		{
			LinearAlgebraType case (type.sizes.size == 2): '''«FOR i : iterators BEFORE '(' SEPARATOR ',' AFTER ')'»«i»«ENDFOR»'''
			default: '''«FOR i : iterators BEFORE '[' SEPARATOR '][' AFTER ']'»«i»«ENDFOR»'''
		}
	}

	override protected getLinearAlgebraType(int dimension) 
	{
		switch dimension
		{
			case 1: return 'nablalib::linearalgebra::stl::VectorType'
			case 2: return 'nablalib::linearalgebra::stl::NablaSparseMatrix'
			default: throw new RuntimeException("Unsupported dimension: " + dimension)
		}
	}

	private def CharSequence getCstrInit(BaseType baseType, Iterable<Connectivity> connectivities)
	{
		switch connectivities.size
		{
			case 0: throw new RuntimeException("Ooops. Can not be there, normally...")
			case 1: connectivities.get(0).nbElemsVar
			default: '''«connectivities.get(0).nbElemsVar», «getCppType(baseType, connectivities.tail)»(«getCstrInit(baseType, connectivities.tail)»)''' 
		}
	}

}

class KokkosTypeContentProvider extends TypeContentProvider
{
	override getCppType(BaseType baseType, Iterable<Connectivity> connectivities) 
	{
		'Kokkos::View<' + baseType.cppType + connectivities.map['*'].join + '>'
	}

	override protected getCstrInit(String varName, IrType type)
	{
		switch type
		{
			LinearAlgebraType:
				// specific initialization for matrices
				'''"«varName»", «FOR s : type.sizes SEPARATOR ', '»«expressionContentProvider.getContent(s)»«ENDFOR»'''
			ConnectivityType:
				'''"«varName»", «FOR c : type.connectivities SEPARATOR ', '»«c.nbElemsVar»«ENDFOR»'''
			default:
				throw new RuntimeException("Ooops. Can not be there, normally...")
		}
	}

	override protected formatIterators(IrType type, List<String> iterators)
	'''«FOR i : iterators BEFORE '(' SEPARATOR ',' AFTER ')'»«i»«ENDFOR»'''

	override protected getLinearAlgebraType(int dimension) 
	{
		switch dimension
		{
			case 1: return 'nablalib::linearalgebra::kokkos::VectorType'
			case 2: return 'nablalib::linearalgebra::kokkos::NablaSparseMatrix'
			default: throw new RuntimeException("Unsupported dimension: " + dimension)
		}
	}
}