/*******************************************************************************
 * Copyright (c) 2022 CEA
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
abstract class AbstractJobInterpreterTest
{
	@Inject extension TestUtils

	@Test
	def void testInterpreteInstructionJob()
	{
		val model =
		'''
		«testModule»
		real[2] X{nodes};
		InitT : t = 5.;
		'''
		assertInterpreteInstructionJob(model)
	}

	@Test
	def void testInterpreteTimeLoopJob()
	{
		val model =
		'''
		«testModule»
		// Simulation options
		let real option_stoptime = 0.2;
		let int option_max_iterations = 10;
		real[2] X{nodes};

		iterate n while (t^{n+1} < option_stoptime && n < option_max_iterations);

		InitT: t^{n=0} = 0.;
		ComputeTn: t^{n+1} = t^{n} + 0.01;
		'''
		assertInterpreteTimeLoopJob(model)
	}

	@Test
	def void testInterpreteTimeLoopCopyJob()
	{
		val model =
		'''
		«testModule»
		// Simulation options
		let real option_stoptime = 0.2;
		let int option_max_iterations = 10;
		real u;
		real[2] X{nodes}, center{cells};

		iterate n while (t^{n+1} < option_stoptime && n < option_max_iterations);

		InitTime: t^{n=0} = 0.0;
		IniU : u^{n=0} = 4.0;
		IniCenter: forall j in cells(), center{j} = 0.25 * sum{r in nodesOfCell(j)}(X^{n=0}{r});
		UpdateU: u^{n+1} = u^{n} + 1;
		'''
		assertInterpreteTimeLoopCopyJob(model)
	}

	def void assertInterpreteInstructionJob(String model)
	def void assertInterpreteTimeLoopJob(String model)
	def void assertInterpreteTimeLoopCopyJob(String model)
}