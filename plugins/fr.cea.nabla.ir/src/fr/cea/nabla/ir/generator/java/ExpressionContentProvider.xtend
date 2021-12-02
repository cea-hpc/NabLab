/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.java

import fr.cea.nabla.ir.IrUtils
import fr.cea.nabla.ir.ir.ArgOrVarRef
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.BaseTypeConstant
import fr.cea.nabla.ir.ir.BinaryExpression
import fr.cea.nabla.ir.ir.BoolConstant
import fr.cea.nabla.ir.ir.Cardinality
import fr.cea.nabla.ir.ir.ContractedIf
import fr.cea.nabla.ir.ir.Function
import fr.cea.nabla.ir.ir.FunctionCall
import fr.cea.nabla.ir.ir.IntConstant
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.MaxConstant
import fr.cea.nabla.ir.ir.MinConstant
import fr.cea.nabla.ir.ir.Parenthesis
import fr.cea.nabla.ir.ir.PrimitiveType
import fr.cea.nabla.ir.ir.RealConstant
import fr.cea.nabla.ir.ir.UnaryExpression
import fr.cea.nabla.ir.ir.Variable
import fr.cea.nabla.ir.ir.VectorConstant

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.ContainerExtensions.*
import static extension fr.cea.nabla.ir.IrTypeExtensions.*
import static extension fr.cea.nabla.ir.generator.Utils.*
import static extension fr.cea.nabla.ir.generator.java.JavaGeneratorUtils.*
import static extension fr.cea.nabla.ir.generator.java.TypeContentProvider.*

class ExpressionContentProvider
{
	static def dispatch CharSequence getContent(ContractedIf it)
	'''(«condition.content» ? «thenExpression.content» : «elseExpression.content»)'''

	static def dispatch CharSequence getContent(BinaryExpression it)
	'''«left.content» «operator» «right.content»'''

	static def dispatch CharSequence getContent(UnaryExpression it)
	'''«operator»«expression.content»'''

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
			default: throw new RuntimeException('Invalid expression Min for type: ' + t.label)
		}
	}

	static def dispatch CharSequence getContent(MaxConstant it)
	{
		val t = type
		switch t
		{
			case (t.scalar && t.primitive == PrimitiveType::INT): '''Integer.MAX_VALUE'''
			case (t.scalar && t.primitive == PrimitiveType::REAL): '''Double.MAX_VALUE'''
			default: throw new RuntimeException('Invalid expression Max for type: ' + t.label)
		}
	}

	static def dispatch CharSequence getContent(BaseTypeConstant it)
	{
		val t = type as BaseType

		if (t.sizes.empty)
		{
			// scalar type
			value.content
		}
		else
		{
			if (t.isStatic)
				'''new «t.javaType» «initArray(t.intSizes, value.content)»'''
			else
			{
				// The array must be allocated and initialized by loops
				// No expression value can be produced in dynamic mode
				// Two instructions must be encapsulated in a function and a function call must be done
				throw new RuntimeException("Not yet implemented")
				//'''new «t.primitive.javaType»«formatIteratorsAndIndices(t, t.sizes.map[content])»'''
			}
		}
	}

	static def dispatch CharSequence getContent(VectorConstant it)
	'''new «type.javaType» «FOR v : values BEFORE '{' SEPARATOR ', ' AFTER '}'»«v.content»«ENDFOR»'''

	static def dispatch CharSequence getContent(Cardinality it)
	{
		val call = container.connectivityCall
		if (call.connectivity.multiple)
		{
			if (call.args.empty)
				call.connectivity.nbElemsVar
			else
				'''mesh.«call.accessor».length'''
		}
		else
			'''1'''
	}

	static def dispatch CharSequence getContent(FunctionCall it)
	'''«function.codeName»(«FOR a:args SEPARATOR ', '»«a.content»«ENDFOR»)'''

	static def dispatch CharSequence getContent(ArgOrVarRef it)
	{
		if (target.linearAlgebra && !(iterators.empty && indices.empty))
			'''«getCodeName».getValue(«formatIteratorsAndIndices(target.type, iterators, indices)»)'''
		else
			'''«getCodeName»«formatIteratorsAndIndices(target.type, iterators, indices)»'''
	}

	static def String getCodeName(ArgOrVarRef it)
	{
		if (target.functionDimVar)
		{
			// In Java code the size of arrays does not appear explicitly like in NabLab.
			// It is possible to create a local variable to set it, i.e. final int x = a.length.
			// But sometimes it is not used and a warning appears.
			// To avoid that, sizes are referenced by array.length instead of the name of the var.
			FunctionContentProvider.getSizeOf(target.eContainer as Function, target as Variable)
		}
		else
		{
			val argOrVarRefModule = IrUtils.getContainerOfType(it, IrModule)
			val varModule = IrUtils.getContainerOfType(target, IrModule)
			if (argOrVarRefModule === varModule)
				target.codeName
			else
				'mainModule.' + target.codeName
		}
	}

	private static def CharSequence initArray(int[] sizes, CharSequence value)
	{
		if (sizes.empty) value
		else initArray(sizes.tail, '''«FOR i : 0..<sizes.head BEFORE '{' SEPARATOR ', ' AFTER '}'»«value»«ENDFOR»''')
	}
}
