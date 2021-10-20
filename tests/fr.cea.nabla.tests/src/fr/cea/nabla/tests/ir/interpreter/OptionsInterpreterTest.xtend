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
import fr.cea.nabla.ir.interpreter.NV0Int
import fr.cea.nabla.ir.interpreter.NV0Real
import fr.cea.nabla.ir.interpreter.NV1Int
import fr.cea.nabla.ir.interpreter.NV1Real
import fr.cea.nabla.ir.interpreter.NV2Real
import fr.cea.nabla.tests.CompilationChainHelper
import fr.cea.nabla.tests.NablaInjectorProvider
import fr.cea.nabla.tests.TestUtils
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.runner.RunWith

import static org.junit.Assert.assertThrows

import static extension fr.cea.nabla.ir.IrRootExtensions.*

@RunWith(XtextRunner)
@InjectWith(NablaInjectorProvider)
class OptionsInterpreterTest extends AbstractOptionsInterpreterTest
{
	@Inject CompilationChainHelper compilationHelper
	@Inject extension TestUtils

	override assertInterpreteDefaultOptions(String model)
	{
		val ir = compilationHelper.getIrForInterpretation(model, testGenModel)
		val context = compilationHelper.getInterpreterContext(ir, jsonDefaultContent)

		assertVariableValueInContext(ir.mainModule, context, "A", new NV0Int(10))
		assertVariableValueInContext(ir.mainModule, context, "B", new NV0Int(9))
		assertVariableValueInContext(ir.mainModule, context, "C", new NV0Real(25.0))
		assertVariableValueInContext(ir.mainModule, context, "D", new NV1Real(#[25.0, 25.0, 25.0]))
		assertVariableValueInContext(ir.mainModule, context, "M", new NV2Real(#[#[25.0, 25.0, 25.0],#[25.0, 25.0, 25.0]]))
	}

	override assertInterpreteJsonOptions(String model, String jsonContent)
	{
		val ir = compilationHelper.getIrForInterpretation(model, testGenModel)
		val context = compilationHelper.getInterpreterContext(ir, jsonContent)

		assertVariableValueInContext(ir.mainModule, context, "A", new NV0Int(8))
		assertVariableValueInContext(ir.mainModule, context, "B", new NV0Int(8))
		assertVariableValueInContext(ir.mainModule, context, "C", new NV0Real(27.0))
		assertVariableValueInContext(ir.mainModule, context, "D", new NV1Real(#[25.0, 12.12, 25.0]))
		assertVariableValueInContext(ir.mainModule, context, "M", new NV2Real(#[#[25.0, 13.13, 25.0],#[25.0, 25.0, 5.4]]))
	}

	override assertInterpreteDefaultMandatoryOptions(String model)
	{
		val ir = compilationHelper.getIrForInterpretation(model, testGenModel)
		assertThrows(IllegalStateException, [compilationHelper.getInterpreterContext(ir, jsonDefaultContent)])
	}

	override assertInterpreteJsonMandatoryOptions(String model, String jsonContent)
	{
		val ir = compilationHelper.getIrForInterpretation(model, testGenModel)
		val context = compilationHelper.getInterpreterContext(ir, jsonContent)

		assertVariableValueInContext(ir.mainModule, context, "A", new NV0Int(8))
		assertVariableValueInContext(ir.mainModule, context, "mandatory1", new NV1Int(#[1, 2]))
		assertVariableValueInContext(ir.mainModule, context, "mandatory2", new NV0Real(2.2))
		assertVariableValueInContext(ir.mainModule, context, "B", new NV0Real(4.4))
	}
}