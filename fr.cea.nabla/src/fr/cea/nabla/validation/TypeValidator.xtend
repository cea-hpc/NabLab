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
package fr.cea.nabla.validation

import com.google.inject.Inject
import fr.cea.nabla.nabla.Affectation
import fr.cea.nabla.nabla.And
import fr.cea.nabla.nabla.Comparison
import fr.cea.nabla.nabla.ContractedIf
import fr.cea.nabla.nabla.Equality
import fr.cea.nabla.nabla.Expression
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.If
import fr.cea.nabla.nabla.Minus
import fr.cea.nabla.nabla.Modulo
import fr.cea.nabla.nabla.MulOrDiv
import fr.cea.nabla.nabla.NablaPackage
import fr.cea.nabla.nabla.Not
import fr.cea.nabla.nabla.Or
import fr.cea.nabla.nabla.Plus
import fr.cea.nabla.nabla.ReductionArg
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.ScalarVarDefinition
import fr.cea.nabla.nabla.VarRef
import fr.cea.nabla.typing.BasicTypeProvider
import fr.cea.nabla.typing.BinaryOperatorTypeProvider
import fr.cea.nabla.typing.ComparisonAndEqualityTypeProvider
import fr.cea.nabla.typing.ExpressionTypeProvider
import fr.cea.nabla.typing.MinusTypeProvider
import fr.cea.nabla.typing.MulOrDivTypeProvider
import fr.cea.nabla.typing.NablaType
import fr.cea.nabla.typing.PlusTypeProvider
import org.eclipse.emf.ecore.EAttribute
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.validation.Check

import static extension fr.cea.nabla.typing.NablaType.*

class TypeValidator extends BasicValidator
{
	static val INVALID_FIELD = 'NablaInvalidField'
	
	val np = NablaPackage::eINSTANCE	
	@Inject extension ExpressionTypeProvider
	@Inject extension BasicTypeProvider
	@Inject extension MulOrDivTypeProvider
	@Inject PlusTypeProvider plusTypeProvider
	@Inject MinusTypeProvider minusTypeProvider
	@Inject ComparisonAndEqualityTypeProvider comparisonAndEqualityTypeProvider

	// *** LES INSTRUCTIONS
	@Check def checkType(ScalarVarDefinition it)
	{
		checkExpectedType(defaultValue?.typeFor, type.typeFor, np.scalarVarDefinition_DefaultValue)
	}
	
	@Check def checkType(Affectation it) 
	{ 
		checkExpectedType(expression?.typeFor, varRef.typeFor, np.affectation_Expression)
	}
	
	@Check def checkType(If it) { checkExpectedType(condition?.typeFor, BasicTypeProvider::BOOL, np.if_Condition) }
		
	// *** LES EXPRESSIONS
	@Check
	def checkSeedAndReturnTypes(ReductionArg it)
	{
		val seedType = seed.typeFor
		if (seedType !== NablaType::UNDEFINED && seedType.base !== returnType)
		{
			var msg = 'Seed type and return types must be identical: ' + seedType.base.literal + '!=' + returnType.literal
			error(msg, NablaPackage.Literals::REDUCTION_ARG__SEED)
		}
	}

	@Check
	def checkArgs(FunctionCall it)
	{
		if (typeFor == NablaType::UNDEFINED)
		{
			val inTypes = args.map[x | x.typeFor.label]
			var msg = 'Wrong arguments : ' + inTypes.join(', ')
			error(msg, NablaPackage.Literals::FUNCTION_CALL__FUNCTION)
		}
	}
	
	@Check
	def checkArgs(ReductionCall it)
	{
		if (typeFor == NablaType::UNDEFINED)
		{
			val inType = arg.typeFor.label
			var msg = 'Wrong arguments : ' + inType
			error(msg, NablaPackage.Literals::REDUCTION_CALL__REDUCTION)
		}
	}

	// Il ne faut pas vérifier le type de la variable : checkType(VarAffectationDeclaration) le fait
	@Check
	def checkType(VarRef it)
	{
		// vérification du type après les itérateurs
		val t = typeForWithoutFields
		if (t==NablaType::UNDEFINED)
		{
			val msg = 'Invalid type for variable ' + variable?.name
			error(msg, NablaPackage.Literals::VAR_REF__VARIABLE)
		}
		else if (!fields.empty)
		{
			val eAtt = NablaPackage.Literals::VAR_REF__FIELDS
			val msg = 'Invalid field on variable ' + variable.name
			switch t.base
			{
				case REAL2: 
				{
					if (fields.size != 1 || !fields.head.isValidReal2Field)
						error(msg, eAtt, INVALID_FIELD)
				}
				case REAL3: 
				{
					if (fields.size != 1 || !fields.head.isValidReal3Field)
						error(msg, eAtt, INVALID_FIELD)
				}
				case REAL2X2: 
				{
					if (fields.size != 2 || fields.exists[f | !f.isValidReal2Field])
						error(msg, eAtt, INVALID_FIELD)					
				}
				case REAL3X3: 
				{
					if (fields.size != 2 || fields.exists[f | !f.isValidReal3Field])
						error(msg, eAtt, INVALID_FIELD)					
				}
				default: error(msg, eAtt, INVALID_FIELD)
			}
		}
	}
	
	
	@Check def checkType(ContractedIf it) 
	{ 
		val condType = condition.typeFor
		val thenType = then.typeFor
		val elseType = ^else.typeFor
		checkExpectedType(condType, BasicTypeProvider::BOOL, np.contractedIf_Condition)
		checkExpectedType(thenType, elseType, np.contractedIf_Else)
	}
	
	@Check def checkType(Not it) { checkExpectedType(expression?.typeFor, BasicTypeProvider::BOOL, np.not_Expression) }
	// UnaryMinus fonctionne avec tous les types
	
	@Check def checkType(MulOrDiv it) { checkBinaryOp(left, right, op.typeProvider, np.mulOrDiv_Op, op) }
	@Check def checkType(Plus it) { checkBinaryOp(left, right, plusTypeProvider, np.plus_Op, op) }
	@Check def checkType(Minus it) { checkBinaryOp(left, right, minusTypeProvider, np.minus_Op, op) }
	@Check def checkType(Comparison it) { checkBinaryOp(left, right, comparisonAndEqualityTypeProvider, np.comparison_Op, op) }
	@Check def checkType(Equality it) { checkBinaryOp(left, right, comparisonAndEqualityTypeProvider, np.comparison_Op, op) }

	@Check def checkType(Modulo it) 
	{ 
		checkExpectedType(left?.typeFor, BasicTypeProvider::INT, np.and_Left)
		checkExpectedType(right?.typeFor, BasicTypeProvider::INT, np.and_Right)
	}

	@Check def checkType(And it) 
	{ 
		checkExpectedType(left?.typeFor, BasicTypeProvider::BOOL, np.and_Left)
		checkExpectedType(right?.typeFor, BasicTypeProvider::BOOL, np.and_Right)
	}

	@Check
	def checkType(Or it) 
	{
		checkExpectedType(left?.typeFor, BasicTypeProvider::BOOL, np.or_Left)
		checkExpectedType(right?.typeFor, BasicTypeProvider::BOOL, np.or_Right)
	}

	private def void checkExpectedType(NablaType actualType, NablaType expectedType, EReference reference) 
	{
		// si un des 2 types est indéfini, il ne faut rien vérifier pour éviter les erreurs multiples due à la récursion
		if (! (actualType==NablaType::UNDEFINED || expectedType==NablaType::UNDEFINED || actualType.match(expectedType)))
			error("Expected " + expectedType.label + " type, but was " + actualType.label, reference)
	}	

	private def void checkBinaryOp(Expression left, Expression right, BinaryOperatorTypeProvider provider, EAttribute operator, String op)
	{
		val leftType = left?.typeFor
		val rightType = right?.typeFor
		
		// si un des 2 types est indéfini, il ne faut rien vérifier pour éviter les erreurs multiples due à la récursion
		if (! (leftType==NablaType::UNDEFINED || rightType==NablaType::UNDEFINED))
			if (provider.typeFor(leftType, rightType) == NablaType::UNDEFINED)
				error('Binary operator ' + op + ' undefined on types ' + leftType.label + ' and ' + rightType.label, operator)
	}
	
	private def isValidReal2Field(String s) { s == 'x' || s == 'y' }
	private def isValidReal3Field(String s) { s.validReal2Field || s == 'z' }
}