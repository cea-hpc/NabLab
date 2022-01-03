/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.python

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
import static extension fr.cea.nabla.ir.generator.python.TypeContentProvider.*

class ExpressionContentProvider
{
	static def dispatch CharSequence getContent(ContractedIf it)
	'''if «condition.content»: «thenExpression.content» else: «elseExpression.content»'''

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
			case (t.scalar && t.primitive == PrimitiveType::INT): '''-sys.maxsize - 1'''
			// Be careful at MIN_VALUE which is a positive value for double.
			case (t.scalar && t.primitive == PrimitiveType::REAL): '''-sys.float_info.max'''
			default: throw new RuntimeException('Invalid expression Min for type: ' + t.label)
		}
	}

	static def dispatch CharSequence getContent(MaxConstant it)
	{
		val t = type
		switch t
		{
			case (t.scalar && t.primitive == PrimitiveType::INT): '''sys.maxsize'''
			case (t.scalar && t.primitive == PrimitiveType::REAL): '''sys.float_info.max'''
			default: throw new RuntimeException('Invalid expression Max for type: ' + t.label)
		}
	}

	static def dispatch CharSequence getContent(BaseTypeConstant it)
	{
		val t = type as BaseType

		if (t.sizes.empty)
			// scalar type
			value.content
		else
			'''np.full((«FOR s : type.baseSizes SEPARATOR ", "»«s.content»«ENDFOR»), «value.content», dtype=np.«type.primitive.numpyType»)'''
	}

	static def dispatch CharSequence getContent(VectorConstant it)
	'''np.array(«FOR v : values SEPARATOR ', '»«v.content»«ENDFOR», dtype=np.«type.primitive.numpyType»)'''

	static def dispatch CharSequence getContent(Cardinality it)
	{
		val call = container.connectivityCall
		if (call.connectivity.multiple)
		{
			if (call.args.empty)
				PythonGeneratorUtils.getNbElemsVar(call.connectivity)
			else
				'''len(mesh.«call.accessor»)'''
		}
		else
			'''1'''
	}

	static def dispatch CharSequence getContent(FunctionCall it)
	'''«PythonGeneratorUtils.getCodeName(function)»(«FOR a:args SEPARATOR ', '»«a.content»«ENDFOR»)'''

	static def dispatch CharSequence getContent(ArgOrVarRef it)
	{
		if (target.linearAlgebra && !(iterators.empty && indices.empty))
			'''«getCodeName».getValue(«FOR i : iterators.map[name] + indices.map[content] SEPARATOR ', '»«i»«ENDFOR»)'''
		else
			'''«getCodeName»«FOR i : iterators.map[name] + indices.map[content] BEFORE '[' SEPARATOR ', ' AFTER ']'»«i»«ENDFOR»'''
	}

	static def String getCodeName(ArgOrVarRef it)
	{
		if (target.functionDimVar)
		{
			// In Python code the size of arrays does not appear explicitly like in NabLab.
			// It is possible to create a local variable to set it, i.e. final int x = len(a).
			// But sometimes it is not used and a warning appears.
			// To avoid that, sizes are referenced by array.length instead of the name of the var.
			FunctionContentProvider.getSizeOf(target.eContainer as Function, target as Variable)
		}
		else
		{
			val argOrVarRefModule = IrUtils.getContainerOfType(it, IrModule)
			val varModule = IrUtils.getContainerOfType(target, IrModule)
			if (argOrVarRefModule === varModule)
				PythonGeneratorUtils.getCodeName(target)
			else
				'self.mainModule.' + PythonGeneratorUtils.getCodeName(target)
		}
	}
}
