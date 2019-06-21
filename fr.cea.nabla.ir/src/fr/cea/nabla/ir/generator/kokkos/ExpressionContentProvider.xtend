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
package fr.cea.nabla.ir.generator.kokkos

import fr.cea.nabla.ir.ir.BinaryExpression
import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.Constant
import fr.cea.nabla.ir.ir.ContractedIf
import fr.cea.nabla.ir.ir.FunctionCall
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.MaxConstant
import fr.cea.nabla.ir.ir.MinConstant
import fr.cea.nabla.ir.ir.Parenthesis
import fr.cea.nabla.ir.ir.SimpleVariable
import fr.cea.nabla.ir.ir.UnaryExpression
import fr.cea.nabla.ir.ir.VarRef
import fr.cea.nabla.ir.ir.Variable
import java.util.ArrayList
import org.eclipse.emf.ecore.EObject

import static extension fr.cea.nabla.ir.BaseTypeExtensions.*
import static extension fr.cea.nabla.ir.JobExtensions.*
import static extension fr.cea.nabla.ir.VariableExtensions.isScalarConst
import static extension fr.cea.nabla.ir.generator.IteratorRefExtensions.*

class ExpressionContentProvider
{
	static def dispatch CharSequence getContent(ContractedIf it) 
	'''(«condition.content» ? «thenExpression.content» ':' «elseExpression.content»'''

	static def dispatch CharSequence getContent(BinaryExpression it) '''«left.content» «operator» «right.content»'''
	static def dispatch CharSequence getContent(UnaryExpression it) '''«operator»«expression.content»'''
	static def dispatch CharSequence getContent(Parenthesis it) '''(«expression.content»)'''
	static def dispatch CharSequence getContent(Constant it) 
	{
		if (values.size==1) '''«values.head»''' 
		else '''{«values.join(",")»}'''
	}
	
	static def dispatch CharSequence getContent(MinConstant it) 
	{
		switch getType().root
		{
			case INT  : '''numeric_limits<int>::min()'''
			case REAL : '''numeric_limits<double>::min()'''
			default: throw new Exception('Invalid expression Min for type: ' + getType().label)
		}
	}

	static def dispatch CharSequence getContent(MaxConstant it) 
	{
		switch getType().root
		{
			case INT  : '''numeric_limits<int>::max()'''
			case REAL : '''numeric_limits<double>::max()'''
			default: throw new Exception('Invalid expression Max for type: ' + getType().label)
		}
	}

	static def dispatch CharSequence getContent(FunctionCall it) 
	'''«function.provider»Functions::«function.name»(«FOR a:args SEPARATOR ', '»«a.content»«ENDFOR»)'''
	
	static def dispatch CharSequence getContent(VarRef it) 
	'''«codeName»«iteratorsContent»«FOR d:arrayTypeIndices BEFORE '('  SEPARATOR ',' AFTER ')'»«d»«ENDFOR»'''

	private static def getCodeName(VarRef it)
	{
		if (constRef) '''as_const(«variable.codeName»)'''
		else '''«variable.codeName»'''
	}
	
	private static def isConstRef(VarRef it)
	{
		val j = getJob(it)
		val scalar = variable instanceof SimpleVariable
		if (j === null) scalar
		else scalar && j.inVars.exists[x | x == variable]
	}
	
	private static def getCodeName(Variable it)
	{
		if (scalarConst) 'options->' + name
		else name
	}

	private static def Job getJob(EObject o)
	{
		if (o === null) null
		else if (o instanceof Job) o as Job
		else o.eContainer.job
	}

	private static def getIteratorsContent(VarRef it) 
	{ 
		if (iterators.empty || variable instanceof SimpleVariable) return ''
		val array = variable as ConnectivityVariable
		if (array.dimensions.size < iterators.size) return ''
		var content = new ArrayList<CharSequence>
		for (r : iterators)
			content += r.indexName				
		return '(' + content.join(',') + ')'
	}
}