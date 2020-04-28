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
import fr.cea.nabla.tests.NablaInjectorProvider
import fr.cea.nabla.tests.TestUtils
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(XtextRunner)
@InjectWith(NablaInjectorProvider)
abstract class AbstractExpressionInterpreterTest
{
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

		assertInterpreteContractedIf(model)
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
		
		assertInterpreteUnaryExpression(model)
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
		
		assertInterpreteParenthesis(model)
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

		assertInterpreteConstant(model)
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

		assertInterpreteMinConstant(model)
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

		assertInterpreteMaxConstant(model)
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

		assertInterpreteBaseTypeConstant(model)
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

		assertInterpreteIntVectorConstant(model)
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

		assertInterpreteIntMatrixConstant(model)
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

		assertInterpreteRealVectorConstant(model)
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

		assertInterpreteRealMatrixConstant(model)
	}

	@Test
	def void testInterpreteCardinality()
	{
		val model = testModuleForSimulation +
		'''
		let c = card(nodes());
		ℝ[2] X{nodes};
		'''

		assertInterpreteCardinality(model)
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


		assertInterpreteFunctionCall(model)
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

		assertInterpreteFunctionCallWithBody(model)
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


		assertInterpreteVarRef(model)
	}

	def void assertInterpreteContractedIf(String model)
	
	def void assertInterpreteUnaryExpression(String model)

	def void assertInterpreteParenthesis(String model)

	def void assertInterpreteConstant(String model)

	def void assertInterpreteMinConstant(String model)

	def void assertInterpreteMaxConstant(String model)

	def void assertInterpreteBaseTypeConstant(String model)
	
	def void assertInterpreteIntVectorConstant(String model)

	def void assertInterpreteIntMatrixConstant(String model)

	def void assertInterpreteRealVectorConstant(String model)

	def void assertInterpreteRealMatrixConstant(String model)

	def void assertInterpreteCardinality(String model)

	def void assertInterpreteFunctionCall(String model)

	def void assertInterpreteFunctionCallWithBody(String model)

	def void assertInterpreteVarRef(String model)
}