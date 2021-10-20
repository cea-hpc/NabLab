/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.tests.ir.interpreter

import com.google.inject.Inject
import fr.cea.nabla.ir.interpreter.Context
import fr.cea.nabla.ir.interpreter.NV0Bool
import fr.cea.nabla.ir.interpreter.NV0Int
import fr.cea.nabla.ir.interpreter.NV0Real
import fr.cea.nabla.ir.interpreter.NV1Int
import fr.cea.nabla.tests.CompilationChainHelper
import fr.cea.nabla.tests.NablaInjectorProvider
import fr.cea.nabla.tests.TestUtils
import java.util.logging.Logger
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.runner.RunWith

import static extension fr.cea.nabla.ir.IrRootExtensions.*

@RunWith(XtextRunner)
@InjectWith(NablaInjectorProvider)
class BinaryOperationsInterpreterTest extends AbstractBinaryOperationsInterpreterTest
{
	@Inject CompilationChainHelper compilationHelper
	@Inject extension TestUtils

	override assertGetValueOfNV0Bool_NV0Bool(String model)
	{
		val ir = compilationHelper.getIrForInterpretation(model, testGenModel)
		val context = new Context(Logger.getLogger(BinaryOperationsInterpreterTest.name), ir, null)

		assertVariableDefaultValue(ir.mainModule, context, "b1", new NV0Bool(true))
		assertVariableDefaultValue(ir.mainModule, context, "b2", new NV0Bool(true))
		assertVariableDefaultValue(ir.mainModule, context, "b3", new NV0Bool(false))

		assertVariableDefaultValue(ir.mainModule, context, "b4", new NV0Bool(false))
		assertVariableDefaultValue(ir.mainModule, context, "b5", new NV0Bool(true))
		assertVariableDefaultValue(ir.mainModule, context, "b6", new NV0Bool(false))

		assertVariableDefaultValue(ir.mainModule, context, "b7", new NV0Bool(false))
		assertVariableDefaultValue(ir.mainModule, context, "b8", new NV0Bool(true))
		assertVariableDefaultValue(ir.mainModule, context, "b9", new NV0Bool(true))
		assertVariableDefaultValue(ir.mainModule, context, "b10", new NV0Bool(false))
		assertVariableDefaultValue(ir.mainModule, context, "b11", new NV0Bool(true))
		assertVariableDefaultValue(ir.mainModule, context, "b12", new NV0Bool(false))
	}

	override assertGetValueOfNV0Int_NV0Int(String model)
	{
		val ir = compilationHelper.getIrForInterpretation(model, testGenModel)
		val context = new Context(Logger.getLogger(BinaryOperationsInterpreterTest.name), ir, null)

		assertVariableDefaultValue(ir.mainModule, context, "b1", new NV0Bool(false))
		assertVariableDefaultValue(ir.mainModule, context, "b2", new NV0Bool(true))
		assertVariableDefaultValue(ir.mainModule, context, "b3", new NV0Bool(true))
		assertVariableDefaultValue(ir.mainModule, context, "b4", new NV0Bool(false))
		assertVariableDefaultValue(ir.mainModule, context, "b5", new NV0Bool(false))
		assertVariableDefaultValue(ir.mainModule, context, "b6", new NV0Bool(true))
		assertVariableDefaultValue(ir.mainModule, context, "b7", new NV0Bool(true))
		assertVariableDefaultValue(ir.mainModule, context, "b8", new NV0Bool(true))	
		assertVariableDefaultValue(ir.mainModule, context, "b9", new NV0Bool(false))
		assertVariableDefaultValue(ir.mainModule, context, "b10", new NV0Bool(true))
		assertVariableDefaultValue(ir.mainModule, context, "b11", new NV0Bool(true))
		assertVariableDefaultValue(ir.mainModule, context, "b12", new NV0Bool(false))

		assertVariableDefaultValue(ir.mainModule, context, "n1", new NV0Int(3))
		assertVariableDefaultValue(ir.mainModule, context, "n2", new NV0Int(1))
		assertVariableDefaultValue(ir.mainModule, context, "n3", new NV0Int(6))
		assertVariableDefaultValue(ir.mainModule, context, "n4", new NV0Int(2))
		assertVariableDefaultValue(ir.mainModule, context, "n5", new NV0Int(2))
		assertVariableDefaultValue(ir.mainModule, context, "n6", new NV0Int(1))
	}

	override assertGetValueOfNV0Int_NV0Real(String model)
	{
		val ir = compilationHelper.getIrForInterpretation(model, testGenModel)
		val context = new Context(Logger.getLogger(BinaryOperationsInterpreterTest.name), ir, null)

		assertVariableDefaultValue(ir.mainModule, context, "b1", new NV0Bool(false))
		assertVariableDefaultValue(ir.mainModule, context, "b2", new NV0Bool(true))
		assertVariableDefaultValue(ir.mainModule, context, "b3", new NV0Bool(true))
		assertVariableDefaultValue(ir.mainModule, context, "b4", new NV0Bool(false))
		assertVariableDefaultValue(ir.mainModule, context, "b5", new NV0Bool(false))
		assertVariableDefaultValue(ir.mainModule, context, "b6", new NV0Bool(true))
		assertVariableDefaultValue(ir.mainModule, context, "b7", new NV0Bool(true))
		assertVariableDefaultValue(ir.mainModule, context, "b8", new NV0Bool(true))	
		assertVariableDefaultValue(ir.mainModule, context, "b9", new NV0Bool(false))
		assertVariableDefaultValue(ir.mainModule, context, "b10", new NV0Bool(true))
		assertVariableDefaultValue(ir.mainModule, context, "b11", new NV0Bool(true))
		assertVariableDefaultValue(ir.mainModule, context, "b12", new NV0Bool(false))

		assertVariableDefaultValue(ir.mainModule, context, "n1", new NV0Real(3.0))
		assertVariableDefaultValue(ir.mainModule, context, "n2", new NV0Real(1.0))
		assertVariableDefaultValue(ir.mainModule, context, "n3", new NV0Real(6.0))
		assertVariableDefaultValue(ir.mainModule, context, "n4", new NV0Real(2.0))
		assertVariableDefaultValue(ir.mainModule, context, "n5", new NV0Real(3.5))
	}

	override assertGetValueOfNV0Int_NV1Int(String model)
	{
		val ir = compilationHelper.getIrForInterpretation(model, testGenModel)
		val context = compilationHelper.getInterpreterContext(ir, jsonDefaultContent)

		assertVariableDefaultValue(ir.mainModule, context, "n1", new NV1Int(#[1, 2]))
		assertVariableValueInContext(ir.mainModule, context, "n1", new NV1Int(#[1, 2]))
		assertVariableValueInContext(ir.mainModule, context, "n2", new NV1Int(#[4, 5]))
		assertVariableValueInContext(ir.mainModule, context, "n3", new NV1Int(#[3, 6]))
	}
}