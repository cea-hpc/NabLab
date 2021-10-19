/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.validation

import com.google.inject.Inject
import fr.cea.nabla.nabla.And
import fr.cea.nabla.nabla.BaseTypeConstant
import fr.cea.nabla.nabla.Comparison
import fr.cea.nabla.nabla.ContractedIf
import fr.cea.nabla.nabla.Div
import fr.cea.nabla.nabla.Equality
import fr.cea.nabla.nabla.Expression
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.IntConstant
import fr.cea.nabla.nabla.Minus
import fr.cea.nabla.nabla.Modulo
import fr.cea.nabla.nabla.Mul
import fr.cea.nabla.nabla.NablaPackage
import fr.cea.nabla.nabla.Not
import fr.cea.nabla.nabla.Or
import fr.cea.nabla.nabla.Plus
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.VectorConstant
import fr.cea.nabla.typing.ExpressionTypeProvider
import fr.cea.nabla.typing.NSTArray1D
import fr.cea.nabla.typing.NSTScalar
import fr.cea.nabla.typing.NablaConnectivityType
import java.util.List
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.validation.CheckType

class ExpressionValidator extends ArgOrVarRefValidator
{
	@Inject extension ValidationUtils
	@Inject extension ExpressionTypeProvider

	public static val BASE_TYPE_CONSTANT_VALUE = "Expressions::BaseTypeConstantValue"
	public static val BASE_TYPE_CONSTANT_TYPE = "Expressions::BaseTypeConstantType"
	public static val FUNCTION_CALL_ARGS = "Expressions::FunctionCallArgs"
	public static val REDUCTION_CALL_ON_CONNECTIVITIES_VARIABLE = "Expressions::ReductionCallOnConnectivitiesVariable"
	public static val REDUCTION_CALL_ARGS = "Expressions::ReductionArgs"
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
	public static val VECTOR_CONSTANT_SIZE = "Expressions::VectorConstantSize"
	public static val VECTOR_CONSTANT_INCONSISTENT_TYPE = "Expressions::VectorConstantInconsistentType"
	public static val VECTOR_CONSTANT_TYPE = "Expressions::VectorConstantType"

	static def getBaseTypeConstantValueMsg(String expectedTypeName) { "Initialization value must be of type " + expectedTypeName }
	static def getBaseTypeConstantTypeMsg() { "Only integer constant allowed for initialization" }
	static def getFunctionCallArgsMsg(List<String> inTypes) { "No candidate function found. Wrong arguments: " + inTypes.join(', ') }
	static def getReductionCallOnConnectivitiesVariableMsg() { "No reduction on connectivities variable" }
	static def getReductionCallArgsMsg(String inType) { "No candidate reduction found. Wrong arguments: " + inType }
	static def getBinaryOpTypeMsg(String op, String leftType, String rightType) { "Binary operator " + op + " undefined on types " + leftType + " and " + rightType }
	static def getVectorConstantSizeMsg(int size) { "Unsupported vector size: " + size }
	static def getVectorConstantInconsistentTypeMsg() { "All values must have the same type" }
	static def getVectorConstantTypeMsg(String actualType)  { "Expected only scalar and vector types, but was " + actualType }

	@Check(CheckType.NORMAL)
	def checkBaseTypeConstantValue(BaseTypeConstant it)
	{
		val vType = value?.typeFor
		if (vType !== null && !(vType instanceof NSTScalar && vType.primitive == type.primitive))
			error(getBaseTypeConstantValueMsg(type.primitive.literal), NablaPackage.Literals.BASE_TYPE_CONSTANT__VALUE, BASE_TYPE_CONSTANT_VALUE)
	}

	@Check(CheckType.NORMAL)
	def checkBaseTypeConstantType(BaseTypeConstant it)
	{
		for (i : 0..<type.sizes.size)
			if (! (type.sizes.get(i) instanceof IntConstant))
			error(getBaseTypeConstantTypeMsg(), NablaPackage.Literals.BASE_TYPE_CONSTANT__TYPE, i, BASE_TYPE_CONSTANT_TYPE)
	}

	@Check(CheckType.NORMAL)
	def checkFunctionCallArgs(FunctionCall it)
	{
		val inTypes = args.map[typeFor]
		if (typeFor === null)
			error(getFunctionCallArgsMsg(inTypes.map[label]), NablaPackage.Literals::FUNCTION_CALL__FUNCTION, FUNCTION_CALL_ARGS)
	}

	@Check(CheckType.NORMAL)
	def checkReductionCallArgs(ReductionCall it)
	{
		val inType = arg?.typeFor
		if (inType !== null && inType instanceof NablaConnectivityType)
			error(getReductionCallOnConnectivitiesVariableMsg, NablaPackage.Literals::REDUCTION_CALL__REDUCTION, REDUCTION_CALL_ON_CONNECTIVITIES_VARIABLE)
		else if (typeFor === null)
			error(getReductionCallArgsMsg(inType.label), NablaPackage.Literals::REDUCTION_CALL__REDUCTION, REDUCTION_CALL_ARGS)
	}

	@Check(CheckType.NORMAL)
	def checkContractedIfType(ContractedIf it)
	{
		val condType = condition?.typeFor
		val thenType = then?.typeFor
		val elseType = ^else?.typeFor

		if (!checkExpectedType(condType, ValidationUtils::BOOL))
			error(getTypeMsg(condType.label, ValidationUtils::BOOL.label), NablaPackage.Literals::CONTRACTED_IF__CONDITION, CONTRACTED_IF_CONDITION_TYPE)
		if (!checkExpectedType(elseType, thenType))
			error(getTypeMsg(elseType.label, thenType.label), NablaPackage.Literals::CONTRACTED_IF__ELSE, CONTRACTED_IF_ELSE_TYPE)
	}

	@Check(CheckType.NORMAL)
	def checkNotExpressionType(Not it)
	{
		if (!checkExpectedType(expression?.typeFor, ValidationUtils::BOOL))
		error(getTypeMsg(expression?.typeFor?.label, ValidationUtils::BOOL.label), NablaPackage.Literals::NOT__EXPRESSION, NOT_EXPRESSION_TYPE)
	}

	// UnaryMinus fonctionne avec tous les types

	@Check(CheckType.NORMAL)
	def checkMulType(Mul it)
	{
		if (!checkBinaryOp(left, right, op))
			error(getBinaryOpTypeMsg(op, left?.typeFor.label, right?.typeFor.label), NablaPackage.Literals.MUL__OP, MUL_TYPE)
	}

	@Check(CheckType.NORMAL)
	def checkDivType(Div it)
	{
		if (!checkBinaryOp(left, right, op))
			error(getBinaryOpTypeMsg(op, left?.typeFor.label, right?.typeFor.label), NablaPackage.Literals.DIV__OP, DIV_TYPE)
	}

	@Check(CheckType.NORMAL)
	def checkPlusType(Plus it)
	{
		if (!checkBinaryOp(left, right, op))
			error(getBinaryOpTypeMsg(op, left?.typeFor.label, right?.typeFor.label), NablaPackage.Literals.PLUS__OP, PLUS_TYPE)
	}

	@Check(CheckType.NORMAL)
	def checkMinusType(Minus it)
	{
		if (!checkBinaryOp(left, right, op))
			error(getBinaryOpTypeMsg(op, left?.typeFor.label, right?.typeFor.label), NablaPackage.Literals.MINUS__OP, MINUS_TYPE)
	}

	@Check(CheckType.NORMAL)
	def checkComparisonType(Comparison it)
	{
		if (!checkBinaryOp(left, right, op))
			error(getBinaryOpTypeMsg(op, left?.typeFor.label, right?.typeFor.label), NablaPackage.Literals.COMPARISON__OP, COMPARISON_TYPE)
	}

	@Check(CheckType.NORMAL)
	def checkEqualityType(Equality it)
	{
		if (!checkBinaryOp(left, right, op))
			error(getBinaryOpTypeMsg(op, left?.typeFor.label, right?.typeFor.label), NablaPackage.Literals.EQUALITY__OP, EQUALITY_TYPE)
	}

	@Check(CheckType.NORMAL)
	def checkModuloType(Modulo it)
	{
		if (!checkExpectedType(left?.typeFor, ValidationUtils::INT))
			error(getTypeMsg(left?.typeFor.label, ValidationUtils::INT.label), NablaPackage.Literals.MODULO__LEFT, MODULO_TYPE)
		if (!checkExpectedType(right?.typeFor, ValidationUtils::INT))
			error(getTypeMsg(right?.typeFor.label, ValidationUtils::INT.label), NablaPackage.Literals.MODULO__RIGHT, MODULO_TYPE)
	}

	@Check(CheckType.NORMAL)
	def checkAndType(And it)
	{
		if (!checkExpectedType(left?.typeFor, ValidationUtils::BOOL))
			error(getTypeMsg(left?.typeFor.label, ValidationUtils::BOOL.label), NablaPackage.Literals.AND__LEFT, AND_TYPE)
		if (!checkExpectedType(right?.typeFor, ValidationUtils::BOOL))
			error(getTypeMsg(right?.typeFor.label, ValidationUtils::BOOL.label), NablaPackage.Literals.AND__RIGHT, AND_TYPE)
	}

	@Check(CheckType.NORMAL)
	def checkOrType(Or it)
	{
		if (!checkExpectedType(left?.typeFor, ValidationUtils::BOOL))
			error(getTypeMsg(left?.typeFor.label, ValidationUtils::BOOL.label), NablaPackage.Literals.OR__LEFT, OR_TYPE)
		if (!checkExpectedType(right?.typeFor, ValidationUtils::BOOL))
			error(getTypeMsg(right?.typeFor.label, ValidationUtils::BOOL.label), NablaPackage.Literals.OR__RIGHT, OR_TYPE)
	}

	@Check(CheckType.NORMAL)
	def checkVectorConstantSize(VectorConstant it)
	{
		if (values.size < 2)
			error(getVectorConstantSizeMsg(values.size), NablaPackage.Literals.VECTOR_CONSTANT__VALUES, VECTOR_CONSTANT_SIZE)
	}

	@Check(CheckType.NORMAL)
	def checkVectorConstantType(VectorConstant it)
	{
		if (!values.empty)
		{
			val firstEltType = values.get(0).typeFor
			if (! (firstEltType instanceof NSTScalar || firstEltType instanceof NSTArray1D))
				error(getVectorConstantTypeMsg(firstEltType.label), NablaPackage.Literals.VECTOR_CONSTANT__VALUES, VECTOR_CONSTANT_TYPE)
			else if (values.size > 1 && values.tail.exists[x | x.typeFor != firstEltType])
				error(getVectorConstantInconsistentTypeMsg(), NablaPackage.Literals.VECTOR_CONSTANT__VALUES, VECTOR_CONSTANT_INCONSISTENT_TYPE)
		}
	}

	private def checkBinaryOp(Expression left, Expression right, String op)
	{
		getTypeFor(left, right, op) !== null
	}
}