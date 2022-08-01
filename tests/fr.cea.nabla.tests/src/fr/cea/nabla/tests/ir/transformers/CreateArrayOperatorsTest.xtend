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
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.BinaryExpression
import fr.cea.nabla.ir.ir.Function
import fr.cea.nabla.ir.ir.FunctionCall
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.PrimitiveType
import fr.cea.nabla.ir.ir.UnaryExpression
import fr.cea.nabla.ir.transformers.CreateArrayOperators
import fr.cea.nabla.ir.transformers.IrTransformationException
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
class CreateArrayOperatorsTest
{
	@Inject extension TestUtils
	@Inject CompilationChainHelper compilationHelper
	val step = new CreateArrayOperators

	@Test
	def void checkNoArrayOperationCreated()
	{
		val model =
		'''
		«testModule»
		real[2] X{nodes};

		real x, y;

		iterate n while (n < 2);

		// scalar affectation => no change
		J1: x = y + 1;
		'''

		val ir = compilationHelper.getRawIr(model, testGenModel)
		Assert.assertEquals(1, ir.modules.size)
		val mainModule = ir.modules.head

		// Before transformation
		Assert.assertTrue(mainModule.functions.empty)

		// Apply the transformation
		try {
			step.transform(ir, null)
			Assert.assertTrue(true)
		} catch (IrTransformationException e) {
			Assert.fail(e.message)
		}

		// After transformation
		Assert.assertTrue(mainModule.functions.empty)
	}

	@Test
	def void checkUnaryArrayOperationsCreated()
	{
		val model =
		'''
		«testModule»
		real[2] X{nodes};

		real[2] x, y;
		real[3] z;

		iterate n while (n < 2);

		J1: x = -y;
		J2: z = -z; // same operator than J1
		'''

		val ir = compilationHelper.getRawIr(model, testGenModel)
		Assert.assertEquals(1, ir.modules.size)
		val mainModule = ir.modules.head

		// Before transformation
		Assert.assertEquals(3, mainModule.jobs.size) // J* + ExecuteTimeLoopJob
		checkUnaryOp(ir, "J1", 2, PrimitiveType.REAL, 1)
		checkUnaryOp(ir, "J2", 3, PrimitiveType.REAL, 1)
		Assert.assertTrue(mainModule.functions.empty)

		// Apply the transformation
		try {
			step.transform(ir, null)
			Assert.assertTrue(true)
		} catch (IrTransformationException e) {
			Assert.fail(e.message)
		}

		// After transformation
		Assert.assertEquals(3, mainModule.jobs.size) // J* + ExecuteTimeLoopJob
		checkFunctionCall(ir, "J1", 2, PrimitiveType.REAL, 1)
		checkFunctionCall(ir, "J2", 3, PrimitiveType.REAL, 1)

		Assert.assertEquals(1, mainModule.functions.size)
		checkOperatorFunction(mainModule.functions.get(0), PrimitiveType.REAL, 1)
	}

	@Test
	def void checkBinaryArrayOperationsCreated()
	{
		val model =
		'''
		«testModule»
		real[2] X{nodes};

		real[2] x, y;
		real[3] z;

		iterate n while (n < 2);

		J1: x = y + 1;
		J2: x = x + y;
		J3: x = 1 + y;
		J4: z = 3 + z; // same operator than J3
		'''

		val ir = compilationHelper.getRawIr(model, testGenModel)
		Assert.assertEquals(1, ir.modules.size)
		val mainModule = ir.modules.head

		// Before transformation
		Assert.assertEquals(5, mainModule.jobs.size) // J* + ExecuteTimeLoopJob
		checkBinaryOp(ir, "J1", 2, PrimitiveType.REAL, 1, PrimitiveType.INT, 0)
		checkBinaryOp(ir, "J2", 2, PrimitiveType.REAL, 1, PrimitiveType.REAL, 1)
		checkBinaryOp(ir, "J3", 2, PrimitiveType.INT, 0, PrimitiveType.REAL, 1)
		checkBinaryOp(ir, "J4", 3, PrimitiveType.INT, 0, PrimitiveType.REAL, 1)
		Assert.assertTrue(mainModule.functions.empty)

		// Apply the transformation
		try {
			step.transform(ir, null)
			Assert.assertTrue(true)
		} catch (IrTransformationException e) {
			Assert.fail(e.message)
		}

		// After transformation
		Assert.assertEquals(5, mainModule.jobs.size) // J* + ExecuteTimeLoopJob
		checkFunctionCall(ir, "J1", 2, PrimitiveType.REAL, 1, PrimitiveType.INT, 0)
		checkFunctionCall(ir, "J2", 2, PrimitiveType.REAL, 1, PrimitiveType.REAL, 1)
		checkFunctionCall(ir, "J3", 2, PrimitiveType.INT, 0, PrimitiveType.REAL, 1)
		checkFunctionCall(ir, "J4", 3, PrimitiveType.INT, 0, PrimitiveType.REAL, 1)

		Assert.assertEquals(3, mainModule.functions.size)
		checkOperatorFunction(mainModule.functions.get(0), PrimitiveType.REAL, 1, PrimitiveType.INT, 0)
		checkOperatorFunction(mainModule.functions.get(1), PrimitiveType.REAL, 1, PrimitiveType.REAL, 1)
		checkOperatorFunction(mainModule.functions.get(2), PrimitiveType.INT, 0, PrimitiveType.REAL, 1)
	}

	private def checkUnaryOp(IrRoot ir, String jobName, int arraySize, PrimitiveType exprPrimitive, int exprDim)
	{
		val j = ir.jobs.findFirst[x | x.name == jobName]
		Assert.assertNotNull(j)
		Assert.assertTrue(j.instruction instanceof Affectation)
		Assert.assertTrue((j.instruction as Affectation).right instanceof UnaryExpression)
		val op = (j.instruction as Affectation).right as UnaryExpression

		Assert.assertTrue(op.type instanceof BaseType)
		val opType = op.type as BaseType
		Assert.assertEquals(PrimitiveType.REAL, opType.primitive)
		Assert.assertEquals(1, opType.sizes.size)
		Assert.assertEquals(arraySize, opType.intSizes.get(0))

		Assert.assertTrue(op.expression.type instanceof BaseType)
		val exprType = op.expression.type as BaseType
		Assert.assertEquals(exprPrimitive, exprType.primitive)
		Assert.assertEquals(exprDim, exprType.sizes.size)
	}

	private def checkBinaryOp(IrRoot ir, String jobName, int arraySize, PrimitiveType leftPrimitive, int leftDim, PrimitiveType rightPrimitive, int rightDim)
	{
		val j = ir.jobs.findFirst[x | x.name == jobName]
		Assert.assertNotNull(j)
		Assert.assertTrue(j.instruction instanceof Affectation)
		Assert.assertTrue((j.instruction as Affectation).right instanceof BinaryExpression)
		val binOp = (j.instruction as Affectation).right as BinaryExpression

		Assert.assertTrue(binOp.type instanceof BaseType)
		val binOpType = binOp.type as BaseType
		Assert.assertEquals(PrimitiveType.REAL, binOpType.primitive)
		Assert.assertEquals(1, binOpType.sizes.size)
		Assert.assertEquals(arraySize, binOpType.intSizes.get(0))

		Assert.assertTrue(binOp.left.type instanceof BaseType)
		val leftBinOpType = binOp.left.type as BaseType
		Assert.assertEquals(leftPrimitive, leftBinOpType.primitive)
		Assert.assertEquals(leftDim, leftBinOpType.sizes.size)

		Assert.assertTrue(binOp.right.type instanceof BaseType)
		val rightBinOpType = binOp.right.type as BaseType
		Assert.assertEquals(rightPrimitive, rightBinOpType.primitive)
		Assert.assertEquals(rightDim, rightBinOpType.sizes.size)
	}

	private def checkFunctionCall(IrRoot ir, String jobName, int arraySize, PrimitiveType argPrimitive, int argDim)
	{
		val j = ir.jobs.findFirst[x | x.name == jobName]
		Assert.assertNotNull(j)
		Assert.assertTrue(j.instruction instanceof Affectation)
		Assert.assertTrue((j.instruction as Affectation).right instanceof FunctionCall)
		val fCall = (j.instruction as Affectation).right as FunctionCall

		Assert.assertTrue(fCall.type instanceof BaseType)
		val fCallType = fCall.type as BaseType
		Assert.assertEquals(PrimitiveType.REAL, fCallType.primitive)
		Assert.assertEquals(1, fCallType.sizes.size)
		Assert.assertEquals(arraySize, fCallType.intSizes.get(0))
		Assert.assertEquals(1, fCall.args.size)

		Assert.assertTrue(fCall.args.get(0).type instanceof BaseType)
		val argType = fCall.args.get(0).type as BaseType
		Assert.assertEquals(argPrimitive, argType.primitive)
		Assert.assertEquals(argDim, argType.sizes.size)
	}

	private def checkFunctionCall(IrRoot ir, String jobName, int arraySize, PrimitiveType arg0Primitive, int arg0Dim, PrimitiveType arg1Primitive, int arg1Dim)
	{
		val j = ir.jobs.findFirst[x | x.name == jobName]
		Assert.assertNotNull(j)
		Assert.assertTrue(j.instruction instanceof Affectation)
		Assert.assertTrue((j.instruction as Affectation).right instanceof FunctionCall)
		val fCall = (j.instruction as Affectation).right as FunctionCall

		Assert.assertTrue(fCall.type instanceof BaseType)
		val fCallType = fCall.type as BaseType
		Assert.assertEquals(PrimitiveType.REAL, fCallType.primitive)
		Assert.assertEquals(1, fCallType.sizes.size)
		Assert.assertEquals(arraySize, fCallType.intSizes.get(0))
		Assert.assertEquals(2, fCall.args.size)

		Assert.assertTrue(fCall.args.get(0).type instanceof BaseType)
		val arg0Type = fCall.args.get(0).type as BaseType
		Assert.assertEquals(arg0Primitive, arg0Type.primitive)
		Assert.assertEquals(arg0Dim, arg0Type.sizes.size)

		Assert.assertTrue(fCall.args.get(1).type instanceof BaseType)
		val arg1Type = fCall.args.get(1).type as BaseType
		Assert.assertEquals(arg1Primitive, arg1Type.primitive)
		Assert.assertEquals(arg1Dim, arg1Type.sizes.size)
	}

	private def checkOperatorFunction(Function f, PrimitiveType argPrimitive, int argDim)
	{
		Assert.assertNotNull(f)

		Assert.assertTrue(f.returnType instanceof BaseType)
		val fType = f.returnType as BaseType
		Assert.assertEquals(PrimitiveType.REAL, fType.primitive)
		Assert.assertEquals(1, fType.sizes.size)
		Assert.assertEquals(-1, fType.intSizes.get(0))
		Assert.assertEquals(1, f.inArgs.size)

		Assert.assertTrue(f.inArgs.get(0).type instanceof BaseType)
		val argType = f.inArgs.get(0).type as BaseType
		Assert.assertEquals(argPrimitive, argType.primitive)
		Assert.assertEquals(argDim, argType.sizes.size)
	}

	private def checkOperatorFunction(Function f, PrimitiveType arg0Primitive, int arg0Dim, PrimitiveType arg1Primitive, int arg1Dim)
	{
		Assert.assertNotNull(f)

		Assert.assertTrue(f.returnType instanceof BaseType)
		val fType = f.returnType as BaseType
		Assert.assertEquals(PrimitiveType.REAL, fType.primitive)
		Assert.assertEquals(1, fType.sizes.size)
		Assert.assertEquals(-1, fType.intSizes.get(0))
		Assert.assertEquals(2, f.inArgs.size)

		Assert.assertTrue(f.inArgs.get(0).type instanceof BaseType)
		val arg0Type = f.inArgs.get(0).type as BaseType
		Assert.assertEquals(arg0Primitive, arg0Type.primitive)
		Assert.assertEquals(arg0Dim, arg0Type.sizes.size)

		Assert.assertTrue(f.inArgs.get(1).type instanceof BaseType)
		val arg1Type = f.inArgs.get(1).type as BaseType
		Assert.assertEquals(arg1Primitive, arg1Type.primitive)
		Assert.assertEquals(arg1Dim, arg1Type.sizes.size)
	}
}

