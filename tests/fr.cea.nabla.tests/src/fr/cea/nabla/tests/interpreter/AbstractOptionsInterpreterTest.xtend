/*******************************************************************************
 * Copyright (c) 2021 CEA
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
	val model =
	'''
	module Test;

	itemtypes { node }
	connectivity nodes: → {node};

	def square: ℝ → ℝ, (a) → return a * a;

	option ℕ A = 10;
	option ℕ B = A / 2 + 4;
	option ℝ C = square(5.0);
	option ℝ[3] D = [C , C , C];
	option ℝ[2, 3] M = [D, D];

	option ℕ max_time_iterations = 500000000;
	option ℝ final_time = 1.;

	let ℝ t = 0.0;
	let ℝ δt = 0.001;

	ℝ[2] X{nodes};
	J: let ℝ s = 3.33;
	'''

	val modelWithMandatoryOptions =
	'''
	module Test;

	itemtypes { node }
	connectivity nodes: → {node};

	option ℕ A = 10;
	option ℕ[2] mandatory1;
	option ℝ mandatory2;
	option ℝ B = mandatory2 * 2;

	option ℕ max_time_iterations = 500000000;
	option ℝ final_time = 1.;

	let ℝ t = 0.0;
	let ℝ δt = 0.001;

	ℝ[2] X{nodes};
	J: let ℝ s = 3.33;
	'''

	@Test
	def void testInterpreteDefaultOptions()
	{
		assertInterpreteDefaultOptions(model)
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

	@Test
	def void testInterpreteDefaultMandatoryOptions()
	{
		assertInterpreteDefaultMandatoryOptions(modelWithMandatoryOptions)
	}

	@Test
	def void testInterpreteJsonMandatoryOptions()
	{
		val jsonContent =
		'
		{
			"test":
			{
				"A":8,
				"mandatory1":[1,2],
				"mandatory2":2.2
			},
			"mesh":
			{
				"nbXQuads":10,
				"nbYQuads":10,
				"xSize":0.05,
				"ySize":0.05
			}
		}'
		assertInterpreteJsonMandatoryOptions(modelWithMandatoryOptions, jsonContent)
	}

	def void assertInterpreteDefaultOptions(String model)
	def void assertInterpreteJsonOptions(String model, String jsonContent)
	def void assertInterpreteDefaultMandatoryOptions(String model)
	def void assertInterpreteJsonMandatoryOptions(String model, String jsonContent)
}