/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.tests.ir.transformers

import com.google.inject.Inject
import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.ArgOrVarRef
import fr.cea.nabla.ir.ir.BinaryExpression
import fr.cea.nabla.ir.ir.InstructionBlock
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.VariableDeclaration
import fr.cea.nabla.ir.transformers.IrTransformationException
import fr.cea.nabla.ir.transformers.ReplaceOptionsByLocalVariables
import fr.cea.nabla.tests.CompilationChainHelper
import fr.cea.nabla.tests.NablaInjectorProvider
import fr.cea.nabla.tests.TestUtils
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(XtextRunner)
@InjectWith(NablaInjectorProvider)
class ReplaceOptionsByLocalVariablesTest
{
	@Inject extension TestUtils
	@Inject CompilationChainHelper compilationHelper
	val step = new ReplaceOptionsByLocalVariables

	@Test
	def void test1()
	{
		val model =
		'''
		«testModule»
		real[2] X{nodes};
		real my_opt;
		real u{cells};

		iterate n while (n < 2);

		// A job with a loop and an option
		J1: forall j in cells(), u^{n+1}{j} = u^{n}{j} + my_opt;
		'''

		val ir = compilationHelper.getRawIr(model, testGenModel)

		val j1 = ir.jobs.findFirst[x | x.name == "J1"]
		Assert.assertNotNull(j1)
		val my_opt = ir.variables.findFirst[x | x.name == "my_opt"]
		Assert.assertNotNull(my_opt)

		// Before transformation
		Assert.assertTrue(j1.instruction instanceof Loop)
		Assert.assertTrue((j1.instruction as Loop).body instanceof Affectation)
		val affect_before = (j1.instruction as Loop).body as Affectation
		Assert.assertTrue(affect_before.right instanceof BinaryExpression)
		Assert.assertTrue((affect_before.right as BinaryExpression).right instanceof ArgOrVarRef)
		val affect_right_before = (affect_before.right as BinaryExpression).right as ArgOrVarRef
		Assert.assertTrue(affect_right_before.target === my_opt)


		// Apply the transformation
		try {
			step.transform(ir, null)
			Assert.assertTrue(true)
		} catch (IrTransformationException e) {
			Assert.fail(e.message)
		}

		// After transformation
		Assert.assertTrue(j1.instruction instanceof InstructionBlock)
		val block = j1.instruction as InstructionBlock
		Assert.assertTrue(block.instructions.get(0) instanceof VariableDeclaration)
		Assert.assertTrue(block.instructions.get(1) instanceof Loop)
		Assert.assertTrue((block.instructions.get(1) as Loop).body instanceof Affectation)
		val affect_after = (block.instructions.get(1) as Loop).body as Affectation
		Assert.assertTrue(affect_after.right instanceof BinaryExpression)
		Assert.assertTrue((affect_after.right as BinaryExpression).right instanceof ArgOrVarRef)
		val affect_right_after = (affect_after.right as BinaryExpression).right as ArgOrVarRef
		Assert.assertFalse(affect_right_after.target === my_opt)
		Assert.assertTrue(affect_right_after.target.name == "tmp_my_opt")
	}
}
