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

import fr.cea.nabla.ir.ir.Arg
import fr.cea.nabla.ir.ir.ArgOrVar
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.SimpleVariable
import fr.cea.nabla.ir.ir.Variable
import java.util.ArrayList
import java.util.List
import org.eclipse.xtend.lib.annotations.Data

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.generator.Utils.*
import static extension fr.cea.nabla.ir.generator.cpp.CppGeneratorUtils.*

@Data
abstract class ArgOrVarContentProvider
{
	val extension TypeContentProvider typeContentProvider

	protected abstract def CharSequence getCstrInit(ConnectivityVariable it)
	protected abstract def CharSequence formatIterators(ConnectivityVariable it, List<String> iterators)

	def dispatch String getCppType(Arg it)
	{
		type.cppType
	}

	def dispatch String getCppType(SimpleVariable it)
	{
		type.cppType
	}

	def dispatch String getCppType(ConnectivityVariable it)
	{
		if (linearAlgebra)
			type.connectivities.size.linearAlgebraType
		else
			type.cppType
	}

	def boolean isMatrix(ArgOrVar it)
	{
		if (it instanceof ConnectivityVariable)
			(linearAlgebra && type.connectivities.size == 2)
		else
			false
	}

	def initCppTypeContent(Variable v)
	{
		if (v.type.baseTypeStatic)
			throw new RuntimeException("No need to init static type for variable: " + v.name)
		else
			initCppType(v)
	}

	private def dispatch initCppType(SimpleVariable v)
	'''«v.name».initSize(«v.type.sizes.map[x | expressionContentProvider.getContent(x)].join(', ')»);'''

	private def dispatch initCppType(ConnectivityVariable v)
	{
		initCppType(v, new ArrayList<String>, v.type.connectivities)
	}

	private def CharSequence initCppType(ConnectivityVariable v, List<String> accessors, Iterable<Connectivity> connectivities)
	{
		if (connectivities.empty)
			'''«v.name»«formatIterators(v, accessors)».initSize(«v.type.base.sizes.map[x | expressionContentProvider.getContent(x)].join(', ')»);'''
		else
		{
			val indexName = "i" + connectivities.size
			accessors += indexName
			'''
				for (size_t «indexName»=0; «indexName»<«connectivities.head.nbElemsVar»; «indexName»++)
					«initCppType(v, accessors, connectivities.tail)»
			'''
		}
	}
}

@Data
class StlArgOrVarContentProvider extends ArgOrVarContentProvider
{
	override protected getCstrInit(ConnectivityVariable it)
	{
		val cs = type.connectivities
		if (linearAlgebra && cs.size == 2)
			// specific initialization for matrices
			'''"«name»", «cs.get(0).nbElemsVar», «cs.get(1).nbElemsVar»'''
		else
			getCstrInit(name, type.base, type.connectivities)
	}

	override protected formatIterators(ConnectivityVariable it, List<String> iterators) 
	{
		// Just different accessors for matrices
		if (linearAlgebra && type.connectivities.size == 2)
			'''«FOR i : iterators BEFORE '(' SEPARATOR ',' AFTER ')'»«i»«ENDFOR»'''
		else
			'''«FOR i : iterators BEFORE '[' SEPARATOR '][' AFTER ']'»«i»«ENDFOR»'''
	}

	private def CharSequence getCstrInit(String varName, BaseType baseType, Iterable<Connectivity> connectivities)
	{
		switch connectivities.size
		{
			case 0: throw new RuntimeException("Ooops. Can not be there, normally...")
			case 1: connectivities.get(0).nbElemsVar
			default: '''«connectivities.get(0).nbElemsVar», «typeContentProvider.getCppType(baseType, connectivities.tail)»(«getCstrInit(varName, baseType, connectivities.tail)»)''' 
		}
	}
}

@Data
class KokkosArgOrVarContentProvider extends ArgOrVarContentProvider
{
	override getCstrInit(ConnectivityVariable it)
	'''"«name»", «FOR d : type.connectivities SEPARATOR ', '»«d.nbElemsVar»«ENDFOR»'''

	override protected formatIterators(ConnectivityVariable it, List<String> iterators)
	'''«FOR i : iterators BEFORE '(' SEPARATOR ',' AFTER ')'»«i»«ENDFOR»'''
}
