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
import fr.cea.nabla.ir.interpreter.NV1Real
import fr.cea.nabla.ir.interpreter.NV2Real
import fr.cea.nabla.tests.CompilationChainHelper
import fr.cea.nabla.tests.NablaInjectorProvider
import fr.cea.nabla.tests.TestUtils
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.Assert
import org.junit.runner.RunWith

import static extension fr.cea.nabla.ir.IrRootExtensions.*

@RunWith(XtextRunner)
@InjectWith(NablaInjectorProvider)
class OptionsInterpreterTest extends AbstractOptionsInterpreterTest
{
	@Inject CompilationChainHelper compilationHelper
	@Inject extension TestUtils

	override assertInterpreteOptions(String model)
	{
		val ir = compilationHelper.getIrForInterpretation(model, testGenModel)
		val thrown = Assert.assertThrows(IllegalStateException, [compilationHelper.getInterpreterContext(ir, jsonDefaultContent) ])
		Assert.assertEquals("Missing option in Json file: A", thrown.message)
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
}