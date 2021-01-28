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

import fr.cea.nabla.ir.ir.ArgOrVarRef
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.BaseTypeConstant
import fr.cea.nabla.ir.ir.BinaryExpression
import fr.cea.nabla.ir.ir.BoolConstant
import fr.cea.nabla.ir.ir.Cardinality
import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.ContractedIf
import fr.cea.nabla.ir.ir.FunctionCall
import fr.cea.nabla.ir.ir.IntConstant
import fr.cea.nabla.ir.ir.MaxConstant
import fr.cea.nabla.ir.ir.MinConstant
import fr.cea.nabla.ir.ir.Parenthesis
import fr.cea.nabla.ir.ir.PrimitiveType
import fr.cea.nabla.ir.ir.RealConstant
import fr.cea.nabla.ir.ir.UnaryExpression
import fr.cea.nabla.ir.ir.VectorConstant

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.ContainerExtensions.*
import static extension fr.cea.nabla.ir.IrTypeExtensions.*
import static extension fr.cea.nabla.ir.Utils.*
import static extension fr.cea.nabla.ir.generator.Utils.*
import static extension fr.cea.nabla.ir.generator.java.JavaGeneratorUtils.*

class ExpressionContentProvider
{
	static def dispatch CharSequence getContent(ContractedIf it) 
	'''(«condition.content» ? «thenExpression.content» : «elseExpression.content»)'''

	static def dispatch CharSequence getContent(BinaryExpression it) 
	{
		val lContent = left.content
		val rContent = right.content

		if (left.type.scalar && right.type.scalar)
			'''«lContent» «operator» «rContent»'''
		else
			'''ArrayOperations.«operator.operatorName»(«lContent», «rContent»)'''
	}

	static def dispatch CharSequence getContent(UnaryExpression it)
	{
		val content = expression.content
		if (expression.type.scalar)
			'''«operator»«expression.content»'''
		else
			'''ArrayOperations.«operator.operatorName»(«content»)'''
	}

	static def dispatch CharSequence getContent(Parenthesis it) '''(«expression.content»)'''
	static def dispatch CharSequence getContent(IntConstant it) '''«value»'''
	static def dispatch CharSequence getContent(RealConstant it) '''«value»'''
	static def dispatch CharSequence getContent(BoolConstant it) '''«value»'''

	static def dispatch CharSequence getContent(MinConstant it) 
	{
		val t = type
		switch t
		{
			case (t.scalar && t.primitive == PrimitiveType::INT): '''Integer.MIN_VALUE'''
			// Be careful at MIN_VALUE which is a positive value for double.
			case (t.scalar && t.primitive == PrimitiveType::REAL): '''-Double.MAX_VALUE'''
			default: throw new Exception('Invalid expression Min for type: ' + t.label)
		}
	}

	static def dispatch CharSequence getContent(MaxConstant it) 
	{
		val t = type
		switch t
		{
			case (t.scalar && t.primitive == PrimitiveType::INT): '''Integer.MAX_VALUE'''
			case (t.scalar && t.primitive == PrimitiveType::REAL): '''Double.MAX_VALUE'''
			default: throw new Exception('Invalid expression Max for type: ' + t.label)
		}
	}

	static def dispatch CharSequence getContent(BaseTypeConstant it) 
	{
		val t = type as BaseType

		if (t.sizes.exists[x | !(x instanceof IntConstant)])
			throw new RuntimeException("BaseTypeConstants size expressions must be IntConstant.")

		val sizes = t.sizes.map[x | (x as IntConstant).value]
		if (sizes.empty) value.content
		else '''new «type.javaType» «initArray(sizes, value.content)»'''
	}

	static def dispatch CharSequence getContent(VectorConstant it)
	'''new «type.javaType» «FOR v : values BEFORE '{' SEPARATOR ', ' AFTER '}'»«v.content»«ENDFOR»'''

	static def dispatch CharSequence getContent(Cardinality it)
	{
		if (container.connectivity.multiple)
			container.getNbElemsVar
		else
			'''1'''
	}

	static def dispatch CharSequence getContent(FunctionCall it) 
	'''«function.codeName»(«FOR a:args SEPARATOR ', '»«a.content»«ENDFOR»)'''

	static def dispatch CharSequence getContent(ArgOrVarRef it)
	{
		var argOrVarContent = codeName
		if (target.linearAlgebra)
			if (target instanceof ConnectivityVariable
				&& (target as ConnectivityVariable).type.connectivities.size  === 2
				&& iterators.size === 2)
				argOrVarContent += ".get("+iterators.map[name].join(', ')+")"+ indices.map[".get("+content+")"].join
			else
				argOrVarContent += iterators.map[".get("+name+")"].join + indices.map[".get("+content+")"].join
		else
			argOrVarContent += iterators.map["["+name+"]"].join + indices.map["["+content+"]"].join
		return argOrVarContent
	}

	private static def getCodeName(ArgOrVarRef it)
	{
		val argOrVarRefModule = irModule
		val varModule = target.irModule
		if (argOrVarRefModule === varModule)
			target.codeName
		else
			'mainModule.' + target.codeName
	}

	private static def CharSequence initArray(int[] sizes, CharSequence value)
	{
		if (sizes.empty) value
		else initArray(sizes.tail, '''«FOR i : 0..<sizes.head BEFORE '{' SEPARATOR ', ' AFTER '}'»«value»«ENDFOR»''')
	}
}