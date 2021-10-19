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
import fr.cea.nabla.ArgOrVarExtensions
import fr.cea.nabla.ExpressionExtensions
import fr.cea.nabla.nabla.Affectation
import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.ConnectivityVar
import fr.cea.nabla.nabla.If
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NablaPackage
import fr.cea.nabla.nabla.OptionDeclaration
import fr.cea.nabla.nabla.SimpleVarDeclaration
import fr.cea.nabla.nabla.VarGroupDeclaration
import fr.cea.nabla.nabla.While
import fr.cea.nabla.typing.BaseTypeTypeProvider
import fr.cea.nabla.typing.ExpressionTypeProvider
import fr.cea.nabla.typing.NablaConnectivityType
import fr.cea.nabla.typing.NablaSimpleType
import org.eclipse.xtext.validation.Check
import org.eclipse.xtext.validation.CheckType

class InstructionValidator extends FunctionOrReductionValidator
{
	@Inject extension ValidationUtils
	@Inject extension BaseTypeTypeProvider
	@Inject extension ExpressionTypeProvider
	@Inject extension ArgOrVarExtensions
	@Inject extension ExpressionExtensions

	public static val DYNAMIC_GLOBAL_VAR = "Instructions::DynamicConnectivityVar"
	public static val LOCAL_CONNECTIVITY_VAR = "Instructions::LocalConnectivityVar"
	public static val AFFECTATION_TYPE = "Instructions::AffectationType"
	public static val AFFECTATION_ON_CONNECTIVITY_TYPE = "Instructions::AffectationOnConnectivityType"
	public static val AFFECTATION_ON_OPTION = "Instructions::AffectationOnOption"
	public static val CONDITION_BOOL = "Instructions::ConditionBool"
	public static val SIMPLE_VAR_TYPE = "Instructions::SimpleVarType"
	public static val GLOBAL_VAR_VALUE = "Instructions::GlobalVarValue"

	static def getDynamicGlobalVarMsg() { "Dynamic array not allowed on global variables"}
	static def getLocalConnectivityVarMsg() { "Connectivities not allowed on local variables"}
	static def getAffectationOnConnectivityTypeMsg() { "Assignment not allowed on connectivity variables: use loop instead" }
	static def getAffectationOnOptionMsg() { "Assignment not allowed on options"}
	static def getGlobalVarValueMsg() { "Assignment with reduction, external function, card or dynamic variable not allowed in options and global variables" }

	@Check(CheckType.NORMAL)
	def checkDynamicGlobalVar(VarGroupDeclaration it)
	{
		// Global variable ?
		if (eContainer !== null && eContainer instanceof NablaModule)
		{
			if (!type.sizes.empty)
			{
				val t = type.typeFor as NablaSimpleType
				if (!t.isStatic && type.eAllContents.filter(ArgOrVarRef).exists[x | !x.target.option])
					error(getDynamicGlobalVarMsg(), NablaPackage.Literals::VAR_DECLARATION__TYPE, DYNAMIC_GLOBAL_VAR)
			}
		}
	}

	@Check(CheckType.NORMAL)
	def checkLocalConnectivitityVar(VarGroupDeclaration it)
	{
		// Local variable ?
		if (eContainer !== null && !(eContainer instanceof NablaModule))
		{
			for (i : 0..<variables.size)
				if (variables.get(i) instanceof ConnectivityVar)
					error(getLocalConnectivityVarMsg(), NablaPackage.Literals::VAR_GROUP_DECLARATION__VARIABLES, i, LOCAL_CONNECTIVITY_VAR)
		}
	}

	@Check(CheckType.NORMAL)
	def checkAffectationType(Affectation it)
	{
		if (right !== null&& left !== null)
		{
			if (left.target.option)
				error(getAffectationOnOptionMsg(), NablaPackage.Literals.AFFECTATION__LEFT, AFFECTATION_ON_OPTION)

			val leftType = left.typeFor
			val rightType = right.typeFor
			if (!checkExpectedType(rightType, leftType))
				error(getTypeMsg(rightType.label, leftType.label), NablaPackage.Literals.AFFECTATION__RIGHT, AFFECTATION_TYPE)
			if (leftType instanceof NablaConnectivityType)
				error(getAffectationOnConnectivityTypeMsg(), NablaPackage.Literals.AFFECTATION__LEFT, AFFECTATION_ON_CONNECTIVITY_TYPE)
		}
	}

	@Check(CheckType.NORMAL)
	def checkIfConditionBoolType(If it)
	{
		if (condition !== null)
		{
			val condType = condition.typeFor
			if (!checkExpectedType(condType, ValidationUtils::BOOL))
				error(getTypeMsg(condType.label, ValidationUtils::BOOL.label), NablaPackage.Literals.IF__CONDITION, CONDITION_BOOL)
		}
	}

	@Check(CheckType.NORMAL)
	def checkWhileConditionBoolType(While it)
	{
		if (condition !== null)
		{
			val condType = condition.typeFor
			if (!checkExpectedType(condType, ValidationUtils::BOOL))
				error(getTypeMsg(condType.label, ValidationUtils::BOOL.label), NablaPackage.Literals.WHILE__CONDITION, CONDITION_BOOL)
		}
	}

	@Check(CheckType.NORMAL)
	def checkVarType(SimpleVarDeclaration it)
	{
		if (value !== null)
		{
			val valueType = value.typeFor
			val varType = type.typeFor
			if (!checkExpectedType(valueType, varType))
				error(getTypeMsg(valueType.label, varType.label), NablaPackage.Literals.SIMPLE_VAR_DECLARATION__VALUE, SIMPLE_VAR_TYPE)
			else
			{
				val global = (eContainer !== null && eContainer instanceof NablaModule)
				if (global && !value.nablaEvaluable)
					error(getGlobalVarValueMsg(), NablaPackage.Literals::SIMPLE_VAR_DECLARATION__VALUE, GLOBAL_VAR_VALUE)
			}
		}
	}

	@Check(CheckType.NORMAL)
	def checkVarType(OptionDeclaration it)
	{
		if (value !== null)
		{
			val valueType = value.typeFor
			val varType = type.typeFor
			if (!checkExpectedType(valueType, varType))
				error(getTypeMsg(valueType.label, varType.label), NablaPackage.Literals.OPTION_DECLARATION__VALUE, SIMPLE_VAR_TYPE)
			else
			{
				if (!value.nablaEvaluable)
					error(getGlobalVarValueMsg(), NablaPackage.Literals::OPTION_DECLARATION__VALUE, GLOBAL_VAR_VALUE)
			}
		}
	}
}