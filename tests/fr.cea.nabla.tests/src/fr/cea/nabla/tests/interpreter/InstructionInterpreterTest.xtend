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
import fr.cea.nabla.ir.interpreter.NV0Real
import fr.cea.nabla.ir.interpreter.NV1Real
import fr.cea.nabla.ir.interpreter.NV3Real
import fr.cea.nabla.tests.CompilationChainHelper
import fr.cea.nabla.tests.NablaInjectorProvider
import fr.cea.nabla.tests.TestUtils
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.Assert
import org.junit.runner.RunWith

import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.IrRootExtensions.*

@RunWith(XtextRunner)
@InjectWith(NablaInjectorProvider)
class InstructionInterpreterTest extends AbstractInstructionInterpreterTest
{
	@Inject CompilationChainHelper compilationHelper
	@Inject extension TestUtils

	override assertInterpreteVarDefinition(String model)
	{
		val ir = compilationHelper.getIrForInterpretation(model, testGenModel)
		val context = compilationHelper.getInterpreterContext(ir, jsonDefaultContent)
		assertVariableValueInContext(ir.mainModule, context, "t", new NV0Real(1.0))
	}

	override assertInterpreteInstructionBlock(String model)
	{
		val ir = compilationHelper.getIrForInterpretation(model, testGenModel)
		val context = compilationHelper.getInterpreterContext(ir, jsonDefaultContent)
		assertVariableValueInContext(ir.mainModule, context, "t", new NV0Real(1.0))
	}

	override assertInterpreteAffectation(String model)
	{
		val ir = compilationHelper.getIrForInterpretation(model, testGenModel)
		val context = compilationHelper.getInterpreterContext(ir, jsonDefaultContent)
		assertVariableValueInContext(ir.mainModule, context, "t", new NV0Real(1.0))
	}

	override assertInterpreteLoop(String model, int xQuads, int yQuads)
	{
		val ir = compilationHelper.getIrForInterpretation(model, testGenModel)
		val mainModule = ir.mainModule
		val context = compilationHelper.getInterpreterContext(ir, getJsonContent(xQuads, yQuads))
		val nbCells = xQuads * yQuads
		val double[] u = newDoubleArrayOfSize(nbCells)
		for (i : 0..<u.length)
			u.set(i, 1.0)
		assertVariableValueInContext(mainModule, context, "U", new NV1Real(u))

		val cjrVar = mainModule.getVariableByName("C")
		val cjr = (context.getVariableValue(cjrVar) as NV3Real).data

		val nbNodesOfCell = 4
		val xEdgeLength = 0.01 // TestUtils::getJsonContent
		val yEdgeLength = xEdgeLength
		for (j : 0..<nbCells)
		{
			for (r : 0..<nbNodesOfCell)
			{
				Assert.assertEquals(0.5*(xEdgeLength), Math.abs(cjr.get(j,r).get(0)), TestUtils.DoubleTolerance)
				Assert.assertEquals(0.5*(yEdgeLength), Math.abs(cjr.get(j,r).get(1)), TestUtils.DoubleTolerance)
			}
		}

		// Test reduction
		val bminVar = mainModule.getVariableByName("Bmin")
		val bmin = (context.getVariableValue(bminVar) as NV0Real).data
		Assert.assertEquals(-0.00390625, bmin, TestUtils.DoubleTolerance)
	}

	override assertInterpreteIf(String model, int xQuads, int yQuads)
	{
		val ir = compilationHelper.getIrForInterpretation(model, testGenModel)
		val context = compilationHelper.getInterpreterContext(ir, getJsonContent(xQuads, yQuads))

		val nbCells = xQuads * yQuads
		val double[] u = newDoubleArrayOfSize(nbCells)
		for (i : 0..<u.length)
			if (i % 2 == 0)
				u.set(i, 0.0)
			else
				u.set(i, 1.0)

		assertVariableValueInContext(ir.mainModule, context, "U", new NV1Real(u))
	}

	override assertInterpreteWhile(String model, int xQuads, int yQuads)
	{
		val ir = compilationHelper.getIrForInterpretation(model, testGenModel)
		val context = compilationHelper.getInterpreterContext(ir, getJsonContent(xQuads, yQuads))

		val nbCells = xQuads * yQuads
		val double[] u = newDoubleArrayOfSize(nbCells)
		for (i : 0..<u.length)
			u.set(i, 2.0)

		assertVariableValueInContext(ir.mainModule, context, "U", new NV1Real(u))
	}

	override assertInterpreteSetDefinition(String model, int xQuads, int yQuads)
	{
		val ir = compilationHelper.getIrForInterpretation(model, testGenModel)
		val context = compilationHelper.getInterpreterContext(ir, getJsonContent(xQuads, yQuads))

		val nbCells = xQuads * yQuads
		val double[] u = newDoubleArrayOfSize(nbCells)
		for (i : 0..<u.length)
			u.set(i, 1.0)

		assertVariableValueInContext(ir.mainModule, context, "U", new NV1Real(u))
	}

	override assertInterpreteExit(String model)
	{
		val ir = compilationHelper.getIrForInterpretation(model, testGenModel)
		try
		{
			compilationHelper.getInterpreterContext(ir, jsonDefaultContent)
			Assert::fail("Should throw exception")
		} 
		catch (RuntimeException e)
		{
			Assert.assertEquals("V must be less than 100", e.message)
		}
	}
}