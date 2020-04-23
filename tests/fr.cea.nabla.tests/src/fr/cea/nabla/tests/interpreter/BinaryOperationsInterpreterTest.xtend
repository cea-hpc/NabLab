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
import fr.cea.nabla.ir.interpreter.Context
import fr.cea.nabla.ir.interpreter.ModuleInterpreter
import fr.cea.nabla.ir.interpreter.NV0Bool
import fr.cea.nabla.ir.interpreter.NV0Int
import fr.cea.nabla.ir.interpreter.NV0Real
import fr.cea.nabla.ir.interpreter.NV1Int
import fr.cea.nabla.tests.CompilationChainHelper
import fr.cea.nabla.tests.NablaInjectorProvider
import fr.cea.nabla.tests.TestUtils
import java.util.logging.ConsoleHandler
import java.util.logging.Level
import java.util.logging.Logger
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.runner.RunWith

@RunWith(XtextRunner)
@InjectWith(NablaInjectorProvider)
class BinaryOperationsInterpreterTest extends AbstractBinaryOperationsInterpreterTest
{
	@Inject CompilationChainHelper compilationHelper
	@Inject extension TestUtils

	override assertGetValueOfNV0Bool_NV0Bool(String model)
	{
		val irModule = compilationHelper.getIrModule(model, testGenModel)
		val context = new Context(irModule, Logger.getLogger(BinaryOperationsInterpreterTest.name))

		assertVariableDefaultValue(irModule, context, "b1", new NV0Bool(true))
		assertVariableDefaultValue(irModule, context, "b2", new NV0Bool(true))
		assertVariableDefaultValue(irModule, context, "b3", new NV0Bool(false))

		assertVariableDefaultValue(irModule, context, "b4", new NV0Bool(false))
		assertVariableDefaultValue(irModule, context, "b5", new NV0Bool(true))
		assertVariableDefaultValue(irModule, context, "b6", new NV0Bool(false))

		assertVariableDefaultValue(irModule, context, "b7", new NV0Bool(false))
		assertVariableDefaultValue(irModule, context, "b8", new NV0Bool(true))
		assertVariableDefaultValue(irModule, context, "b9", new NV0Bool(true))
		assertVariableDefaultValue(irModule, context, "b10", new NV0Bool(false))
		assertVariableDefaultValue(irModule, context, "b11", new NV0Bool(true))
		assertVariableDefaultValue(irModule, context, "b12", new NV0Bool(false))
	}

	override assertGetValueOfNV0Int_NV0Int(String model)
	{
		val irModule = compilationHelper.getIrModule(model, testGenModel)
		val context = new Context(irModule, Logger.getLogger(BinaryOperationsInterpreterTest.name))

		assertVariableDefaultValue(irModule, context, "b1", new NV0Bool(false))
		assertVariableDefaultValue(irModule, context, "b2", new NV0Bool(true))
		assertVariableDefaultValue(irModule, context, "b3", new NV0Bool(true))
		assertVariableDefaultValue(irModule, context, "b4", new NV0Bool(false))
		assertVariableDefaultValue(irModule, context, "b5", new NV0Bool(false))
		assertVariableDefaultValue(irModule, context, "b6", new NV0Bool(true))
		assertVariableDefaultValue(irModule, context, "b7", new NV0Bool(true))
		assertVariableDefaultValue(irModule, context, "b8", new NV0Bool(true))	
		assertVariableDefaultValue(irModule, context, "b9", new NV0Bool(false))
		assertVariableDefaultValue(irModule, context, "b10", new NV0Bool(true))
		assertVariableDefaultValue(irModule, context, "b11", new NV0Bool(true))
		assertVariableDefaultValue(irModule, context, "b12", new NV0Bool(false))

		assertVariableDefaultValue(irModule, context, "n1", new NV0Int(3))
		assertVariableDefaultValue(irModule, context, "n2", new NV0Int(1))
		assertVariableDefaultValue(irModule, context, "n3", new NV0Int(6))
		assertVariableDefaultValue(irModule, context, "n4", new NV0Int(2))
		assertVariableDefaultValue(irModule, context, "n5", new NV0Int(2))
		assertVariableDefaultValue(irModule, context, "n6", new NV0Int(1))
	}

	override assertGetValueOfNV0Int_NV0Real(String model)
	{
		val irModule = compilationHelper.getIrModule(model, testGenModel)
		val context = new Context(irModule, Logger.getLogger(BinaryOperationsInterpreterTest.name))

		assertVariableDefaultValue(irModule, context, "b1", new NV0Bool(false))
		assertVariableDefaultValue(irModule, context, "b2", new NV0Bool(true))
		assertVariableDefaultValue(irModule, context, "b3", new NV0Bool(true))
		assertVariableDefaultValue(irModule, context, "b4", new NV0Bool(false))
		assertVariableDefaultValue(irModule, context, "b5", new NV0Bool(false))
		assertVariableDefaultValue(irModule, context, "b6", new NV0Bool(true))
		assertVariableDefaultValue(irModule, context, "b7", new NV0Bool(true))
		assertVariableDefaultValue(irModule, context, "b8", new NV0Bool(true))	
		assertVariableDefaultValue(irModule, context, "b9", new NV0Bool(false))
		assertVariableDefaultValue(irModule, context, "b10", new NV0Bool(true))
		assertVariableDefaultValue(irModule, context, "b11", new NV0Bool(true))
		assertVariableDefaultValue(irModule, context, "b12", new NV0Bool(false))

		assertVariableDefaultValue(irModule, context, "n1", new NV0Real(3.0))
		assertVariableDefaultValue(irModule, context, "n2", new NV0Real(1.0))
		assertVariableDefaultValue(irModule, context, "n3", new NV0Real(6.0))
		assertVariableDefaultValue(irModule, context, "n4", new NV0Real(2.0))
		assertVariableDefaultValue(irModule, context, "n5", new NV0Real(3.5))
	}

	override assertGetValueOfNV0Int_NV1Int(String model)
	{
		val irModule = compilationHelper.getIrModule(model, testGenModel)
		val handler = new ConsoleHandler
		handler.level = Level::OFF
		val moduleInterpreter = new ModuleInterpreter(irModule, handler)
		val context = moduleInterpreter.interprete

		assertVariableDefaultValue(irModule, context, "n1", new NV1Int(#[1, 2]))
		assertVariableValueInContext(irModule, context, "n1", new NV1Int(#[1, 2]))
		assertVariableValueInContext(irModule, context, "n2", new NV1Int(#[4, 5]))
		assertVariableValueInContext(irModule, context, "n3", new NV1Int(#[3, 6]))
	}
}