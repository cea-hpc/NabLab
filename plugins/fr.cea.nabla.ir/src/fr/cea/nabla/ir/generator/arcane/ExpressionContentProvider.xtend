/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.arcane

import fr.cea.nabla.ir.IrUtils
import fr.cea.nabla.ir.generator.CppGeneratorUtils
import fr.cea.nabla.ir.ir.ArgOrVarRef
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.BaseTypeConstant
import fr.cea.nabla.ir.ir.BinaryExpression
import fr.cea.nabla.ir.ir.BoolConstant
import fr.cea.nabla.ir.ir.Cardinality
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.ContractedIf
import fr.cea.nabla.ir.ir.Expression
import fr.cea.nabla.ir.ir.Function
import fr.cea.nabla.ir.ir.FunctionCall
import fr.cea.nabla.ir.ir.IntConstant
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.IrType
import fr.cea.nabla.ir.ir.ItemIndex
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.LinearAlgebraType
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
import static extension fr.cea.nabla.ir.generator.arcane.VariableExtensions.*

class ExpressionContentProvider
{
	static def formatIterators(Iterable<String> iterators)
	'''«FOR i : iterators»[«i»]«ENDFOR»'''

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
			default: throw new Exception('Invalid expression Min for type: ' + t.label)
		}
	}

	static def dispatch CharSequence getContent(MaxConstant it)
	{
		val t = type
		switch t
		{
			case (t.scalar && t.primitive == PrimitiveType::INT): '''numeric_limits<int>::max()'''
			case (t.scalar && t.primitive == PrimitiveType::REAL): '''numeric_limits<double>::max()'''
			default: throw new Exception('Invalid expression Max for type: ' + t.label)
		}
	}

	static def dispatch CharSequence getContent(BaseTypeConstant it)
	{
		val t = type as BaseType

		if (t.sizes.exists[x | !(x instanceof IntConstant)])
			throw new RuntimeException("BaseTypeConstants size expressions must be IntConstant.")

		val sizes = t.sizes.map[x | (x as IntConstant).value]
		'''{«initArray(sizes, value.content)»}'''
	}

	static def dispatch CharSequence getContent(VectorConstant it)
	'''{«innerContent»}'''

	static def dispatch CharSequence getContent(Cardinality it)
	{
		val call = container.connectivityCall
		if (call.connectivity.multiple)
		{
			if (call.args.empty)
				call.connectivity.nbElemsVar
			else
				'''mesh->«call.accessor».size()'''
		}
		else
			'''1'''
	}

	static def dispatch CharSequence getContent(FunctionCall it)
	'''«CppGeneratorUtils.getCodeName(function)»(«FOR a:args SEPARATOR ', '»«a.content»«ENDFOR»)'''

	static def dispatch CharSequence getContent(ArgOrVarRef it)
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
			if (target.linearAlgebra && !(iterators.empty && indices.empty))
				'''«codeName».getValue(«formatIteratorsAndIndices(target.type, iterators, indices)»)'''
			else
				'''«codeName»«formatIteratorsAndIndices(target.type, iterators, indices)»'''
		}
	}

	static def formatIteratorsAndIndices(IrType type, Iterable<ItemIndex> iterators, Iterable<Expression> indices)
	{
		switch type
		{
			case (iterators.empty && indices.empty): ''''''
			BaseType: '''«FOR i : indices»[«i.content»]«ENDFOR»'''
			LinearAlgebraType: '''«FOR i : iterators SEPARATOR ', '»«i.name»«ENDFOR»«FOR i : indices SEPARATOR ', '»«i.content»«ENDFOR»'''
			ConnectivityType: '''«formatIterators(iterators.map[itemName])»«FOR i : indices»[«i.content»]«ENDFOR»'''
		}
	}

	static def CharSequence getCodeName(ArgOrVarRef it)
	{
		val t = target
		val tName = switch t
		{
			Variable case t.option: 'options.' + t.name
			case t.iteratorCounter: (t.eContainer as Iterator).index.name
			Variable: t.codeName
			default: t.name
		}

		if (IrUtils.getContainerOfType(it, IrModule) === IrUtils.getContainerOfType(target, IrModule))
			tName
		else
			'mainModule->' + tName
	}

	private static def dispatch CharSequence getInnerContent(Expression it) { content }
	private static def dispatch CharSequence getInnerContent(VectorConstant it)
	'''«FOR v : values SEPARATOR ', '»«v.innerContent»«ENDFOR»'''

	private static def CharSequence initArray(int[] sizes, CharSequence value)
	'''«FOR size : sizes SEPARATOR ",  "»«FOR i : 0..<size SEPARATOR ', '»«value»«ENDFOR»«ENDFOR»'''
}
