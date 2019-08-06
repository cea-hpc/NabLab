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
import fr.cea.nabla.MandatoryOptions
import fr.cea.nabla.SpaceIteratorExtensions
import fr.cea.nabla.VarExtensions
import fr.cea.nabla.nabla.Affectation
import fr.cea.nabla.nabla.BaseType
import fr.cea.nabla.nabla.Connectivity
import fr.cea.nabla.nabla.ConnectivityCall
import fr.cea.nabla.nabla.ConnectivityVar
import fr.cea.nabla.nabla.DimensionOperation
import fr.cea.nabla.nabla.DimensionVar
import fr.cea.nabla.nabla.DimensionVarReference
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.FunctionArg
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NablaPackage
import fr.cea.nabla.nabla.PrimitiveType
import fr.cea.nabla.nabla.RangeSpaceIterator
import fr.cea.nabla.nabla.Reduction
import fr.cea.nabla.nabla.ReductionArg
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.ScalarVarDefinition
import fr.cea.nabla.nabla.SingletonSpaceIterator
import fr.cea.nabla.nabla.SpaceIterator
import fr.cea.nabla.nabla.SpaceIteratorRef
import fr.cea.nabla.nabla.Var
import fr.cea.nabla.nabla.VarGroupDeclaration
import fr.cea.nabla.nabla.VarRef
import java.util.HashSet
import org.eclipse.xtext.validation.Check

import static extension fr.cea.nabla.Utils.*

class BasicValidator  extends AbstractNablaValidator
{
	@Inject extension VarExtensions
	@Inject extension SpaceIteratorExtensions

	// ===== NablaModule =====	
	public static val COORD_VARIABLE = "NablaModule::CoordVariable"
	public static val MANDATORY_OPTION = "NablaModule::MandatoryOption"
	public static val MODULE_NAME = "NablaModule::ModuleName"

	static def getCoordVariableMsg() { "Module must contain a node variable named '" + MandatoryOptions::COORD + "' to store node coordinates" }
	static def getMandatoryOption(String[] missingOptions) { "Missing mandatory option(s): " + missingOptions.join(", ") }
	static def getModuleNameMsg() { "Module name must start with an upper case" }
	
	@Check
	def checkCoordVariable(NablaModule it)
	{
		if (!variables.filter(VarGroupDeclaration).exists[g | g.variables.exists[v|v.name == MandatoryOptions::COORD]])
			warning(getCoordVariableMsg(), NablaPackage.Literals.NABLA_MODULE__NAME, COORD_VARIABLE)
	}
	
	@Check
	def checkMandatoryOptions(NablaModule it)
	{
		val scalarConsts = variables.filter(ScalarVarDefinition).filter[const].map[variable.name].toList
		val missingConsts = MandatoryOptions::OPTION_NAMES.filter[x | !scalarConsts.contains(x)]
		if (missingConsts.size > 0)
			error(getMandatoryOption(missingConsts), NablaPackage.Literals.NABLA_MODULE__VARIABLES, MANDATORY_OPTION)			
	}

	@Check
	def checkName(NablaModule it)
	{
		if (!name.nullOrEmpty && Character::isLowerCase(name.charAt(0)))
			error(getModuleNameMsg(), NablaPackage.Literals.NABLA_MODULE__NAME, MODULE_NAME)
	}


	// ===== BaseType =====	
	public static val TYPE_DIMENSION = "BaseType::TypeDimension"

	static def getTypeDimensionMsg() { "Dimensions must be greater or equal than 2" }
	
	@Check
	def checkTypeDimension(BaseType it)
	{
		if (!sizes.empty && sizes.exists[x | x<2])
			error(getTypeDimensionMsg(), NablaPackage.Literals.BASE_TYPE__SIZES, TYPE_DIMENSION)
	}

	// ===== Constant expressions =====	
//	public static val ONLY_REAL_ARRAY_CONST = "Constant::OnlyRealArrayConst"
//	
//	static def getOnlyRealArrayConstMsg() { "This initialization is only possible on real arrays" }
//	
	//TODO : CheckOnlyRealArrayConst ?
//	@Check
//	def checkOnlyRealArrayConst(BaseTypeConstant it)
//	{
//		if (type.root != PrimitiveType::REAL || type.sizes.empty)
//			error(getOnlyRealArrayConstMsg(), NablaPackage.Literals.BASE_TYPE_CONSTANT__TYPE, ONLY_REAL_ARRAY_CONST)
//	}


	// ===== Variables : Var & VarRef =====	
	public static val UNUSED_VARIABLE = "Variables::UnusedVariable"
	public static val INDICES_NUMBER = "Variables::IndicesNumber"
	public static val ITERATOR_NUMBER = "Variables::IteratorNumber"
	public static val ITERATOR_TYPE = "Variables::IteratorType"
	
	static def getUnusedVariableMsg() { "Unused variable" }
	static def getIndicesNumberMsg(int expectedSize, int actualSize) { "Wrong number of indices: Expected " + expectedSize + ", but was " + actualSize }
	static def getIteratorNumberMsg(int expectedSize, int actualSize) { "Wrong number of iterators: Expected " + expectedSize + ", but was " + actualSize }
	static def getIteratorTypeMsg(String expectedTypeName, String actualTypeName) { "Wrong iterator type: Expected " + expectedTypeName + ", but was " + actualTypeName }

	@Check
	def checkUnusedVariable(Var it)
	{
		val referenced = MandatoryOptions::OPTION_NAMES.contains(name) || nablaModule.eAllContents.filter(VarRef).exists[x|x.variable===it]
		if (!referenced)
			warning(getUnusedVariableMsg(), NablaPackage.Literals::VAR__NAME, UNUSED_VARIABLE)
	}

	@Check
	def checkIndicesNumber(VarRef it)
	{
		val vTypeSizes = variable.baseType.sizes
		if (indices.size > 0 && indices.size != vTypeSizes.size)
			error(getIndicesNumberMsg(vTypeSizes.size, indices.size), NablaPackage.Literals::VAR_REF__SPACE_ITERATORS, INDICES_NUMBER)
	}
	
	@Check
	def checkIteratorNumberAndType(VarRef it)
	{
		if (variable instanceof ConnectivityVar)
		{
			val dimensions = (variable as ConnectivityVar).dimensions
			
			if (dimensions.size > 0 && spaceIterators.empty)
				if (indices.size > 0)
					error(getIndicesNumberMsg(0, indices.size), NablaPackage.Literals::VAR_REF__SPACE_ITERATORS, INDICES_NUMBER)

			if (spaceIterators.size > 0 && dimensions.size != spaceIterators.size)
				error(getIteratorNumberMsg(dimensions.size, spaceIterators.size), NablaPackage.Literals::VAR_REF__SPACE_ITERATORS, ITERATOR_NUMBER)
			else
			{
				for (i : 0..<spaceIterators.length)
				{
					val spaceIteratorRefI = spaceIterators.get(i)
					val dimensionI = dimensions.get(i)
					val actualT = spaceIteratorRefI.target.type
					val expectedT = dimensionI.returnType.type
					if (actualT != expectedT)
						error(getIteratorTypeMsg(expectedT.name, actualT.name), NablaPackage.Literals::VAR_REF__SPACE_ITERATORS, i, ITERATOR_TYPE)
				}
			}
		}
	}	

	// ===== Functions (Reductions, Dimension) =====	
	public static val UNUSED_FUNCTION = "Functions::UnusedFunction"
	public static val UNUSED_REDUCTION = "Functions::UnusedReduction"
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
	static def getFunctionInTypesOperationMsg() { "In types must not contain operations" }
	static def getFunctionIncompatibleInTypesMsg() { "Declaration conflicts" }
	static def getFunctionReturnTypeMsg(String variableName) { "Only input type variables can be used for return types. Invalid variable: " + variableName }
	static def getReductionCollectionTypeOperationMsg() { "Collection type must not contain operations" }
	static def getReductionIncompatibleCollectionTypeMsg() { "Declaration conflicts" }
	static def getReductionReturnTypeMsg(String variableName) { "Only collection type variables can be used for return types. Invalid variable: " + variableName }
	static def getDimensionVarNameMsg() { "Invalid name (reserved for time step)" }
	static def getUnusedDimensionVar() { "Unused variable" }
	
	@Check
	def checkUnusedFunction(Function it)
	{
		val referenced = nablaModule.eAllContents.filter(FunctionCall).exists[x|x.function===it]
		if (!referenced)
			warning(getUnusedFunctionMsg(), NablaPackage.Literals::FUNCTION__NAME, UNUSED_FUNCTION)
	}	
	
	@Check
	def checkUnusedReduction(Reduction it)
	{
		val referenced = nablaModule.eAllContents.filter(ReductionCall).exists[x|x.reduction===it]
		if (!referenced)
			warning(getUnusedReductionMsg(), NablaPackage.Literals::REDUCTION__NAME, UNUSED_REDUCTION)
	}	

	@Check
	def checkFunctionInTypes(FunctionArg it)
	{
		for (inType : inTypes)
			if (inType.dimensions.filter(DimensionOperation).size > 0)
				error(getFunctionInTypesOperationMsg(), NablaPackage.Literals::FUNCTION_ARG__IN_TYPES, FUNCTION_IN_TYPES_OPERATION)
				
		val otherFunctionArgs = eContainer.eAllContents.filter(FunctionArg).filter[x | x !== it]
		val conflictingFunctionArg = otherFunctionArgs.findFirst[x | !areCompatible(x, it)]
		if (conflictingFunctionArg !== null)
			error(getFunctionIncompatibleInTypesMsg(), NablaPackage.Literals::FUNCTION_ARG__IN_TYPES, FUNCTION_INCOMPATIBLE_IN_TYPES)
	}

	/** 
	 * Returns true if a and b can be declared together, false otherwise. 
	 * For example, false for R[2]->R and R[n]->R
	 */
	private def areCompatible(FunctionArg a, FunctionArg b)
	{
		if (a.inTypes.size != b.inTypes.size) 
			return true
			
		for (i : 0..<a.inTypes.size)
		{
			val ai = a.inTypes.get(i)
			val bi = b.inTypes.get(i)
			if (ai.root != bi.root || ai.dimensions.size != bi.dimensions.size) 
				return true
		}
		
		return false
	}
	
	@Check
	def checkFunctionReturnType(FunctionArg it)
	{
		val inTypeVars = new HashSet<DimensionVar>
		for (inType : inTypes)
			for (dim : inType.dimensions.filter(DimensionVarReference))
				inTypeVars += dim.target

		val returnTypeVars = new HashSet<DimensionVar>		
		for (dim : returnType.dimensions.filter(DimensionVarReference))
			returnTypeVars += dim.target
		
		val x = returnTypeVars.findFirst[x | !inTypeVars.contains(x)]
		//TODO When x is not declared (x instance of eProxy) -> x.name = null
		if (x !== null)
			error(getFunctionReturnTypeMsg(x.name), NablaPackage.Literals::FUNCTION_ARG__RETURN_TYPE, FUNCTION_RETURN_TYPE)
	}

	@Check
	def checkReductionCollectionType(ReductionArg it)
	{
		if (collectionType.dimensions.filter(DimensionOperation).size > 0)
			error(getReductionCollectionTypeOperationMsg(), NablaPackage.Literals::REDUCTION_ARG__COLLECTION_TYPE, REDUCTION_COLLECTION_TYPE_OPERATION)

		val otherReductionArgs = eContainer.eAllContents.filter(ReductionArg).filter[x | x !== it]
		val conflictingReductionArg = otherReductionArgs.findFirst[x | !areCompatible(x, it)]
		if (conflictingReductionArg !== null)
			error(getReductionIncompatibleCollectionTypeMsg(), NablaPackage.Literals::REDUCTION_ARG__COLLECTION_TYPE, REDUCTION_INCOMPATIBLE_COLLECTION_TYPE)
	}
	
	private def areCompatible(ReductionArg a, ReductionArg b)
	{
		(a.collectionType.root != b.collectionType.root || a.collectionType.dimensions.size != b.collectionType.dimensions.size) 
	}

	@Check
	def checkReductionReturnType(ReductionArg it)
	{	
		// return type should reference only known variables
		val inTypeVars = new HashSet<DimensionVar>
		for (dim : collectionType.dimensions.filter(DimensionVarReference))
			inTypeVars += dim.target

		val returnTypeVars = new HashSet<DimensionVar>		
		for (dim : returnType.dimensions.filter(DimensionVarReference))
			returnTypeVars += dim.target
		
		val x = returnTypeVars.findFirst[x | !inTypeVars.contains(x)]
		if (x !== null)
			error(getReductionReturnTypeMsg(x.name), NablaPackage.Literals::REDUCTION_ARG__RETURN_TYPE, REDUCTION_RETURN_TYPE)
	}

	@Check
	def checkDimensionVarName(DimensionVar it)
	{
		if (name == 'n')
			error(getDimensionVarNameMsg(), NablaPackage.Literals::DIMENSION_VAR__NAME, DIMENSION_VAR_NAME)
	}
	
	@Check
	def checkUnusedDimensionVar(DimensionVar it)
	{
		val varRefs = eContainer.eAllContents.filter(DimensionVarReference).map[target].toSet
		if (!varRefs.contains(it))
			warning(getUnusedDimensionVar(), NablaPackage.Literals::DIMENSION_VAR__NAME, UNUSED_DIMENSION_VAR)
	}


	// ===== Connectivities =====	
	public static val UNUSED_CONNECTIVITY = "Connectivities::UnusedConnectivity"
	public static val CONNECTIVITY_CALL_INDEX = "Connectivities::ConnectivityCallIndex"
	public static val CONNECTIVITY_CALL_TYPE = "Connectivities::ConnectivityCallType"
	public static val NOT_IN_INSTRUCTIONS = "Connectivities::NotInInstructions"
	public static val DIMENSION_MULTIPLE = "Connectivities::DimensionMultiple"
	public static val DIMENSION_ARG = "Connectivities::DimensionArg"
	public static val ONLY_REAL_ARRAY = "BaseType::OnlyRealArray"
	
	static def getUnusedConnectivityMsg() { "Unused connectivity" }
	static def getConnectivityCallIndexMsg(int expectedSize, int actualSize) { "Wrong number of arguments: Expected " + expectedSize + ", but was " + actualSize }
	static def getConnectivityCallTypeMsg(String expectedType, String actualType) { "Wrong argument type: Expected " + expectedType + ', but was ' + actualType }
	static def getNotInInstructionsMsg() { "Local variables can only be scalar (no connectivity arrays)" }
	static def getDimensionMultipleMsg() { "Dimension must be on connectivities returning a set of items" }
	static def getDimensionArgMsg() { "Dimension 1 must be on connectivities taking no argument" }
	static def getOnlyRealArrayMsg() { "Vector and matrix only available for " +  PrimitiveType::REAL.literal }
	
	@Check
	def checkUnusedConnectivity(Connectivity it)
	{
		val referenced = nablaModule.eAllContents.filter(ConnectivityCall).exists[x|x.connectivity===it]
			|| nablaModule.eAllContents.filter(ConnectivityVar).exists[x|x.dimensions.contains(it)]
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
			error(getNotInInstructionsMsg(), NablaPackage.Literals::VAR__NAME, NOT_IN_INSTRUCTIONS)
	}

	@Check
	def checkDimensionMultipleAndArg(ConnectivityVar it)
	{
		if (dimensions.empty) return;

		if (!dimensions.exists[d | d.returnType.multiple])
				error(getDimensionMultipleMsg(), NablaPackage.Literals::CONNECTIVITY_VAR__DIMENSIONS, DIMENSION_MULTIPLE)

		if (!dimensions.head.inTypes.empty)
			error(getDimensionArgMsg(), NablaPackage.Literals::CONNECTIVITY_VAR__DIMENSIONS, DIMENSION_ARG)
		
//		for (i : 1..<dimensions.length)
//		{
//			if (dimensions.get(i).inTypes.length != 1)
//				error('Dimension 2..N must be on connectivities with 1 argument', NablaPackage.Literals::ARRAY_VAR__DIMENSIONS, i)
//			else if (dimensions.get(i).inTypes.head != dimensions.get(i-1).returnType.type)
//				error('Dimension ' + (i+1) + ' argument must have same type as dimension ' + i + ' return type', NablaPackage.Literals::ARRAY_VAR__DIMENSIONS, i)
//		}
	}

	@Check
	def checkOnlyRealArray(ConnectivityVar it)
	{
		if (baseType.root != PrimitiveType::REAL && connectivityMatrix)
			error(getOnlyRealArrayMsg(), NablaPackage.Literals::VAR__NAME, ONLY_REAL_ARRAY)
	}


	// ===== Instructions =====
	public static val AFFECTATION_VAR = "Instructions::AffectationVar"
	public static val SCALAR_VAR_DEFAULT_VALUE = "Instructions::ScalarVarDefaultValue"
	
	static def getAffectationVarMsg() { "Affectation to constant variable" }
	static def getScalarVarDefaultValueMsg() { "Assignment with non constant variables" }
	
	@Check
	def checkAffectationVar(Affectation it)
	{
		if (varRef.variable.isConst && (varRef.variable.eContainer instanceof NablaModule))
			error(getAffectationVarMsg(), NablaPackage.Literals::AFFECTATION__VAR_REF, AFFECTATION_VAR)
	}
	
	@Check
	def checkScalarVarDefaultValue(ScalarVarDefinition it)
	{
		if (isConst && defaultValue!==null && defaultValue.eAllContents.filter(VarRef).exists[x|!x.variable.isConst])
			error(getScalarVarDefaultValueMsg(), NablaPackage.Literals::SCALAR_VAR_DEFINITION__DEFAULT_VALUE, SCALAR_VAR_DEFAULT_VALUE)
	}
	

	// ===== Iterators =====
	public static val UNUSED_ITERATOR = "Iterators::UnusedIterator"
	public static val RANGE_RETURN_TYPE = "Iterators::RangeReturnType"
	public static val SINGLETON_RETURN_TYPE = "Iterators::SingletonReturnType"
	public static val SHIFT_VALIDITY = "Iterators::ShiftValidity"
	
	static def getUnusedIteratorMsg() { "Unused iterator" }
	static def getRangeReturnTypeMsg() { "Connectivity return type must be a collection" }
	static def getSingletonReturnTypeMsg() { "Connectivity return type must be a singleton" }
	static def getShiftValidityMsg() { "Shift only valid on a range iterator" }
	
	@Check
	def checkUnusedIterator(SpaceIterator it)
	{
		val referenced = eContainer.eAllContents.filter(SpaceIteratorRef).exists[x|x.target===it]
		if (!referenced)
			warning(getUnusedIteratorMsg(), NablaPackage.Literals::SPACE_ITERATOR__NAME, UNUSED_ITERATOR)
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