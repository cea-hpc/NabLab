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

import fr.cea.nabla.nabla.SimpleVar
import fr.cea.nabla.nabla.TimeIterator
import fr.cea.nabla.nablagen.NablagenPackage
import fr.cea.nabla.nablagen.VtkOutput
import org.eclipse.xtext.validation.Check
import fr.cea.nabla.nablagen.Cpp
import fr.cea.nabla.nablagen.NablagenConfig

/**
 * This class contains custom validation rules. 
 *
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class NablagenValidator extends AbstractNablagenValidator 
{
	public static val PERIOD_VARIABLES_TYPE = "NablagenValidator::PeriodVariablesType"
	public static val CPP_MANDATORY_VARIABLES = "NablagenValidator::CppMandatoryVariables"

	static def getPeriodVariablesTypeMsg() { "Invalid variable type: only scalar types accepted" }
	static def getCppMandatoryVariablesMsg() { "'iterationMax' and 'timeMax' simulation variables must be defined (after timeStep) when using C++ code generator" }

	@Check
	def void checkPeriodVariablesType(VtkOutput it)
	{
		if (periodReference !== null && !(periodReference instanceof SimpleVar || periodReference instanceof TimeIterator))
			error(getPeriodVariablesTypeMsg(), NablagenPackage.Literals::VTK_OUTPUT__PERIOD_REFERENCE, PERIOD_VARIABLES_TYPE)
	}

	@Check
	def void checkCppMandatoryVariables(NablagenConfig it)
	{
		if (targets.exists[x | x instanceof Cpp] && (iterationMax === null || timeMax === null))
			error(getCppMandatoryVariablesMsg(), NablagenPackage.Literals::NABLAGEN_CONFIG__TIME_STEP, CPP_MANDATORY_VARIABLES)
	}
}
