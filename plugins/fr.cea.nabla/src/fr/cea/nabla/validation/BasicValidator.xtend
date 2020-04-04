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
import fr.cea.nabla.ArgOrVarExtensions
import fr.cea.nabla.ItemExtensions
import fr.cea.nabla.ir.MandatoryOptions
import fr.cea.nabla.nabla.Affectation
import fr.cea.nabla.nabla.Arg
import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.BaseType
import fr.cea.nabla.nabla.Connectivity
import fr.cea.nabla.nabla.ConnectivityCall
import fr.cea.nabla.nabla.ConnectivityVar
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.FunctionOrReduction
import fr.cea.nabla.nabla.InitTimeIteratorRef
import fr.cea.nabla.nabla.InstructionBlock
import fr.cea.nabla.nabla.IntConstant
import fr.cea.nabla.nabla.Interval
import fr.cea.nabla.nabla.Item
import fr.cea.nabla.nabla.ItemRef
import fr.cea.nabla.nabla.ItemType
import fr.cea.nabla.nabla.Job
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NablaPackage
import fr.cea.nabla.nabla.NextTimeIteratorRef
import fr.cea.nabla.nabla.Reduction
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.Return
import fr.cea.nabla.nabla.SimpleVar
import fr.cea.nabla.nabla.SimpleVarDefinition
import fr.cea.nabla.nabla.SpaceIterator
import fr.cea.nabla.nabla.TimeIterator
import fr.cea.nabla.nabla.TimeIteratorRef
import fr.cea.nabla.nabla.Var
import fr.cea.nabla.nabla.VarGroupDeclaration
import fr.cea.nabla.nabla.VectorConstant
import fr.cea.nabla.overloading.DeclarationProvider
import fr.cea.nabla.typing.ArgOrVarTypeProvider
import fr.cea.nabla.typing.NablaConnectivityType
import fr.cea.nabla.typing.NablaSimpleType
import java.util.HashSet
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.scoping.IScopeProvider
import org.eclipse.xtext.util.SimpleAttributeResolver
import org.eclipse.xtext.validation.Check

import static extension fr.cea.nabla.ConnectivityCallExtensions.*

class BasicValidator extends AbstractNablaValidator
{
	@Inject extension ArgOrVarExtensions
	@Inject extension DeclarationProvider
	@Inject extension ItemExtensions
	@Inject extension ArgOrVarTypeProvider
	@Inject IScopeProvider scopeProvider

	// ===== Temporary limitations ====

	public static val ZERO_FROM = "ZeroFrom"
	static def getZeroFromMsg() { "Lower bound must be 0" }

	@Check
	def void checkFrom(Interval it)
	{
		if (from != 0)
			error(getZeroFromMsg(), NablaPackage.Literals.INTERVAL__FROM, ZERO_FROM);
	}

	// ===== Unique Names ====

	public static val DUPLICATE_NAME = "DuplicateName"
	static def getDuplicateNameMsg(EClass objectClass, String objectName) { "Duplicate " + objectClass.name + ": " + objectName }

	@Check
	def void checkDuplicate(Arg it)
	{
		if (eContainer instanceof Function && (eContainer as Function).inArgs.size>0)
		{
			val args = (eContainer as Function).inArgs
			val duplicate = args.findFirst[x | x.name == name && x != it]
			if (duplicate !== null)
				error(getDuplicateNameMsg(NablaPackage.Literals.ARG, duplicate.name), NablaPackage.Literals.ARG_OR_VAR__NAME, DUPLICATE_NAME);
		}
	}

	@Check
	def void checkDuplicate(Var it) 
	{
		if (eContainer instanceof VarGroupDeclaration)
		{
			val variables = (eContainer as VarGroupDeclaration).variables
			val duplicate = variables.findFirst[x | x.name == name && x != it]
			if (duplicate !== null)
				error(getDuplicateNameMsg(NablaPackage.Literals.VAR, duplicate.name), NablaPackage.Literals.ARG_OR_VAR__NAME, DUPLICATE_NAME);
		}

		val scope = scopeProvider.getScope(it, NablaPackage.Literals.ARG_OR_VAR_REF__TARGET)
		val duplicated = scope.allElements.exists[x | x.name.lastSegment == name]
		if (duplicated)
		{
			error(getDuplicateNameMsg(NablaPackage.Literals.ARG_OR_VAR, name), NablaPackage.Literals.ARG_OR_VAR__NAME, DUPLICATE_NAME);
		}
		else
		{
			val module = EcoreUtil2.getContainerOfType(it, NablaModule)
			if (module.iteration !== null && module.iteration.iterators.exists[x | x.name == name])
				error(getDuplicateNameMsg(NablaPackage.Literals.ARG_OR_VAR, name + " (iterator)"), NablaPackage.Literals.ARG_OR_VAR__NAME, DUPLICATE_NAME);
		}
	}

	@Check
	def void checkDuplicate(Item it)
	{
		val scope = scopeProvider.getScope(it, NablaPackage.Literals.ITEM_REF__TARGET)
		//println('checkDuplicate(' + it + ') : ' + scope.allElements.map[name.segments.join('.')].join(', '))
		val duplicated = scope.allElements.exists[x | x.name.lastSegment == name]
		if (duplicated)
			error(getDuplicateNameMsg(NablaPackage.Literals.ITEM, name), NablaPackage.Literals.ITEM__NAME, DUPLICATE_NAME);
	}

	@Check
	def void checkDuplicate(ItemType it) { checkDuplicates(NablaPackage.Literals.ITEM_TYPE__NAME) }

	@Check
	def void checkDuplicate(Connectivity it) { checkDuplicates(NablaPackage.Literals.CONNECTIVITY__NAME) }

	@Check
	def void checkDuplicate(Job it) { checkDuplicates(NablaPackage.Literals.JOB__NAME) }

	@Check
	def void checkDuplicate(TimeIterator it) {  checkDuplicates(NablaPackage.Literals.ARG_OR_VAR__NAME) }

	private def <T extends EObject> checkDuplicates(T t, EStructuralFeature f)
	{
		val name = SimpleAttributeResolver.NAME_RESOLVER.apply(t)
		//println('checkDuplicates(' + t + ', ' + f.name + ', ' + name + ')')
		val module = EcoreUtil2.getContainerOfType(t, NablaModule)
		if (module !== null)
		{
			val contents = EcoreUtil2.getAllContentsOfType(module, t.class)
			for (tx : contents)
			{
				val tx_name = SimpleAttributeResolver.NAME_RESOLVER.apply(tx)
				if (tx_name.equals(name) && tx !== t)
					error(getDuplicateNameMsg(t.eClass, name), f, DUPLICATE_NAME);
			}
		}
	}

	// ===== Return Instruction ====

	public static val FORBIDDEN_RETURN = "Return::Forbidden"
	public static val MISSING_RETURN = "Return::Missing"
	public static val UNREACHABLE_CODE = "Return::UnreachableCode"

	static def getForbiddenReturnMsg() { "Return instruction tted in jobs" }
	static def getMissingReturnMsg() { "Function/Reduction must end with a return instruction" }
	static def getUnreachableReturnMsg() { "Unreachable code" }

	@Check
	def checkForbiddenReturn(Return it)
	{
		val function = EcoreUtil2.getContainerOfType(it, FunctionOrReduction)
		if (function === null)
			error(getForbiddenReturnMsg(), NablaPackage.Literals.RETURN__EXPRESSION, FORBIDDEN_RETURN)
	}

	@Check
	def checkMissingReturn(FunctionOrReduction it)
	{
		if (body === null) return;

		val hasReturn = (body instanceof Return) || body.eAllContents.exists[x | x instanceof Return]
		if (!hasReturn)
			error(getMissingReturnMsg(), NablaPackage.Literals.FUNCTION_OR_REDUCTION__NAME, MISSING_RETURN)
	}

	@Check
	def checkUnreachableCode(FunctionOrReduction it)
	{
		if (body === null) return;
		
		if (body instanceof InstructionBlock)
		{
			val instructions = (body as InstructionBlock).instructions
			for (i : 0..<instructions.size-1)
				if (instructions.get(i) instanceof Return)
				{
					error(getUnreachableReturnMsg(), instructions.get(i+1), null, UNREACHABLE_CODE)
					return // no need to return further errors
				}
		}
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
		val scalarConsts = instructions.filter(SimpleVarDefinition).filter[const].map[variable.name].toList
		val missingConsts = MandatoryOptions::NAMES.filter[x | !scalarConsts.contains(x)]
		if (missingConsts.size > 0)
			error(getMandatoryOptionsMsg(missingConsts), NablaPackage.Literals.NABLA_MODULE__NAME, MANDATORY_OPTION)
	}

	@Check
	def checkName(NablaModule it)
	{
		if (!name.nullOrEmpty && Character::isLowerCase(name.charAt(0)))
			error(getModuleNameMsg(), NablaPackage.Literals.NABLA_MODULE__NAME, MODULE_NAME)
	}

	// ===== TimeIterator =====

	public static val UNUSED_TIME_ITERATOR = "TimeIterator::Unused"
	public static val INIT_VALUE = "TimeIterator::InitValue"
	public static val NEXT_VALUE = "TimeIterator::NextValue"
	public static val NO_REDUCTION_IN_CONDITION = "TimeIterator::NoReductionInCondition"

	static def getUnusedTimeIteratorMsg() { "Unused time iterator" }
	static def getInitValueMsg(int actualValue) { "Wrong time iterator init value: Expected 0, but was " + actualValue }
	static def getNextValueMsg(int actualValue) { "Wrong time iterator next value: Expected 1, but was " + actualValue }
	static def getNoReductionInConditionMsg() { "Reduction in time iterator condition not yet implemented" }

	@Check 
	def checkUnusedTimeIterator(TimeIterator it)
	{
		val m = EcoreUtil2::getContainerOfType(it, NablaModule)
		if (m !== null)
		{
			val timeIterRefs =  m.eAllContents.filter(TimeIteratorRef).toList
			val hasItRef = timeIterRefs.exists[x | x.target === it]
			if (!hasItRef)
				warning(getUnusedTimeIteratorMsg(), NablaPackage.Literals.ARG_OR_VAR__NAME, UNUSED_TIME_ITERATOR)
		}
	}

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
	def checkNoReductionInCondition(TimeIterator it)
	{
		if (cond !== null && (cond instanceof ReductionCall || cond.eAllContents.exists[x | x instanceof ReductionCall]))
			error(getNoReductionInConditionMsg(), NablaPackage.Literals.TIME_ITERATOR__COND, NO_REDUCTION_IN_CONDITION)
	}

	// ===== BaseType =====

	public static val ARRAY_SIZES = "BaseType::ArraySizes"
	public static val ARRAY_DIMENSION = "BaseType::ArrayDimension"

	static def getArraySizesMsg() { "Must be greater or equal than 2" }
	static def getArrayDimensionMsg() { "Max 2 dimensions for arrays" }

	@Check
	def checkArraySizes(BaseType it)
	{
		for (i : 0..<sizes.size)
		{
			val size = sizes.get(i)
			if (size instanceof IntConstant && (size as IntConstant).value < 2)
				error(getArraySizesMsg(), NablaPackage.Literals.BASE_TYPE__SIZES, i, ARRAY_SIZES)
		}
	}

	@Check
	def checkArrayDimension(BaseType it)
	{
		if (sizes.size > 2)
			error(getArrayDimensionMsg(), NablaPackage.Literals.BASE_TYPE__SIZES, ARRAY_DIMENSION)
	}

	// ===== VectorConstant =====

	public static val VECTOR_CONSTANT_SIZE = "VectorConstant::Size"
	static def getVectorConstantSizeMsg() { "Must be greater or equal than 2" }

	@Check
	def checkVectorConstantSize(VectorConstant it)
	{
		if (values.size < 2)
			error(getVectorConstantSizeMsg(), NablaPackage.Literals.VECTOR_CONSTANT__VALUES, VECTOR_CONSTANT_SIZE)
	}

	// ===== Variables : Var & VarRef =====

	public static val UNUSED_VARIABLE = "Variables::UnusedVariable"
	public static val INDICES_NUMBER = "Variables::IndicesNumber"
	public static val SPACE_ITERATOR_NUMBER = "Variables::SpaceIteratorNumber"
	public static val SPACE_ITERATOR_TYPE = "Variables::SpaceIteratorType"
	public static val TIME_ITERATOR_USAGE = 'Variables::TimeIteratorUsage'
	
	static def getUnusedVariableMsg() { "Unused variable" }
	static def getIndicesNumberMsg(int expectedSize, int actualSize) { "Wrong number of indices: Expected " + expectedSize + ", but was " + actualSize }
	static def getSpaceIteratorNumberMsg(int expectedSize, int actualSize) { "Wrong number of space iterators: Expected " + expectedSize + ", but was " + actualSize }
	static def getSpaceIteratorTypeMsg(String expectedType, String actualType) { "Wrong space iterator type: Expected " + expectedType + ", but was " + actualType }
	static def getTimeIteratorUsageMsg() { "Time iterator must be specified" }

	@Check
	def checkUnusedVariable(Var it)
	{
		val m = EcoreUtil2.getContainerOfType(it, NablaModule)
		val mandatories = (MandatoryOptions::NAMES).toList
		val referenced = mandatories.contains(name) || m.eAllContents.filter(ArgOrVarRef).exists[x|x.target===it]
		if (!referenced)
			warning(getUnusedVariableMsg(), NablaPackage.Literals::ARG_OR_VAR__NAME, UNUSED_VARIABLE)
	}

	@Check
	def checkIndicesNumber(ArgOrVarRef it)
	{
		if (target === null || target.eIsProxy) return
		val vTypeSize = target.typeFor
		val dimension = if (vTypeSize instanceof NablaConnectivityType) vTypeSize.simple.dimension 
			else (vTypeSize as NablaSimpleType).dimension
		if (indices.size > 0 && indices.size != dimension)
			error(getIndicesNumberMsg(dimension, indices.size), NablaPackage.Literals::ARG_OR_VAR_REF__INDICES, INDICES_NUMBER)
	}

	@Check
	def checkSpaceIteratorNumberAndType(ArgOrVarRef it)
	{
		if (target instanceof ConnectivityVar)
		{
			val dimensions = (target as ConnectivityVar).supports

			if (spaceIterators.size >  0 && spaceIterators.size != dimensions.size)
				error(getSpaceIteratorNumberMsg(dimensions.size, spaceIterators.size), NablaPackage.Literals::ARG_OR_VAR_REF__SPACE_ITERATORS, SPACE_ITERATOR_NUMBER)
			else
			{
				for (i : 0..<spaceIterators.length)
				{
					val spaceIteratorRefI = spaceIterators.get(i)
					val dimensionI = dimensions.get(i)
					val actualT = spaceIteratorRefI.target.type
					val expectedT = dimensionI.returnType
					if (actualT != expectedT)
						error(getSpaceIteratorTypeMsg(expectedT.name, actualT.name), NablaPackage.Literals::ARG_OR_VAR_REF__SPACE_ITERATORS, i, SPACE_ITERATOR_TYPE)
				}
			}
		}
		else
		{
			if (!spaceIterators.empty)
				error(getSpaceIteratorNumberMsg(0, spaceIterators.size), NablaPackage.Literals::ARG_OR_VAR_REF__SPACE_ITERATORS, SPACE_ITERATOR_NUMBER)
		}
	}

	@Check
	def checkTimeIteratorUsage(ArgOrVarRef it)
	{
		if (timeIterators.empty)
		{
			val module = EcoreUtil2::getContainerOfType(it, NablaModule)
			val otherSameVarRefs = module.eAllContents.filter(ArgOrVarRef).filter[x | x.target == target]
			if (otherSameVarRefs.exists[x | !x.timeIterators.empty])
				error(getTimeIteratorUsageMsg(), NablaPackage.Literals::ARG_OR_VAR_REF__TIME_ITERATORS, TIME_ITERATOR_USAGE)
		}
	}


	// ===== Functions (Reductions, Dimension) =====

	public static val ONLY_INT_AND_VAR_IN_FUNCTION_IN_TYPES = "SizeType::OnlyIntAndVarInFunctionInTypes"
	public static val ONLY_INT_AND_VAR_IN_REDUCTION_TYPE = "SizeType::OnlyIntAndVarInReductionType"
	public static val UNUSED_FUNCTION = "Functions::UnusedFunction"
	public static val UNUSED_REDUCTION = "Functions::UnusedReduction"
	public static val FUNCTION_INVALID_ARG_NUMBER = "Functions::InvalidArgNumber"
	public static val FUNCTION_INCOMPATIBLE_IN_TYPES = "Functions::FunctionIncompatibleInTypes"
	public static val FUNCTION_RETURN_TYPE = "Functions::FunctionReturnType"
	public static val REDUCTION_INCOMPATIBLE_TYPES = "Functions::ReductionIncompatibleTypes"

	static def getOnlyIntAndVarInFunctionInTypesMsg() { "In types must only contain int and variables" }
	static def getOnlyIntAndVarInReductionTypeMsg() { "Type must only contain int and variables" }
	static def getUnusedFunctionMsg() { "Unused function" }
	static def getUnusedReductionMsg() { "Unused reduction" }
	static def getFunctionInvalidArgNumberMsg() { "Number of arguments must be equal to number of input types" }
	static def getFunctionIncompatibleInTypesMsg() { "Declaration conflicts" }
	static def getFunctionReturnTypeMsg(String variableName) { "Only input type variables can be used for return types. Invalid variable: " + variableName }
	static def getReductionIncompatibleTypesMsg() { "Declaration conflicts" }

	@Check
	def checkOnlyIntAndVarInFunctionInTypes(Function it)
	{
		for (inType : inTypes)
			if (!inType.sizes.forall[x | x instanceof IntConstant || x instanceof ArgOrVarRef])
				error(getOnlyIntAndVarInFunctionInTypesMsg(), NablaPackage.Literals::FUNCTION__IN_TYPES, ONLY_INT_AND_VAR_IN_FUNCTION_IN_TYPES)
	}

	@Check
	def checkOnlyIntAndVarInReductionType(Reduction it)
	{
		if (!type.sizes.forall[x | x instanceof IntConstant || x instanceof ArgOrVarRef])
			error(getOnlyIntAndVarInReductionTypeMsg(), NablaPackage.Literals::REDUCTION__TYPE, ONLY_INT_AND_VAR_IN_REDUCTION_TYPE)
	}

	@Check
	def checkUnusedFunction(Function it)
	{
		val m = EcoreUtil2.getContainerOfType(it, NablaModule)
		val allCalls = m.eAllContents.filter(FunctionCall)
		val allCorrespondingDeclarations = allCalls.map[declaration]
		val referenced = allCorrespondingDeclarations.exists[x | x !== null && x.model===it]
		if (!referenced)
			warning(getUnusedFunctionMsg(), NablaPackage.Literals::FUNCTION_OR_REDUCTION__NAME, UNUSED_FUNCTION)
	}

	@Check
	def checkUnusedReduction(Reduction it)
	{
		val m = EcoreUtil2.getContainerOfType(it, NablaModule)
		val allCalls = m.eAllContents.filter(ReductionCall)
		val allCorrespondingDeclarations = allCalls.map[declaration]
		val referenced = allCorrespondingDeclarations.exists[x | x !== null && x.model===it]
		if (!referenced)
			warning(getUnusedReductionMsg(), NablaPackage.Literals::FUNCTION_OR_REDUCTION__NAME, UNUSED_REDUCTION)
	}

	@Check
	def checkFunctionIncompatibleInTypes(Function it)
	{
		if (!external && inTypes.size !== inArgs.size)
		{
			error(getFunctionInvalidArgNumberMsg(), NablaPackage.Literals::FUNCTION_OR_REDUCTION__IN_ARGS, FUNCTION_INVALID_ARG_NUMBER)
			return
		}

		val module = eContainer as NablaModule
		val otherFunctionArgs = module.functions.filter(Function).filter[x | x.name == name && x !== it]
		val conflictingFunctionArg = otherFunctionArgs.findFirst[x | !areCompatible(x, it)]
		if (conflictingFunctionArg !== null)
			error(getFunctionIncompatibleInTypesMsg(), NablaPackage.Literals::FUNCTION_OR_REDUCTION__NAME, FUNCTION_INCOMPATIBLE_IN_TYPES)
	}

	/** 
	 * Returns true if a and b can be declared together, false otherwise. 
	 * For example, false for R[2]->R and R[n]->R
	 */
	private def areCompatible(Function a, Function b)
	{
		if (a.inTypes.size != b.inTypes.size)
			return true

		for (i : 0..<a.inTypes.size)
			if (areCompatible(a.inTypes.get(i), b.inTypes.get(i)))
				return true

		return false
	}

	@Check
	def checkFunctionReturnType(Function it)
	{
		val inTypeVars = new HashSet<SimpleVar>
		for (inType : inTypes)
			for (dim : inType.eAllContents.filter(ArgOrVarRef).toIterable)
				if (dim.target !== null && !dim.target.eIsProxy && dim.target instanceof SimpleVar)
					inTypeVars += dim.target as SimpleVar

		val returnTypeVars = new HashSet<SimpleVar>
		for (dim : returnType.eAllContents.filter(ArgOrVarRef).toIterable)
			if (dim.target !== null && !dim.target.eIsProxy && dim.target instanceof SimpleVar)
				returnTypeVars += dim.target as SimpleVar

		val x = returnTypeVars.findFirst[x | !inTypeVars.contains(x)]
		if (x !== null)
			error(getFunctionReturnTypeMsg(x.name), NablaPackage.Literals::FUNCTION__RETURN_TYPE, FUNCTION_RETURN_TYPE)
	}

	@Check
	def checkReductionIncompatibleTypes(Reduction it)
	{
		val otherReductionArgs = eContainer.eAllContents.filter(Reduction).filter[x | x.name == name && x !== it]
		val conflictingReductionArg = otherReductionArgs.findFirst[x | !areCompatible(x.type, type)]
		if (conflictingReductionArg !== null)
			error(getReductionIncompatibleTypesMsg(), NablaPackage.Literals::REDUCTION__TYPE, REDUCTION_INCOMPATIBLE_TYPES)
	}

	private def areCompatible(BaseType a, BaseType b)
	{
		(a.primitive != b.primitive || a.sizes.size != b.sizes.size)
	}


	// ===== Connectivities =====

	public static val UNUSED_CONNECTIVITY = "Connectivities::UnusedConnectivity"
	public static val CONNECTIVITY_CALL_INDEX = "Connectivities::ConnectivityCallIndex"
	public static val CONNECTIVITY_CALL_TYPE = "Connectivities::ConnectivityCallType"
	public static val NOT_IN_INSTRUCTIONS = "Connectivities::NotInInstructions"
	public static val DIMENSION_ARG = "Connectivities::DimensionArg"

	static def getUnusedConnectivityMsg() { "Unused connectivity" }
	static def getConnectivityCallIndexMsg(int expectedSize, int actualSize) { "Wrong number of arguments: Expected " + expectedSize + ", but was " + actualSize }
	static def getConnectivityCallTypeMsg(String expectedType, String actualType) { "Wrong argument type: Expected " + expectedType + ', but was ' + actualType }
	static def getNotInInstructionsMsg() { "Local variables can only be scalar (no connectivity arrays)" }
	static def getDimensionArgMsg() { "Dimension 1 must be on connectivities taking no argument" }

	@Check
	def checkUnusedConnectivity(Connectivity it)
	{
		val m = EcoreUtil2.getContainerOfType(it, NablaModule)
		val referenced = m.eAllContents.filter(ConnectivityCall).exists[x|x.connectivity===it]
			|| m.eAllContents.filter(ConnectivityVar).exists[x|x.supports.contains(it)]
		if (!referenced)
			warning(getUnusedConnectivityMsg(), NablaPackage.Literals::CONNECTIVITY__NAME, UNUSED_CONNECTIVITY)
	}

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
	def checkNotInInstructions(ConnectivityVar it)
	{
		val varGroupDeclaration = eContainer
		if (varGroupDeclaration !== null && !(varGroupDeclaration.eContainer instanceof NablaModule))
			error(getNotInInstructionsMsg(), NablaPackage.Literals::ARG_OR_VAR__NAME, NOT_IN_INSTRUCTIONS)
	}

	@Check
	def checkDimensionArg(ConnectivityVar it)
	{
		if (supports.empty) return;

		if (!supports.head.inTypes.empty)
			error(getDimensionArgMsg(), NablaPackage.Literals::CONNECTIVITY_VAR__SUPPORTS, DIMENSION_ARG)
	}

	// ===== Instructions =====

	public static val AFFECTATION_CONST = "Instructions::AffectationConst"
	public static val SCALAR_VAR_DEFAULT_VALUE = "Instructions::ScalarVarDefaultValue"

	static def getAffectationConstMsg() { "Affectation to constant element" }
	static def getScalarVarDefaultValueMsg() { "Assignment with non constant variables" }

	@Check
	def checkAffectationVar(Affectation it)
	{
		if (left.target !== null && !left.target.eIsProxy && left.target.isConst)
			error(getAffectationConstMsg(), NablaPackage.Literals::AFFECTATION__LEFT, AFFECTATION_CONST)
	}

	@Check
	def checkScalarVarDefaultValue(SimpleVarDefinition it)
	{
		if (isConst && defaultValue!==null && defaultValue.eAllContents.filter(ArgOrVarRef).exists[x|!x.target.isConst])
			error(getScalarVarDefaultValueMsg(), NablaPackage.Literals::SIMPLE_VAR_DEFINITION__DEFAULT_VALUE, SCALAR_VAR_DEFAULT_VALUE)
	}

	// ===== Items =====

	public static val UNUSED_ITEM = "Items::UnusedItem"
	public static val SHIFT_VALIDITY = "Items::ShiftValidity"

	static def getUnusedItemMsg() { "Unused iterator" }
	static def getShiftValidityMsg() { "Shift only valid for an iteration on a connectivity set" }

	@Check
	def checkUnusedItem(Item it)
	{
		val m = EcoreUtil2.getContainerOfType(it, NablaModule)
		val referenced = m.eAllContents.filter(ConnectivityCall).exists[x|x.args.contains(it)]
			|| m.eAllContents.filter(ItemRef).exists[x|x.target === it]
		if (!referenced)
			warning(getUnusedItemMsg(), NablaPackage.Literals::ITEM__NAME, UNUSED_ITEM)
	}

	@Check
	def checkShiftValidity(ItemRef it)
	{
		if ((inc>0 || dec>0) && target !== null && !(target.eContainer instanceof SpaceIterator))
			error(getShiftValidityMsg(), NablaPackage.Literals::ITEM_REF__TARGET, SHIFT_VALIDITY)
	}
}