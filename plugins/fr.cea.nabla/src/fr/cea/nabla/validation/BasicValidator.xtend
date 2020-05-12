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
import fr.cea.nabla.ExpressionExtensions
import fr.cea.nabla.ItemExtensions
import fr.cea.nabla.ir.MandatoryOptions
import fr.cea.nabla.nabla.BaseType
import fr.cea.nabla.nabla.ConnectivityCall
import fr.cea.nabla.nabla.ConnectivityVar
import fr.cea.nabla.nabla.Expression
import fr.cea.nabla.nabla.InitTimeIteratorRef
import fr.cea.nabla.nabla.Interval
import fr.cea.nabla.nabla.ItemRef
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NablaPackage
import fr.cea.nabla.nabla.NextTimeIteratorRef
import fr.cea.nabla.nabla.SpaceIterator
import fr.cea.nabla.nabla.TimeIterator
import fr.cea.nabla.typing.ExpressionTypeProvider
import fr.cea.nabla.typing.NSTIntScalar
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.xtext.validation.Check

import static extension fr.cea.nabla.ConnectivityCallExtensions.*

// Caution: OptDefinition validation with InstructionValidator
class BasicValidator extends UnusedValidator
{
	@Inject extension ItemExtensions
	@Inject extension ExpressionExtensions
	@Inject extension ExpressionTypeProvider

	// ===== Interval ====

	public static val ZERO_FROM = "Interval::ZeroFrom"

	static def getZeroFromMsg() { "Lower bound must be 0" }

	@Check
	def void checkFrom(Interval it)
	{
		if (from != 0)
			error(getZeroFromMsg(), NablaPackage.Literals.INTERVAL__FROM, ZERO_FROM);
	}

	@Check
	def void checkNbElems(Interval it)
	{
		if (nbElems !== null) 
			checkExpressionValidityAndType(nbElems, NablaPackage.Literals.INTERVAL__NB_ELEMS)
	}

	// ===== NablaModule =====

	public static val MANDATORY_OPTION = "NablaModule::MandatoryOption"
	public static val MODULE_NAME = "NablaModule::ModuleName"

	static def getMandatoryOptionsMsg(String[] missingOptions) { "Missing mandatory mesh option(s): " + missingOptions.join(", ") }
	static def getModuleNameMsg() { "Module name must start with an upper case" }

	@Check
	def checkMandatoryOptions(NablaModule it)
	{
		if (itemTypes.empty) return; // no mesh
		val options = definitions.filter[option].map[variable.name].toList
		val missingOptions = MandatoryOptions::NAMES.filter[x | !options.contains(x)]
		if (missingOptions.size > 0)
			error(getMandatoryOptionsMsg(missingOptions), NablaPackage.Literals.NABLA_MODULE__NAME, MANDATORY_OPTION)
	}

	@Check
	def checkName(NablaModule it)
	{
		if (!name.nullOrEmpty && Character::isLowerCase(name.charAt(0)))
			error(getModuleNameMsg(), NablaPackage.Literals.NABLA_MODULE__NAME, MODULE_NAME)
	}

	// ===== TimeIterator =====

	public static val INIT_VALUE = "TimeIterator::InitValue"
	public static val NEXT_VALUE = "TimeIterator::NextValue"
	public static val CONDITION_CONSTRAINTS = "TimeIterator::ConditionConstraints"

	static def getInitValueMsg(int actualValue) { "Expected 0, but was " + actualValue }
	static def getNextValueMsg(int actualValue) { "Expected 1, but was " + actualValue }
	static def getConditionConstraintsMsg() { "Reductions not allowed in time iterator condition" }

	@Check 
	def checkInitValue(InitTimeIteratorRef it)
	{
		if (value !== 0)
			error(getInitValueMsg(value), NablaPackage.Literals.INIT_TIME_ITERATOR_REF__VALUE, INIT_VALUE)
	}

	@Check 
	def checkNextValue(NextTimeIteratorRef it)
	{
		if (value !== 1)
			error(getNextValueMsg(value), NablaPackage.Literals.NEXT_TIME_ITERATOR_REF__VALUE, NEXT_VALUE)
	}

	@Check
	def checkConditionConstraints(TimeIterator it)
	{
		if (cond !== null && !cond.reductionLess)
			error(getConditionConstraintsMsg(), NablaPackage.Literals.TIME_ITERATOR__COND, CONDITION_CONSTRAINTS)
	}

	// ===== BaseType =====

	public static val UNSUPPORTED_DIMENSION = "BaseType::UnsupportedDimension"

	static def getUnsupportedDimensionMsg(int dimension) { "Unsupported dimension: " + dimension }

	@Check
	def checkUnsupportedDimension(BaseType it)
	{
		if (sizes.size > 2)
			error(getUnsupportedDimensionMsg(sizes.size), NablaPackage.Literals.BASE_TYPE__SIZES, UNSUPPORTED_DIMENSION)
	}

	@Check
	def checkSizeExpression(BaseType it)
	{
		for (i : 0..<sizes.size)
			checkExpressionValidityAndType(sizes.get(i), NablaPackage.Literals.BASE_TYPE__SIZES, i)
	}


	// ===== Connectivities =====

	public static val CONNECTIVITY_CALL_INDEX = "Connectivities::ConnectivityCallIndex"
	public static val CONNECTIVITY_CALL_TYPE = "Connectivities::ConnectivityCallType"
	public static val DIMENSION_ARG = "Connectivities::DimensionArg"

	static def getConnectivityCallIndexMsg(int expectedSize, int actualSize) { "Wrong number of arguments. Expected " + expectedSize + ", but was " + actualSize }
	static def getConnectivityCallTypeMsg(String expectedType, String actualType) { "Expected " + expectedType + ', but was ' + actualType }
	static def getDimensionArgMsg() { "First dimension must be on connectivities taking no argument" }

	@Check
	def checkConnectivityCallIndexAndType(ConnectivityCall it)
	{
		if (args.size != connectivity.inTypes.size)
			error(getConnectivityCallIndexMsg(connectivity.inTypes.size, args.size), NablaPackage.Literals::CONNECTIVITY_CALL__ARGS, CONNECTIVITY_CALL_INDEX)
		else
		{
			for (i : 0..<args.length)
			{
				val actualT = args.get(i).target.type
				val expectedT = connectivity.inTypes.get(i)
				if (actualT != expectedT)
					error(getConnectivityCallTypeMsg(expectedT.name, actualT.name), NablaPackage.Literals::CONNECTIVITY_CALL__ARGS, i, CONNECTIVITY_CALL_TYPE)
			}
		}
	}

	@Check
	def checkDimensionArg(ConnectivityVar it)
	{
		if (supports.empty) return;

		if (!supports.head.inTypes.empty)
			error(getDimensionArgMsg(), NablaPackage.Literals::CONNECTIVITY_VAR__SUPPORTS, DIMENSION_ARG)
	}

	// ===== Items =====

	public static val SHIFT_VALIDITY = "Items::ShiftValidity"

	static def getShiftValidityMsg() { "Shift only valid for an iteration on a connectivity set" }

	@Check
	def checkShiftValidity(ItemRef it)
	{
		if ((inc>0 || dec>0) && target !== null && !(target.eContainer instanceof SpaceIterator))
			error(getShiftValidityMsg(), NablaPackage.Literals::ITEM_REF__TARGET, SHIFT_VALIDITY)
	}

	// ===== Tools to share expression validation                          =====
	// ===== Used by BaseType sizes, Interval nbElems, ArgOrVarRef indices =====
	public static val VALIDITY_EXPRESSION = "Expressions::ValidityExpression"
	public static val TYPE_EXPRESSION_TYPE = "Expressions::TypeExpression"

	static def getValidityExpressionMsg() { "Reductions not allowed in types" }
	static def getTypeExpressionMsg(String actualType) { "Expected " + ValidationUtils::INT.label + " type, but was " + actualType }

	protected def void checkExpressionValidityAndType(Expression it, EStructuralFeature feature)
	{
		if (!reductionLess)
			error(getValidityExpressionMsg(), feature, VALIDITY_EXPRESSION);

		val t = typeFor
		if (t !== null && !(t instanceof NSTIntScalar))
			error(getTypeExpressionMsg(t.label), feature, TYPE_EXPRESSION_TYPE);
	}

	protected def void checkExpressionValidityAndType(Expression it, EStructuralFeature feature, int index)
	{
		if (!reductionLess)
			error(getValidityExpressionMsg(), feature, index, VALIDITY_EXPRESSION);

		val t = typeFor
		if (t !== null && !(t instanceof NSTIntScalar))
			error(getTypeExpressionMsg(t.label), feature, index, TYPE_EXPRESSION_TYPE);
	}
}