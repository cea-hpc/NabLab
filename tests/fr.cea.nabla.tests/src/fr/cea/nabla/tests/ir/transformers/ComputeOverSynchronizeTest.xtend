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
import fr.cea.nabla.ir.JobExtensions
import fr.cea.nabla.ir.ir.Synchronize
import fr.cea.nabla.ir.transformers.ComputeOverSynchronize
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
class ComputeOverSynchronizeTest
{
	@Inject extension TestUtils
	@Inject CompilationChainHelper compilationHelper
	val step = new ComputeOverSynchronize

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
		ℝ s{cells}, h{cells}, u{cells}, v{cells};
		
		iterate n while (t^{n+1} < stopTime && n+1 < maxIterations);
		
		IniTime: t^{n=0} = 0.0;

		J1: ∀j∈nodes(), l{j} = norm(X{j});

		J2: ∀j∈cells(), s{j} = ∑{r∈nodesOfCell(j)}(l{r});
		
		J3: ∀j∈cells(), h{j} = ∑{r∈nodesOfCell(j)}(l{r});
		
		J4: ∀j∈cells(), u^{n+1}{j} = δt + u^{n}{j} + 1.0;
		
		J5: ∀j∈cells(), v^{n+1}{j} = ∑{r∈neighbourCells(j)}(v^{n}{r} + s{r});
		'''
		
		val ir = compilationHelper.getIrForGeneration(model, testGenModel)

		// Apply the transformation ComputeSynchronize to prepare ir to parallel execution
		try {
			val computeSynchronizeTransform = new ComputeSynchronize
			computeSynchronizeTransform.transform(ir, null)
			Assert.assertTrue(true)
		} catch (IrTransformationException e) {
			Assert.fail(e.message)
		}
		
		val j1 = ir.jobs.findFirst[x | x.name == "J1"]
		val j2 = ir.jobs.findFirst[x | x.name == "J2"]
		val j3 = ir.jobs.findFirst[x | x.name == "J3"]
		val j4 = ir.jobs.findFirst[x | x.name == "J4"]
		val j5 = ir.jobs.findFirst[x | x.name == "J5"]
		val timeLoopJob = ir.jobs.findFirst[x | x.name.startsWith(JobExtensions.EXECUTE_TIMELOOP_PREFIX)]

		Assert.assertNotNull(j1)
		Assert.assertNotNull(j2)
		Assert.assertNotNull(j3)
		Assert.assertNotNull(j4)
		Assert.assertNotNull(j5)
		Assert.assertNotNull(timeLoopJob)

		// Before transformation
		Assert.assertTrue(j1.eAllContents.filter(Synchronize).empty)
		Assert.assertTrue(j2.eAllContents.filter(Synchronize).size === 1)
		Assert.assertTrue(j3.eAllContents.filter(Synchronize).size === 1)
		Assert.assertTrue(j4.eAllContents.filter(Synchronize).empty)
		Assert.assertTrue(j5.eAllContents.filter(Synchronize).size === 2)
		
		val j2Synchronizes = j2.eAllContents.filter(Synchronize)
		val j3Synchronizes = j3.eAllContents.filter(Synchronize)
		val j5Synchronizes = j5.eAllContents.filter(Synchronize)
		
		Assert.assertTrue(j2Synchronizes.head.variable.name == "l")
		Assert.assertTrue(j3Synchronizes.head.variable.name == "l")
		Assert.assertTrue(j5Synchronizes.head.variable.name == "v_n")
		Assert.assertTrue(j5Synchronizes.last.variable.name == "s")
		
		// Apply the transformation
		try {
			step.transform(ir, null)
			Assert.assertTrue(true)
		} catch (IrTransformationException e) {
			Assert.fail(e.message)
		}
		
		// After transformation
		Assert.assertTrue(j1.eAllContents.filter(Synchronize).empty)
		Assert.assertTrue(j2.eAllContents.filter(Synchronize).size === 1)
		Assert.assertTrue(j3.eAllContents.filter(Synchronize).empty)
		Assert.assertTrue(j4.eAllContents.filter(Synchronize).empty)
		Assert.assertTrue(j5.eAllContents.filter(Synchronize).size === 1)
		
		val j2SynchronizesAfter = j2.eAllContents.filter(Synchronize)
		val j5SynchronizesAfter = j5.eAllContents.filter(Synchronize)
		
		Assert.assertTrue(j2SynchronizesAfter.head.variable.name == "l")
		Assert.assertTrue(j5SynchronizesAfter.head.variable.name == "v_n")
		
		// Check if the new job to synchronize update read only variables is create and synchronize the right value
		val synchronizeBeforeTimeLoop = ir.jobs.findFirst[x | x.name == "SynchronizeBeforeTimeLoop"]
		Assert.assertNotNull(synchronizeBeforeTimeLoop)

		
		Assert.assertTrue(synchronizeBeforeTimeLoop.eAllContents.filter(Synchronize).size === 1)
		val synchronizeBeforeTimeLoopSynchronizes = synchronizeBeforeTimeLoop.eAllContents.filter(Synchronize)
		Assert.assertTrue(synchronizeBeforeTimeLoopSynchronizes.head.variable.name == "s")
	}
}
