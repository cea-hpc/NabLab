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

import org.eclipse.xtext.validation.Check
import fr.cea.nabla.nablagen.TagPersistentVariablesComponent
import fr.cea.nabla.nabla.SimpleVar
import fr.cea.nabla.nabla.TimeIterator
import fr.cea.nabla.nablagen.NablagenPackage
import fr.cea.nabla.nablagen.Cpp
import fr.cea.nabla.nablagen.CppProgrammingModel

/**
 * This class contains custom validation rules. 
 *
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class NablagenValidator extends AbstractNablagenValidator 
{
	public static val PERIOD_VAR_TYPE = "TagPersistentVariablesComponent::PeriodVarType"
	public static val KOKKOS_PATH = "Cpp::KokkosPath"

	static def getPeriodVarTypeMsg() { "Invalid variable type: only scalar types accepted" }
	static def getKokkosPathMsg() { "Kokkos path is required when KOKKOS programming model is selected" }

	@Check
	def void checkPeriodVarType(TagPersistentVariablesComponent it)
	{
		if (periodVar !== null && !(periodVar instanceof SimpleVar || periodVar instanceof TimeIterator))
			error(getPeriodVarTypeMsg(), NablagenPackage.Literals::TAG_PERSISTENT_VARIABLES_COMPONENT__PERIOD_VAR, PERIOD_VAR_TYPE)
	}

	@Check
	def void checkKokkosPath(Cpp it)
	{
		if ((programmingModel == CppProgrammingModel::KOKKOS || programmingModel == CppProgrammingModel::KOKKOS_TEAM_THREAD) && kokkosPath.nullOrEmpty)
			error(getKokkosPathMsg(), NablagenPackage.Literals::CPP__PROGRAMMING_MODEL, KOKKOS_PATH)
	}
}
