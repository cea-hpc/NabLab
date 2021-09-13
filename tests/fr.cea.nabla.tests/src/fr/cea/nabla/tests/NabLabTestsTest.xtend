/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.tests

import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.BeforeClass
import org.junit.FixMethodOrder
import org.junit.Test
import org.junit.runner.RunWith
import org.junit.runners.MethodSorters

@RunWith(XtextRunner)
@InjectWith(NablaInjectorProvider)
@FixMethodOrder(MethodSorters.NAME_ASCENDING)
class NabLabTestsTest extends GenerateAndExecuteTestBase
{
	final static String NabLabTestsProjectName = 'NabLabTests'
	final static String NabLabTestsRelativePath = "tests/NabLabTests"

	@BeforeClass
	static def void setup()
	{
		setup(NabLabTestsProjectName, NabLabTestsRelativePath)
	}

	@Test
	def void testGenerateAffectations()
	{
		testGenerateModule("Affectations")
	}

	@Test
	def void testGenerateHydroRemap()
	{
		testGenerateModule("HydroRemap", #["Hydro", "Remap"])
	}

	@Test
	def void testGenerateIteration()
	{
		testGenerateModule("Iteration")
	}
}