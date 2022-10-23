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
abstract class AbstractBinaryOperationsInterpreterTest
{
	@Inject extension TestUtils

	@Test
	def void testGetValueOfNV0Bool_NV0Bool()
	{
		val model =
		'''
		«testModule»
		let bool b1 = true || false; // -> true
		let bool b2 = true || true; // -> true
		let bool b3 = false || false; // -> false

		let bool b4 = true && false; // -> false
		let bool b5 = true && true; // -> true
		let bool b6 = false && false; // -> false

		let bool b7 = true == false; // -> false
		let bool b8 = true != false; // -> true
		let bool b9 = true >= false; // -> true
		let bool b10 = true <= false; // -> false
		let bool b11 = true > false; // -> true
		let bool b12 = true < false; // -> false

		real[2] X{nodes};
		'''
		assertGetValueOfNV0Bool_NV0Bool(model)
	}

	@Test
	def void testGetValueOfNV0Int_NV0Int()
	{
		val model =
		'''
		«testModule»
		let bool b1 = 1 == 2; // -> false
		let bool b2 = 1 == 1; // -> true

		let bool b3 = 1 != 2; // -> true
		let bool b4 = 2 != 2; // -> false

		let bool b5 = 1 >= 2; // -> false
		let bool b6 = 2 >= 2; // -> true

		let bool b7 = 1 <= 2; // -> true
		let bool b8 = 2 <= 2; // -> true

		let bool b9 = 1 > 2; // -> false
		let bool b10 = 2 > 1; // -> true

		let bool b11 = 1 < 2; // -> true
		let bool b12 = 2 < 1; // -> false

		let int n1 = 1 + 2; // -> 3
		let int n2 = 2 - 1; // -> 1
		let int n3 = 2 * 3; // -> 6
		let int n4 = 6 / 3; // -> 2
		let int n5 = 7 / 3; // -> 2
		let int n6 = 7 % 3; // -> 1

		real[2] X{nodes};
		'''
		assertGetValueOfNV0Int_NV0Int(model)
	}

	@Test
	def void testGetValueOfNV0Int_NV0Real()
	{
		val model =
		'''
		«testModule»
		let bool b1 = 1 == 2.; // -> false
		let bool b2 = 1 == 1; // -> true

		let bool b3 = 1 != 2.; // -> true
		let bool b4 = 2 != 2.; // -> false

		let bool b5 = 1 >= 2.; // -> false
		let bool b6 = 2 >= 2.; // -> true

		let bool b7 = 1 <= 2.; // -> true
		let bool b8 = 2 <= 2.; // -> true

		let bool b9 = 1 > 2.; // -> false
		let bool b10 = 2 > 1.; // -> true

		let bool b11 = 1 < 2.; // -> true
		let bool b12 = 2 < 1.; // -> false

		let real n1 = 1 + 2.; // -> 3.
		let real n2 = 2 - 1.; // -> 1.
		let real n3 = 2 * 3.; // -> 6.
		let real n4 = 6 / 3.; // -> 2.
		let real n5 = 7 / 2.; // -> 3.5.

		real[2] X{nodes};
		'''
		assertGetValueOfNV0Int_NV0Real(model)
	}

	@Test
	def void testGetValueOfNV0Int_NV1Int()
	{
		val model =
		'''
		«testModule»
		let int[2] n1 = [1,2];
		let int[2] n2 = 3 + n1;
		let int[2] n3 = 3 * n1;

		real[2] X{nodes};

		InitT: t=0.0;
		'''
		assertGetValueOfNV0Int_NV1Int(model)
	}

	def void assertGetValueOfNV0Bool_NV0Bool(String model)
	def void assertGetValueOfNV0Int_NV0Int(String model)
	def void assertGetValueOfNV0Int_NV0Real(String model)
	def void assertGetValueOfNV0Int_NV1Int(String model)
}