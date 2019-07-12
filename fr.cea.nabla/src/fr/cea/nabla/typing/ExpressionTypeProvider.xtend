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
package fr.cea.nabla.typing

import com.google.inject.Inject
import fr.cea.nabla.DeclarationProvider
import fr.cea.nabla.VarExtensions
import fr.cea.nabla.nabla.And
import fr.cea.nabla.nabla.BaseType
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
import fr.cea.nabla.nabla.MaxConstant
import fr.cea.nabla.nabla.MinConstant
import fr.cea.nabla.nabla.Minus
import fr.cea.nabla.nabla.Modulo
import fr.cea.nabla.nabla.MulOrDiv
import fr.cea.nabla.nabla.Not
import fr.cea.nabla.nabla.Or
import fr.cea.nabla.nabla.Parenthesis
import fr.cea.nabla.nabla.Plus
import fr.cea.nabla.nabla.PrimitiveType
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

	def dispatch ExpressionType getTypeFor(ContractedIf it) { new BoolType(#[]) }
	
	def dispatch ExpressionType getTypeFor(Or it) { new BoolType(#[]) }	
	def dispatch ExpressionType getTypeFor(And it) { new BoolType(#[]) }
	def dispatch ExpressionType getTypeFor(Equality it) { new BoolType(#[]) }
	def dispatch ExpressionType getTypeFor(Comparison it) { new BoolType(#[]) }
	def dispatch ExpressionType getTypeFor(Plus it) { eval(left, right ,op) }
	def dispatch ExpressionType getTypeFor(Minus it) { eval(left, right ,op) }
	def dispatch ExpressionType getTypeFor(MulOrDiv it)  { eval(left, right ,op) }
	def dispatch ExpressionType getTypeFor(Modulo it)  { new IntType(#[]) }

	def dispatch ExpressionType getTypeFor(Parenthesis it) { expression.typeFor }
	def dispatch ExpressionType getTypeFor(UnaryMinus it) { expression.typeFor }
	def dispatch ExpressionType getTypeFor(Not it) { expression.typeFor }

	def dispatch ExpressionType getTypeFor(IntConstant it) { new IntType(#[]) }
	def dispatch ExpressionType getTypeFor(RealConstant it) { new RealType(#[]) }
	def dispatch ExpressionType getTypeFor(BoolConstant it)  { new BoolType(#[]) }

	def dispatch ExpressionType getTypeFor(MinConstant it) { type.typeFor }
	def dispatch ExpressionType getTypeFor(MaxConstant it) { type.typeFor }
	
	def dispatch ExpressionType getTypeFor(FunctionCall it)
	{
		val decl = declaration
		if (decl === null) new UndefinedType
		else decl.returnType
	}
	
	def dispatch ExpressionType getTypeFor(ReductionCall it)
	{
		val decl = declaration
		if (decl === null) new UndefinedType
		else decl.returnType
	}
	
	def dispatch ExpressionType getTypeFor(VarRef it)
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

	def dispatch ExpressionType getTypeFor(RealVectorConstant it) { new RealArrayType(#[], #[values.size]) }
	def dispatch ExpressionType getTypeFor(RealMatrixConstant it) { new RealArrayType(#[], values.map[x | x.values.size]) }
	def dispatch ExpressionType getTypeFor(BaseTypeConstant it) { type.typeFor }

	def dispatch ExpressionType getTypeFor(PrimitiveType it)
	{
		switch it
		{
			case INT: new IntType(#[])
			case REAL: new RealType(#[])
			case BOOL: new BoolType(#[])
		}
	}

	def dispatch ExpressionType getTypeFor(BaseType it) { getTypeFor(root, #[], sizes) }

	def ExpressionType getTypeFor(PrimitiveType t, Connectivity[] connectivities, int[] baseTypeSizes)
	{
		switch t
		{
			case BOOL: if (baseTypeSizes.empty && connectivities.empty) new BoolType(connectivities) else new UndefinedType
			case INT: if (baseTypeSizes.empty && connectivities.empty) new IntType(connectivities) else new UndefinedType
			case REAL: if (baseTypeSizes.empty && connectivities.empty) new RealType(connectivities) else new RealArrayType(connectivities, baseTypeSizes)
		}
	}

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