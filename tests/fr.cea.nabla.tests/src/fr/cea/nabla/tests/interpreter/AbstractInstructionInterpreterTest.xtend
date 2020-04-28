/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.tests.interpreter

import com.google.inject.Inject
import fr.cea.nabla.tests.NablaInjectorProvider
import fr.cea.nabla.tests.TestUtils
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(XtextRunner)
@InjectWith(NablaInjectorProvider)
abstract class AbstractInstructionInterpreterTest 
{
	@Inject extension TestUtils

	@Test
	def void testInterpreteVarDefinition()
	{
		val model = testModuleForSimulation
		+
		'''
		ℝ[2] X{nodes};
		Job1: { let r = 1.0; t = r; }
		'''
		
		assertInterpreteVarDefinition(model)
	}

	@Test
	def void testInterpreteInstructionBlock()
	{
		val model = testModuleForSimulation
		+
		'''
		ℝ[2] X{nodes};
		Job1: { let r = 1.0; t = r; }
		'''

		assertInterpreteInstructionBlock(model)
	}

	@Test
	def void testInterpreteAffectation()
	{
		val model = testModuleForSimulation
		+
		'''
		ℝ[2] X{nodes};
		Job1: { let r = 1.0; t = r; }
		'''

		assertInterpreteAffectation(model)
	}

	@Test
	def void testInterpreteLoop()
	{
		val xQuads = 100
		val yQuads = 100
		val model = getTestModule(xQuads, yQuads)
		+
		'''
		ℝ U{cells};
		ℝ[2] X{nodes}, C{cells, nodesOfCell};
		InitU : ∀r∈cells(), U{r} = 1.0;
		ComputeCjr: ∀j∈ cells(), {
			set rCellsJ = nodesOfCell(j);
			let cardRCellsJ = card(rCellsJ);
			ℝ[cardRCellsJ] tmp;
			∀r, countr ∈ rCellsJ, {
				tmp[countr] = 0.5; // stupid but test countr
				C{j,r} = tmp[countr] * (X{r+1} - X{r-1});
			}
		}
		'''

		assertInterpreteLoop(model, xQuads, yQuads)
	}

	@Test
	def void testInterpreteSetDefinition()
	{
		val xQuads = 100
		val yQuads = 100
		val model = getTestModule(xQuads, yQuads)
		+
		'''
		ℝ[2] X{nodes};
		ℝ U{cells};
		InitU : {
			set myCells = cells();
			∀r∈myCells, U{r} = 1.0;
		}
		'''

		assertInterpreteSetDefinition(model, xQuads, yQuads)
	}

	@Test
	def void testInterpreteExit()
	{
		val xQuads = 100
		val yQuads = 100
		val model = getTestModule(xQuads, yQuads)
		+
		'''
		let V=100;
		ℝ[2] X{nodes};

		Test : if (V < 100) V = V+1; else exit "V must be less than 100";
		'''

		assertInterpreteExit(model)
	}
	
	def void assertInterpreteVarDefinition(String model)

	def void assertInterpreteInstructionBlock(String model)

	def void assertInterpreteAffectation(String model)

	def void assertInterpreteLoop(String model, int xQuads, int yQuads)

	def void assertInterpreteSetDefinition(String model, int xQuads, int yQuads)

	def void assertInterpreteExit(String model)
}