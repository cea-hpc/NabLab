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
import fr.cea.nabla.ir.interpreter.NV2Real
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
class OptionsInterpreterTest extends AbstractOptionsInterpreterTest
{
	@Inject CompilationChainHelper compilationHelper
	@Inject extension TestUtils

	override assertInterpreteDefaultOptions(String model)
	{
		val irModule = compilationHelper.getIrModuleForInterpretation(model, testGenModel)
		val handler = new ConsoleHandler
		handler.level = Level::OFF
		val moduleInterpreter = new ModuleInterpreter(irModule, handler)

		val context = moduleInterpreter.interpreteWithOptionDefaultValues
		assertVariableValueInContext(irModule, context, "A", new NV0Int(10))
		assertVariableValueInContext(irModule, context, "B", new NV0Int(9))
		assertVariableValueInContext(irModule, context, "C", new NV0Real(25.0))
		assertVariableValueInContext(irModule, context, "D", new NV1Real(#[25.0, 25.0, 25.0]))
		assertVariableValueInContext(irModule, context, "M", new NV2Real(#[#[25.0, 25.0, 25.0],#[25.0, 25.0, 25.0]]))
	}

	override assertInterpreteJsonOptions(String model, String jsonOptions)
	{
		val irModule = compilationHelper.getIrModuleForInterpretation(model, testGenModel)
		val handler = new ConsoleHandler
		handler.level = Level::OFF
		val moduleInterpreter = new ModuleInterpreter(irModule, handler)

		val context = moduleInterpreter.interprete(jsonOptions)
		assertVariableValueInContext(irModule, context, "A", new NV0Int(10))
		assertVariableValueInContext(irModule, context, "B", new NV0Int(2))
		assertVariableValueInContext(irModule, context, "C", new NV0Real(27.0))
		assertVariableValueInContext(irModule, context, "D", new NV1Real(#[25.0, 12.12, 25.0]))
		assertVariableValueInContext(irModule, context, "M", new NV2Real(#[#[25.0, 13.13, 25.0],#[25.0, 25.0, 5.4]]))
	}
}