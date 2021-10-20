/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.tests.ir.interpreter

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
		val model =
		'''
		«testModule»
		ℝ[2] X{nodes};
		Job1: { let ℝ r = 1.0; t = r; }
		'''
		assertInterpreteVarDefinition(model)
	}

	@Test
	def void testInterpreteInstructionBlock()
	{
		val model =
		'''
		«testModule»
		ℝ[2] X{nodes};
		Job1: { let ℝ r = 1.0; t = r; }
		'''
		assertInterpreteInstructionBlock(model)
	}

	@Test
	def void testInterpreteAffectation()
	{
		val model =
		'''
		«testModule»
		ℝ[2] X{nodes};
		Job1: { let ℝ r = 1.0; t = r; }
		'''
		assertInterpreteAffectation(model)
	}

	@Test
	def void testInterpreteLoop()
	{
		val model =
		'''
		«testModule»
		option ℕ maxIter = 10;
		option ℝ maxTime = 1.0;
		ℝ U{cells};
		ℝ[2] X{nodes}, B{nodes}, C{cells, nodesOfCell};
		ℝ Bmin, Bmax;

		iterate n while (n+1 < maxIter && t^{n+1} < maxTime);

		InitTime: t^{n=0} = 0.0;
		InitU : ∀r∈cells(), U{r} = 1.0;
		ComputeCjr: ∀j∈ cells(), {
			set rCellsJ = nodesOfCell(j);
			let ℕ cardRCellsJ = card(rCellsJ);
			ℝ[cardRCellsJ] tmp;
			∀r, countr ∈ rCellsJ, {
				tmp[countr] = 0.5; // stupid but test countr
				C{j,r} = tmp[countr] * (X{r+1} - X{r-1});
			}
		}

		InitB: ∀r∈nodes(),
		{
			B^{n=0}{r}[0] = -X{r}[0];
			B^{n=0}{r}[1] = -X{r}[1];
		}
		ComputeB: ∀r∈nodes(), B^{n+1}{r} = B^{n}{r} / 2;
		ComputeBmin: Bmin = Min{r∈nodes()}(B^{n}{r}[0]);
		ComputeBmax: Bmax = Max{r∈nodes()}(B^{n}{r}[0]);

		InitT: t^{n=0} = 0.0;
		ComputeTn: t^{n+1} = t^{n} + δt;
		'''

		assertInterpreteLoop(model, 100, 100)
	}

	@Test
	def void testInterpreteIf()
	{
		val model =
		'''
		«testModule»
		ℝ U{cells};
		ℝ[2] X{nodes};
		InitU : ∀r, countr ∈ cells(), {
			if (countr % 2 == 0)
				U{r} = 0.0;
			else
				U{r} = 1.0;
		}
		'''
		assertInterpreteIf(model, 100, 100)
	}

	@Test
	def void testInterpreteWhile()
	{
		val model =
		'''
		«testModule»
		ℝ U{cells};
		ℝ[2] X{nodes}, C{cells, nodesOfCell};
		InitU : {
			let ℕ i = 0;
			while (i<3) {
				∀r ∈ cells(), U{r} = 1.0 * i;
				i = i +1;
			}
		}
		'''
		assertInterpreteWhile(model, 100, 100)
	}

	@Test
	def void testInterpreteSetDefinition()
	{
		val model =
		'''
		«testModule»

		ℝ[2] X{nodes};
		ℝ U{cells};
		InitU : {
			set myCells = cells();
			∀r∈myCells, U{r} = 1.0;
		}
		'''
		assertInterpreteSetDefinition(model, 100, 100)
	}

	@Test
	def void testInterpreteExit()
	{
		val model =
		'''
		«testModule»
		let ℕ V=100;
		let ℕ W=0;
		ℝ[2] X{nodes};

		Test : if (V < 100) W = V+1; else exit "V must be less than 100";
		'''
		assertInterpreteExit(model)
	}

	def void assertInterpreteVarDefinition(String model)
	def void assertInterpreteInstructionBlock(String model)
	def void assertInterpreteAffectation(String model)
	def void assertInterpreteLoop(String model, int xQuads, int yQuads)
	def void assertInterpreteIf(String model, int xQuads, int yQuads)
	def void assertInterpreteWhile(String model, int xQuads, int yQuads)
	def void assertInterpreteSetDefinition(String model, int xQuads, int yQuads)
	def void assertInterpreteExit(String model)
}