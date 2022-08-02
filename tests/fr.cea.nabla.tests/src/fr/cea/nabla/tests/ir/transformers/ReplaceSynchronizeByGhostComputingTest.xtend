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
import fr.cea.nabla.ir.transformers.ComputeSynchronize
import fr.cea.nabla.ir.transformers.IrTransformationException
import fr.cea.nabla.ir.transformers.ReplaceSynchronizeByGhostComputing
import fr.cea.nabla.tests.CompilationChainHelper
import fr.cea.nabla.tests.NablaInjectorProvider
import fr.cea.nabla.tests.TestUtils
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ContainerExtensions

@RunWith(XtextRunner)
@InjectWith(NablaInjectorProvider)
class ReplaceSynchronizeByGhostComputingTest
{
	@Inject extension TestUtils
	@Inject CompilationChainHelper compilationHelper
	val step = new ReplaceSynchronizeByGhostComputing

	@Test
	def void test1()
	{
		val model =
		'''
		«testModule»
		ℝ stopTime;
		ℕ maxIterations;
		
		ℝ[2] X{nodes};
		ℝ a{nodes}, c{nodes};
		ℝ b{cells}, rho{cells}, ajr{cells}, v{cells};
		
		iterate n while (t^{n+1} < stopTime && n+1 < maxIterations);
		
		// Init
		IniTime: t^{n=0} = 0.0;
		
		J1: ∀j∈nodes(), a{j} = norm(X{j});
		
		J2: ∀j∈cells(), b{j} = ∑{r∈nodesOfCell(j)}(a{r});
		
		J3: ∀j∈cells(), rho{j} = 1.0;
		
		
		// ExecuteTimeLoopJob
		J4: ∀j∈cells(), rho{j} = t^{n};
		
		J5: ∀j∈cells(), ajr{j} = rho{j} + t^{n};
		
		J6: ∀j∈cells(), v^{n+1}{j} = ∑{r∈neighbourCells(j)}(v^{n}{r} + ajr{r});
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
		val j6 = ir.jobs.findFirst[x | x.name == "J6"]
		val timeLoopJob = ir.jobs.findFirst[x | x.name.startsWith(JobExtensions.EXECUTE_TIMELOOP_PREFIX)]

		Assert.assertNotNull(j1)
		Assert.assertNotNull(j2)
		Assert.assertNotNull(j3)
		Assert.assertNotNull(j4)
		Assert.assertNotNull(j5)
		Assert.assertNotNull(j6)
		Assert.assertNotNull(timeLoopJob)

		// Before transformation
		Assert.assertTrue(j1.eAllContents.filter(Synchronize).empty)
		Assert.assertTrue(j2.eAllContents.filter(Synchronize).size === 1)
		Assert.assertTrue(j3.eAllContents.filter(Synchronize).empty)
		Assert.assertTrue(j4.eAllContents.filter(Synchronize).empty)
		Assert.assertTrue(j5.eAllContents.filter(Synchronize).empty)
		Assert.assertTrue(j6.eAllContents.filter(Synchronize).size === 2)
		
		val j2Synchronizes = j2.eAllContents.filter(Synchronize)
		val j6Synchronizes = j6.eAllContents.filter(Synchronize)
		
		Assert.assertTrue(j2Synchronizes.head.variable.name == "a")
		Assert.assertTrue(j6Synchronizes.head.variable.name == "v_n")
		Assert.assertTrue(j6Synchronizes.last.variable.name == "ajr")
		
		// Apply the transformation
		try {
			step.transform(ir, null)
			Assert.assertTrue(true)
		} catch (IrTransformationException e) {
			Assert.fail(e.message)
		}
		
		// After transformation
		Assert.assertTrue(j1.eAllContents.filter(Synchronize).empty)
		Assert.assertTrue(j2.eAllContents.filter(Synchronize).empty)
		Assert.assertTrue(j3.eAllContents.filter(Synchronize).empty)
		Assert.assertTrue(j4.eAllContents.filter(Synchronize).empty)
		Assert.assertTrue(j5.eAllContents.filter(Synchronize).empty)
		Assert.assertTrue(j6.eAllContents.filter(Synchronize).size === 1)
		
		val j6SynchronizesAfter = j6.eAllContents.filter(Synchronize)
		
		Assert.assertTrue(j6SynchronizesAfter.head.variable.name == "v_n")
		
		val loopJ1 = j1.eAllContents.filter(Loop).head
		val iterationblockj1 = loopJ1.iterationBlock as Iterator
		val connectivityCallj1 = ContainerExtensions.getConnectivityCall(iterationblockj1.container)
		Assert.assertTrue(connectivityCallj1.allItems)
		
		val loopJ2 = j2.eAllContents.filter(Loop).head
		val iterationblockj2 = loopJ2.iterationBlock as Iterator
		val connectivityCallj2 = ContainerExtensions.getConnectivityCall(iterationblockj2.container)
		Assert.assertTrue(connectivityCallj2.allItems === false)
		
		val loopJ3 = j3.eAllContents.filter(Loop).head
		val iterationblockj3 = loopJ3.iterationBlock as Iterator
		val connectivityCallj3 = ContainerExtensions.getConnectivityCall(iterationblockj3.container)
		Assert.assertTrue(connectivityCallj3.allItems === false)
		
		val loopJ4 = j4.eAllContents.filter(Loop).head
		val iterationblockj4 = loopJ4.iterationBlock as Iterator
		val connectivityCallj4 = ContainerExtensions.getConnectivityCall(iterationblockj4.container)
		Assert.assertTrue(connectivityCallj4.allItems)
		
		val loopJ5 = j5.eAllContents.filter(Loop).head
		val iterationblockj5 = loopJ5.iterationBlock as Iterator
		val connectivityCallj5 = ContainerExtensions.getConnectivityCall(iterationblockj5.container)
		Assert.assertTrue(connectivityCallj5.allItems)
		
		val loopJ6 = j6.eAllContents.filter(Loop).head
		val iterationblockj6 = loopJ6.iterationBlock as Iterator
		val connectivityCallj6 = ContainerExtensions.getConnectivityCall(iterationblockj6.container)
		Assert.assertTrue(connectivityCallj6.allItems === false)
	}
}
