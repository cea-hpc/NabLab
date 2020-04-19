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
import fr.cea.nabla.ir.interpreter.ModuleInterpreter
import fr.cea.nabla.ir.interpreter.NV0Int
import fr.cea.nabla.ir.interpreter.NV0Real
import fr.cea.nabla.ir.interpreter.NV1Real
import fr.cea.nabla.tests.CompilationChainHelper
import fr.cea.nabla.tests.NablaInjectorProvider
import fr.cea.nabla.tests.TestUtils
import java.util.logging.ConsoleHandler
import java.util.logging.Level
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(XtextRunner)
@InjectWith(NablaInjectorProvider)
class JobInterpreterTest 
{
	@Inject CompilationChainHelper compilationHelper
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

		val irModule = compilationHelper.getIrModule(model, testGenModel)
		val handler = new ConsoleHandler
		handler.level = Level::OFF
		val moduleInterpreter = new ModuleInterpreter(irModule, handler)
		val context = moduleInterpreter.interprete

		assertVariableValueInContext(irModule, context, "t", new NV0Real(5.0))
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

		val irModule = compilationHelper.getIrModule(model, testGenModel)
		val handler = new ConsoleHandler
		handler.level = Level::OFF
		val moduleInterpreter = new ModuleInterpreter(irModule, handler)
		val context = moduleInterpreter.interprete
		assertVariableValueInContext(irModule, context, "t_n0", new NV0Real(0.0))
		assertVariableValueInContext(irModule, context, "n", new NV0Int(10))
		assertVariableValueInContext(irModule, context, "t_n", new NV0Real(0.09))
		assertVariableValueInContext(irModule, context, "t_nplus1", new NV0Real(0.1))
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

		val irModule = compilationHelper.getIrModule(model, testGenModel)
		val handler = new ConsoleHandler
		handler.level = Level::OFF
		val moduleInterpreter = new ModuleInterpreter(irModule, handler)
		val context = moduleInterpreter.interprete
		context.logVariables("After")
		assertVariableValueInContext(irModule, context, "u_n0", new NV1Real(#[0.0 , 0.0]))
		assertVariableValueInContext(irModule, context, "u_n", new NV1Real(#[1.0 , 2.0]))
		val X_n0 = context.getVariableValue("X_n0")
		assertVariableValueInContext(irModule, context, "X_n", X_n0)
	}
}