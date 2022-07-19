/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.tests.ir.transformers

import com.google.inject.Inject
import fr.cea.nabla.ir.ir.Synchronize
import fr.cea.nabla.ir.transformers.ComputeSynchronize
import fr.cea.nabla.ir.transformers.IrTransformationException
import fr.cea.nabla.tests.CompilationChainHelper
import fr.cea.nabla.tests.NablaInjectorProvider
import fr.cea.nabla.tests.TestUtils
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(XtextRunner)
@InjectWith(NablaInjectorProvider)
class ComputeSynchronizeTest
{
	@Inject extension TestUtils
	@Inject CompilationChainHelper compilationHelper
	val step = new ComputeSynchronize

	@Test
	def void test1()
	{
		val model =
		'''
		«testModule»
		ℝ stopTime;
		ℕ maxIterations;
		
		ℝ[2] X{nodes};
		ℝ l{nodes};
		ℝ s{cells}, u{cells}, v{cells};
		
		iterate n while (t^{n+1} < stopTime && n+1 < maxIterations);
		
		IniTime: t^{n=0} = 0.0;
		// scalar affectation => no change ------- no synchro
		J1: ∀j∈nodes(), l{j} = norm(X{j});
		
		// Array variable affectation => replace by loop ------- synchro
		J2: ∀j∈cells(), s{j} = ∑{r∈nodesOfCell(j)}(l{r});
		
		// Connectivity variable. Un = Un+1 at the end of time loop => replace by loop ------- no synchro
		J3: ∀j∈cells(), u^{n+1}{j} = δt + u^{n}{j} + 1.0;
		
		// Connectivity array variable. Vn = Vn+1 at the end of time loop => replace by loop ------- synchro
		J4: ∀j∈cells(), v^{n+1}{j} = ∑{r∈neighbourCells(j)}(v^{n}{r});
		'''

		val ir = compilationHelper.getRawIr(model, testGenModel)

		val j1Before = ir.jobs.findFirst[x | x.name == "J1"]
		val j2Before = ir.jobs.findFirst[x | x.name == "J2"]
		val j3Before = ir.jobs.findFirst[x | x.name == "J3"]
		val j4Before = ir.jobs.findFirst[x | x.name == "J4"]

		Assert.assertNotNull(j1Before)
		Assert.assertNotNull(j2Before)
		Assert.assertNotNull(j3Before)
		Assert.assertNotNull(j4Before)

		// Before transformation
		Assert.assertTrue(j1Before.instruction.eAllContents.filter(Synchronize).empty)
		Assert.assertTrue(j2Before.instruction.eAllContents.filter(Synchronize).empty)
		Assert.assertTrue(j3Before.instruction.eAllContents.filter(Synchronize).empty)
		Assert.assertTrue(j4Before.instruction.eAllContents.filter(Synchronize).empty)
		
		// Apply the transformation
		try {
			step.transform(ir, null)
			Assert.assertTrue(true)
		} catch (IrTransformationException e) {
			Assert.fail(e.message)
		}
		
		val j1After = ir.jobs.findFirst[x | x.name == "J1"]
		val j2After = ir.jobs.findFirst[x | x.name == "J2"]
		val j3After = ir.jobs.findFirst[x | x.name == "J3"]
		val j4After = ir.jobs.findFirst[x | x.name == "J4"]
		
		// After transformation
		Assert.assertTrue(j1After.eAllContents.filter(Synchronize).empty)
		Assert.assertTrue(j2After.eAllContents.filter(Synchronize).size === 1)
		Assert.assertTrue(j3After.eAllContents.filter(Synchronize).empty)
		Assert.assertTrue(j4After.eAllContents.filter(Synchronize).size === 1)
		
		val j2Synchronize = j2After.eAllContents.filter(Synchronize).head
		val j4Synchronize = j4After.eAllContents.filter(Synchronize).head
		
		Assert.assertTrue(j2Synchronize.variable.name == "l")
		Assert.assertTrue(j4Synchronize.variable.name == "v_n")
	}
}
