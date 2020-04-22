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
import fr.cea.nabla.ExpressionExtensions
import fr.cea.nabla.nabla.Affectation
import fr.cea.nabla.nabla.If
import fr.cea.nabla.nabla.NablaPackage
import fr.cea.nabla.nabla.SimpleVarDefinition
import fr.cea.nabla.typing.ExpressionTypeProvider
import org.eclipse.xtext.validation.Check

class InstructionValidator extends FunctionOrReductionValidator
{
	@Inject extension ValidationUtils
	@Inject extension ExpressionTypeProvider
	@Inject extension ExpressionExtensions
	@Inject extension ArgOrVarExtensions

	public static val AFFECTATION_TYPE = "Instructions::AffectationType"
	public static val IF_CONDITION_BOOL = "Instructions::IfConditionBool"
	public static val GLOBAL_VAR_VALUE = "Instructions::GlobalVarValue"

	static def getAffectationTypeMsg(String actualTypeName, String expectedTypeName) { "Expected " + expectedTypeName + ", but was " + actualTypeName }
	static def getIfConditionBoolMsg(String actualTypeName) { "Expected " + ValidationUtils::BOOL.label + ", but was " + actualTypeName }
	static def getGlobalVarValueMsg() { "Assignment with reduction not allowed in global variables" }


	@Check
	def checkAffectationType(Affectation it)
	{
		if (!checkExpectedType(right?.typeFor, left?.typeFor))
			error(getAffectationTypeMsg(right?.typeFor.label, left?.typeFor.label), NablaPackage.Literals.AFFECTATION__RIGHT, AFFECTATION_TYPE)
	}

	@Check
	def checkIfConditionBoolType(If it)
	{
		if (!checkExpectedType(condition?.typeFor, ValidationUtils::BOOL))
			error(getIfConditionBoolMsg(condition?.typeFor.label), NablaPackage.Literals.IF__CONDITION, IF_CONDITION_BOOL)
	}

	@Check
	def checkGlobalVarValue(SimpleVarDefinition it)
	{
		if (value !== null)
		{
			// no function or reduction in global variables initialisation
			if (variable.global && !value.respectGlobalExprConstraints)
				error(getGlobalVarValueMsg(), NablaPackage.Literals::SIMPLE_VAR_DEFINITION__VALUE, GLOBAL_VAR_VALUE)
		}
	}
}