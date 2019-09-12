/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.kokkos

import fr.cea.nabla.ir.ir.Array1D
import fr.cea.nabla.ir.ir.Array2D
import fr.cea.nabla.ir.ir.BaseTypeConstant
import fr.cea.nabla.ir.ir.BinaryExpression
import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.Constant
import fr.cea.nabla.ir.ir.ContractedIf
import fr.cea.nabla.ir.ir.FunctionCall
import fr.cea.nabla.ir.ir.IntMatrixConstant
import fr.cea.nabla.ir.ir.IntVectorConstant
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.MaxConstant
import fr.cea.nabla.ir.ir.MinConstant
import fr.cea.nabla.ir.ir.Parenthesis
import fr.cea.nabla.ir.ir.PrimitiveType
import fr.cea.nabla.ir.ir.RealMatrixConstant
import fr.cea.nabla.ir.ir.RealVectorConstant
import fr.cea.nabla.ir.ir.Scalar
import fr.cea.nabla.ir.ir.SimpleVariable
import fr.cea.nabla.ir.ir.UnaryExpression
import fr.cea.nabla.ir.ir.VarRef
import java.util.ArrayList
import org.eclipse.emf.ecore.EObject

import static extension fr.cea.nabla.ir.IrTypeExtensions.*
import static extension fr.cea.nabla.ir.JobExtensions.*
import static extension fr.cea.nabla.ir.generator.IteratorRefExtensions.*
import static extension fr.cea.nabla.ir.generator.Utils.*
import static extension fr.cea.nabla.ir.generator.kokkos.VariableExtensions.*

class ExpressionContentProvider
{
	static def dispatch CharSequence getContent(ContractedIf it) 
	'''(«condition.content» ? «thenExpression.content» ':' «elseExpression.content»'''

	static def dispatch CharSequence getContent(BinaryExpression it) 
	{
		val lContent = left.content
		val rContent = right.content

		if (left.type instanceof Scalar && right.type instanceof Scalar) 
			'''«lContent» «operator» «rContent»'''
		else 
			'''ArrayOperations::«operator.operatorName»(«lContent», «rContent»)'''
	}
	
	static def dispatch CharSequence getContent(UnaryExpression it) '''«operator»«expression.content»'''
	static def dispatch CharSequence getContent(Parenthesis it) '''(«expression.content»)'''
	static def dispatch CharSequence getContent(Constant it) '''«value»'''
	
	static def dispatch CharSequence getContent(MinConstant it) 
	{
		val t = type
		switch t
		{
			Scalar case (t.primitive == PrimitiveType::INT): '''numeric_limits<int>::min()'''
			Scalar case (t.primitive == PrimitiveType::REAL): '''numeric_limits<double>::min()'''
			default: throw new Exception('Invalid expression Min for type: ' + t.label)
		}
	}

	static def dispatch CharSequence getContent(MaxConstant it) 
	{
		val t = type
		switch t
		{
			Scalar case (t.primitive == PrimitiveType::INT): '''numeric_limits<int>::max()'''
			Scalar case (t.primitive == PrimitiveType::REAL): '''numeric_limits<double>::max()'''
			default: throw new Exception('Invalid expression Max for type: ' + t.label)
		}
	}
	
	static def dispatch CharSequence getContent(BaseTypeConstant it) 
	{
		val t = type
		switch t
		{
			Array1D: initConstant(t, value.content)
			Array2D: '''{«initConstant(t, value.content)»}''' // One additional bracket for matrix... Magic C++ !
			default: throw new Exception('Invalid path...')
		}
	}
	
	static def dispatch CharSequence getContent(IntVectorConstant it) 
	'''«FOR v : values BEFORE '{' SEPARATOR ', ' AFTER '}'»«v»«ENDFOR»'''
	
	static def dispatch CharSequence getContent(IntMatrixConstant it) 
	'''«FOR v : values BEFORE '{{' SEPARATOR ', ' AFTER '}}'»«v.content»«ENDFOR»'''
	
	static def dispatch CharSequence getContent(RealVectorConstant it) 
	'''«FOR v : values BEFORE '{' SEPARATOR ', ' AFTER '}'»«v»«ENDFOR»'''
	
	static def dispatch CharSequence getContent(RealMatrixConstant it) 
	'''«FOR v : values BEFORE '{{' SEPARATOR ', ' AFTER '}}'»«v.content»«ENDFOR»'''

	static def dispatch CharSequence getContent(FunctionCall it) 
	'''«function.provider»Functions::«function.name»(«FOR a:args SEPARATOR ', '»«a.content»«ENDFOR»)'''
	
	static def dispatch CharSequence getContent(VarRef it) 
	'''«codeName»«iteratorsContent»«FOR d:indices BEFORE '['  SEPARATOR '][' AFTER ']'»«d»«ENDFOR»'''

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
		if (array.supports.size < iterators.size) return ''
		var content = new ArrayList<CharSequence>
		for (r : iterators)
			content += r.indexName				
		return '(' + content.join(',') + ')'
	}
}