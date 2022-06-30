/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.arcane

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
import fr.cea.nabla.ir.ir.IrPackage
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.MaxConstant
import fr.cea.nabla.ir.ir.MinConstant
import fr.cea.nabla.ir.ir.Parenthesis
import fr.cea.nabla.ir.ir.PrimitiveType
import fr.cea.nabla.ir.ir.RealConstant
import fr.cea.nabla.ir.ir.UnaryExpression
import fr.cea.nabla.ir.ir.Variable
import fr.cea.nabla.ir.ir.VectorConstant

import static fr.cea.nabla.ir.generator.arcane.TypeContentProvider.*

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.ContainerExtensions.*
import static extension fr.cea.nabla.ir.IrTypeExtensions.*

class ExpressionContentProvider
{
	static def dispatch CharSequence getContent(ContractedIf it) 
	'''(«condition.content» ? «thenExpression.content» ':' «elseExpression.content»'''

	static def dispatch CharSequence getContent(BinaryExpression it) 
	{
		val lContent = left.content
		val rContent = right.content
		'''«lContent» «operator» «rContent»'''
	}

	static def dispatch CharSequence getContent(UnaryExpression it) '''«operator»«expression.content»'''
	static def dispatch CharSequence getContent(Parenthesis it) '''(«expression.content»)'''
	static def dispatch CharSequence getContent(IntConstant it) '''«value»'''
	static def dispatch CharSequence getContent(RealConstant it) '''«value»'''
	static def dispatch CharSequence getContent(BoolConstant it) '''«value»'''

	static def dispatch CharSequence getContent(MinConstant it)
	{
		val t = type
		switch t
		{
			case (t.scalar && t.primitive == PrimitiveType::INT): '''numeric_limits<int>::min()'''
			// Be careful at MIN_VALUE which is a positive value for double.
			case (t.scalar && t.primitive == PrimitiveType::REAL): '''-numeric_limits<double>::max()'''
			default: throw new RuntimeException('Invalid expression Min for type: ' + t.label)
		}
	}

	static def dispatch CharSequence getContent(MaxConstant it)
	{
		val t = type
		switch t
		{
			case (t.scalar && t.primitive == PrimitiveType::INT): '''numeric_limits<int>::max()'''
			case (t.scalar && t.primitive == PrimitiveType::REAL): '''numeric_limits<double>::max()'''
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
			{
				val totalSize = t.intSizes.reduce[p1, p2| p1 * p2]
				if (TypeContentProvider.isNumArray(type))
				{
					val dimensions = t.intSizes.join(', ')
					'''«TypeContentProvider.getTypeName(type)»(«dimensions», {«FOR x : 0..<totalSize SEPARATOR ', '»«value.content»«ENDFOR»})'''		
				}
				else // RealX or Real XxX
				{
					'''{«FOR x : 0..<totalSize SEPARATOR ', '»«value.content»«ENDFOR»}'''
				}
			}
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
	{
		if (TypeContentProvider.isNumArray(type))
		{
			if (eContainer !== null && eContainer instanceof VectorConstant)
			{
				// the variable is declared with a type => no type to add
				'''«FOR v : values SEPARATOR ', '»«v.content»«ENDFOR»'''
			}
			else
			{
				val t = type as BaseType
				val dimensions = t.sizes.map[x | x.content].join(', ')
				// the type must be added, for example for FunctionCall
				'''«TypeContentProvider.getTypeName(type)»(«dimensions», {«FOR v : values SEPARATOR ', '»«v.content»«ENDFOR»})'''
			}
		}
		else // RealX or Real XxX
		{
			'''«TypeContentProvider.getTypeName(type)»{«FOR v : values SEPARATOR ', '»«v.content»«ENDFOR»}'''
		}
	}

	static def dispatch CharSequence getContent(Cardinality it)
	{
		val call = container.connectivityCall
		if (call.connectivity.multiple)
		{
			if (call.group !== null)
				'''m_mesh->getGroup("«call.group»").size()'''
			else if (call.args.empty)
				'''nb«call.connectivity.returnType.name.toFirstUpper»()'''
			else
				'''m_mesh->«call.accessor».size()'''
		}
		else
			'''1'''
	}

	static def dispatch CharSequence getContent(FunctionCall it)
	{
		'''«ArcaneUtils.getCodeName(function)»(«FOR a:args SEPARATOR ', '»«a.content»«ENDFOR»)'''
	}

	static def dispatch CharSequence getContent(ArgOrVarRef it)
	{
		if (target.functionDimVar)
		{
			// In Arcane code the size of arrays does not appear explicitly like in NabLab (no template).
			// It is possible to create a local variable to set it, i.e. final int x = a.length.
			// But sometimes it is not used and a warning appears.
			// To avoid that, sizes are referenced by array.length instead of the name of the var.
			FunctionContentProvider.getSizeOf(target.eContainer as Function, target as Variable)
		}
		else
		{
			if (ArcaneUtils.isArcaneManaged(target) && indices.empty && iterators.empty && eContainingFeature !== IrPackage.Literals.AFFECTATION__LEFT)
				'''«codeName»()''' // get the value of a VariableScalar...
			else if (target.linearAlgebra && !(iterators.empty && indices.empty))
				'''«codeName».getValue(«formatIteratorsAndIndices(target, iterators, indices)»)'''
			else
				'''«codeName»«formatIteratorsAndIndices(target, iterators, indices)»'''
		}
	}

	static def CharSequence getCodeName(ArgOrVarRef it)
	{
		val t = target
		switch t
		{
			case t.iteratorCounter: (t.eContainer as Iterator).index.name
			Variable: ArcaneUtils.getCodeName(t)
			default: t.name
		}
	}
}
