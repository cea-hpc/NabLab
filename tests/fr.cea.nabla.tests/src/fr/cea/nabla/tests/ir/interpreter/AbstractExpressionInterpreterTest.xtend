/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.tests.ir.interpreter

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
		val model =
		'''
		«testModule»
		let real r1 = true ? 1.0 : 2.0; // -> 1.0
		let real r2 = false ? 1.0 : 2.0; // -> 1.0

		real[2] X{nodes};

		InitT: t=0.0;
		'''
		assertInterpreteContractedIf(model)
	}

	@Test
	def void testInterpreteUnaryExpression()
	{
		val model =
		'''
		«testModule»
		let bool b0 = !false; // -> true
		let int n0 = -(1); // -> -1
		let real r0 = -(1.); // -> -1.
		let int[2] n1 = [1, 2];
		let int[2] n2 = -n1; // -> [-1, -2]
		let real[2] r1 = [1., 2.];
		let real[2] r2 = -r1; // -> [-1., -2]
		let int[2,2] n3 = [[0, 1],[1, 2]];
		let int[2,2] n4 = -n3; // -> [[0, -1],[-1, -2]]
		let real[2,2] r3 = [[0., 1.],[1., 2.]];
		let real[2,2] r4 = -r3; // -> [[-0., -1.],[-1., -2.]]*/

		real[2] X{nodes};

		InitT: t=0.0;
		'''
		assertInterpreteUnaryExpression(model)
	}

	@Test
	def void testInterpreteParenthesis()
	{
		val model =
		'''
		«testModule»
		let bool b = (true);
		real[2] X{nodes};

		InitT: t=0.0;
		'''
		assertInterpreteParenthesis(model)
	}

	@Test
	def void testInterpreteConstant()
	{
		//NB : Constant only for Scalar
		val model =
		'''
		«testModule»
		let int n1 = 1;
		let real r1 = 2.0;
		let bool b1 = true;
		let bool b2 = false;

		real[2] X{nodes};

		InitT: t=0.0;
		'''
		assertInterpreteConstant(model)
	}

	@Test
	def void testInterpreteMinConstant()
	{
		val model =
		'''
		«testModule»
		let int nMin = int.MinValue;
		let real rMin = real.MinValue;

		real[2] X{nodes};

		InitT: t=0.0;
		'''
		assertInterpreteMinConstant(model)
	}

	@Test
	def void testInterpreteMaxConstant()
	{
		val model =
		'''
		«testModule»
		let int nMax = int.MaxValue;
		let real rMax = real.MaxValue;

		real[2] X{nodes};

		InitT: t=0.0;
		'''
		assertInterpreteMaxConstant(model)
	}

	@Test
	def void testInterpreteBaseTypeConstant()
	{
		val model =
		'''
		«testModule»
		let int n1 = int(1);
		let int[2] n2 = int[2](1);
		let int[2,3] n3 = int[2,3](1);

		let real r1 = real(1.);
		let real[2] r2 = real[2](1.);
		let real[2,3] r3 = real[2,3](1.);
		
		let bool b1 = bool(true);
		let bool[2] b2 = bool[2](true);
		let bool[2,3] b3 = bool[2,3](true);

		real[2] X{nodes};

		InitT: t=0.0;
		'''
		assertInterpreteBaseTypeConstant(model)
	}

	@Test
	def void testInterpreteIntVectorConstant()
	{
		val model =
		'''
		«testModule»
		let int[2] n = [1, 2];
		real[2] X{nodes};

		InitT: t=0.0;
		'''
		assertInterpreteIntVectorConstant(model)
	}

	@Test
	def void testInterpreteIntMatrixConstant()
	{
		val model =
		'''
		«testModule»
		let int[2,3] n = [[0, 1, 2],[1, 2, 3]];
		real[2] X{nodes};

		InitT: t=0.0;
		'''
		assertInterpreteIntMatrixConstant(model)
	}

	@Test
	def void testInterpreteRealVectorConstant()
	{
		val model =
		'''
		«testModule»
		let real[2] r = [1.0, 2.0];
		real[2] X{nodes};

		InitT: t=0.0;
		'''
		assertInterpreteRealVectorConstant(model)
	}

	@Test
	def void testInterpreteRealMatrixConstant()
	{
		val model =
		'''
		«testModule»
		let real[2,3] r = [[0., 1., 2.],[1., 2., 3.]];
		real[2] X{nodes};

		InitT: t=0.0;
		'''
		assertInterpreteRealMatrixConstant(model)
	}

	@Test
	def void testInterpreteCardinality()
	{
		val model =
		'''
		«testModule»
		int c;
		real[2] X{nodes};

		InitT: t=0.0;
		Job1: c = card(nodes());
		'''
		assertInterpreteCardinality(model)
	}

	@Test
	def void testInterpreteFunctionCall()
	{
		val model =
		'''
		«emptyTestModule»
		with CartesianMesh2D.*;

		def int getOne() return 1;
		def int addOne(int a) return a + 1;
		def real addOne(real a) return a + 1.0;
		def int add(int a, int b) return a + b;
		def real add(real a, int b) return a + b;
		def real add(real a, real b) return a + b;
		def <x> real[x] add(real[x] a, real[x] b) return a + b;
		def <x,y> real[x,y] add(real[x,y] a, real[x,y] b) return a + b;

		«simulationVariables»
		let int n0 = 0;
		let int n1 = getOne(); 	//-> 1
		let int n2 = addOne(n1); 	//-> 2
		let int n3 = add(n1, n2); //-> 3
		let real r0 = 0. ;
		let real r1 = addOne(r0); 	//-> 1.
		let real r2 = add(r1, n1); //-> 2.
		let real r3 = add(r2, r1); //-> 3.

		let real[2] u = real[2](1.);
		let real[2] v = real[2](2.);
		let real[2] w = add(u,v); //-> [3., 3.]

		let real[3] alpha = real[3](1.);
		let real[3] beta = real[3](2.);
		let real[3] res1 = add(alpha,beta); //-> [3., 3., 3.]

		let real[2,2] delta = real[2,2](1.);
		let real[2,2] rho = real[2,2](2.);
		let real[2,2] res2 = add(delta,rho); //-> [3., 3][3., 3.]

		let real[3] res3 = add(res1 + alpha, beta);  //-> [6., 6., 6.]
		real[2] X{nodes};

		InitT: t=0.0;
		'''
		assertInterpreteFunctionCall(model)
	}

	@Test
	def void testInterpreteFunctionCallWithBody()
	{
		val model =
		'''
		«emptyTestModule»

		with CartesianMesh2D.*;

		def real[2] h(real[2] a) return 2 * a;

		def <a> real[a] i(real[a] x) {
			return 2 * x;
		}

		def <a> real[a] j(real[a] x) {
			real[a] y;
			forall i in [0;a[, y[i] = 2 * x[i];
			return y;
		}

		def <b> real[b] k(real[b] x) return j(x);

		«simulationVariables»
		let real[2] u = [0.0, 0.1];
		let real[3] v = [0.0, 0.1, 0.2];
		real[2] w1;
		real[2] w2;
		real[3] w3;
		real[2] w4;
		real[3] w5;
		real[2] w6;
		real[2] X{nodes};

		J1: w1 = h(u);
		J2: w2 = i(u);
		J3: w3 = i(v);
		J4: w4 = j(u);
		J5: w5 = j(v);
		J6: w6 = k(u);

		InitT: t=0.0;
		'''
		assertInterpreteFunctionCallWithBody(model)
	}

	@Test
	def void testInterpreteVarRef()
	{
		val model =
		'''
		«testModule»
		let bool b1 = true;
		let bool b2 = b1; // -> true

		let int n1 = 1;
		let int n2 = n1; // -> 1
		let int[2] n3 = [2,3];
		let int[2] n4 = n3; // -> [2,3]
		let int n5 = n3[0]; // -> 2
		let int[3,2] n6 = [[2,3],[4,5],[6,7]];
		let int[3,2] n7 = n6; // -> [[2,3],[4,5],[6,7]]
		let int n8 = n6[1,1]; // -> 5

		let real r1 = 1.;
		let real r2 = r1; // -> 1.
		let real[2] r3 = [2.,3.];
		let real[2] r4 = r3; // -> [2.,3.]
		let real r5 = r3[0]; // -> 2.
		let real[3,2] r6 = [[2.,3.],[4.,5.],[6.,7.]];
		let real[3,2] r7 = r6; // -> [[2.,3.],[4.,5.],[6.,7.]]
		let real r8 = r6[1,1]; // -> 5.

		real[2] X{nodes};

		InitT: t=0.0;
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