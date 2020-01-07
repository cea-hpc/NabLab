/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.tests

import com.google.inject.Inject
import fr.cea.nabla.ir.interpreter.ModuleInterpreter
import fr.cea.nabla.ir.interpreter.NV0Real
import fr.cea.nabla.ir.interpreter.NV1Real
import java.util.logging.ConsoleHandler
import java.util.logging.Level
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

import static fr.cea.nabla.tests.TestUtils.*

@RunWith(XtextRunner)
@InjectWith(NablaInjectorProvider)
class JobInterpreterTest 
{
	@Inject CompilationChainHelper compilationHelper

	@Test
	def void testInterpreteInSituJob()
	{
		//TODO
	}

	@Test
	def void testInterpreteInstructionJob()
	{
		val model = TestUtils::testModule
		+
		'''
		initT : t = 5.;
		'''

		val irModule = compilationHelper.getIrModule(model, TestUtils::testGenModel)
		val handler = new ConsoleHandler
		handler.level = Level::OFF
		val moduleInterpreter = new ModuleInterpreter(irModule, handler)
		val context = moduleInterpreter.interprete

		assertVariableValueInContext(irModule, context, "t", new NV0Real(5.0))
	}

	@Test
	def void testInterpreteEndOfInitJob()
	{
		val model = TestUtils::testModule
		+
		'''
		ℝ[2] u;
		ℝ[2] center{cells};
		ComputeUx : u[0] = u^{n=0}[0] + 1.0;
		ComputeUy : u[1] = u^{n=0}[1] + 2.0;
		IniCenter: ∀j∈cells(), center{j} = 0.25 * ∑{r∈nodesOfCell(j)}(X^{n=0}{r});
		'''

		val irModule = compilationHelper.getIrModule(model, TestUtils::testGenModel)
		val handler = new ConsoleHandler
		handler.level = Level::OFF
		val moduleInterpreter = new ModuleInterpreter(irModule, handler)
		val context = moduleInterpreter.interprete
		context.logVariables("After")
		//assertVariableValueInContext(irModule, context, "u_n0", new NV1Real(#[0.0 , 0.0]))
		assertVariableValueInContext(irModule, context, "u", new NV1Real(#[1.0 , 2.0]))
		val X_n0 = context.getVariableValue("X_n0")
		assertVariableValueInContext(irModule, context, "X", X_n0)
	}

	@Test
	def void testInterpreteEndOfTimeLoopJob()
	{
		val model = TestUtils::testModule
		+
		'''
		InitT: t = 0.;
		ComputeTn: t^{n+1} = t + 0.01;
		'''

		val irModule = compilationHelper.getIrModule(model, TestUtils::testGenModel)
		val handler = new ConsoleHandler
		handler.level = Level::OFF
		val moduleInterpreter = new ModuleInterpreter(irModule, handler)
		val context = moduleInterpreter.interprete
		assertVariableValueInContext(irModule, context, "t", new NV0Real(0.01))
		assertVariableValueInContext(irModule, context, "t_nplus1", new NV0Real(0.00))
	}
}