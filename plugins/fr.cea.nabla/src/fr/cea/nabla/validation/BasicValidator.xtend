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
import fr.cea.nabla.SpaceIteratorExtensions
import fr.cea.nabla.nabla.AbstractTimeIterator
import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.BaseType
import fr.cea.nabla.nabla.ConnectivityCall
import fr.cea.nabla.nabla.ConnectivityVar
import fr.cea.nabla.nabla.Expression
import fr.cea.nabla.nabla.InitTimeIteratorRef
import fr.cea.nabla.nabla.Interval
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NablaPackage
import fr.cea.nabla.nabla.NablaRoot
import fr.cea.nabla.nabla.NextTimeIteratorRef
import fr.cea.nabla.nabla.SpaceIteratorRef
import fr.cea.nabla.nabla.TimeIterator
import fr.cea.nabla.nabla.TimeIteratorBlock
import fr.cea.nabla.nabla.TimeIteratorRef
import fr.cea.nabla.typing.ExpressionTypeProvider
import fr.cea.nabla.typing.NSTIntScalar
import java.util.ArrayList
import java.util.List
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.validation.CheckType
import fr.cea.nabla.nabla.Job

// Caution: OptDefinition validation with InstructionValidator
class BasicValidator extends UnusedValidator
{
	@Inject extension ValidationUtils
	@Inject extension SpaceIteratorExtensions
	@Inject extension ExpressionExtensions
	@Inject extension ExpressionTypeProvider

	// ===== Module ====

	/**
	 * A module must have at least one variable or job or iterate.
	 * That is a way to differentiate between modules and extensions.
	 */
	public static val MODULE_BASE = "Module::ModuleBase"

	static def getModuleBaseMsg() { "Module must contains at least a variable declaration, a job definition or an iterate instruction"}

	@Check(CheckType.NORMAL)
	def void checkModuleBase(NablaModule it)
	{
		if (declarations.empty && iteration === null && jobs.empty)
			error(getModuleBaseMsg(), NablaPackage.Literals.NABLA_ROOT__NAME, MODULE_BASE);
	}

	// ===== Interval ====

	public static val ZERO_FROM = "Interval::ZeroFrom"

	static def getZeroFromMsg() { "Lower bound must be 0" }

	@Check(CheckType.NORMAL)
	def void checkFrom(Interval it)
	{
		if (from != 0)
			error(getZeroFromMsg(), NablaPackage.Literals.INTERVAL__FROM, ZERO_FROM);
	}

	@Check(CheckType.NORMAL)
	def void checkNbElems(Interval it)
	{
		if (nbElems !== null) 
			checkExpressionValidityAndType(nbElems, NablaPackage.Literals.INTERVAL__NB_ELEMS)
	}

	// ===== Names format  =====

	public static val UPPER_CASE_START_NAME = "UpperCaseStartName"

	static def getUpperCaseNameMsg() {"Name must start with an upper case" }

	@Check(CheckType.NORMAL)
	def checkUpperCase(NablaRoot it)
	{
		if (!name.nullOrEmpty && Character::isLowerCase(name.charAt(0)))
			error(getUpperCaseNameMsg(), NablaPackage.Literals.NABLA_ROOT__NAME, UPPER_CASE_START_NAME)
	}

	@Check(CheckType.NORMAL)
	def checkUpperCase(Job it)
	{
		if (!name.nullOrEmpty && Character::isLowerCase(name.charAt(0)))
			error(getUpperCaseNameMsg(), NablaPackage.Literals.JOB__NAME, UPPER_CASE_START_NAME)
	}

	// ===== TimeIterator =====

	public static val INIT_VALUE = "TimeIterator::InitValue"
	public static val NEXT_VALUE = "TimeIterator::NextValue"
	public static val CONDITION_CONSTRAINTS = "TimeIterator::ConditionConstraints"
	public static val CONDITION_BOOL = "TimeIterator::ConditionBool"
	public static val REF_VALIDITY = "TimeIterator::RefValidity"

	static def getInitValueMsg(int actualValue) { "Expected 0, but was " + actualValue }
	static def getNextValueMsg(int actualValue) { "Expected 1, but was " + actualValue }
	static def getConditionConstraintsMsg() { "Reductions not allowed in time iterator condition" }
	static def getRefValidityMsg(String[] expecteds, String actual)
	{
		var expectedsMsg = if (expecteds.empty) "nothing" else expecteds.join(' or ')
		"Wrong iterator. Expected " + expectedsMsg + ", but was " + actual
	}

	@Check(CheckType.NORMAL)
	def checkInitValue(InitTimeIteratorRef it)
	{
		if (value !== 0)
			error(getInitValueMsg(value), NablaPackage.Literals.INIT_TIME_ITERATOR_REF__VALUE, INIT_VALUE)
	}

	@Check(CheckType.NORMAL)
	def checkNextValue(NextTimeIteratorRef it)
	{
		if (value !== 1)
			error(getNextValueMsg(value), NablaPackage.Literals.NEXT_TIME_ITERATOR_REF__VALUE, NEXT_VALUE)
	}

	@Check(CheckType.NORMAL)
	def checkConditionConstraints(TimeIterator it)
	{
		if (condition !== null)
		{
			val condType = condition.typeFor
			if (!checkExpectedType(condType, ValidationUtils::BOOL))
				error(getTypeMsg(condType.label, ValidationUtils::BOOL.label), NablaPackage.Literals.TIME_ITERATOR__CONDITION, CONDITION_BOOL)

			if (!condition.reductionLess)
				error(getConditionConstraintsMsg(), NablaPackage.Literals.TIME_ITERATOR__CONDITION, CONDITION_CONSTRAINTS)
		}
	}

	@Check(CheckType.NORMAL)
	def checkRefValidity(TimeIteratorRef it)
	{
		if (target !== null)
		{
			val referencerIterators = (eContainer as ArgOrVarRef).timeIterators
			val i = referencerIterators.indexOf(it)
			var List<TimeIterator> expectedIters
			if (i > 0)
				expectedIters = getTimeIterators(referencerIterators.get(i-1).target.innerIterator)
			else
			{
				val m = EcoreUtil2.getContainerOfType(it, NablaModule)
				if (m !== null && m.iteration !== null && m.iteration.iterator !== null)
					expectedIters = m.iteration.iterator.timeIterators
			}
			if (!expectedIters.contains(target))
				error(getRefValidityMsg(expectedIters.map[name], target.name), NablaPackage.Literals.TIME_ITERATOR_REF__TARGET, REF_VALIDITY)
		}
	}

	private def List<TimeIterator> getTimeIterators(AbstractTimeIterator ti)
	{
		switch (ti)
		{
			case null: return #[]
			TimeIterator: return #[ti]
			TimeIteratorBlock:
			{
				val iters = new ArrayList<TimeIterator>
				for (blockIt : ti.iterators)
					iters += blockIt.timeIterators
				return iters
			}
		}
	}

	// ===== BaseType =====

	public static val UNSUPPORTED_DIMENSION = "BaseType::UnsupportedDimension"

	static def getUnsupportedDimensionMsg(int dimension) { "Unsupported dimension: " + dimension }

	@Check(CheckType.NORMAL)
	def checkUnsupportedDimension(BaseType it)
	{
		if (sizes.size > 2)
			error(getUnsupportedDimensionMsg(sizes.size), NablaPackage.Literals.BASE_TYPE__SIZES, UNSUPPORTED_DIMENSION)
	}

	@Check(CheckType.NORMAL)
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
	static def getDimensionArgMsg() { "First dimension must be on connectivities taking no argument" }

	@Check(CheckType.NORMAL)
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
					error(getTypeMsg(expectedT.name, actualT.name), NablaPackage.Literals::CONNECTIVITY_CALL__ARGS, i, CONNECTIVITY_CALL_TYPE)
			}
		}
	}

	@Check(CheckType.NORMAL)
	def checkDimensionArg(ConnectivityVar it)
	{
		if (supports.empty) return;

		if (!supports.head.inTypes.empty)
			error(getDimensionArgMsg(), NablaPackage.Literals::CONNECTIVITY_VAR__SUPPORTS, DIMENSION_ARG)
	}

	// ===== Items =====

	public static val SHIFT_VALIDITY = "Items::ShiftValidity"

	static def getShiftValidityMsg() { "Shift invalid on a singleton set" }

	@Check(CheckType.NORMAL)
	def checkShiftValidity(SpaceIteratorRef it)
	{
		if ((inc>0 || dec>0) && target !== null && !(target.multiple))
			error(getShiftValidityMsg(), NablaPackage.Literals::SPACE_ITERATOR_REF__TARGET, SHIFT_VALIDITY)
	}

	// ===== Tools to share expression validation                          =====
	// ===== Used by BaseType sizes, Interval nbElems, ArgOrVarRef indices =====
	public static val VALIDITY_EXPRESSION = "Expressions::ValidityExpression"
	public static val TYPE_EXPRESSION_TYPE = "Expressions::TypeExpression"

	static def getValidityExpressionMsg() { "Reductions not allowed in types" }

	protected def void checkExpressionValidityAndType(Expression it, EStructuralFeature feature)
	{
		if (!reductionLess)
			error(getValidityExpressionMsg(), feature, VALIDITY_EXPRESSION);

		val t = typeFor
		if (t !== null && !(t instanceof NSTIntScalar))
			error(getTypeMsg(t.label, ValidationUtils::INT.label), feature, TYPE_EXPRESSION_TYPE);
	}

	protected def void checkExpressionValidityAndType(Expression it, EStructuralFeature feature, int index)
	{
		if (!reductionLess)
			error(getValidityExpressionMsg(), feature, index, VALIDITY_EXPRESSION);

		val t = typeFor
		if (t !== null && !(t instanceof NSTIntScalar))
			error(getTypeMsg(t.label, ValidationUtils::INT.label), feature, index, TYPE_EXPRESSION_TYPE);
	}
}