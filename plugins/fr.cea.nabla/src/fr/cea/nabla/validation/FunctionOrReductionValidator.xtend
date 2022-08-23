/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.validation

import com.google.inject.Inject
import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.BaseType
import fr.cea.nabla.nabla.Exit
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.FunctionOrReduction
import fr.cea.nabla.nabla.FunctionReturnTypeDeclaration
import fr.cea.nabla.nabla.If
import fr.cea.nabla.nabla.Instruction
import fr.cea.nabla.nabla.InstructionBlock
import fr.cea.nabla.nabla.IntConstant
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NablaPackage
import fr.cea.nabla.nabla.Reduction
import fr.cea.nabla.nabla.Return
import fr.cea.nabla.nabla.SimpleVar
import fr.cea.nabla.typing.BaseTypeTypeProvider
import fr.cea.nabla.typing.ExpressionTypeProvider
import fr.cea.nabla.typing.NSTScalar
import java.util.HashSet
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.validation.CheckType
import fr.cea.nabla.nabla.FunctionInTypeDeclaration
import java.util.List

class FunctionOrReductionValidator extends BasicValidator
{
	@Inject extension ValidationUtils
	@Inject extension BaseTypeTypeProvider
	@Inject extension ExpressionTypeProvider

	public static val EMPTY_BODY = "Functions::EmptyBody"
	public static val FORBIDDEN_RETURN = "Functions::Forbidden"
	public static val MISSING_RETURN = "Functions::Missing"
	public static val UNREACHABLE_CODE = "Functions::UnreachableCode"
	public static val ONLY_INT_AND_VAR_IN_FUNCTION_IN_TYPES = "Functions::OnlyIntAndVarInFunctionInTypes"
	public static val ONLY_INT_AND_VAR_IN_REDUCTION_TYPE = "Functions::OnlyIntAndVarInReductionType"
	public static val FUNCTION_INVALID_ARG_NUMBER = "Functions::InvalidArgNumber"
	public static val FUNCTION_INCOMPATIBLE_IN_TYPES = "Functions::FunctionIncompatibleInTypes"
	public static val FUNCTION_RETURN_TYPE = "Functions::FunctionReturnTypeDeclaration"
	public static val FUNCTION_RETURN_TYPE_VAR = "Functions::FunctionReturnTypeDeclarationVar"
	public static val REDUCTION_INCOMPATIBLE_TYPES = "Functions::ReductionIncompatibleTypes"
	public static val REDUCTION_SEED_TYPE = "Functions::ReductionSeedType"
	public static val REDUCTION_TYPES_COMPATIBILITY = "Functions::ReductionTypesCompatibility"

	static def getEmptyBodyMsg() { "Extern functions (with no body) not allowed in modules, create an extension" }
	static def getForbiddenReturnMsg() { "Return instruction only allowed in functions" }
	static def getMissingReturnMsg() { "Function/Reduction must end with a return instruction" }
	static def getUnreachableReturnMsg() { "Unreachable code" }
	static def getOnlyIntAndVarInFunctionInTypesMsg(String[] allowedVarNames) { buildMsg("In types", allowedVarNames) }
	static def getOnlyIntAndVarInReductionTypeMsg(String[] allowedVarNames) { buildMsg("Type", allowedVarNames) }
	static def getFunctionInvalidArgNumberMsg() { "Number of arguments must be equal to number of input types" }
	static def getFunctionIncompatibleInTypesMsg() { "Declaration conflicts" }
	static def getFunctionReturnTypeDeclarationVarMsg(String variableName) { "Only input type variables can be used for return types. Invalid variable: " + variableName }
	static def getReductionIncompatibleTypesMsg() { "Declaration conflicts" }
	static def getReductionSeedTypeMsg() { "Seed type must be scalar" }
	static def getReductionTypesCompatibilityMsg(String seedType, String type) { "Seed type and reduction type are incompatible: " + seedType + " and " + type }

	@Check(CheckType.NORMAL)
	def checkEmptyBody(Function it)
	{
		if (external && eContainer instanceof NablaModule)
			error(getEmptyBodyMsg(), NablaPackage.Literals.FUNCTION_OR_REDUCTION__NAME, EMPTY_BODY)
	}

	@Check(CheckType.NORMAL)
	def checkForbiddenReturn(Return it)
	{
		val function = EcoreUtil2.getContainerOfType(it, FunctionOrReduction)
		if (function === null)
			error(getForbiddenReturnMsg(), NablaPackage.Literals.RETURN__EXPRESSION, FORBIDDEN_RETURN)
	}

	@Check(CheckType.NORMAL)
	def checkMissingReturn(FunctionOrReduction it)
	{
		if (body !== null && !body.hasReturn)
			error(getMissingReturnMsg(), NablaPackage.Literals.FUNCTION_OR_REDUCTION__NAME, MISSING_RETURN)
	}

	private def dispatch boolean hasReturn(Instruction it) { false }
	private def dispatch boolean hasReturn(Return it) { true }
	private def dispatch boolean hasReturn(Exit it) { true }
	private def dispatch boolean hasReturn(InstructionBlock it) { instructions.exists[hasReturn] }
	private def dispatch boolean hasReturn(If it)
	{
		if (^else === null) false
		else then.hasReturn && ^else.hasReturn
	}

	@Check(CheckType.NORMAL)
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

	@Check(CheckType.NORMAL)
	def checkOnlyIntAndVarInFunctionInTypes(Function it)
	{
		for (inType : intypesDeclaration.map[inTypes])
			if (!inType.sizes.forall[x | x instanceof IntConstant || (x instanceof ArgOrVarRef && (x as ArgOrVarRef).target.eContainer === it)])
				error(getOnlyIntAndVarInFunctionInTypesMsg(variables.map[name]), NablaPackage.Literals::FUNCTION__INTYPES_DECLARATION, ONLY_INT_AND_VAR_IN_FUNCTION_IN_TYPES)
	}

	@Check(CheckType.NORMAL)
	def checkOnlyIntAndVarInReductionType(Reduction it)
	{
		if (!typeDeclaration.type.sizes.forall[x | x instanceof IntConstant || (x instanceof ArgOrVarRef && (x as ArgOrVarRef).target.eContainer === it)])
			error(getOnlyIntAndVarInReductionTypeMsg(variables.map[name]), NablaPackage.Literals::REDUCTION__TYPE_DECLARATION, ONLY_INT_AND_VAR_IN_REDUCTION_TYPE)
	}

	@Check(CheckType.NORMAL)
	def checkFunctionIncompatibleInTypes(Function it)
	{
		if (!external && intypesDeclaration.size !== inArgs.size)
		{
			error(getFunctionInvalidArgNumberMsg(), NablaPackage.Literals::FUNCTION_OR_REDUCTION__IN_ARGS, FUNCTION_INVALID_ARG_NUMBER)
			return
		}

		val otherFunctionArgs = eContainer.eAllContents.filter(Function).filter[x | x.name == name && x !== it]
		val conflictingFunctionArg = otherFunctionArgs.findFirst[x | !areCompatible(x.intypesDeclaration, intypesDeclaration)]
		if (conflictingFunctionArg !== null)
			error(getFunctionIncompatibleInTypesMsg(), NablaPackage.Literals::FUNCTION_OR_REDUCTION__NAME, FUNCTION_INCOMPATIBLE_IN_TYPES)
	}

	@Check(CheckType.NORMAL)
	def checkFunctionReturnTypeDeclaration(FunctionReturnTypeDeclaration it)
	{
		val f = eContainer as Function
		if (!f.external && f.body !== null)
		{
			val returnInstruction = if (f.body instanceof Return) f.body as Return else f.body.eAllContents.findFirst[x | x instanceof Return]
			if (returnInstruction !== null)
			{
				val ri = returnInstruction as Return
				val expressionType = ri.expression?.typeFor
				val fType = returnType.typeFor
				if (expressionType !== null && !checkExpectedType(expressionType, fType))
					error(getTypeMsg(expressionType.label, fType.label), NablaPackage.Literals.FUNCTION_RETURN_TYPE_DECLARATION__RETURN_TYPE, FUNCTION_RETURN_TYPE)
			}
		}
	}

	@Check(CheckType.NORMAL)
	def checkFunctionReturnTypeDeclarationVar(FunctionReturnTypeDeclaration rtd)
	{
		val it = rtd.eContainer as Function
		val inTypeVars = new HashSet<SimpleVar>
		for (inType : it.intypesDeclaration.map[inTypes])
			for (dim : EcoreUtil2.getAllContentsOfType(inType, ArgOrVarRef))
				if (dim.target !== null && !dim.target.eIsProxy && dim.target instanceof SimpleVar)
					inTypeVars += dim.target as SimpleVar

		val returnTypeVars = new HashSet<SimpleVar>
		for (dim : EcoreUtil2.getAllContentsOfType(rtd.returnType, ArgOrVarRef))
			if (dim.target !== null && !dim.target.eIsProxy && dim.target instanceof SimpleVar)
				returnTypeVars += dim.target as SimpleVar

		val x = returnTypeVars.findFirst[x | !inTypeVars.contains(x)]
		if (x !== null)
			error(getFunctionReturnTypeDeclarationVarMsg(x.name), NablaPackage.Literals::FUNCTION_RETURN_TYPE_DECLARATION__RETURN_TYPE, FUNCTION_RETURN_TYPE_VAR)
	}

	@Check(CheckType.NORMAL)
	def checkReductionIncompatibleTypes(Reduction it)
	{
		val otherReductionArgs = eContainer.eAllContents.filter(Reduction).filter[x | x.name == name && x !== it]
		val conflictingReductionArg = otherReductionArgs.findFirst[x | !areCompatible(x.typeDeclaration.type, typeDeclaration.type)]
		if (conflictingReductionArg !== null)
			error(getReductionIncompatibleTypesMsg(), NablaPackage.Literals::REDUCTION__TYPE_DECLARATION, REDUCTION_INCOMPATIBLE_TYPES)
	}

	@Check(CheckType.NORMAL)
	def checkSeedAndType(Reduction it)
	{
		val seedType = seed?.typeFor
		// Seed must be scalar and Seed rootType must be the same as Return rootType
		// If type is Array, the reduction Seed will be used as many times as Array size
		// Ex (int.MaxValue, real]) int[2]; -> we will use (int.MaxValue, int.MaxValue) as reduction seed
		if (seedType !== null)
		{
			val rType = typeDeclaration.type.primitive
			if (!(seedType instanceof NSTScalar))
				error(getReductionSeedTypeMsg(), NablaPackage.Literals.REDUCTION__SEED, REDUCTION_SEED_TYPE)
			else if (seedType.label != rType.literal)
				error(getReductionTypesCompatibilityMsg(seedType.label, rType.literal), NablaPackage.Literals.REDUCTION__SEED, REDUCTION_TYPES_COMPATIBILITY)
		}
	}

		/** 
	 * Returns true if a and b can be declared together, false otherwise. 
	 * For example, false for R[2]->R and R[n]->R
	 */
	private def areCompatible(List<FunctionInTypeDeclaration> a, List<FunctionInTypeDeclaration> b)
	{
		if (a.size != b.size)
			return true

		for (i : 0..<a.size)
			if (areCompatible(a.get(i).inTypes, b.get(i).inTypes))
				return true

		return false
	}

	private def areCompatible(BaseType a, BaseType b)
	{
		(a.primitive != b.primitive || a.sizes.size != b.sizes.size)
	}

	private static def buildMsg(String prefix, String[] allowedVarNames) 
	{
		var msg = prefix + " must only contain int constants"
		if (!allowedVarNames.empty)
			msg += ", " + allowedVarNames.join(', ')
		return msg
	}
}