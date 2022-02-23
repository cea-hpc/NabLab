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
class NabLabExamplesTest extends GenerateAndExecuteTestBase
{
	final static String NabLabExamplesProjectName = 'NabLabExamples'
	final static String NabLabExamplesRelativePath = "plugins/fr.cea.nabla.ui/examples/NabLabExamples"

	static boolean explicitHeatEquationSourceChanged
	static boolean glace2dSourceChanged
	static boolean heatEquationSourceChanged
	static boolean implicitHeatEquationSourceChanged
	static boolean iterativeHeatEquationSourceChanged

	@BeforeClass
	static def void setup()
	{
		explicitHeatEquationSourceChanged = true
		glace2dSourceChanged = true
		heatEquationSourceChanged = true
		implicitHeatEquationSourceChanged = true
		iterativeHeatEquationSourceChanged = true
		setup(NabLabExamplesProjectName, NabLabExamplesRelativePath)
	}

	@Test
	def void test1GenerateExplicitHeatEquation()
	{
		testGenerateModule("ExplicitHeatEquation")
		explicitHeatEquationSourceChanged = false
	}

	@Test
	def void test2ExecuteExplicitHeatEquationIfSourceChanged()
	{
		Assume.assumeTrue(explicitHeatEquationSourceChanged)
		testExecuteModule("ExplicitHeatEquation")
	}

	@Test
	def void test1GenerateGlace2d()
	{
		testGenerateModule("Glace2d")
		glace2dSourceChanged = false
	}

	@Test
	def void test2ExecuteGlace2d()
	{
		Assume.assumeTrue(glace2dSourceChanged)
		testExecuteModule("Glace2d")
	}

	@Test
	def void test1GenerateHeatEquation()
	{
		testGenerateModule("HeatEquation")
		heatEquationSourceChanged = false
	}

	@Test
	def void test2ExecuteHeatEquation()
	{
		Assume.assumeTrue(heatEquationSourceChanged)
		testExecuteModule("HeatEquation")
	}

	@Test
	def void test1GenerateImplicitHeatEquation()
	{
		testGenerateModule("ImplicitHeatEquation")
		implicitHeatEquationSourceChanged = false
	}

	@Test
	def void test2ExecuteImplicitHeatEquation()
	{
		Assume.assumeTrue(implicitHeatEquationSourceChanged)
		testExecuteModule("ImplicitHeatEquation")
	}

	@Test
	def void test1GenerateIterativeHeatEquation()
	{
		testGenerateModule("IterativeHeatEquation")
		iterativeHeatEquationSourceChanged = false
	}

	@Test
	def void test2ExecuteIterativeHeatEquation()
	{
		Assume.assumeTrue(iterativeHeatEquationSourceChanged)
		testExecuteModule("IterativeHeatEquation")
	}
}