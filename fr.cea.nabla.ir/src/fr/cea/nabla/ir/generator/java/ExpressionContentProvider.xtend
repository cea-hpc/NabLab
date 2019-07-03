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

import fr.cea.nabla.ir.ir.ArrayVariable
import fr.cea.nabla.ir.ir.BinaryExpression
import fr.cea.nabla.ir.ir.BoolConstant
import fr.cea.nabla.ir.ir.ContractedIf
import fr.cea.nabla.ir.ir.FunctionCall
import fr.cea.nabla.ir.ir.IntConstant
import fr.cea.nabla.ir.ir.MaxConstant
import fr.cea.nabla.ir.ir.MinConstant
import fr.cea.nabla.ir.ir.Parenthesis
import fr.cea.nabla.ir.ir.Real2Constant
import fr.cea.nabla.ir.ir.Real2x2Constant
import fr.cea.nabla.ir.ir.Real3Constant
import fr.cea.nabla.ir.ir.Real3x3Constant
import fr.cea.nabla.ir.ir.RealConstant
import fr.cea.nabla.ir.ir.ScalarVariable
import fr.cea.nabla.ir.ir.UnaryExpression
import fr.cea.nabla.ir.ir.VarRef
import fr.cea.nabla.ir.ir.Variable

import static extension fr.cea.nabla.ir.VariableExtensions.*
import static extension fr.cea.nabla.ir.generator.IteratorRefExtensions.*
import static extension fr.cea.nabla.ir.generator.java.Ir2JavaUtils.*
import fr.cea.nabla.ir.Utils

class ExpressionContentProvider
{
	static def dispatch CharSequence getContent(ContractedIf it) 
	'''(«condition.content» ? «thenExpression.content» ':' «elseExpression.content»'''
	
	static def dispatch CharSequence getContent(BinaryExpression it) 
	{
		val lContent = left.content
		val rContent = right.content

		if (!left.getType().basicType.javaBasicType) '''«lContent».«operator.javaOperator»(«rContent»)'''
		// si on arrive ici sans erreur de compilation, l'opérateur est commutatif
		else if (!right.getType().basicType.javaBasicType) '''«rContent».«operator.javaOperator»(«lContent»)'''
		else '''«lContent» «operator» «rContent»'''
	}

	static def dispatch CharSequence getContent(UnaryExpression it) 
	{
		val content = expression.content
		if (expression.getType().basicType.javaBasicType) '''«operator»«content»'''
		else '''«content».«operator.javaOperator»()'''
	}

	static def dispatch CharSequence getContent(Parenthesis it) '''(«expression.content»)'''
	static def dispatch CharSequence getContent(IntConstant it) '''«value»'''
	static def dispatch CharSequence getContent(RealConstant it) '''«value»'''
	static def dispatch CharSequence getContent(Real2Constant it) '''new Real2(«x», «y»)'''
	static def dispatch CharSequence getContent(Real3Constant it) '''new Real3(«x», «y», «z»)'''
	static def dispatch CharSequence getContent(Real2x2Constant it) '''new Real2x2(«x.content», «y.content»)'''
	static def dispatch CharSequence getContent(Real3x3Constant it) '''new Real3x3(«x.content», «y.content», «z.content»)'''
	static def dispatch CharSequence getContent(BoolConstant it) '''«value»'''
	
	static def dispatch CharSequence getContent(MinConstant it) 
	{
		switch getType().basicType
		{
			case INT  : '''Integer.MIN_VALUE'''
			case REAL : '''Double.MIN_VALUE'''
			case REAL2, case REAL2X2, case REAL3, case REAL3X3: '''new «getType().basicType»(Double.MIN_VALUE)'''
			default: throw new Exception('Invalid expression Min for type: ' + getType().basicType)
		}
	}

	static def dispatch CharSequence getContent(MaxConstant it) 
	{
		switch getType().basicType
		{
			case INT  : '''Integer.MAX_VALUE'''
			case REAL : '''Double.MAX_VALUE'''
			case REAL2, case REAL2X2, case REAL3, case REAL3X3: '''new «getType().basicType»(Double.MAX_VALUE)'''
			default: throw new Exception('Invalid expression Max for type: ' + getType().basicType)
		}
	}

	static def dispatch CharSequence getContent(FunctionCall it) 
	'''«function.provider»«Utils::FunctionAndReductionproviderSuffix».«function.name»(«FOR a:args SEPARATOR ', '»«a.content»«ENDFOR»)'''
	
	static def dispatch CharSequence getContent(VarRef it)
	'''«variable.codeName»«iteratorsContent»«FOR f:fields BEFORE '.' SEPARATOR '.'»get«f.toFirstUpper»()«ENDFOR»'''

	private static def getCodeName(Variable it)
	{
		if (scalarConst) 'options.' + name
		else name
	}
	
	private static def getIteratorsContent(VarRef it) 
	{ 
		if (iterators.empty || variable instanceof ScalarVariable) return ''
		val array = variable as ArrayVariable
		if (array.dimensions.size < iterators.size) return ''
		var content = ''
		for (r : iterators)
			content += '[' + r.indexName + ']'					
		return content
	}
}