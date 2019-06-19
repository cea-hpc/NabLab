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
import fr.cea.nabla.ir.ir.BoolConstant
import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.ContractedIf
import fr.cea.nabla.ir.ir.Expression
import fr.cea.nabla.ir.ir.FunctionCall
import fr.cea.nabla.ir.ir.IntConstant
import fr.cea.nabla.ir.ir.MaxConstant
import fr.cea.nabla.ir.ir.MinConstant
import fr.cea.nabla.ir.ir.Parenthesis
import fr.cea.nabla.ir.ir.RealConstant
import fr.cea.nabla.ir.ir.RealVectorConstant
import fr.cea.nabla.ir.ir.SimpleVariable
import fr.cea.nabla.ir.ir.UnaryExpression
import fr.cea.nabla.ir.ir.VarRef
import fr.cea.nabla.ir.ir.Variable

import static extension fr.cea.nabla.ir.BaseTypeExtensions.*
import static extension fr.cea.nabla.ir.VariableExtensions.*
import static extension fr.cea.nabla.ir.generator.IteratorRefExtensions.*

class ExpressionContentProvider
{
	static def dispatch CharSequence getContent(ContractedIf it) 
	'''(«condition.content» ? «thenExpression.content» ':' «elseExpression.content»'''
	
	static def dispatch CharSequence getContent(BinaryExpression it) { generateLoop(type.dimSizes, 0) }
	static def dispatch CharSequence getContent(UnaryExpression it)  { generateLoop(type.dimSizes, 0) }
	static def dispatch CharSequence getContent(Parenthesis it) '''(«expression.content»)'''
	static def dispatch CharSequence getContent(IntConstant it) '''«value»'''
	static def dispatch CharSequence getContent(RealConstant it) '''«value»'''
	static def dispatch CharSequence getContent(RealVectorConstant it) '''{«values.join(",")»}'''
	static def dispatch CharSequence getContent(BoolConstant it) '''«value»'''
	
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
	'''«variable.codeName»«iteratorsContent»«FOR d:variable.type.dimSizes»[«d»]«ENDFOR»'''

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
	
	private static def CharSequence generateLoop(BinaryExpression exp, Iterable<Integer> dimSizes, int loopCount)
	'''
		«IF dimSizes.empty»
			«getAccessor(exp.left, loopCount)» «exp.operator» «getAccessor(exp.right, loopCount)»
		«ELSE»
			for(int i«loopCount»=0 ; i<«dimSizes.head» ; ++i)
				«generateLoop(exp, dimSizes.tail, loopCount+1)»
		«ENDIF»
	'''
	
	private static def CharSequence generateLoop(UnaryExpression exp, Iterable<Integer> dimSizes, int loopCount)
	'''
		«IF dimSizes.empty»
			«exp.operator» «getAccessor(exp.expression, loopCount)»
		«ELSE»
			for(int i«loopCount»=0 ; i<«dimSizes.head» ; ++i)
				«generateLoop(exp, dimSizes.tail, loopCount+1)»
		«ENDIF»
	'''

	static def getAccessor(Expression e, int loopCount)
	{
		var eContent = e.content
		for (i : 0..<loopCount) 
			eContent = '''«eContent»[i«i»]'''
		return eContent
	}
}