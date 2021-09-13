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
class NabLabExamplesTest extends GenerateAndExecuteTestBase
{
	final static String NabLabExamplesProjectName = 'NabLabExamples'
	final static String NabLabExamplesRelativePath = "plugins/fr.cea.nabla.ui/examples/NabLabExamples"

	@BeforeClass
	static def void setup()
	{
		setup(NabLabExamplesProjectName, NabLabExamplesRelativePath)
	}

	@Test
	def void test1GenerateExplicitHeatEquation()
	{
		testGenerateModule("ExplicitHeatEquation")
	}

	@Test
	def void test2ExecuteExplicitHeatEquation()
	{
		testExecuteModule("ExplicitHeatEquation")
	}

	@Test
	def void test1GenerateGlace2d()
	{
		testGenerateModule("Glace2d")
	}

	@Test
	def void test2ExecuteGlace2d()
	{
		testExecuteModule("Glace2d")
	}

	@Test
	def void test1GenerateHeatEquation()
	{
		testGenerateModule("HeatEquation")
	}

	@Test
	def void test2ExecuteHeatEquation()
	{
		testExecuteModule("HeatEquation")
	}

	@Test
	def void test1GenerateImplicitHeatEquation()
	{
		testGenerateModule("ImplicitHeatEquation")
	}

	@Test
	def void test2ExecuteImplicitHeatEquation()
	{
		testExecuteModule("ImplicitHeatEquation")
	}

	@Test
	def void test1GenerateIterativeHeatEquation()
	{
		testGenerateModule("IterativeHeatEquation")
	}

	@Test
	def void test2ExecuteIterativeHeatEquation()
	{
		testExecuteModule("IterativeHeatEquation")
	}
}