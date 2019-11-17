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
import fr.cea.nabla.ArgOrVarExtensions
import fr.cea.nabla.SpaceIteratorExtensions
import fr.cea.nabla.ir.MandatoryOptions
import fr.cea.nabla.ir.MandatoryVariables
import fr.cea.nabla.nabla.Affectation
import fr.cea.nabla.nabla.ArgOrVar
import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.ArgOrVarType
import fr.cea.nabla.nabla.Connectivity
import fr.cea.nabla.nabla.ConnectivityCall
import fr.cea.nabla.nabla.ConnectivityVar
import fr.cea.nabla.nabla.DimensionIndex
import fr.cea.nabla.nabla.DimensionInt
import fr.cea.nabla.nabla.DimensionOperation
import fr.cea.nabla.nabla.DimensionSymbol
import fr.cea.nabla.nabla.DimensionSymbolRef
import fr.cea.nabla.nabla.DimensionVar
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.InstructionBlock
import fr.cea.nabla.nabla.Iterable
import fr.cea.nabla.nabla.Job
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NablaPackage
import fr.cea.nabla.nabla.RangeSpaceIterator
import fr.cea.nabla.nabla.Reduction
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.Return
import fr.cea.nabla.nabla.SimpleVarDefinition
import fr.cea.nabla.nabla.SingletonSpaceIterator
import fr.cea.nabla.nabla.SpaceIterator
import fr.cea.nabla.nabla.SpaceIteratorRef
import fr.cea.nabla.nabla.Var
import fr.cea.nabla.nabla.VarGroupDeclaration
import fr.cea.nabla.typing.DeclarationProvider
import java.util.HashSet
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.scoping.IScopeProvider
import org.eclipse.xtext.util.SimpleAttributeResolver
import org.eclipse.xtext.validation.Check

import static extension fr.cea.nabla.Utils.*

class BasicValidator extends AbstractNablaValidator
{
	@Inject extension ArgOrVarExtensions
	@Inject extension SpaceIteratorExtensions
	@Inject extension DeclarationProvider
	@Inject IScopeProvider scopeProvider

	// ===== Unique Names ====

	public static val DUPLICATE_NAME = "DuplicateName"

	static def getDuplicateNameMsg(EClass objectClass, String objectName) { "Duplicate " + objectClass.name + ": " + objectName }

	@Check
	def void checkDuplicate(Var it) 
	{
		if (eContainer instanceof VarGroupDeclaration)
		{
			val variables = (eContainer as VarGroupDeclaration).variables
			val duplicate = variables.findFirst[x | x.name == name && x != it]
			if (duplicate !== null)
				error(getDuplicateNameMsg(NablaPackage.Literals.ARG_OR_VAR, duplicate.name), NablaPackage.Literals.ARG_OR_VAR__NAME);
		}
	}

	@Check
	def void checkDuplicate(ArgOrVar it) 
	{
		val scope = scopeProvider.getScope(it, NablaPackage.Literals.ARG_OR_VAR_REF__TARGET)
		val duplicated = scope.allElements.exists[x | x.name.lastSegment == name]
		if (duplicated)
			error(getDuplicateNameMsg(NablaPackage.Literals.ARG_OR_VAR, name), NablaPackage.Literals.ARG_OR_VAR__NAME);
	}

	@Check
	def void checkDuplicate(SpaceIterator it)
	{
		val scope = scopeProvider.getScope(it, NablaPackage.Literals.SPACE_ITERATOR_REF__TARGET)
		println('checkDuplicate(' + it + ') : ' + scope.allElements.map[name.segments.join('.')].join(', '))
		val duplicated = scope.allElements.exists[x | x.name.lastSegment == name]
		if (duplicated)
			error(getDuplicateNameMsg(NablaPackage.Literals.SPACE_ITERATOR, name), NablaPackage.Literals.SPACE_ITERATOR__NAME);
	}

	@Check
	def void checkDuplicate(DimensionSymbol it)
	{
		val scope = scopeProvider.getScope(it, NablaPackage.Literals.DIMENSION_SYMBOL_REF__TARGET)
		println('checkDuplicate(' + it + ') : ' + scope.allElements.map[name.lastSegment].join(', '))
		val duplicated = scope.allElements.exists[x | x.name.lastSegment == name]
		if (duplicated)
			error(getDuplicateNameMsg(NablaPackage.Literals.DIMENSION_SYMBOL, name), NablaPackage.Literals.DIMENSION_SYMBOL__NAME);
	}

	@Check
	def void checkDuplicate(Connectivity it) { checkDuplicates(NablaPackage.Literals.CONNECTIVITY__NAME) }

	@Check
	def void checkDuplicate(Job it) { checkDuplicates(NablaPackage.Literals.JOB__NAME) }

	private def <T extends EObject> checkDuplicates(T t, EStructuralFeature f)
	{
		val name = SimpleAttributeResolver.NAME_RESOLVER.apply(t)
		//println('checkDuplicates(' + t + ', ' + f.name + ', ' + all + ')')
		val module = EcoreUtil2.getContainerOfType(t, NablaModule)
		if (module !== null)
		{
			val contents = EcoreUtil2.getAllContentsOfType(module, t.class)
			for (tx : contents)
			{
				val tx_name = SimpleAttributeResolver.NAME_RESOLVER.apply(tx)
				if (tx_name.equals(name) && tx !== t)
					error(getDuplicateNameMsg(t.eClass, name), f);
			}
		}
	}

	// ===== Return Instruction ====

	public static val FORBIDDEN_RETURN = "Return::Forbidden"
	public static val MISSING_RETURN = "Return::Missing"
	public static val UNREACHABLE_CODE = "Return::UnreachableCode"

	static def getForbiddenReturnMsg() { "Return instruction not permitted in jobs" }
	static def getMissingReturnMsg() { "Function must end with a return instruction" }
	static def getUnreachableReturnMsg() { "Unreachable code" }

	@Check
	def checkForbiddenReturn(Return it)
	{
		val function = EcoreUtil2.getContainerOfType(it, Function)
		if (function === null)
			error(getForbiddenReturnMsg(), NablaPackage.Literals.RETURN__EXPRESSION, FORBIDDEN_RETURN)
	}

	@Check
	def checkMissingReturn(Function it)
	{
		if (external) return;

		val hasReturn = (body instanceof Return) || body.eAllContents.exists[x | x instanceof Return]
		if (!hasReturn)
			error(getMissingReturnMsg(), NablaPackage.Literals.FUNCTION__NAME, MISSING_RETURN)
	}

	@Check
	def checkUnreachableCode(Function it)
	{
		if (external) return;

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

	public static val MANDATORY_VARIABLE = "NablaModule::MandatoryVariable"
	public static val MANDATORY_OPTION = "NablaModule::MandatoryOption"
	public static val MODULE_NAME = "NablaModule::ModuleName"

	static def getMandatoryVariablesMsg(String[] missingVariables) { "Missing mandatory variable(s): " + missingVariables.join(", ") }
	static def getMandatoryOptionsMsg(String[] missingOptions) { "Missing mandatory option(s): " + missingOptions.join(", ") }
	static def getModuleNameMsg() { "Module name must start with an upper case" }

	@Check
	def checkMandatoryVariable(NablaModule it)
	{
		val vars = eAllContents.filter(Var).map[name].toList
		val missingVars = MandatoryVariables::NAMES.filter[x | !vars.contains(x)]
		if (missingVars.size > 0)
			error(getMandatoryVariablesMsg(missingVars), NablaPackage.Literals.NABLA_MODULE__NAME, MANDATORY_VARIABLE)
	}

	@Check
	def checkMandatoryOptions(NablaModule it)
	{
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


	// ===== ArgOrVarType =====
	
	public static val ARRAY_SIZES = "ArgOrVarType::ArraySizes"
	public static val ARRAY_DIMENSION = "ArgOrVarType::ArrayDimension"

	static def getArraySizesMsg() { "Must be greater or equal than 2" }
	static def getArrayDimensionMsg() { "Max 2 dimensions for arrays" }
	
	@Check
	def checkArraySizes(ArgOrVarType it)
	{
		for (i : 0..<sizes.size)
		{
			val size = sizes.get(i)
			if (size instanceof DimensionInt && (size as DimensionInt).value < 2)
				error(getArraySizesMsg(), NablaPackage.Literals.ARG_OR_VAR_TYPE__SIZES, i, ARRAY_SIZES)
		}
	}

	@Check
	def checkArrayDimension(ArgOrVarType it)
	{
		if (sizes.size > 2)
			error(getArrayDimensionMsg(), NablaPackage.Literals.ARG_OR_VAR_TYPE__SIZES, ARRAY_DIMENSION)
	}

	// ===== Variables : Var & VarRef =====

	public static val UNUSED_VARIABLE = "Variables::UnusedVariable"
	public static val INDICES_NUMBER = "Variables::IndicesNumber"
	public static val ITERATOR_NUMBER = "Variables::IteratorNumber"
	public static val ITERATOR_TYPE = "Variables::IteratorType"

	static def getUnusedVariableMsg() { "Unused variable" }
	static def getIndicesNumberMsg(int expectedSize, int actualSize) { "Wrong number of indices: Expected " + expectedSize + ", but was " + actualSize }
	static def getIteratorNumberMsg(int expectedSize, int actualSize) { "Wrong number of space iterators: Expected " + expectedSize + ", but was " + actualSize }
	static def getIteratorTypeMsg(String expectedTypeName, String actualTypeName) { "Wrong space iterator type: Expected " + expectedTypeName + ", but was " + actualTypeName }

	@Check
	def checkUnusedVariable(Var it)
	{
		val referenced = MandatoryVariables::NAMES.contains(name) || MandatoryOptions::NAMES.contains(name) || nablaModule.eAllContents.filter(ArgOrVarRef).exists[x|x.target===it]
		if (!referenced)
			warning(getUnusedVariableMsg(), NablaPackage.Literals::ARG_OR_VAR__NAME, UNUSED_VARIABLE)
	}

	@Check
	def checkIndicesNumber(ArgOrVarRef it)
	{
		if (target === null || target.eIsProxy) return
		val vTypeSize = target.dimension
		if (indices.size > 0 && indices.size != vTypeSize)
			error(getIndicesNumberMsg(vTypeSize, indices.size), NablaPackage.Literals::ARG_OR_VAR_REF__INDICES, INDICES_NUMBER)
	}

	@Check
	def checkIteratorNumberAndType(ArgOrVarRef it)
	{
		if (target instanceof ConnectivityVar)
		{
			val dimensions = (target as ConnectivityVar).supports

			if (spaceIterators.size >  0 && spaceIterators.size != dimensions.size)
				error(getIteratorNumberMsg(dimensions.size, spaceIterators.size), NablaPackage.Literals::ARG_OR_VAR_REF__SPACE_ITERATORS, ITERATOR_NUMBER)
			else
			{
				for (i : 0..<spaceIterators.length)
				{
					val spaceIteratorRefI = spaceIterators.get(i)
					val dimensionI = dimensions.get(i)
					val actualT = spaceIteratorRefI.target.type
					val expectedT = dimensionI.returnType.type
					if (actualT != expectedT)
						error(getIteratorTypeMsg(expectedT.name, actualT.name), NablaPackage.Literals::ARG_OR_VAR_REF__SPACE_ITERATORS, i, ITERATOR_TYPE)
				}
			}
		}
		else
		{
			if (!spaceIterators.empty)
				error(getIteratorNumberMsg(0, spaceIterators.size), NablaPackage.Literals::ARG_OR_VAR_REF__SPACE_ITERATORS, ITERATOR_NUMBER)
		}
	}

	// ===== Functions (Reductions, Dimension) =====

	public static val UNUSED_FUNCTION = "Functions::UnusedFunction"
	public static val UNUSED_REDUCTION = "Functions::UnusedReduction"
	public static val FUNCTION_INVALID_ARG_NUMBER = "Functions::InvalidArgNumber"
	public static val FUNCTION_IN_TYPES_OPERATION = "Functions::FunctionInTypesOperation"
	public static val FUNCTION_INCOMPATIBLE_IN_TYPES = "Functions::FunctionIncompatibleInTypes"
	public static val FUNCTION_RETURN_TYPE = "Functions::FunctionReturnType"
	public static val REDUCTION_COLLECTION_TYPE_OPERATION = "Functions::ReductionCollectionTypeOperation"
	public static val REDUCTION_INCOMPATIBLE_COLLECTION_TYPE = "Functions::ReductionIncompatibleCollectionType"
	public static val REDUCTION_RETURN_TYPE = "Functions::ReductionReturnType"
	public static val DIMENSION_VAR_NAME = "Functions::DimensionVarName"
	public static val UNUSED_DIMENSION_VAR = "Functions::UnusedDimensionVar"

	static def getUnusedFunctionMsg() { "Unused function" }
	static def getUnusedReductionMsg() { "Unused reduction" }
	static def getFunctionInvalidArgNumberMsg() { "Number of arguments must be equal to number of input types" }
	static def getFunctionInTypesOperationMsg() { "In types must not contain operations" }
	static def getFunctionIncompatibleInTypesMsg() { "Declaration conflicts" }
	static def getFunctionReturnTypeMsg(String variableName) { "Only input type variables can be used for return types. Invalid variable: " + variableName }
	static def getReductionCollectionTypeOperationMsg() { "Collection type must not contain operations" }
	static def getReductionIncompatibleCollectionTypeMsg() { "Declaration conflicts" }
	static def getReductionReturnTypeMsg(String variableName) { "Only collection type variables can be used for return types. Invalid variable: " + variableName }
	static def getDimensionVarNameMsg() { "Invalid name (reserved for time step)" }
	static def getUnusedDimensionVarMsg() { "Unused variable" }

	@Check
	def checkUnusedFunction(Function it)
	{
		val allCalls = nablaModule.eAllContents.filter(FunctionCall)
		val allCorrespondingDeclarations = allCalls.map[declaration]
		val referenced = allCorrespondingDeclarations.exists[x | x !== null && x.model===it]
		if (!referenced)
			warning(getUnusedFunctionMsg(), NablaPackage.Literals::FUNCTION__NAME, UNUSED_FUNCTION)
	}

	@Check
	def checkUnusedReduction(Reduction it)
	{
		val allCalls = nablaModule.eAllContents.filter(ReductionCall)
		val allCorrespondingDeclarations = allCalls.map[declaration]
		val referenced = allCorrespondingDeclarations.exists[x | x !== null && x.model===it]
		if (!referenced)
			warning(getUnusedReductionMsg(), NablaPackage.Literals::REDUCTION__NAME, UNUSED_REDUCTION)
	}

	@Check
	def checkFunctionInTypes(Function it)
	{
		if (!external && inTypes.size !== inArgs.size)
		{
			error(getFunctionInvalidArgNumberMsg(), NablaPackage.Literals::FUNCTION__IN_ARGS, FUNCTION_INVALID_ARG_NUMBER)
			return
		}

		for (inType : inTypes)
			if (inType.eAllContents.filter(DimensionOperation).size > 0)
				error(getFunctionInTypesOperationMsg(), NablaPackage.Literals::FUNCTION__IN_TYPES, FUNCTION_IN_TYPES_OPERATION)

		val module = eContainer as NablaModule
		val otherFunctionArgs = module.functions.filter(Function).filter[x | x.name == name && x !== it]
		val conflictingFunctionArg = otherFunctionArgs.findFirst[x | !areCompatible(x, it)]
		if (conflictingFunctionArg !== null)
			error(getFunctionIncompatibleInTypesMsg(), NablaPackage.Literals::FUNCTION__NAME, FUNCTION_INCOMPATIBLE_IN_TYPES)
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
		val inTypeVars = new HashSet<DimensionVar>
		for (inType : inTypes)
			for (dim : inType.eAllContents.filter(DimensionSymbolRef).toIterable)
				if (dim.target !== null && !dim.target.eIsProxy && dim.target instanceof DimensionVar)
					inTypeVars += dim.target as DimensionVar

		val returnTypeVars = new HashSet<DimensionVar>
		for (dim : returnType.eAllContents.filter(DimensionSymbolRef).toIterable)
			if (dim.target !== null && !dim.target.eIsProxy && dim.target instanceof DimensionVar)
				returnTypeVars += dim.target as DimensionVar

		val x = returnTypeVars.findFirst[x | !inTypeVars.contains(x)]
		if (x !== null)
			error(getFunctionReturnTypeMsg(x.name), NablaPackage.Literals::FUNCTION__RETURN_TYPE, FUNCTION_RETURN_TYPE)
	}

	@Check
	def checkReductionCollectionType(Reduction it)
	{
		if (collectionType.eAllContents.filter(DimensionOperation).size > 0)
			error(getReductionCollectionTypeOperationMsg(), NablaPackage.Literals::REDUCTION__COLLECTION_TYPE, REDUCTION_COLLECTION_TYPE_OPERATION)

		val otherReductionArgs = eContainer.eAllContents.filter(Reduction).filter[x | x.name == name && x !== it]
		val conflictingReductionArg = otherReductionArgs.findFirst[x | !areCompatible(x.collectionType, collectionType)]
		if (conflictingReductionArg !== null)
			error(getReductionIncompatibleCollectionTypeMsg(), NablaPackage.Literals::REDUCTION__COLLECTION_TYPE, REDUCTION_INCOMPATIBLE_COLLECTION_TYPE)
	}

	private def areCompatible(ArgOrVarType a, ArgOrVarType b)
	{
		(a.primitive != b.primitive || a.sizes.size != b.sizes.size)
	}

	@Check
	def checkReductionReturnType(Reduction it)
	{	
		// return type should reference only known variables
		val inTypeVars = new HashSet<DimensionVar>
		for (dim : collectionType.eAllContents.filter(DimensionSymbolRef).toIterable)
			if (dim.target !== null && !dim.target.eIsProxy && dim.target instanceof DimensionVar)
				inTypeVars += dim.target as DimensionVar

		val returnTypeVars = new HashSet<DimensionVar>
		for (dim : returnType.eAllContents.filter(DimensionSymbolRef).toIterable)
			if (dim.target !== null && !dim.target.eIsProxy && dim.target instanceof DimensionVar)
				returnTypeVars += dim.target as DimensionVar

		val x = returnTypeVars.findFirst[x | !inTypeVars.contains(x)]
		if (x !== null)
			error(getReductionReturnTypeMsg(x.name), NablaPackage.Literals::REDUCTION__RETURN_TYPE, REDUCTION_RETURN_TYPE)
	}

	@Check
	def checkDimensionVarName(DimensionVar it)
	{
		if (name == 'n')
			error(getDimensionVarNameMsg(), NablaPackage.Literals::DIMENSION_SYMBOL__NAME, DIMENSION_VAR_NAME)
	}

	@Check
	def checkUnusedDimensionVar(DimensionVar it)
	{
		val varRefs = eContainer.eAllContents.filter(DimensionSymbolRef).map[target].toSet
		if (!varRefs.contains(it))
			warning(getUnusedDimensionVarMsg(), NablaPackage.Literals::DIMENSION_SYMBOL__NAME, UNUSED_DIMENSION_VAR)
	}

	// ===== Connectivities =====

	public static val UNUSED_CONNECTIVITY = "Connectivities::UnusedConnectivity"
	public static val CONNECTIVITY_CALL_INDEX = "Connectivities::ConnectivityCallIndex"
	public static val CONNECTIVITY_CALL_TYPE = "Connectivities::ConnectivityCallType"
	public static val NOT_IN_INSTRUCTIONS = "Connectivities::NotInInstructions"
	public static val DIMENSION_MULTIPLE = "Connectivities::DimensionMultiple"
	public static val DIMENSION_ARG = "Connectivities::DimensionArg"

	static def getUnusedConnectivityMsg() { "Unused connectivity" }
	static def getConnectivityCallIndexMsg(int expectedSize, int actualSize) { "Wrong number of arguments: Expected " + expectedSize + ", but was " + actualSize }
	static def getConnectivityCallTypeMsg(String expectedType, String actualType) { "Wrong argument type: Expected " + expectedType + ', but was ' + actualType }
	static def getNotInInstructionsMsg() { "Local variables can only be scalar (no connectivity arrays)" }
	static def getDimensionMultipleMsg() { "Dimension must be on connectivities returning a set of items" }
	static def getDimensionArgMsg() { "Dimension 1 must be on connectivities taking no argument" }

	@Check
	def checkUnusedConnectivity(Connectivity it)
	{
		val referenced = nablaModule.eAllContents.filter(ConnectivityCall).exists[x|x.connectivity===it]
			|| nablaModule.eAllContents.filter(ConnectivityVar).exists[x|x.supports.contains(it)]
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
	def checkDimensionMultipleAndArg(ConnectivityVar it)
	{
		if (supports.empty) return;

		if (!supports.exists[d | d.returnType.multiple])
				error(getDimensionMultipleMsg(), NablaPackage.Literals::CONNECTIVITY_VAR__SUPPORTS, DIMENSION_MULTIPLE)

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

	// ===== Iterators && Dimension indices =====

	public static val UNUSED_ITERATOR = "Iterators::UnusedIterator"
	public static val UNUSED_DIMENSION_INDEX = "Iterators::UnusedDimensionIndex"
	public static val RANGE_RETURN_TYPE = "Iterators::RangeReturnType"
	public static val SINGLETON_RETURN_TYPE = "Iterators::SingletonReturnType"
	public static val SHIFT_VALIDITY = "Iterators::ShiftValidity"

	static def getUnusedIteratorMsg() { "Unused iterator" }
	static def getUnusedDimensionIndexMsg() { "Unused index" }
	static def getRangeReturnTypeMsg() { "Connectivity return type must be a collection" }
	static def getSingletonReturnTypeMsg() { "Connectivity return type must be a singleton" }
	static def getShiftValidityMsg() { "Shift only valid on a range iterator" }

	@Check
	def checkUnusedIterator(SpaceIterator it)
	{
		val iterable = EcoreUtil2.getContainerOfType(it, Iterable)
		val referenced = iterable.eAllContents.filter(SpaceIteratorRef).exists[x|x.target===it]
		if (!referenced)
			warning(getUnusedIteratorMsg(), NablaPackage.Literals::SPACE_ITERATOR__NAME, UNUSED_ITERATOR)
	}

	@Check
	def checkUnusedIterator(DimensionIndex it)
	{
		val iterable = EcoreUtil2.getContainerOfType(it, Iterable)
		val referenced = iterable.eAllContents.filter(DimensionSymbolRef).exists[x|x.target===it]
		if (!referenced)
			warning(getUnusedDimensionIndexMsg(), NablaPackage.Literals::DIMENSION_SYMBOL__NAME, UNUSED_DIMENSION_INDEX)
	}

	@Check
	def checkRangeReturnType(RangeSpaceIterator it)
	{
		if (!container.connectivity.returnType.multiple)
			error(getRangeReturnTypeMsg(), NablaPackage.Literals::SPACE_ITERATOR__CONTAINER, RANGE_RETURN_TYPE)
	}

	@Check
	def checkSingletonReturnType(SingletonSpaceIterator it)
	{
		if (container.connectivity.returnType.multiple)
			error(getSingletonReturnTypeMsg(), NablaPackage.Literals::SPACE_ITERATOR__CONTAINER, SINGLETON_RETURN_TYPE)
	}

	@Check
	def checkIncAndDecValidity(SpaceIteratorRef it)
	{
		if ((inc>0 || dec>0) && target !== null && target instanceof SingletonSpaceIterator)
			error(getShiftValidityMsg(), NablaPackage.Literals::SPACE_ITERATOR_REF__TARGET, SHIFT_VALIDITY)
	}
}