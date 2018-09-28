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
import fr.cea.nabla.FunctionCallExtensions
import fr.cea.nabla.nabla.And
import fr.cea.nabla.nabla.BoolConstant
import fr.cea.nabla.nabla.Comparison
import fr.cea.nabla.nabla.Equality
import fr.cea.nabla.nabla.Expression
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.IntConstant
import fr.cea.nabla.nabla.ItemType
import fr.cea.nabla.nabla.MaxConstant
import fr.cea.nabla.nabla.MinConstant
import fr.cea.nabla.nabla.Minus
import fr.cea.nabla.nabla.MulOrDiv
import fr.cea.nabla.nabla.Not
import fr.cea.nabla.nabla.Or
import fr.cea.nabla.nabla.Parenthesis
import fr.cea.nabla.nabla.Plus
import fr.cea.nabla.nabla.Real2Constant
import fr.cea.nabla.nabla.Real3Constant
import fr.cea.nabla.nabla.RealConstant
import fr.cea.nabla.nabla.RealXCompactConstant
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.SpaceIteratorRange
import fr.cea.nabla.nabla.SpaceIteratorRef
import fr.cea.nabla.nabla.UnaryMinus
import fr.cea.nabla.nabla.VarRef
import java.util.List
import fr.cea.nabla.nabla.Real2x2Constant
import fr.cea.nabla.nabla.Real3x3Constant

class ExpressionTypeProvider 
{
	@Inject extension FunctionCallExtensions
	@Inject extension BasicTypeProvider
	@Inject extension VarTypeProvider
	@Inject extension MulOrDivTypeProvider
	@Inject PlusTypeProvider ptp
	@Inject MinusTypeProvider mtp

	def dispatch NablaType getTypeFor(Expression e) 
	{
		switch (e) 
		{
			IntConstant: BasicTypeProvider::INT
			RealConstant: BasicTypeProvider::REAL
			Real2Constant: BasicTypeProvider::REAL2
			Real3Constant: BasicTypeProvider::REAL3
			Real2x2Constant: BasicTypeProvider::REAL2X2
			Real3x3Constant: BasicTypeProvider::REAL3X3
			BoolConstant: BasicTypeProvider::BOOL
			RealXCompactConstant: e.type.typeFor
			MinConstant: e.type.typeFor
			MaxConstant: e.type.typeFor
			
			Or, And, Not, Equality, Comparison: BasicTypeProvider::BOOL

			Plus: ptp.typeFor(e.left?.typeFor, e.right?.typeFor)
			Minus: mtp.typeFor(e.left?.typeFor, e.right?.typeFor)
			MulOrDiv: e.op.typeProvider.typeFor(e.left?.typeFor, e?.right.typeFor)
			UnaryMinus: e.expression?.typeFor
			Parenthesis: e.expression?.typeFor
			
			FunctionCall: e.typeFor
			ReductionCall: e.typeFor
			VarRef: e.typeFor
		}
	}
	
	def dispatch NablaType getTypeFor(FunctionCall it)
	{
		val decl = declaration
		if (decl === null) NablaType::UNDEFINED
		else decl.returnType.typeFor
	}
	
	def dispatch NablaType getTypeFor(ReductionCall it)
	{
		val decl = declaration
		if (decl === null) NablaType::UNDEFINED
		else decl.returnType.typeFor
	}
	
	def dispatch NablaType getTypeFor(VarRef it)
	{
		// type apres application de l'iterateur
		val varRefTypeWithoutFields = typeForWithoutFields
		if (varRefTypeWithoutFields === NablaType::UNDEFINED)
			NablaType::UNDEFINED
		else 
			typeAfterFields(varRefTypeWithoutFields, fields)
	}
	
	// utile pour la completion...
	def NablaType getTypeForWithoutFields(VarRef it)
	{
		// type de la variable
		val varType = variable.typeFor
		
		// s'il y a plus d'iterateur que le type n'a de dimension ==> UNDEFINED
		if (varType===NablaType::UNDEFINED || (varType.dimension - spaceIterators.length) < 0)  
			NablaType::UNDEFINED
		else
			new NablaType(varType.base, varType.dimension - spaceIterators.length)
	}
	
	private def typeAfterFields(NablaType t, List<String> fields)
	{
		if (fields.empty) t
		else if (t.dimension > 0) NablaType::UNDEFINED
		else switch t.base
		{
			case REAL2: fields.convertReal2
			case REAL3: fields.convertReal3
			case REAL2X2: fields.convertReal2x2
			case REAL3X3: fields.convertReal3x3
			default: NablaType::UNDEFINED
		}
	}
	
	private def convertReal2(List<String> fields)
	{
		switch fields.length
		{
			case 0 : BasicTypeProvider::REAL2
			case 1 : BasicTypeProvider::REAL
			default : NablaType::UNDEFINED
		}
	}
	
	private def convertReal3(List<String> fields)
	{
		switch fields.length
		{
			case 0 : BasicTypeProvider::REAL3
			case 1 : BasicTypeProvider::REAL
			default : NablaType::UNDEFINED
		}
	}

	private def convertReal2x2(List<String> fields)
	{
		switch fields.length
		{
			case 0 : BasicTypeProvider::REAL2X2
			case 1 : BasicTypeProvider::REAL2
			case 2 : BasicTypeProvider::REAL
			default : NablaType::UNDEFINED
		}
	}
	
	private def convertReal3x3(List<String> fields)
	{
		switch fields.length
		{
			case 0 : BasicTypeProvider::REAL3X3
			case 1 : BasicTypeProvider::REAL3
			case 2 : BasicTypeProvider::REAL
			default : NablaType::UNDEFINED
		}
	}
	
	private def dispatch ItemType getItemType(SpaceIteratorRange it) 
	{
		connectivity.returnType.type
	}
	
	private def dispatch ItemType getItemType(SpaceIteratorRef it) 
	{
		iterator.range.itemType
	}
}