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

import fr.cea.nabla.tests.NablaInjectorProvider
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(XtextRunner)
@InjectWith(NablaInjectorProvider)
abstract class AbstractOptionsInterpreterTest
{
	val model =
	'''
	module Test;

	with CartesianMesh2D.*;

	ℕ A;
	let ℕ B = A / 2 + 4;
	ℝ C;
	ℝ[3] D;
	ℝ[2, 3] M;

	ℕ max_time_iterations;
	ℝ final_time;

	let ℝ t = 0.0;
	let ℝ δt = 0.001;

	ℝ[2] X{nodes};
	J: let ℝ s = 3.33;
	'''

	@Test
	def void testInterpreteOptions()
	{
		assertInterpreteOptions(model)
	}

	@Test
	def void testInterpreteJsonOptions()
	{
		// no B : default value used
		val jsonContent =
		'
		{
			"test":
			{
				"A":8,
				"C":27.0,
				"D":[25.0,12.12,25.0],
				"M":[[25.0,13.13,25.0],[25.0,25.0,5.4]],
				"max_time_iterations":500000000,
				"final_time":1.0
			},
			"mesh":
			{
				"nbXQuads":10,
				"nbYQuads":10,
				"xSize":0.05,
				"ySize":0.05
			}
		}'
		assertInterpreteJsonOptions(model, jsonContent)
	}

	def void assertInterpreteOptions(String model)
	def void assertInterpreteJsonOptions(String model, String jsonContent)
}