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
import fr.cea.nabla.tests.CompilationChainHelper
import fr.cea.nabla.tests.NablaInjectorProvider
import fr.cea.nabla.tests.TestUtils
import java.util.logging.ConsoleHandler
import java.util.logging.Level
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.runner.RunWith

@RunWith(XtextRunner)
@InjectWith(NablaInjectorProvider)
class JobInterpreterTest extends AbstractJobInterpreterTest
{
	@Inject CompilationChainHelper compilationHelper
	@Inject extension TestUtils

	override assertInterpreteInstructionJob(String model)
	{
		val irModule = compilationHelper.getIrModuleForInterpretation(model, testGenModel)
		val handler = new ConsoleHandler
		handler.level = Level::OFF
		val moduleInterpreter = new ModuleInterpreter(irModule, handler)
		val context = moduleInterpreter.interpreteWithOptionDefaultValues

		assertVariableValueInContext(irModule, context, "t", new NV0Real(5.0))
	}

	override assertInterpreteTimeLoopJob(String model)
	{
		val irModule = compilationHelper.getIrModuleForInterpretation(model, testGenModel)
		val handler = new ConsoleHandler
		handler.level = Level::OFF
		val moduleInterpreter = new ModuleInterpreter(irModule, handler)
		val context = moduleInterpreter.interpreteWithOptionDefaultValues
		assertVariableValueInContext(irModule, context, "t_n0", new NV0Real(0.0))
		assertVariableValueInContext(irModule, context, "n", new NV0Int(10))
		assertVariableValueInContext(irModule, context, "t_n", new NV0Real(0.09))
		assertVariableValueInContext(irModule, context, "t_nplus1", new NV0Real(0.1))
	}

	override assertInterpreteTimeLoopCopyJob(String model)
	{
		val irModule = compilationHelper.getIrModuleForInterpretation(model, testGenModel)
		val handler = new ConsoleHandler
		handler.level = Level::OFF
		val moduleInterpreter = new ModuleInterpreter(irModule, handler)
		val context = moduleInterpreter.interpreteWithOptionDefaultValues
		context.logVariables("After")
		assertVariableValueInContext(irModule, context, "u_n0", new NV0Real(4.0))
		assertVariableValueInContext(irModule, context, "u_n", new NV0Real(13.0))
	}
}