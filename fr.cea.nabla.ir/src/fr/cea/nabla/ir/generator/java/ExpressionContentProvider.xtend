/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 * 	Benoit Lelandais - initial implementation
 * 	Marie-Pierre Oudot - initial implementation
 * 	Jean-Sylvain Camier - Nabla generation support
 *******************************************************************************/
package fr.cea.nabla.ir.generator.java

import fr.cea.nabla.ir.Utils
import fr.cea.nabla.ir.ir.BinaryExpression
import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.Constant
import fr.cea.nabla.ir.ir.ContractedIf
import fr.cea.nabla.ir.ir.FunctionCall
import fr.cea.nabla.ir.ir.MaxConstant
import fr.cea.nabla.ir.ir.MinConstant
import fr.cea.nabla.ir.ir.Parenthesis
import fr.cea.nabla.ir.ir.SimpleVariable
import fr.cea.nabla.ir.ir.UnaryExpression
import fr.cea.nabla.ir.ir.VarRef
import fr.cea.nabla.ir.ir.Variable
import java.util.ArrayList

import static extension fr.cea.nabla.ir.BaseTypeExtensions.*
import static extension fr.cea.nabla.ir.VariableExtensions.*
import static extension fr.cea.nabla.ir.generator.IteratorRefExtensions.*
import static extension fr.cea.nabla.ir.generator.java.Ir2JavaUtils.*

class ExpressionContentProvider
{
	static def dispatch CharSequence getContent(ContractedIf it) 
	'''(«condition.content» ? «thenExpression.content» ':' «elseExpression.content»'''
	
	static def dispatch CharSequence getContent(BinaryExpression it) 
	{
		val lContent = left.content
		val rContent = right.content

		if (left.type.scalar && right.type.scalar) 
			'''«lContent» «operator» «rContent»'''
		else 
			'''OperatorExtensions.operator_«operator.operatorName»(«lContent», «rContent»)'''
	}

	static def dispatch CharSequence getContent(UnaryExpression it) '''«operator»«expression.content»'''
	static def dispatch CharSequence getContent(Parenthesis it) '''(«expression.content»)'''
	static def dispatch CharSequence getContent(Constant it)
	{
		if (values.size==1) initConstant(type.dimSizes, values.head)
		else '''new double[]{«values.join(",")»}'''
	}
	
	static def dispatch CharSequence getContent(MinConstant it) 
	{
		switch getType().root
		{
			case INT  : '''Integer.MIN_VALUE'''
			case REAL : '''Double.MIN_VALUE'''
			default: throw new Exception('Invalid expression Min for type: ' + getType().label)
		}
	}

	static def dispatch CharSequence getContent(MaxConstant it) 
	{
		switch getType().root
		{
			case INT  : '''Integer.MAX_VALUE'''
			case REAL : '''Double.MAX_VALUE'''
			default: throw new Exception('Invalid expression Max for type: ' + getType().label)
		}
	}

	static def dispatch CharSequence getContent(FunctionCall it) 
	'''«function.provider»«Utils::FunctionAndReductionproviderSuffix».«function.name»(«FOR a:args SEPARATOR ', '»«a.content»«ENDFOR»)'''
	
	static def dispatch CharSequence getContent(VarRef it)
	'''«variable.codeName»«iteratorsContent»«FOR d:arrayTypeIndices»[«d»]«ENDFOR»'''

	private static def getCodeName(Variable it)
	{
		if (scalarConst) 'options.' + name
		else name
	}
	
	private static def getIteratorsContent(VarRef it) 
	{ 
		if (iterators.empty || variable instanceof SimpleVariable) return ''
		val array = variable as ConnectivityVariable
		if (array.dimensions.size < iterators.size) return ''
		var content = ''
		for (r : iterators)
			content += '[' + r.indexName + ']'					
		return content
	}
	
	private static def String initConstant(int[] dimSizes, String value)
	{
		if (dimSizes.empty) value
		else 
		{
			val dim = dimSizes.head
			val t = dimSizes.tail
			val values = new ArrayList<String>
			for (i : 0..<dim) values += initConstant(t, value)
			'{' + values.join(',') + '}'
		}
	}
}