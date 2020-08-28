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
abstract class AbstractBinaryOperationsInterpreterTest
{
	@Inject extension TestUtils

	@Test
	def void testGetValueOfNV0Bool_NV0Bool()
	{
		val model =
		'''
		«testModuleForSimulation»
		let ℾ b1 = true || false; // -> true
		let ℾ b2 = true || true; // -> true
		let ℾ b3 = false || false; // -> false

		let ℾ b4 = true && false; // -> false
		let ℾ b5 = true && true; // -> true
		let ℾ b6 = false && false; // -> false

		let ℾ b7 = true == false; // -> false
		let ℾ b8 = true != false; // -> true
		let ℾ b9 = true >= false; // -> true
		let ℾ b10 = true <= false; // -> false
		let ℾ b11 = true > false; // -> true
		let ℾ b12 = true < false; // -> false

		ℝ[2] X{nodes};
		'''
		assertGetValueOfNV0Bool_NV0Bool(model)
	}

	@Test
	def void testGetValueOfNV0Int_NV0Int()
	{
		val model =
		'''
		«testModuleForSimulation»
		let ℾ b1 = 1 == 2; // -> false
		let ℾ b2 = 1 == 1; // -> true

		let ℾ b3 = 1 != 2; // -> true
		let ℾ b4 = 2 != 2; // -> false

		let ℾ b5 = 1 >= 2; // -> false
		let ℾ b6 = 2 >= 2; // -> true

		let ℾ b7 = 1 <= 2; // -> true
		let ℾ b8 = 2 <= 2; // -> true

		let ℾ b9 = 1 > 2; // -> false
		let ℾ b10 = 2 > 1; // -> true

		let ℾ b11 = 1 < 2; // -> true
		let ℾ b12 = 2 < 1; // -> false

		let ℕ n1 = 1 + 2; // -> 3
		let ℕ n2 = 2 - 1; // -> 1
		let ℕ n3 = 2 * 3; // -> 6
		let ℕ n4 = 6 / 3; // -> 2
		let ℕ n5 = 7 / 3; // -> 2
		let ℕ n6 = 7 % 3; // -> 1

		ℝ[2] X{nodes};
		'''
		assertGetValueOfNV0Int_NV0Int(model)
	}

	@Test
	def void testGetValueOfNV0Int_NV0Real()
	{
		val model =
		'''
		«testModuleForSimulation»
		let ℾ b1 = 1 == 2.; // -> false
		let ℾ b2 = 1 == 1; // -> true

		let ℾ b3 = 1 != 2.; // -> true
		let ℾ b4 = 2 != 2.; // -> false

		let ℾ b5 = 1 >= 2.; // -> false
		let ℾ b6 = 2 >= 2.; // -> true

		let ℾ b7 = 1 <= 2.; // -> true
		let ℾ b8 = 2 <= 2.; // -> true

		let ℾ b9 = 1 > 2.; // -> false
		let ℾ b10 = 2 > 1.; // -> true

		let ℾ b11 = 1 < 2.; // -> true
		let ℾ b12 = 2 < 1.; // -> false

		let ℝ n1 = 1 + 2.; // -> 3.
		let ℝ n2 = 2 - 1.; // -> 1.
		let ℝ n3 = 2 * 3.; // -> 6.
		let ℝ n4 = 6 / 3.; // -> 2.
		let ℝ n5 = 7 / 2.; // -> 3.5.

		ℝ[2] X{nodes};
		'''
		assertGetValueOfNV0Int_NV0Real(model)
	}

	@Test
	def void testGetValueOfNV0Int_NV1Int()
	{
		val model =
		'''
		«testModuleForSimulation»
		let ℕ[2] n1 = [1,2];
		let ℕ[2] n2 = 3 + n1;
		let ℕ[2] n3 = 3 * n1;

		ℝ[2] X{nodes};
		'''
		assertGetValueOfNV0Int_NV1Int(model)
	}

	def void assertGetValueOfNV0Bool_NV0Bool(String model)
	def void assertGetValueOfNV0Int_NV0Int(String model)
	def void assertGetValueOfNV0Int_NV0Real(String model)
	def void assertGetValueOfNV0Int_NV1Int(String model)
}