/*******************************************************************************
 * Copyright (c) 2021 CEA
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
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.transformers.CompositeTransformationStep
import fr.cea.nabla.ir.transformers.CreateInitVariableJobs
import fr.cea.nabla.ir.transformers.FillJobHLTs
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
class CreateInitVariableJobsTest
{
	@Inject extension TestUtils
	@Inject CompilationChainHelper compilationHelper
	val step = new CompositeTransformationStep("Transformation Test", #[new CreateInitVariableJobs, new FillJobHLTs])

	@Test
	def void testNoJobForConstExprVar()
	{
		val model =
		'''
		«testModule»
		ℝ[2] X{nodes};
		let ℝ my_const_expr_real = 3.3;
		let ℕ[3] my_const_expr_array_int = [1 , 2 , 3];
		'''

		val ir = compilationHelper.getRawIr(model, testGenModel)
		Assert.assertEquals(0, ir.jobs.size)
		Assert.assertTrue(isConstExpr(ir, "my_const_expr_real"))
		Assert.assertTrue(isConstExpr(ir, "my_const_expr_array_int"))

		Assert.assertTrue(step.transform(ir))

		Assert.assertEquals(0, ir.jobs.size)
	}

	@Test
	def void testJobForVarDefaultValue()
	{
		val model =
		'''
		«testModule»
		ℝ[2] X{nodes};
		let ℝ my_real = 3.3;
		let ℕ[3] my_array_int = [1 , 2 , 3];

		Job: { 
			my_real = 4.4;
			my_array_int = [4, 5, 6];
		}
		'''

		val ir = compilationHelper.getRawIr(model, testGenModel)
		Assert.assertEquals(1, ir.jobs.size)
		Assert.assertEquals("Job", ir.jobs.head.name)
		Assert.assertFalse(isConstExpr(ir, "my_real"))
		Assert.assertFalse(isConstExpr(ir, "my_array_int"))

		Assert.assertTrue(step.transform(ir))

		Assert.assertEquals(3, ir.jobs.size)

		val job = ir.jobs.findFirst[x | x.name == "Job"]
		Assert.assertNotNull(job)

		val init_my_real_job = getInitJobFor(ir, "my_real")
		Assert.assertNotNull(init_my_real_job)

		val init_my_array_int_job = getInitJobFor(ir, "my_array_int")
		Assert.assertNotNull(init_my_array_int_job)

		Assert.assertEquals(1.0, job.at, 0.0)
		Assert.assertEquals(1.0, init_my_real_job.at, 0.0)
		Assert.assertEquals(1.0, init_my_array_int_job.at, 0.0)
	}

	@Test
	def void testJobForOptions()
	{
		val model =
		'''
		«testModule»
		ℝ[2] X{nodes};
		option ℝ my_real = 3.3;
		option ℕ[3] my_array_int = [1 , 2 , 3];
		option ℝ my_second_real = 2.0 * my_real;
		'''

		val ir = compilationHelper.getRawIr(model, testGenModel)
		Assert.assertEquals(0, ir.jobs.size)
		Assert.assertFalse(isConstExpr(ir, "my_real"))
		Assert.assertFalse(isConstExpr(ir, "my_array_int"))
		Assert.assertFalse(isConstExpr(ir, "my_second_real"))

		Assert.assertTrue(step.transform(ir))

		Assert.assertEquals(3, ir.jobs.size)

		val init_my_real_job = getInitJobFor(ir, "my_real")
		Assert.assertNotNull(init_my_real_job)

		val init_my_array_int_job = getInitJobFor(ir, "my_array_int")
		Assert.assertNotNull(init_my_array_int_job)

		val init_my_second_real_job = getInitJobFor(ir, "my_second_real")
		Assert.assertNotNull(init_my_second_real_job)

		Assert.assertEquals("my_real", init_my_real_job.outVars.head.name)
		Assert.assertEquals("my_real", init_my_second_real_job.inVars.head.name)
		Assert.assertEquals(1.0, init_my_real_job.at, 0.0)
		Assert.assertEquals(1.0, init_my_array_int_job.at, 0.0)
		Assert.assertEquals(2.0, init_my_second_real_job.at, 0.0)
		Assert.assertEquals(1, init_my_second_real_job.previousJobs.size)
		Assert.assertEquals(init_my_real_job, init_my_second_real_job.previousJobs.head)
	}

	@Test
	def void testJobForDynamicArrayAllocation()
	{
		val model =
		'''
		«testModule»
		ℝ[2] X{nodes};
		ℕ dim;
		ℝ[dim] my_array_real;

		InitiliazeDim: {
			dim = 3;
		}
		'''

		val ir = compilationHelper.getRawIr(model, testGenModel)
		Assert.assertEquals(1, ir.jobs.size)
		Assert.assertEquals("InitiliazeDim", ir.jobs.head.name)

		Assert.assertTrue(step.transform(ir))

		Assert.assertEquals(2, ir.jobs.size)

		val initialize_dim_job = ir.jobs.findFirst[x | x.name == "InitiliazeDim"]
		Assert.assertNotNull(initialize_dim_job)

		val init_my_array_real_job = getInitJobFor(ir, "my_array_real")
		Assert.assertNotNull(init_my_array_real_job)

		Assert.assertEquals("dim", initialize_dim_job.outVars.head.name)
		Assert.assertEquals("dim", init_my_array_real_job.inVars.head.name)
		Assert.assertEquals(1.0, initialize_dim_job.at, 0.0)
		Assert.assertEquals(2.0, init_my_array_real_job.at, 0.0)
		Assert.assertEquals(1, init_my_array_real_job.previousJobs.size)
		Assert.assertEquals(initialize_dim_job, init_my_array_real_job.previousJobs.head)
	}

	private def Job getInitJobFor(IrRoot ir, String variableName)
	{
		ir.jobs.findFirst[x | x.name == JobExtensions.INIT_VARIABLE_PREFIX + variableName]
	}

	private def boolean isConstExpr(IrRoot ir, String variableName)
	{
		ir.variables.findFirst[x | x.name == variableName].constExpr
	}
}