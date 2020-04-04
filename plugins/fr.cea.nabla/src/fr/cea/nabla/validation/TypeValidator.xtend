/*******************************************************************************
 * Copyright (c) 2020 CEA
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
import fr.cea.nabla.nabla.Div
import fr.cea.nabla.nabla.Equality
import fr.cea.nabla.nabla.Expression
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.If
import fr.cea.nabla.nabla.Minus
import fr.cea.nabla.nabla.Modulo
import fr.cea.nabla.nabla.Mul
import fr.cea.nabla.nabla.NablaPackage
import fr.cea.nabla.nabla.Not
import fr.cea.nabla.nabla.Or
import fr.cea.nabla.nabla.Plus
import fr.cea.nabla.nabla.Reduction
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.Return
import fr.cea.nabla.nabla.VectorConstant
import fr.cea.nabla.typing.BaseTypeTypeProvider
import fr.cea.nabla.typing.ExpressionTypeProvider
import fr.cea.nabla.typing.NSTArray1D
import fr.cea.nabla.typing.NSTBoolScalar
import fr.cea.nabla.typing.NSTIntScalar
import fr.cea.nabla.typing.NSTScalar
import fr.cea.nabla.typing.NablaConnectivityType
import fr.cea.nabla.typing.NablaType
import java.util.List
import org.eclipse.xtext.validation.Check

class TypeValidator extends BasicValidator
{
	static val BOOL = new NSTBoolScalar
	static val INT = new NSTIntScalar

	@Inject extension ExpressionTypeProvider
	@Inject extension BaseTypeTypeProvider

	// ===== Functions =====

	public static val FUNCTION_RETURN_TYPE = "Functions::ReturnType"
	static def getFunctionReturnTypeMsg(String actualTypeName, String expectedTypeName) { "Wrong return type: Expected " + expectedTypeName + ", but was " + actualTypeName }

	@Check
	def checkReturnType(Function it)
	{
		if (!external && body !== null)
		{
			val returnInstruction = if (body instanceof Return) body as Return else body.eAllContents.findFirst[x | x instanceof Return]
			if (returnInstruction !== null)
			{
				val ri = returnInstruction as Return
				val expressionType = ri.expression?.typeFor
				val fType = returnType.typeFor
				if (expressionType !== null && !checkExpectedType(expressionType, fType))
					error(getFunctionReturnTypeMsg(expressionType.label, fType.label), NablaPackage.Literals.FUNCTION__RETURN_TYPE, FUNCTION_RETURN_TYPE)
			}
		}
	}

	// ===== Instructions =====

	public static val AFFECTATION_TYPE = "Instructions::AffectationType"
	public static val IF_CONDITION_BOOL = "Instructions::IfConditionBool"

	static def getAffectationTypeMsg(String actualTypeName, String expectedTypeName) { "Wrong type: Expected " + expectedTypeName + ", but was " + actualTypeName }
	static def getIfConditionBoolMsg(String actualTypeName) { "Wrong type: Expected " + BOOL.label + ", but was " + actualTypeName }

	@Check
	def checkType(Affectation it)
	{
		if (!checkExpectedType(right?.typeFor, left?.typeFor))
			error(getAffectationTypeMsg(right?.typeFor.label, left?.typeFor.label), NablaPackage.Literals.AFFECTATION__RIGHT, AFFECTATION_TYPE)
	}

	@Check
	def checkType(If it)
	{
		if (!checkExpectedType(condition?.typeFor, BOOL))
			error(getIfConditionBoolMsg(condition?.typeFor.label), NablaPackage.Literals.IF__CONDITION, IF_CONDITION_BOOL)
	}

	// ===== Expressions =====

	public static val VALUE_TYPE = "Expressions::ValueType"
	public static val REDUCTION_SEED_TYPE = "Expressions::ReductionSeedType"
	public static val REDUCTION_TYPES_COMPATIBILITY = "Expressions::ReductionTypesCompatibility"
	public static val FUNCTION_ARGS = "Expressions::FunctionArgs"
	public static val REDUCTION_ON_CONNECTIVITIES_VARIABLE = "Expressions::ReductionOnConnectivitiesVariable"
	public static val REDUCTION_ARGS = "Expressions::ReductionArgs"
	public static val CONTRACTED_IF_CONDITION_TYPE = "Expressions::ContractedIfConditionType"
	public static val CONTRACTED_IF_ELSE_TYPE = "Expressions::ContractedIfElseType"
	public static val NOT_EXPRESSION_TYPE = "Expressions::NotExpressionType"
	public static val MUL_TYPE = "Expressions::MulType"
	public static val DIV_TYPE = "Expressions::DivType"
	public static val PLUS_TYPE = "Expressions::PlusType"
	public static val MINUS_TYPE = "Expressions::MinusType"
	public static val COMPARISON_TYPE = "Expressions::ComparisonType"
	public static val EQUALITY_TYPE = "Expressions::EqualityType"
	public static val MODULO_TYPE = "Expressions::ModuloType"
	public static val AND_TYPE = "Expressions::AndType"
	public static val OR_TYPE = "Expressions::OrType"
	public static val VECTOR_CONSTANT_INCONSISTENT_TYPE = "Expressions::VectorConstantInconsistentType"
	public static val VECTOR_CONSTANT_TYPE_SIZE = "Expressions::VectorConstantTypeSize"

	static def getValueTypeMsg(String expectedTypeName) { "Initialization value type must be " + expectedTypeName }
	static def getReductionSeedTypeMsg() { "Seed type must be scalar" }
	static def getReductionTypesCompatibilityMsg(String seedType, String type) { "Seed type and reduction type are incompatible: " + seedType + " and " + type }
	static def getFunctionArgsMsg(List<String> inTypes) { "Wrong arguments : " + inTypes.join(', ') }
	static def getReductionOnConnectivitiesVariableMsg() { "No reduction on connectivities variable" }	
	static def getReductionArgsMsg(String inType) { "Wrong arguments : " + inType }	
	static def getContractedIfConditionTypeMsg(String actualType) { "Expected " + BOOL.label + " type, but was " + actualType }
	static def getContractedIfElseTypeMsg(String actualType, String expectedType) { "Expected " + expectedType + " type, but was " + actualType }
	static def getNotExpressionTypeMsg(String actualType) { "Expected " + BOOL.label + " type, but was " + actualType }	
	static def getBinaryOpTypeMsg(String op, String leftType, String rightType) { "Binary operator " + op + " undefined on types " + leftType + " and " + rightType }
	static def getModuloTypeMsg(String actualType) { "Expected " + INT.label + " type, but was " + actualType }
	static def getAndTypeMsg(String actualType) { "Expected " + BOOL.label + " type, but was " + actualType }
	static def getOrTypeMsg(String actualType) { "Expected " + BOOL.label + " type, but was " + actualType }
	static def getVectorConstantInconsistentTypeMsg()  { "All values must have the same type" }
	static def getVectorConstantTypeSizeMsg(String actualType)  { "Expected only scalar and vector types, but was " + actualType }

	@Check
	def checkValueType(BaseTypeConstant it)
	{
		val vType = value.typeFor
		if (vType !== null && !(vType instanceof NSTScalar && vType.primitive == type.primitive))
			error(getValueTypeMsg(type.primitive.literal), NablaPackage.Literals.BASE_TYPE_CONSTANT__TYPE, VALUE_TYPE)
	}

	@Check
	def checkSeedAndType(Reduction it)
	{
		val seedType = seed?.typeFor
		// Seed must be scalar and Seed rootType must be the same as Return rootType
		// If type is Array, the reduction Seed will be used as many times as Array size
		// Ex (ℕ.MaxValue, ℝ])→ℕ[2]; -> we will use (ℕ.MaxValue, ℕ.MaxValue) as reduction seed
		if (seedType !== null)
		{
			val rType = type.primitive
			if (!(seedType instanceof NSTScalar))
				error(getReductionSeedTypeMsg(), NablaPackage.Literals.REDUCTION__SEED, REDUCTION_SEED_TYPE)
			else if (seedType.label != rType.literal)
				error(getReductionTypesCompatibilityMsg(seedType.label, rType.literal), NablaPackage.Literals.REDUCTION__SEED, REDUCTION_TYPES_COMPATIBILITY)
		}
	}

	@Check
	def checkFunctionCallArgs(FunctionCall it)
	{
		if (typeFor === null)
		{
			val inTypes = args.map[x | x.typeFor.label]
			error(getFunctionArgsMsg(inTypes), NablaPackage.Literals::FUNCTION_CALL__FUNCTION, FUNCTION_ARGS)
		}
	}

	@Check
	def checkReductionArgs(ReductionCall it)
	{
		val inT = arg.typeFor

		if (inT !== null && inT instanceof NablaConnectivityType)
			error(getReductionOnConnectivitiesVariableMsg, NablaPackage.Literals::REDUCTION_CALL__REDUCTION, REDUCTION_ON_CONNECTIVITIES_VARIABLE)
		else if (typeFor === null)
			error(getReductionArgsMsg(inT.label), NablaPackage.Literals::REDUCTION_CALL__REDUCTION, REDUCTION_ARGS)
	}

	@Check 
	def checkContractedIfType(ContractedIf it)
	{
		val condType = condition?.typeFor
		val thenType = then?.typeFor
		val elseType = ^else?.typeFor

		if (!checkExpectedType(condType, BOOL))
			error(getContractedIfConditionTypeMsg(condType.label), NablaPackage.Literals::CONTRACTED_IF__CONDITION, CONTRACTED_IF_CONDITION_TYPE)
		if (!checkExpectedType(elseType, thenType))
			error(getContractedIfElseTypeMsg(elseType.label, thenType.label), NablaPackage.Literals::CONTRACTED_IF__ELSE, CONTRACTED_IF_ELSE_TYPE)
	}

	@Check
	def checkNotExpressionType(Not it)
	{
		if (!checkExpectedType(expression?.typeFor, BOOL))
		error(getNotExpressionTypeMsg(expression?.typeFor?.label), NablaPackage.Literals::NOT__EXPRESSION, NOT_EXPRESSION_TYPE)
	}

	// UnaryMinus fonctionne avec tous les types

	@Check
	def checkMulOrDivType(Mul it)
	{
		if (!checkBinaryOp(left, right, op))
			error(getBinaryOpTypeMsg(op, left?.typeFor.label, right?.typeFor.label), NablaPackage.Literals.MUL__OP, MUL_TYPE)
	}

	@Check
	def checkMulOrDivType(Div it)
	{
		if (!checkBinaryOp(left, right, op))
			error(getBinaryOpTypeMsg(op, left?.typeFor.label, right?.typeFor.label), NablaPackage.Literals.DIV__OP, DIV_TYPE)
	}

	@Check
	def checkPlusType(Plus it)
	{
		if (!checkBinaryOp(left, right, op))
			error(getBinaryOpTypeMsg(op, left?.typeFor.label, right?.typeFor.label), NablaPackage.Literals.PLUS__OP, PLUS_TYPE)
	}

	@Check
	def checkMinusType(Minus it)
	{
		if (!checkBinaryOp(left, right, op))
			error(getBinaryOpTypeMsg(op, left?.typeFor.label, right?.typeFor.label), NablaPackage.Literals.MINUS__OP, MINUS_TYPE)
	}

	@Check
	def checkComparisonType(Comparison it)
	{
		if (!checkBinaryOp(left, right, op))
			error(getBinaryOpTypeMsg(op, left?.typeFor.label, right?.typeFor.label), NablaPackage.Literals.COMPARISON__OP, COMPARISON_TYPE)
	}

	@Check
	def checkEqualityType(Equality it)
	{
		if (!checkBinaryOp(left, right, op))
			error(getBinaryOpTypeMsg(op, left?.typeFor.label, right?.typeFor.label), NablaPackage.Literals.EQUALITY__OP, EQUALITY_TYPE)
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

	@Check
	def checkVectorConstantType(VectorConstant it)
	{
		if (!values.empty)
		{
			val firstEltType = values.get(0).typeFor
			if (! (firstEltType instanceof NSTScalar || firstEltType instanceof NSTArray1D))
				error(getVectorConstantTypeSizeMsg(firstEltType.label), NablaPackage.Literals.VECTOR_CONSTANT__VALUES, VECTOR_CONSTANT_TYPE_SIZE)
			else if (values.size > 1 && values.tail.exists[x | x.typeFor != firstEltType])
				error(getVectorConstantInconsistentTypeMsg(), NablaPackage.Literals.VECTOR_CONSTANT__VALUES, VECTOR_CONSTANT_INCONSISTENT_TYPE)
		}
	}

	private def checkExpectedType(NablaType actualType, NablaType expectedType)
	{
		// si un des 2 types est indéfini, il ne faut rien vérifier pour éviter les erreurs multiples due à la récursion
		return (actualType === null || expectedType === null || actualType == expectedType)
	}

	private def checkBinaryOp(Expression left, Expression right, String op)
	{
		getTypeFor(left, right, op) !== null
	}
}