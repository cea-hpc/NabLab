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

import fr.cea.nabla.ir.IrUtils
import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.generator.cpp.CppGeneratorUtils
import fr.cea.nabla.ir.ir.ArgOrVarRef
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.BaseTypeConstant
import fr.cea.nabla.ir.ir.BinaryExpression
import fr.cea.nabla.ir.ir.BoolConstant
import fr.cea.nabla.ir.ir.Cardinality
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.ContractedIf
import fr.cea.nabla.ir.ir.Expression
import fr.cea.nabla.ir.ir.FunctionCall
import fr.cea.nabla.ir.ir.IntConstant
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.IrType
import fr.cea.nabla.ir.ir.ItemIndex
import fr.cea.nabla.ir.ir.LinearAlgebraType
import fr.cea.nabla.ir.ir.MaxConstant
import fr.cea.nabla.ir.ir.MinConstant
import fr.cea.nabla.ir.ir.Parenthesis
import fr.cea.nabla.ir.ir.PrimitiveType
import fr.cea.nabla.ir.ir.RealConstant
import fr.cea.nabla.ir.ir.UnaryExpression
import fr.cea.nabla.ir.ir.VectorConstant
import org.eclipse.xtend.lib.annotations.Data

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.ContainerExtensions.*
import static extension fr.cea.nabla.ir.IrTypeExtensions.*

@Data
abstract class ExpressionContentProvider
{
	protected abstract def CharSequence formatIterators(Iterable<String> iterators)

	def dispatch CharSequence getContent(ContractedIf it) 
	'''(«condition.content» ? «thenExpression.content» ':' «elseExpression.content»'''

	def dispatch CharSequence getContent(BinaryExpression it) 
	{
		val lContent = left.content
		val rContent = right.content
		'''«lContent» «operator» «rContent»'''
	}

	def dispatch CharSequence getContent(UnaryExpression it) '''«operator»«expression.content»'''
	def dispatch CharSequence getContent(Parenthesis it) '''(«expression.content»)'''
	def dispatch CharSequence getContent(IntConstant it) '''«value»'''
	def dispatch CharSequence getContent(RealConstant it) '''«value»'''
	def dispatch CharSequence getContent(BoolConstant it) '''«value»'''

	def dispatch CharSequence getContent(MinConstant it)
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

	def dispatch CharSequence getContent(MaxConstant it)
	{
		val t = type
		switch t
		{
			case (t.scalar && t.primitive == PrimitiveType::INT): '''numeric_limits<int>::max()'''
			case (t.scalar && t.primitive == PrimitiveType::REAL): '''numeric_limits<double>::max()'''
			default: throw new Exception('Invalid expression Max for type: ' + t.label)
		}
	}

	def dispatch CharSequence getContent(BaseTypeConstant it)
	{
		val t = type as BaseType

		if (t.sizes.exists[x | !(x instanceof IntConstant)])
			throw new RuntimeException("BaseTypeConstants size expressions must be IntConstant.")

		val sizes = t.sizes.map[x | (x as IntConstant).value]
		'''{«initArray(sizes, value.content)»}'''
	}

	def dispatch CharSequence getContent(VectorConstant it)
	'''{«innerContent»}'''

	def dispatch CharSequence getContent(Cardinality it)
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

	def dispatch CharSequence getContent(FunctionCall it)
	'''«CppGeneratorUtils.getCodeName(function)»(«FOR a:args SEPARATOR ', '»«a.content»«ENDFOR»)'''

	def dispatch CharSequence getContent(ArgOrVarRef it)
	{
		if (target.linearAlgebra && !(iterators.empty && indices.empty))
			'''«codeName».getValue(«formatIteratorsAndIndices(target.type, iterators, indices)»)'''
		else
			'''«codeName»«formatIteratorsAndIndices(target.type, iterators, indices)»'''
	}

	def formatIteratorsAndIndices(IrType type, Iterable<ItemIndex> iterators, Iterable<Expression> indices)
	{
		switch type
		{
			case (iterators.empty && indices.empty): ''''''
			BaseType: '''«FOR i : indices»[«i.content»]«ENDFOR»'''
			LinearAlgebraType: '''«FOR i : iterators SEPARATOR ', '»«i.name»«ENDFOR»«FOR i : indices SEPARATOR ', '»«i.content»«ENDFOR»'''
			ConnectivityType: '''«formatIterators(iterators.map[name])»«FOR i : indices»[«i.content»]«ENDFOR»'''
		}
	}

	def CharSequence getCodeName(ArgOrVarRef it)
	{
		if (IrUtils.getContainerOfType(it, IrModule) === IrUtils.getContainerOfType(target, IrModule))
			Utils.getCodeName(target)
		else
			'mainModule->' + Utils.getCodeName(target)
	}

	private def dispatch CharSequence getInnerContent(Expression it) { content }
	private def dispatch CharSequence getInnerContent(VectorConstant it)
	'''«FOR v : values SEPARATOR ', '»«v.innerContent»«ENDFOR»'''

	private def CharSequence initArray(int[] sizes, CharSequence value)
	'''«FOR size : sizes SEPARATOR ",  "»«FOR i : 0..<size SEPARATOR ', '»«value»«ENDFOR»«ENDFOR»'''
}


class DefaultExpressionContentProvider extends ExpressionContentProvider
{
	override formatIterators(Iterable<String> iterators)
	'''«FOR i : iterators»[«i»]«ENDFOR»'''
}

class KokkosExpressionContentProvider extends ExpressionContentProvider
{
	override formatIterators(Iterable<String> iterators)
	'''«FOR i : iterators BEFORE '(' SEPARATOR ', ' AFTER ')'»«i»«ENDFOR»'''
}
