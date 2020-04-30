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

import fr.cea.nabla.tests.NablaInjectorProvider
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(XtextRunner)
@InjectWith(NablaInjectorProvider)
abstract class AbstractOptionsInterpreterTest
{
	val model = '''
		module Test;
		
		itemtypes { node }
		set nodes: → {node};

		def square: ℝ → ℝ, (a) → return a * a;

		option A = 10;
		option B = A / 2 + 4;
		option C = square(5.0);
		option D = [C , C , C];
		option M = [D, D];

		option X_EDGE_LENGTH = 0.01;
		option Y_EDGE_LENGTH = X_EDGE_LENGTH;
		option X_EDGE_ELEMS = 4;
		option Y_EDGE_ELEMS = 4;
		option max_time_iterations = 500000000;
		option final_time = 1.;

		let t = 0.0;
		let δt = 0.001;
		
		ℝ[2] X{nodes};
	'''

	@Test
	def void testInterpreteDefaultOptions()
	{
		assertInterpreteDefaultOptions(model)
	}

	@Test
	def void testInterpreteJsonOptions()
	{
		val jsonOptions = '
		{
			"_comment": "Generated file - Do not overwrite",
			"A":10,
			"B":2,
			"C":27.0,
			"D":[25.0,12.12,25.0],
			"M":[[25.0,13.13,25.0],[25.0,25.0,5.4]],
			"X_EDGE_LENGTH":0.01,
			"Y_EDGE_LENGTH":0.01,
			"X_EDGE_ELEMS":4,
			"Y_EDGE_ELEMS":4,
			"max_time_iterations":500000000,
			"final_time":1.0
		}'

		assertInterpreteJsonOptions(model, jsonOptions)
	}

	def void assertInterpreteDefaultOptions(String model)
	def void assertInterpreteJsonOptions(String model, String jsonOptions)
}