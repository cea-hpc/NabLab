/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.validation

import com.google.inject.Inject
import fr.cea.nabla.nabla.Affectation
import fr.cea.nabla.nabla.And
import fr.cea.nabla.nabla.BaseTypeConstant
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
import fr.cea.nabla.typing.AbstractType
import fr.cea.nabla.typing.ArrayType
import fr.cea.nabla.typing.BinaryOperationsTypeProvider
import fr.cea.nabla.typing.BoolType
import fr.cea.nabla.typing.DefinedType
import fr.cea.nabla.typing.ExpressionTypeProvider
import fr.cea.nabla.typing.IntType
import fr.cea.nabla.typing.MiscTypeProvider
import fr.cea.nabla.typing.UndefinedType
import java.util.List
import org.eclipse.xtext.validation.Check

class TypeValidator extends BasicValidator
{
	static val BOOL = new BoolType(#[])
	static val INT = new IntType(#[])
	
	@Inject extension ExpressionTypeProvider
	@Inject extension BinaryOperationsTypeProvider
	@Inject extension MiscTypeProvider

	// ===== Instructions =====	
	
	public static val SCALAR_VAR_DEFAULT_VALUE_TYPE = "Instructions::ScalarVarDefaultValueType"
	public static val AFFECTATION_TYPE = "Instructions::AffectationType"
	public static val IF_CONDITION_BOOL = "Instructions::IfConditionBool"
	
	static def getScalarDefinitionTypeMsg(String actualTypeName, String expectedTypeName) { "Wrong type: Expected " + expectedTypeName + ", but was " + actualTypeName }
	static def getAffectationTypeMsg(String actualTypeName, String expectedTypeName) { "Wrong type: Expected " + expectedTypeName + ", but was " + actualTypeName }
	static def getIfConditionBoolMsg(String actualTypeName) { "Wrong type: Expected " + BOOL.label + ", but was " + actualTypeName }
		
	@Check 
	def checkType(ScalarVarDefinition it)
	{
		if (!checkExpectedType(defaultValue?.typeFor, type.typeFor))
			error(getScalarDefinitionTypeMsg(defaultValue?.typeFor.label, type.typeFor.label), NablaPackage.Literals.SCALAR_VAR_DEFINITION__DEFAULT_VALUE, SCALAR_VAR_DEFAULT_VALUE_TYPE)			
	}
	
	@Check 
	def checkType(Affectation it) 
	{ 
		if (!checkExpectedType(expression?.typeFor, varRef.typeFor))
			error(getAffectationTypeMsg(expression?.typeFor.label, varRef.typeFor.label), NablaPackage.Literals.AFFECTATION__EXPRESSION, AFFECTATION_TYPE)			
	}
	
	@Check 
	def checkType(If it) 
	{ 
		if (!checkExpectedType(condition?.typeFor, BOOL))
			error(getIfConditionBoolMsg(condition?.typeFor.label), NablaPackage.Literals.IF__CONDITION, IF_CONDITION_BOOL)			
	}
		
	// ===== Expressions =====	

	public static val VALUE_TYPE = "Expressions::ValueType"
	public static val SEED_TYPE = "Expressions::SeedType"
	public static val SEED_AND_RETURN_TYPES = "Expressions::SeedAndReturnTypes"
	public static val FUNCTION_ARGS = "Expressions::FunctionArgs"
	public static val REDUCTION_ON_CONNECTIVITIES_VARIABLE = "Expressions::ReductionOnConnectivitiesVariable"
	public static val REDUCTION_ARGS = "Expressions::ReductionArgs"
	//public static val VAR_REF_TYPE = "Expressions::VarRefType"
	public static val CONTRACTED_IF_CONDITION_TYPE = "Expressions::ContractedIfConditionType"
	public static val CONTRACTED_IF_ELSE_TYPE = "Expressions::ContractedIfElseType"
	public static val NOT_EXPRESSION_TYPE = "Expressions::NotExpressionType"
	public static val MUL_OR_DIV_TYPE = "Expressions::MulOrDivType"
	public static val PLUS_TYPE = "Expressions::PlusType"
	public static val MINUS_TYPE = "Expressions::MinusType"
	public static val COMPARISON_TYPE = "Expressions::ComparisonType"
	public static val EQUALITY_TYPE = "Expressions::EqualityType"
	public static val MODULO_TYPE = "Expressions::ModuloType"
	public static val AND_TYPE = "Expressions::AndType"
	public static val OR_TYPE = "Expressions::OrType"
	
	static def getValueTypeMsg(String expectedTypeName) { "Initialization value type must be " + expectedTypeName }
	static def getSeedTypeMsg() { "Seed type must be scalar" }
	static def getSeedAndReturnTypesMsg(String seedType, String returnType) { "Seed type and return primitive type must be identical: " + seedType + "!=" + returnType }
	static def getFunctionArgsMsg(List<String> inTypes) { "Wrong arguments : " + inTypes.join(', ') }
	static def getReductionOnConnectivitiesVariableMsg() { "No reduction on connectivities variable" }	
	static def getReductionArgsMsg(String inType) { "Wrong arguments : " + inType }	
	//static def getVarRefTypeMsg() { "Undefined type" }
	static def getContractedIfConditionTypeMsg(String actualType) { "Expected " + BOOL.label + " type, but was " + actualType }
	static def getContractedIfElseTypeMsg(String actualType, String expectedType) { "Expected " + expectedType + " type, but was " + actualType }
	static def getNotExpressionTypeMsg(String actualType) { "Expected " + BOOL.label + " type, but was " + actualType }	
	static def getMulOrDivTypeMsg(String op, String leftType, String rightType) { "Binary operator " + op + " undefined on types " + leftType + " and " + rightType }
	static def getPlusTypeMsg(String op, String leftType, String rightType) { "Binary operator " + op + " undefined on types " + leftType + " and " + rightType }
	static def getMinusTypeMsg(String op, String leftType, String rightType) { "Binary operator " + op + " undefined on types " + leftType + " and " + rightType }
	static def getComparisonTypeMsg(String op, String leftType, String rightType) { "Binary operator " + op + " undefined on types " + leftType + " and " + rightType }
	static def getEqualityTypeMsg(String op, String leftType, String rightType) { "Binary operator " + op + " undefined on types " + leftType + " and " + rightType }
	static def getModuloTypeMsg(String actualType) { "Expected " + INT.label + " type, but was " + actualType }
	static def getAndTypeMsg(String actualType) { "Expected " + BOOL.label + " type, but was " + actualType }
	static def getOrTypeMsg(String actualType) { "Expected " + BOOL.label + " type, but was " + actualType }

	@Check
	def checkValueType(BaseTypeConstant it)
	{
		val vType = value.typeFor
		if (vType !== null && (vType as DefinedType).root !== type.root)
			error(getValueTypeMsg(type.root.literal), NablaPackage.Literals.BASE_TYPE_CONSTANT__TYPE, VALUE_TYPE)	
	}
	
	@Check
	def checkSeedAndReturnTypes(ReductionArg it)
	{
		val seedType = seed?.typeFor
		val rType = returnType.root
		// Seed must be scalar and Seed rootType must be the same as Return rootType
		// If Return type is Array, the reduction Seed will be used as many times as Array size
		// Ex (ℕ.MaxValue, ℝ])→ℕ[2]; -> we will use (ℕ.MaxValue, ℕ.MaxValue) as reduction seed
		if (! (seedType === null || seedType instanceof UndefinedType))
		{
			if (seedType instanceof ArrayType)
				error(getSeedTypeMsg(), NablaPackage.Literals.REDUCTION_ARG__SEED, SEED_TYPE)
			else if (seedType.label != rType.literal)
				error(getSeedAndReturnTypesMsg(seedType.label, rType.literal), NablaPackage.Literals.REDUCTION_ARG__SEED, SEED_AND_RETURN_TYPES)
		}
	}

	@Check
	def checkFunctionArgs(FunctionCall it)
	{
		if (typeFor.undefined)
		{
			val inTypes = args.map[x | x.typeFor.label]
			error(getFunctionArgsMsg(inTypes), NablaPackage.Literals::FUNCTION_CALL__FUNCTION, FUNCTION_ARGS)
		}
	}
	
	@Check
	def checkReductionArgs(ReductionCall it)
	{
		val inT = arg.typeFor
		
		if (inT instanceof DefinedType && !(inT as DefinedType).connectivities.empty)
			error(getReductionOnConnectivitiesVariableMsg, NablaPackage.Literals::REDUCTION_CALL__REDUCTION, REDUCTION_ON_CONNECTIVITIES_VARIABLE)
		else if (typeFor.undefined)
			error(getReductionArgsMsg(inT.label), NablaPackage.Literals::REDUCTION_CALL__REDUCTION, REDUCTION_ARGS)
	}

//	@Check
//	def checkVarRefType(VarRef it)
//	{
//		if (it.typeFor.undefined)
//			error(getVarRefTypeMsg(), NablaPackage.Literals::VAR_REF__VARIABLE, VAR_REF_TYPE)
//	}	

	@Check 
	def checkContractedIfType(ContractedIf it) 
	{ 
		val condType = condition.typeFor
		val thenType = then.typeFor
		val elseType = ^else.typeFor
		
		if (!checkExpectedType(condType, BOOL))
			error(getContractedIfConditionTypeMsg(condType.label), NablaPackage.Literals::CONTRACTED_IF__CONDITION, CONTRACTED_IF_CONDITION_TYPE)
		if (!checkExpectedType(elseType, thenType))
			error(getContractedIfElseTypeMsg(elseType.label, thenType.label), NablaPackage.Literals::CONTRACTED_IF__ELSE, CONTRACTED_IF_ELSE_TYPE)
	}
	
	@Check 
	def checkNotExpressionType(Not it) 
	{ 
		if (!checkExpectedType(expression?.typeFor, BOOL))
		error(getNotExpressionTypeMsg(expression?.typeFor.label), NablaPackage.Literals::NOT__EXPRESSION, NOT_EXPRESSION_TYPE)
	}
	
	// UnaryMinus fonctionne avec tous les types
	
	@Check 
	def checkMulOrDivType(MulOrDiv it) 
	{ 
		if (!checkBinaryOp(left, right, op))
			error(getMulOrDivTypeMsg(op, left.typeFor.label, right.typeFor.label), NablaPackage.Literals.MUL_OR_DIV__OP, MUL_OR_DIV_TYPE)			
	}
	
	@Check 
	def checkPlusType(Plus it)
	{ 
		if (!checkBinaryOp(left, right, op))
			error(getPlusTypeMsg(op, left.typeFor.label, right.typeFor.label), NablaPackage.Literals.PLUS__OP, PLUS_TYPE)			
	}
	
	@Check 
	def checkMinusType(Minus it) 
	{
		if (!checkBinaryOp(left, right, op))
			error(getMinusTypeMsg(op, left.typeFor.label, right.typeFor.label), NablaPackage.Literals.MINUS__OP, MINUS_TYPE)
	}
	
	@Check 
	def checkComparisonType(Comparison it) 
	{ 
		if (!checkBinaryOp(left, right, op))
			error(getComparisonTypeMsg(op, left.typeFor.label, right.typeFor.label), NablaPackage.Literals.COMPARISON__OP, COMPARISON_TYPE)
	}
	
	@Check 
	def checkEqualityType(Equality it)
	{ 
		if (!checkBinaryOp(left, right, op))
			error(getEqualityTypeMsg(op, left.typeFor.label, right.typeFor.label), NablaPackage.Literals.EQUALITY__OP, EQUALITY_TYPE)
	}

	@Check def checkModuloType(Modulo it) 
	{ 
		if (!checkExpectedType(left?.typeFor, INT))
			error(getModuloTypeMsg(left?.typeFor.label), NablaPackage.Literals.MODULO__LEFT, MODULO_TYPE)
		if (!checkExpectedType(right?.typeFor, INT))
			error(getModuloTypeMsg(right?.typeFor.label), NablaPackage.Literals.MODULO__RIGHT, MODULO_TYPE)
	}

	@Check def checkAndType(And it) 
	{ 
		if (!checkExpectedType(left?.typeFor, BOOL))
			error(getAndTypeMsg(left?.typeFor.label), NablaPackage.Literals.AND__LEFT, AND_TYPE)
		if (!checkExpectedType(right?.typeFor, BOOL))
			error(getAndTypeMsg(right?.typeFor.label), NablaPackage.Literals.AND__RIGHT, AND_TYPE)
	}

	@Check
	def checkOrType(Or it) 
	{
		if (!checkExpectedType(left?.typeFor, BOOL))
			error(getAndTypeMsg(left?.typeFor.label), NablaPackage.Literals.OR__LEFT, OR_TYPE)
		if (!checkExpectedType(right?.typeFor, BOOL))
			error(getAndTypeMsg(right?.typeFor.label), NablaPackage.Literals.OR__RIGHT, OR_TYPE)
	}

	private def checkExpectedType(AbstractType actualType, AbstractType expectedType) 
	{
		// si un des 2 types est indéfini, il ne faut rien vérifier pour éviter les erreurs multiples due à la récursion
		return (actualType.undefined || expectedType.undefined || actualType == expectedType)
	}	

	private def checkBinaryOp(Expression left, Expression right, String op)
	{
		val leftType = left?.typeFor
		val rightType = right?.typeFor

		// si un des 2 types est indéfini, il ne faut rien vérifier pour éviter les erreurs multiples due à la récursion
		return (leftType.undefined || rightType.undefined || !getTypeFor(leftType, rightType, op).undefined) 
	}
}