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
import fr.cea.nabla.nabla.Affectation
import fr.cea.nabla.nabla.ConnectivityVar
import fr.cea.nabla.nabla.If
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NablaPackage
import fr.cea.nabla.nabla.SimpleVarDefinition
import fr.cea.nabla.nabla.VarGroupDeclaration
import fr.cea.nabla.typing.BaseTypeTypeProvider
import fr.cea.nabla.typing.ExpressionTypeProvider
import org.eclipse.xtext.validation.Check

class InstructionValidator extends FunctionOrReductionValidator
{
	@Inject extension ValidationUtils
	@Inject extension BaseTypeTypeProvider
	@Inject extension ExpressionTypeProvider
	@Inject extension ExpressionExtensions

	public static val LOCAL_CONNECTIVITY_VAR = "Instructions::LocalConnectivityVar"
	public static val AFFECTATION_TYPE = "Instructions::AffectationType"
	public static val SIMPLE_VAR_TYPE = "Instructions::SimpleVarType"
	public static val IF_CONDITION_BOOL = "Instructions::IfConditionBool"
	public static val GLOBAL_VAR_VALUE = "Instructions::GlobalVarValue"
	public static val LOCAL_OPTION = "Instructions::Local Option"

	static def getLocalConnectivityVarMsg() { "Local variables not allowed on connectivities"}
	static def getAffectationTypeMsg(String actualTypeName, String expectedTypeName) { "Expected " + expectedTypeName + ", but was " + actualTypeName }
	static def getIfConditionBoolMsg(String actualTypeName) { "Expected " + ValidationUtils::BOOL.label + ", but was " + actualTypeName }
	static def getGlobalVarValueMsg() { "Assignment with reduction, external function or card not allowed in options and global variables" }
	static def getLocalOptionMsg() { "Option definition not allowed in jobs and functions (options are global)" }

	@Check
	def checkLocalConnectivitityVar(VarGroupDeclaration it)
	{
		// Global or local variable ?
		if (eContainer !== null && !(eContainer instanceof NablaModule))
		{
			for (i : 0..<vars.size)
				if (vars.get(i) instanceof ConnectivityVar)
					error(getLocalConnectivityVarMsg(), NablaPackage.Literals::VAR_GROUP_DECLARATION__VARS, i, LOCAL_CONNECTIVITY_VAR)
		}
	}

	@Check
	def checkAffectationType(Affectation it)
	{
		if (right !== null&& left !== null)
		{
			val leftType = left.typeFor
			val rightType = right.typeFor
			if (!checkExpectedType(rightType, leftType))
				error(getAffectationTypeMsg(rightType.label, leftType.label), NablaPackage.Literals.AFFECTATION__RIGHT, AFFECTATION_TYPE)
		}
	}

	@Check
	def checkIfConditionBoolType(If it)
	{
		if (condition !== null)
		{
			val condType = condition.typeFor
			if (!checkExpectedType(condType, ValidationUtils::BOOL))
				error(getIfConditionBoolMsg(condType.label), NablaPackage.Literals.IF__CONDITION, IF_CONDITION_BOOL)
		}
	}

	@Check
	def checkVarType(SimpleVarDefinition it)
	{
		if (value !== null)
		{
			val valueType = value.typeFor
			val varType = type.typeFor
			if (!checkExpectedType(valueType, varType))
				error(getAffectationTypeMsg(valueType.label, varType.label), NablaPackage.Literals.SIMPLE_VAR_DEFINITION__VALUE, SIMPLE_VAR_TYPE)
			else
			{
				val global = (eContainer !== null && eContainer instanceof NablaModule)
				if (global && !value.nablaEvaluable)
					error(getGlobalVarValueMsg(), NablaPackage.Literals::SIMPLE_VAR_DEFINITION__VALUE, GLOBAL_VAR_VALUE)
				else if (!global && option)
					error(getLocalOptionMsg(), NablaPackage.Literals::SIMPLE_VAR_DEFINITION__VALUE, LOCAL_OPTION)
			}
		}
	}
}