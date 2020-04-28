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
abstract class AbstractJobInterpreterTest 
{
	@Inject extension TestUtils

	@Test
	def void testInterpreteInstructionJob()
	{
		val model = testModuleForSimulation
		+
		'''
		ℝ[2] X{nodes};
		initT : t = 5.;
		'''

		assertInterpreteInstructionJob(model)
	}

	@Test
	def void testInterpreteTimeLoopJob()
	{
		val model = testModuleForSimulation
		+
		'''
		// Simulation options
		let option_stoptime = 0.2;
		let option_max_iterations = 10;
		ℝ[2] X{nodes};

		iterate n while (t^{n} < option_stoptime && n < option_max_iterations);

		InitT: t^{n=0} = 0.;
		ComputeTn: t^{n+1} = t^{n} + 0.01;
		'''

		assertInterpreteTimeLoopJob(model)
	}

	@Test
	def void testInterpreteTimeLoopCopyJob()
	{
		val model = getTestModule(10,10)
		+
		'''
		// Simulation options
		let option_stoptime = 0.2;
		let option_max_iterations = 10;
		ℝ[2] u, X{nodes}, center{cells};

		iterate n while (t^{n} < option_stoptime && n < option_max_iterations);

		ComputeUx : u^{n}[0] = u^{n=0}[0] + 1.0;
		ComputeUy : u^{n}[1] = u^{n=0}[1] + 2.0;
		IniCenter: ∀j∈cells(), center{j} = 0.25 * ∑{r∈nodesOfCell(j)}(X^{n=0}{r});
		'''

		assertInterpreteTimeLoopCopyJob(model)
	}
	
	def void assertInterpreteInstructionJob(String model)

	def void assertInterpreteTimeLoopJob(String model)

	def void assertInterpreteTimeLoopCopyJob(String model)
}