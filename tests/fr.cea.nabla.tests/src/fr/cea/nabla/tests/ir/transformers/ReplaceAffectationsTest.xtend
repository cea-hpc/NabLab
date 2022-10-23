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
import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.InstructionBlock
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.transformers.IrTransformationException
import fr.cea.nabla.ir.transformers.ReplaceAffectations
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
class ReplaceAffectationsTest
{
	@Inject extension TestUtils
	@Inject CompilationChainHelper compilationHelper
	val step = new ReplaceAffectations

	@Test
	def void test1()
	{
		val model =
		'''
		«testModule»
		real[2] X{nodes};
		real x, y;
		real[5] a, b;
		real u{cells};
		real[4] v{cells};

		iterate n while (n < 2);

		// scalar affectation => no change
		J1: x = y;

		// Array variable affectation => replace by loop
		J2: a = b;

		// Connectivity variable. Un = Un+1 at the end of time loop => replace by loop
		J3: forall j in cells(), u^{n+1}{j} = u^{n}{j} + 1.0;

		// Connectivity array variable. Vn = Vn+1 at the end of time loop => replace by loop
		J4: forall j in cells(), v^{n+1}{j} = v^{n}{j} + 1.0;
		'''

		val ir = compilationHelper.getRawIr(model, testGenModel)

		val j1 = ir.jobs.findFirst[x | x.name == "J1"]
		val j2 = ir.jobs.findFirst[x | x.name == "J2"]
		val timeLoopJob = ir.jobs.findFirst[x | x.name.startsWith(JobExtensions.EXECUTE_TIMELOOP_PREFIX)]

		Assert.assertNotNull(j1)
		Assert.assertNotNull(j2)
		Assert.assertNotNull(timeLoopJob)

		// Before transformation
		Assert.assertTrue(j1.instruction instanceof Affectation)
		Assert.assertTrue(j2.instruction instanceof Affectation)
		Assert.assertTrue(timeLoopJob.instruction instanceof InstructionBlock)
		val timeLoopJobBlock = timeLoopJob.instruction as InstructionBlock
		Assert.assertEquals(2, timeLoopJobBlock.instructions.size)
		Assert.assertTrue(timeLoopJobBlock.instructions.forall[x | x instanceof Affectation])

		// Apply the transformation
		try {
			step.transform(ir, null)
			Assert.assertTrue(true)
		} catch (IrTransformationException e) {
			Assert.fail(e.message)
		}

		// After transformation
		Assert.assertTrue(j1.instruction instanceof Affectation)
		Assert.assertTrue(j2.instruction instanceof Loop)
		Assert.assertEquals(2, timeLoopJobBlock.instructions.size)
		Assert.assertTrue(timeLoopJobBlock.instructions.forall[x | x instanceof Loop])
	}
}
