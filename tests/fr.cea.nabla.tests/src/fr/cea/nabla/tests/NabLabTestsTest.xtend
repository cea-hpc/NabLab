/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.tests

import com.google.inject.Inject
import java.nio.file.Paths
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.Assume
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
	final static String NabLabTestsRelativePath = Paths.get("tests", "NabLabTests").toString

	static boolean hydroRemapSourceChanged
	static boolean iterationSourceChanged
	static boolean variablesSourceChanged

	@Inject TestUtils testUtils

	@BeforeClass
	static def void setup()
	{
		hydroRemapSourceChanged = true
		iterationSourceChanged = true
		variablesSourceChanged = true
		setup(NabLabTestsProjectName, NabLabTestsRelativePath)
	}

	@Test
	def void test1GenerateHydroRemap()
	{
		testGenerateModule("HydroRemap", #["Hydro", "Remap"])
		hydroRemapSourceChanged = false
	}

	@Test
	def void test2ExecuteHydroRemap()
	{
		Assume.assumeTrue(hydroRemapSourceChanged || testUtils.runningOnCI())
		testExecuteModule("HydroRemap", #["Hydro", "Remap"])
	}

	@Test
	def void test1GenerateIteration()
	{
		testGenerateModule("Iteration")
		iterationSourceChanged = false
	}

	@Test
	def void test2ExecuteIteration()
	{
		Assume.assumeTrue(iterationSourceChanged || testUtils.runningOnCI())
		testExecuteModule("Iteration")
	}

	@Test
	def void test1GenerateVariables()
	{
		testGenerateModule("Variables")
		variablesSourceChanged = false
	}

	@Test
	def void test2ExecuteVariables()
	{
		Assume.assumeTrue(variablesSourceChanged || testUtils.runningOnCI())
		testExecuteModule("Variables")
	}
}