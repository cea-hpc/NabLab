/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.typing

import com.google.inject.Inject
import fr.cea.nabla.VarExtensions
import fr.cea.nabla.nabla.And
import fr.cea.nabla.nabla.Arg
import fr.cea.nabla.nabla.BaseTypeConstant
import fr.cea.nabla.nabla.BoolConstant
import fr.cea.nabla.nabla.Comparison
import fr.cea.nabla.nabla.ConnectivityVar
import fr.cea.nabla.nabla.ContractedIf
import fr.cea.nabla.nabla.Equality
import fr.cea.nabla.nabla.Expression
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.IntConstant
import fr.cea.nabla.nabla.IntMatrixConstant
import fr.cea.nabla.nabla.IntVectorConstant
import fr.cea.nabla.nabla.MaxConstant
import fr.cea.nabla.nabla.MinConstant
import fr.cea.nabla.nabla.Minus
import fr.cea.nabla.nabla.Modulo
import fr.cea.nabla.nabla.MulOrDiv
import fr.cea.nabla.nabla.Not
import fr.cea.nabla.nabla.Or
import fr.cea.nabla.nabla.Parenthesis
import fr.cea.nabla.nabla.Plus
import fr.cea.nabla.nabla.RealConstant
import fr.cea.nabla.nabla.RealMatrixConstant
import fr.cea.nabla.nabla.RealVectorConstant
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.SimpleVar
import fr.cea.nabla.nabla.SpaceIteratorRef
import fr.cea.nabla.nabla.UnaryMinus
import fr.cea.nabla.nabla.VarRef
import java.util.List

class ExpressionTypeProvider
{
	@Inject extension DeclarationProvider
	@Inject extension BinaryOperationsTypeProvider
	@Inject extension PrimitiveTypeTypeProvider
	@Inject extension BaseTypeTypeProvider
	@Inject extension VarTypeProvider
	@Inject extension VarExtensions

	def dispatch NablaType getTypeFor(ContractedIf it) { then.typeFor }

	def dispatch NablaType getTypeFor(Or it) { new NSTBoolScalar }	
	def dispatch NablaType getTypeFor(And it) { new NSTBoolScalar }
	def dispatch NablaType getTypeFor(Equality it) { new NSTBoolScalar }
	def dispatch NablaType getTypeFor(Comparison it) { new NSTBoolScalar }
	def dispatch NablaType getTypeFor(Plus it) { getTypeFor(left, right, op) }
	def dispatch NablaType getTypeFor(Minus it) { getTypeFor(left, right, op) }
	def dispatch NablaType getTypeFor(MulOrDiv it)  { getTypeFor(left, right, op) }
	def dispatch NablaType getTypeFor(Modulo it)  { new NSTIntScalar }

	def dispatch NablaType getTypeFor(Parenthesis it) { expression?.typeFor }
	def dispatch NablaType getTypeFor(UnaryMinus it) { expression?.typeFor }
	def dispatch NablaType getTypeFor(Not it) { expression?.typeFor }

	def dispatch NablaType getTypeFor(IntConstant it) { new NSTIntScalar }
	def dispatch NablaType getTypeFor(RealConstant it) { new NSTRealScalar }
	def dispatch NablaType getTypeFor(BoolConstant it)  { new NSTBoolScalar }

	def dispatch NablaType getTypeFor(MinConstant it) { type.typeFor }
	def dispatch NablaType getTypeFor(MaxConstant it) { type.typeFor }

	def dispatch NablaType getTypeFor(FunctionCall it)
	{
		val decl = declaration
		if (decl === null) null
		else decl.returnType
	}

	def dispatch NablaType getTypeFor(ReductionCall it)
	{
		val decl = declaration
		if (decl === null) null
		else decl.returnType
	}

	def dispatch NablaType getTypeFor(VarRef it)
	{
		if (variable === null || variable.eIsProxy) null
		else getTypeForVar(variable, spaceIterators, indices.size)
	}

	private def dispatch NablaType getTypeForVar(SimpleVar v, List<SpaceIteratorRef> iterators, int nbIndices)
	{
		if (iterators.empty)
		{
			val t = v.baseType.typeFor
			getTypeForVar(t, nbIndices)
		}
		else null
	}

	private def dispatch NablaType getTypeForVar(ConnectivityVar v, List<SpaceIteratorRef> iterators, int nbIndices)
	{
		if (iterators.empty)
			if (nbIndices== 0) v.typeFor
			else null
		else
		{
			if (iterators.size == v.supports.size)
				getTypeForVar(v.baseType.typeFor, nbIndices)
			else
				null	
		}
	}

	private def dispatch NablaType getTypeForVar(Arg v, List<SpaceIteratorRef> iterators, int nbIndices)
	{
		// TODO
		null
	}

	private def NablaType getTypeForVar(NablaSimpleType t, int nbIndices)
	{
		switch t
		{
			case nbIndices == 0 : t
			NSTArray1D case nbIndices == 1 : t.primitive.typeFor 
			NSTArray2D case nbIndices == 2 : t.primitive.typeFor
			default : null 
		}
	}

	def dispatch NablaType getTypeFor(IntVectorConstant it) { new NSTIntArray1D(values.size) }
	def dispatch NablaType getTypeFor(RealVectorConstant it) { new NSTRealArray1D(values.size) }
	def dispatch NablaType getTypeFor(IntMatrixConstant it) { new NSTIntArray2D(values.size, values.head.values.size) }
	def dispatch NablaType getTypeFor(RealMatrixConstant it) { new NSTRealArray2D(values.size, values.head.values.size) }
	def dispatch NablaType getTypeFor(BaseTypeConstant it) { type.typeFor }

	def NablaSimpleType getTypeFor(Expression a, Expression b, String op)
	{
		val atype = a?.typeFor
		val btype = b?.typeFor
		if (atype !== null && btype !== null && atype instanceof NablaSimpleType && btype instanceof NablaSimpleType)
			getTypeFor(atype as NablaSimpleType, btype as NablaSimpleType, op)
		else 
			null
	}
}