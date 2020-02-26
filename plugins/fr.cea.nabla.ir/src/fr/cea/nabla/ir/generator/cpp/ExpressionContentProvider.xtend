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

import fr.cea.nabla.ir.ir.ArgOrVarRef
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.BaseTypeConstant
import fr.cea.nabla.ir.ir.BinaryExpression
import fr.cea.nabla.ir.ir.BoolConstant
import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.ContractedIf
import fr.cea.nabla.ir.ir.FunctionCall
import fr.cea.nabla.ir.ir.IntConstant
import fr.cea.nabla.ir.ir.MaxConstant
import fr.cea.nabla.ir.ir.MinConstant
import fr.cea.nabla.ir.ir.Parenthesis
import fr.cea.nabla.ir.ir.PrimitiveType
import fr.cea.nabla.ir.ir.RealConstant
import fr.cea.nabla.ir.ir.SimpleVariable
import fr.cea.nabla.ir.ir.SizeTypeInt
import fr.cea.nabla.ir.ir.UnaryExpression
import fr.cea.nabla.ir.ir.VectorConstant
import java.util.ArrayList
import org.eclipse.xtend.lib.annotations.Data

import static extension fr.cea.nabla.ir.IrTypeExtensions.*
import static extension fr.cea.nabla.ir.generator.IteratorRefExtensions.*
import static extension fr.cea.nabla.ir.generator.SizeTypeContentProvider.*
import static extension fr.cea.nabla.ir.generator.Utils.*

@Data
class ExpressionContentProvider
{
	val extension TypeContentProvider

	def dispatch CharSequence getContent(ContractedIf it) 
	'''(«condition.content» ? «thenExpression.content» ':' «elseExpression.content»'''

	def dispatch CharSequence getContent(BinaryExpression it) 
	{
		val lContent = left.content
		val rContent = right.content

		if (left.type.scalar && right.type.scalar) 
			'''«lContent» «operator» «rContent»'''
		else 
			'''ArrayOperations::«operator.operatorName»(«lContent», «rContent»)'''
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
			case (t.scalar && t.primitive == PrimitiveType::REAL): '''numeric_limits<double>::min()'''
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
		val sizes = t.sizes.filter(SizeTypeInt).map[value]
		'''{«initArray(sizes, value.content)»}''' // One additional bracket for matrix... Magic C++ !
	}

	def dispatch CharSequence getContent(VectorConstant it)
	'''«FOR v : values BEFORE '{{' SEPARATOR ', ' AFTER '}}'»«v.content»«ENDFOR»'''

	def dispatch CharSequence getContent(FunctionCall it)
	{
		if (function.name == 'solveLinearSystem')
			'''«function.getCodeName("::")»(«FOR a:args SEPARATOR ', '»«a.content»«ENDFOR», cg_info)'''
		else
			'''«function.getCodeName("::")»(«FOR a:args SEPARATOR ', '»«a.content»«ENDFOR»)'''
	}

	def dispatch CharSequence getContent(ArgOrVarRef it)
	'''«target.getCodeName('->')»«iteratorsContent»«FOR d:indices BEFORE '['  SEPARATOR '][' AFTER ']'»«d.content»«ENDFOR»'''

	private def getIteratorsContent(ArgOrVarRef it)
	{
		if (iterators.empty || target instanceof SimpleVariable) return ''
		val array = target as ConnectivityVariable
		if (array.type.connectivities.size < iterators.size) return ''
		var content = new ArrayList<String>
		for (r : iterators)
			content += r.indexName
		content.formatVarIteratorsContent
	}
}
