/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.typing

import com.google.inject.Inject
import fr.cea.nabla.ArgOrVarExtensions
import fr.cea.nabla.BaseTypeSizeEvaluator
import fr.cea.nabla.nabla.And
import fr.cea.nabla.nabla.Arg
import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.BaseTypeConstant
import fr.cea.nabla.nabla.BoolConstant
import fr.cea.nabla.nabla.Cardinality
import fr.cea.nabla.nabla.Comparison
import fr.cea.nabla.nabla.ConnectivityVar
import fr.cea.nabla.nabla.ContractedIf
import fr.cea.nabla.nabla.Div
import fr.cea.nabla.nabla.Equality
import fr.cea.nabla.nabla.Expression
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.IntConstant
import fr.cea.nabla.nabla.MaxConstant
import fr.cea.nabla.nabla.MinConstant
import fr.cea.nabla.nabla.Minus
import fr.cea.nabla.nabla.Modulo
import fr.cea.nabla.nabla.Mul
import fr.cea.nabla.nabla.NablaFactory
import fr.cea.nabla.nabla.Not
import fr.cea.nabla.nabla.Or
import fr.cea.nabla.nabla.Parenthesis
import fr.cea.nabla.nabla.Plus
import fr.cea.nabla.nabla.RealConstant
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.SimpleVar
import fr.cea.nabla.nabla.SpaceIteratorRef
import fr.cea.nabla.nabla.TimeIterator
import fr.cea.nabla.nabla.UnaryMinus
import fr.cea.nabla.nabla.VectorConstant
import fr.cea.nabla.overloading.DeclarationProvider
import java.util.List

class ExpressionTypeProvider
{
	@Inject extension BaseTypeSizeEvaluator
	@Inject extension DeclarationProvider
	@Inject extension BinaryOperationsTypeProvider
	@Inject extension PrimitiveTypeTypeProvider
	@Inject extension BaseTypeTypeProvider
	@Inject extension ArgOrVarTypeProvider
	@Inject extension ArgOrVarExtensions

	def NablaSimpleType getTypeFor(Expression a, Expression b, String op)
	{
		val atype = a?.typeFor
		val btype = b?.typeFor
		if (atype !== null && btype !== null && atype instanceof NablaSimpleType && btype instanceof NablaSimpleType)
			getTypeFor(atype as NablaSimpleType, btype as NablaSimpleType, op)
		else 
			null
	}

	def dispatch NablaType getTypeFor(ContractedIf it) { then?.typeFor }
	def dispatch NablaType getTypeFor(Or it) { new NSTBoolScalar }
	def dispatch NablaType getTypeFor(And it) { new NSTBoolScalar }
	def dispatch NablaType getTypeFor(Equality it) { new NSTBoolScalar }
	def dispatch NablaType getTypeFor(Comparison it) { new NSTBoolScalar }
	def dispatch NablaType getTypeFor(Plus it) { getTypeFor(left, right, op) }
	def dispatch NablaType getTypeFor(Minus it) { getTypeFor(left, right, op) }
	def dispatch NablaType getTypeFor(Mul it) { getTypeFor(left, right, op) }
	def dispatch NablaType getTypeFor(Div it) { getTypeFor(left, right, op) }
	def dispatch NablaType getTypeFor(Modulo it) { new NSTIntScalar }
	def dispatch NablaType getTypeFor(Parenthesis it) { expression?.typeFor }
	def dispatch NablaType getTypeFor(UnaryMinus it) { expression?.typeFor }
	def dispatch NablaType getTypeFor(Not it) { new NSTBoolScalar }
	def dispatch NablaType getTypeFor(IntConstant it) { new NSTIntScalar }
	def dispatch NablaType getTypeFor(RealConstant it) { new NSTRealScalar }
	def dispatch NablaType getTypeFor(BoolConstant it)  { new NSTBoolScalar }
	def dispatch NablaType getTypeFor(MinConstant it) { type?.typeFor }
	def dispatch NablaType getTypeFor(MaxConstant it) { type?.typeFor }

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
		else decl.type
	}

	def dispatch NablaType getTypeFor(BaseTypeConstant it)
	{
		type?.typeFor
	}

	def dispatch NablaType getTypeFor(VectorConstant it)
	{
		if (values.size > 0)
		{
			val eltType = values.get(0).typeFor
			val intConst = createIntConstant(values.size)
			switch eltType
			{
				NSTBoolScalar: new NSTBoolArray1D(intConst, values.size)
				NSTIntScalar: new NSTIntArray1D(intConst, values.size)
				NSTRealScalar: new NSTRealArray1D(intConst, values.size)
				NSTBoolArray1D: new NSTBoolArray2D(intConst, eltType.size, values.size, getIntSizeFor(eltType.size))
				NSTIntArray1D: new NSTIntArray2D(intConst, eltType.size, values.size, getIntSizeFor(eltType.size))
				NSTRealArray1D: new NSTRealArray2D(intConst, eltType.size, values.size, getIntSizeFor(eltType.size))
				default: null
			}
		}
		else
			null
	}

	def dispatch NablaType getTypeFor(Cardinality it)
	{
		new NSTIntScalar
	}

	def dispatch NablaType getTypeFor(ArgOrVarRef it)
	{
		if (target === null || target.eIsProxy) null
		else getTypeForVar(target, spaceIterators, indices.size)
	}

	private def dispatch NablaType getTypeForVar(SimpleVar v, List<SpaceIteratorRef> spaceIterators, int nbIndices)
	{
		if (spaceIterators.empty)
		{
			val t = v.typeFor
			getTypeForVar(t as NablaSimpleType, nbIndices)
		}
		else null
	}

	private def dispatch NablaType getTypeForVar(TimeIterator v, List<SpaceIteratorRef> spaceIterators, int nbIndices)
	{
		if (spaceIterators.empty && nbIndices==0) v.typeFor
		else null
	}

	private def dispatch NablaType getTypeForVar(ConnectivityVar v, List<SpaceIteratorRef> spaceIterators, int nbIndices)
	{
		if (spaceIterators.empty)
			if (nbIndices== 0) v.typeFor
			else null
		else
		{
			if (spaceIterators.size == v.supports.size)
				getTypeForVar(v.type.typeFor, nbIndices)
			else
				null
		}
	}

	private def dispatch NablaType getTypeForVar(Arg v, List<SpaceIteratorRef> spaceIterators, int nbIndices)
	{
		if (spaceIterators.empty)
		{
			val t = v.type.typeFor
			getTypeForVar(t, nbIndices)
		}
		else null
	}

	private def NablaType getTypeForVar(NablaType t, int nbIndices)
	{
		switch t
		{
			case nbIndices == 0 : t
			NSTArray1D case nbIndices == 1 : t.primitive.typeFor
			NSTArray2D case nbIndices == 2 : t.primitive.typeFor
			default : null 
		}
	}

	private def IntConstant createIntConstant(int v)
	{
		NablaFactory::eINSTANCE.createIntConstant => [value = v]
	}
}