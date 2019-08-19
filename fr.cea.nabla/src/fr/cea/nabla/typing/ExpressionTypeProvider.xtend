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
import fr.cea.nabla.DeclarationProvider
import fr.cea.nabla.VarExtensions
import fr.cea.nabla.nabla.And
import fr.cea.nabla.nabla.BaseTypeConstant
import fr.cea.nabla.nabla.BoolConstant
import fr.cea.nabla.nabla.Comparison
import fr.cea.nabla.nabla.Connectivity
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
import fr.cea.nabla.nabla.UnaryMinus
import fr.cea.nabla.nabla.VarRef

class ExpressionTypeProvider 
{
	@Inject extension DeclarationProvider
	@Inject extension BinaryOperationsTypeProvider
	@Inject extension VarExtensions
	@Inject extension MiscTypeProvider

	def dispatch AbstractType getTypeFor(ContractedIf it) { then.typeFor }
	
	def dispatch AbstractType getTypeFor(Or it) { new BoolType(#[]) }	
	def dispatch AbstractType getTypeFor(And it) { new BoolType(#[]) }
	def dispatch AbstractType getTypeFor(Equality it) { new BoolType(#[]) }
	def dispatch AbstractType getTypeFor(Comparison it) { new BoolType(#[]) }
	def dispatch AbstractType getTypeFor(Plus it) { eval(left, right ,op) }
	def dispatch AbstractType getTypeFor(Minus it) { eval(left, right ,op) }
	def dispatch AbstractType getTypeFor(MulOrDiv it)  { eval(left, right ,op) }
	def dispatch AbstractType getTypeFor(Modulo it)  { new IntType(#[]) }

	def dispatch AbstractType getTypeFor(Parenthesis it) { expression.typeFor }
	def dispatch AbstractType getTypeFor(UnaryMinus it) { expression.typeFor }
	def dispatch AbstractType getTypeFor(Not it) { expression.typeFor }

	def dispatch AbstractType getTypeFor(IntConstant it) { new IntType(#[]) }
	def dispatch AbstractType getTypeFor(RealConstant it) { new RealType(#[]) }
	def dispatch AbstractType getTypeFor(BoolConstant it)  { new BoolType(#[]) }

	def dispatch AbstractType getTypeFor(MinConstant it) { type.typeFor }
	def dispatch AbstractType getTypeFor(MaxConstant it) { type.typeFor }
	
	def dispatch AbstractType getTypeFor(FunctionCall it)
	{
		val decl = declaration
		if (decl === null) new UndefinedType
		else decl.returnType
	}
	
	def dispatch AbstractType getTypeFor(ReductionCall it)
	{
		val decl = declaration
		if (decl === null) new UndefinedType
		else decl.returnType
	}
		
	def dispatch AbstractType getTypeFor(VarRef it)
	{
		val varBaseType = variable.baseType
		val newRootType = varBaseType.root
		// indices == 0 || indices == varBaseType.size (cf. validator)
		val newBaseTypeSizes = if (indices.empty) varBaseType.sizes else #[]
		
		var Connectivity[] newDimensions = #[] 
		if (variable instanceof ConnectivityVar)
		{
			val dimensions = (variable as ConnectivityVar).dimensions
			// iterators.size == 0 || iterators.size == dimensions.size (cf. validator)
			if (spaceIterators.empty) 
				newDimensions = dimensions
		}
		
		getTypeFor(newRootType, newDimensions, newBaseTypeSizes)
	}

	def dispatch AbstractType getTypeFor(IntVectorConstant it) { new IntArrayType(#[], #[values.size]) }
	def dispatch AbstractType getTypeFor(RealVectorConstant it) { new RealArrayType(#[], #[values.size]) }
	def dispatch AbstractType getTypeFor(IntMatrixConstant it) { new IntArrayType(#[], values.map[x | x.values.size]) }
	def dispatch AbstractType getTypeFor(RealMatrixConstant it) { new RealArrayType(#[], values.map[x | x.values.size]) }
	def dispatch AbstractType getTypeFor(BaseTypeConstant it) { type.typeFor }
	

	private def eval(Expression a, Expression b, String op) 
	{ 
		val atype = a.typeFor
		val btype = b.typeFor
		if (atype instanceof DefinedType && btype instanceof DefinedType 
			&& (atype as DefinedType).connectivities.empty && (btype as DefinedType).connectivities.empty)
			getTypeFor(atype, btype, op)
		else 
			new UndefinedType
	}
}