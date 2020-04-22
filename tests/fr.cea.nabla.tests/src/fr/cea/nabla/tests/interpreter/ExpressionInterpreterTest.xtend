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
import fr.cea.nabla.ir.interpreter.NV1Bool
import fr.cea.nabla.ir.interpreter.NV1Int
import fr.cea.nabla.ir.interpreter.NV1Real
import fr.cea.nabla.ir.interpreter.NV2Bool
import fr.cea.nabla.ir.interpreter.NV2Int
import fr.cea.nabla.ir.interpreter.NV2Real
import fr.cea.nabla.tests.CompilationChainHelper
import fr.cea.nabla.tests.NablaInjectorProvider
import fr.cea.nabla.tests.TestUtils
import java.util.logging.ConsoleHandler
import java.util.logging.Level
import java.util.logging.Logger
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import org.junit.Assert

@RunWith(XtextRunner)
@InjectWith(NablaInjectorProvider)
class ExpressionInterpreterTest
{
	@Inject CompilationChainHelper compilationHelper
	@Inject extension TestUtils

	@Test
	def void testInterpreteContractedIf() 
	{
		val model = testModuleForSimulation
		+
		'''	
		let r1 = true ? 1.0 : 2.0; // -> 1.0
		let r2 = false ? 1.0 : 2.0; // -> 1.0

		ℝ[2] X{nodes};
		'''

		val irModule = compilationHelper.getIrModule(model, testGenModel)
		val context = new Context(irModule, Logger.getLogger(ExpressionInterpreterTest.name))

		assertVariableDefaultValue(irModule, context, "r1", new NV0Real(1.0))
		assertVariableDefaultValue(irModule, context, "r2", new NV0Real(2.0))
	}

	@Test
	def void testInterpreteBinaryExpression()
	{
		//cf BinaryOperationsInterpreter
	}

	@Test
	def void testInterpreteUnaryExpression()
	{
		val model = testModuleForSimulation
		+
		'''
		let b0 = !false; // -> true
		let n0 = -(1); // -> -1
		let r0 = -(1.); // -> -1.
		let n1 = [1, 2];
		let n2 = -n1; // -> [-1, -2]
		let r1 = [1., 2.];
		let r2 = -r1; // -> [-1., -2
		let n3 = [[0, 1],[1, 2]];
		let n4 = -n3; // -> [[0, -1],[-1, -2]]
		let r3 = [[0., 1.],[1., 2.]];
		let r4 = -r3; // -> [[-0., -1.],[-1., -2.]]*/

		ℝ[2] X{nodes};
		'''
		val irModule = compilationHelper.getIrModule(model, testGenModel)
		val handler = new ConsoleHandler
		handler.level = Level::OFF
		val moduleInterpreter = new ModuleInterpreter(irModule, handler)
		val context = moduleInterpreter.interprete

		assertVariableValueInContext(irModule, context, "b0", new NV0Bool(true))
		assertVariableValueInContext(irModule, context, "n0", new NV0Int(-1))
		assertVariableValueInContext(irModule, context, "r0", new NV0Real(-1))
		assertVariableValueInContext(irModule, context, "n1", new NV1Int(#[1, 2]))
		assertVariableValueInContext(irModule, context, "n2", new NV1Int(#[-1, -2]))
		assertVariableValueInContext(irModule, context, "r1", new NV1Real(#[1.0, 2.0]))
		assertVariableValueInContext(irModule, context, "r2", new NV1Real(#[-1.0, -2.0]))
		assertVariableValueInContext(irModule, context, "n3", new NV2Int(#[#[0, 1],#[1, 2]]))
		assertVariableValueInContext(irModule, context, "n4", new NV2Int(#[#[0, -1],#[-1, -2]]))
		assertVariableValueInContext(irModule, context, "r3", new NV2Real(#[#[0.0, 1.0],#[1.0, 2.0]]))
		// Warning : -0.0 != 0.0
		assertVariableValueInContext(irModule, context, "r4", new NV2Real(#[#[-0.0, -1.0],#[-1.0, -2.0]]))
	}

	@Test
	def void testInterpreteParenthesis()
	{
		val model = testModuleForSimulation
		+
		'''
		let b = (true);
		ℝ[2] X{nodes};
		'''
		val irModule = compilationHelper.getIrModule(model, testGenModel)
		val context = new Context(irModule, Logger.getLogger(ExpressionInterpreterTest.name))

		assertVariableDefaultValue(irModule, context, "b", new NV0Bool(true))
	}

	@Test
	def void testInterpreteConstant()
	{
		//NB : Constant only for Scalar
		val model = testModuleForSimulation
		+
		'''
		let n1 = 1;
		let r1 = 2.0;
		let b1 = true;
		let b2 = false;

		ℝ[2] X{nodes};
		'''
		val irModule = compilationHelper.getIrModule(model, testGenModel)
		val context = new Context(irModule, Logger.getLogger(ExpressionInterpreterTest.name))

		assertVariableDefaultValue(irModule, context, "n1", new NV0Int(1))
		assertVariableDefaultValue(irModule, context, "r1", new NV0Real(2.0))
		assertVariableDefaultValue(irModule, context, "b1", new NV0Bool(true))
		assertVariableDefaultValue(irModule, context, "b2", new NV0Bool(false))
	}

	@Test
	def void testInterpreteMinConstant()
	{
		val model = testModuleForSimulation
		+
		'''
		let nMin = ℕ.MinValue;
		let rMin = ℝ.MinValue;

		ℝ[2] X{nodes};
		'''
		val irModule = compilationHelper.getIrModule(model, testGenModel)
		val context = new Context(irModule, Logger.getLogger(ExpressionInterpreterTest.name))

		assertVariableDefaultValue(irModule, context, "nMin", new NV0Int(Integer.MIN_VALUE))
		assertVariableDefaultValue(irModule, context, "rMin", new NV0Real(Double.MIN_VALUE))
	}

	@Test
	def void testInterpreteMaxConstant()
	{
		val model = testModuleForSimulation
		+
		'''
		let nMax = ℕ.MaxValue;
		let rMax = ℝ.MaxValue;

		ℝ[2] X{nodes};
		'''
		val irModule = compilationHelper.getIrModule(model, testGenModel)
		val context = new Context(irModule, Logger.getLogger(ExpressionInterpreterTest.name))

		assertVariableDefaultValue(irModule, context, "nMax", new NV0Int(Integer.MAX_VALUE))
		assertVariableDefaultValue(irModule, context, "rMax", new NV0Real(Double.MAX_VALUE))
	}

	@Test
	def void testInterpreteBaseTypeConstant()
	{
		val model = testModuleForSimulation
		+
		'''
		let n1 = ℕ(1);
		let n2 = ℕ[2](1);
		let n3 = ℕ[2,3](1);

		let r1 = ℝ(1.);
		let r2 = ℝ[2](1.);
		let r3 = ℝ[2,3](1.);
		
		let b1 = ℾ(true);
		let b2 = ℾ[2](true);
		let b3 = ℾ[2,3](true);

		ℝ[2] X{nodes};
		'''
		val irModule = compilationHelper.getIrModule(model, testGenModel)
		val context = new Context(irModule, Logger.getLogger(ExpressionInterpreterTest.name))

		assertVariableDefaultValue(irModule, context, "n1", new NV0Int(1))
		assertVariableDefaultValue(irModule, context, "n2", new NV1Int(#[1,1]))
		assertVariableDefaultValue(irModule, context, "n3", new NV2Int(#[#[1, 1, 1],#[1, 1, 1]]))

		assertVariableDefaultValue(irModule, context, "r1", new NV0Real(1.0))
		assertVariableDefaultValue(irModule, context, "r2", new NV1Real(#[1.0,1.0]))
		assertVariableDefaultValue(irModule, context, "r3", new NV2Real(#[#[1.0, 1.0, 1.0],#[1.0, 1.0, 1.0]]))

		assertVariableDefaultValue(irModule, context, "b1", new NV0Bool(true))
		assertVariableDefaultValue(irModule, context, "b2", new NV1Bool(#[true, true]))
		assertVariableDefaultValue(irModule, context, "b3", new NV2Bool(#[#[true, true, true],#[true, true, true]]))
	}
	
	@Test
	def void testInterpreteIntVectorConstant()
	{
		val model = testModuleForSimulation
		+
		'''
		let n = [1, 2];
		ℝ[2] X{nodes};
		'''
		val irModule = compilationHelper.getIrModule(model, testGenModel)
		val context = new Context(irModule, Logger.getLogger(ExpressionInterpreterTest.name))

		assertVariableDefaultValue(irModule, context, "n", new NV1Int(#[1,2]))
	}

	@Test
	def void testInterpreteIntMatrixConstant()
	{
		val model = testModuleForSimulation
		+
		'''
		let n = [[0, 1, 2],[1, 2, 3]];
		ℝ[2] X{nodes};
		'''
		val irModule = compilationHelper.getIrModule(model, testGenModel)
		val context = new Context(irModule, Logger.getLogger(ExpressionInterpreterTest.name))

		assertVariableDefaultValue(irModule, context, "n", new NV2Int(#[#[0, 1, 2],#[1, 2, 3]]))
	}

	@Test
	def void testInterpreteRealVectorConstant()
	{
		val model = testModuleForSimulation
		+
		'''
		let r = [1.0, 2.0];
		ℝ[2] X{nodes};
		'''
		val irModule = compilationHelper.getIrModule(model, testGenModel)
		val context = new Context(irModule, Logger.getLogger(ExpressionInterpreterTest.name))

		assertVariableDefaultValue(irModule, context, "r", new NV1Real(#[1.0, 2.0]))
	}

	@Test
	def void testInterpreteRealMatrixConstant()
	{
		val model = testModuleForSimulation
		+
		'''
		let r = [[0., 1., 2.],[1., 2., 3.]];
		ℝ[2] X{nodes};
		'''
		val irModule = compilationHelper.getIrModule(model, testGenModel)
		val context = new Context(irModule, Logger.getLogger(ExpressionInterpreterTest.name))

		assertVariableDefaultValue(irModule, context, "r", new NV2Real(#[#[0.0, 1.0, 2.0],#[1.0, 2.0, 3.0]]))
	}

	@Test
	def void testInterpreteCardinality()
	{
		val model = testModuleForSimulation +
		'''
		let c = card(nodes());
		ℝ[2] X{nodes};
		'''
		val irModule = compilationHelper.getIrModule(model, testGenModel)
		val handler = new ConsoleHandler
		handler.level = Level::OFF
		val moduleInterpreter = new ModuleInterpreter(irModule, handler)
		val context = moduleInterpreter.interprete
		val variableValue = context.getVariableValue(irModule.getVariableByName("c"))
		Assert.assertNotNull(variableValue)
		Assert.assertTrue(variableValue instanceof NV0Int)
		Assert.assertEquals(121, (variableValue as NV0Int).data)
	}

	@Test
	def void testInterpreteFunctionCall()
	{
		val model = getTestModule(defaultConnectivities,
		'''
		def getOne:  → ℕ;
		def addOne: ℕ → ℕ;
		def addOne: ℝ → ℝ;
		def add: ℕ × ℕ → ℕ;
		def add: ℝ × ℕ → ℝ;
		def add: ℝ × ℝ → ℝ;
		def add: x | ℝ[x] × ℝ[x] → ℝ[x];
		def add: x,y | ℝ[x,y] × ℝ[x,y] → ℝ[x,y];
		''')
		+ simulationVariables +
		'''
		let n0 = 0;
		let n1 = getOne(); 	//-> 1
		let n2 = addOne(n1); 	//-> 2
		let n3 = add(n1, n2); //-> 3
		let r0 = 0. ;
		let r1 = addOne(r0); 	//-> 1.
		let r2 = add(r1, n1); //-> 2.
		let r3 = add(r2, r1); //-> 3.

		let u = ℝ[2](1.);
		let v = ℝ[2](2.);
		let w = add(u,v); //-> [3., 3.]

		let α = ℝ[3](1.);
		let β = ℝ[3](2.);
		let res1 = add(α,β); //-> [3., 3., 3.]

		let δ = ℝ[2,2](1.);
		let ρ = ℝ[2,2](2.);
		let res2 = add(δ,ρ); //-> [3., 3][3., 3.]

		ℝ[2] X{nodes};
		'''

		val irModule = compilationHelper.getIrModule(model, testGenModel)
		val handler = new ConsoleHandler
		handler.level = Level::OFF
		val moduleInterpreter = new ModuleInterpreter(irModule, handler)
		val context = moduleInterpreter.interprete

		assertVariableValueInContext(irModule, context, "n0", new NV0Int(0))
		assertVariableValueInContext(irModule, context, "n1", new NV0Int(1))
		assertVariableValueInContext(irModule, context, "n2", new NV0Int(2))
		assertVariableValueInContext(irModule, context, "n3", new NV0Int(3))

		assertVariableValueInContext(irModule, context, "r1", new NV0Real(1.0))
		assertVariableValueInContext(irModule, context, "r2", new NV0Real(2.0))
		assertVariableValueInContext(irModule, context, "r3", new NV0Real(3.0))

		assertVariableValueInContext(irModule, context, "w", new NV1Real(#[3.0, 3.0]))
		assertVariableValueInContext(irModule, context, "res1", new NV1Real(#[3.0, 3.0, 3.0]))
		assertVariableValueInContext(irModule, context, "res2", new NV2Real(#[#[3.0, 3.0],#[3.0, 3.0]]))
	}

	@Test
	def void testInterpreteFunctionCallWithBody()
	{
		val model = getTestModule(defaultConnectivities,
		'''
		def h: ℝ[2] → ℝ[2], (a) → return 2 * a;

		def i: a | ℝ[a] → ℝ[a], (x) → {
			return 2 * x;
		}

		def	j: a | ℝ[a] → ℝ[a], (x) → {
			ℝ[a] y;
			∀i∈[0;a[, y[i] = 2 * x[i];
			return y;
		}

		def k: b | ℝ[b] → ℝ[b], (x) → return j(x);
		''')
		+ simulationVariables +
		'''
		let u = [0.0, 0.1];
		let v = [0.0, 0.1, 0.2];
		ℝ[2] w1;
		ℝ[2] w2;
		ℝ[3] w3;
		ℝ[2] w4;
		ℝ[3] w5;
		ℝ[2] w6;
		ℝ[2] X{nodes};

		j1: w1 = h(u);
		j2: w2 = i(u);
		j3: w3 = i(v);
		j4: w4 = j(u);
		j5: w5 = j(v);
		j6: w6 = k(u);
		'''
		val irModule = compilationHelper.getIrModule(model, testGenModel)
		val handler = new ConsoleHandler
		handler.level = Level::OFF
		val moduleInterpreter = new ModuleInterpreter(irModule, handler)
		val context = moduleInterpreter.interprete

		assertVariableValueInContext(irModule, context, "w1", new NV1Real(#[0.0, 0.2]))
		assertVariableValueInContext(irModule, context, "w2", new NV1Real(#[0.0, 0.2]))
		assertVariableValueInContext(irModule, context, "w3", new NV1Real(#[0.0, 0.2, 0.4]))
		assertVariableValueInContext(irModule, context, "w4", new NV1Real(#[0.0, 0.2]))
		assertVariableValueInContext(irModule, context, "w5", new NV1Real(#[0.0, 0.2, 0.4]))
		assertVariableValueInContext(irModule, context, "w6", new NV1Real(#[0.0, 0.2]))
	}

	@Test
	def void testInterpreteVarRef()
	{
		val model = getTestModuleForSimulation
		+
		'''
		let b1 = true;
		let b2 = b1; // -> true

		let n1 = 1;
		let n2 = n1; // -> 1
		let n3 = [2,3];
		let n4 = n3; // -> [2,3]
		let n5 = n3[0]; // -> 2
		let n6 = [[2,3],[4,5],[6,7]];
		let n7 = n6; // -> [[2,3],[4,5],[6,7]]
		let n8 = n6[1,1]; // -> 5

		let r1 = 1.;
		let r2 = r1; // -> 1.
		let r3 = [2.,3.];
		let r4 = r3; // -> [2.,3.]
		let r5 = r3[0]; // -> 2.
		let r6 = [[2.,3.],[4.,5.],[6.,7.]];
		let r7 = r6; // -> [[2.,3.],[4.,5.],[6.,7.]]
		let r8 = r6[1,1]; // -> 5.

		ℝ[2] X{nodes};
		'''

		val irModule = compilationHelper.getIrModule(model, testGenModel)
		val handler = new ConsoleHandler
		handler.level = Level::OFF
		val moduleInterpreter = new ModuleInterpreter(irModule, handler)
		val context = moduleInterpreter.interprete

		assertVariableValueInContext(irModule, context, "b2", new NV0Bool(true))

		assertVariableValueInContext(irModule, context, "n2", new NV0Int(1))
		assertVariableValueInContext(irModule, context, "n4", new NV1Int(#[2,3]))
		assertVariableValueInContext(irModule, context, "n7", new NV2Int(#[#[2,3],#[4,5],#[6,7]]))
		assertVariableValueInContext(irModule, context, "n8", new NV0Int(5))

		assertVariableValueInContext(irModule, context, "r2", new NV0Real(1.0))
		assertVariableValueInContext(irModule, context, "r4", new NV1Real(#[2.0,3.0]))
		assertVariableValueInContext(irModule, context, "r7", new NV2Real(#[#[2.0,3.0],#[4.0,5.0],#[6.0,7.0]]))
		assertVariableValueInContext(irModule, context, "r8", new NV0Real(5.0))
	}
}