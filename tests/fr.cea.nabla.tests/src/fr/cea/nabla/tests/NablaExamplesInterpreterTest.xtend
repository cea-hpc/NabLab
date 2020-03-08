/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.tests

import com.google.inject.Inject
import fr.cea.nabla.ir.interpreter.ModuleInterpreter
import java.util.logging.ConsoleHandler
import java.util.logging.Level
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.BeforeClass
import org.junit.Test
import org.junit.runner.RunWith

import static fr.cea.nabla.tests.TestUtils.*
import java.util.logging.FileHandler
import java.util.logging.SimpleFormatter

@RunWith(XtextRunner)
@InjectWith(NablaInjectorProvider)
class NablaExamplesInterpreterTest
{
	static String wsPath
	static String examplesProjectSubPath
	static String examplesProjectPath

	@Inject CompilationChainHelper compilationHelper

	@BeforeClass
	def static void setup()
	{
		val testProjectPath = System.getProperty("user.dir")
		wsPath = testProjectPath + "/../../"
		examplesProjectSubPath = "plugins/fr.cea.nabla.ui/examples/NablaExamples/"
		examplesProjectPath = wsPath + examplesProjectSubPath
		
		System.setProperty("java.util.logging.SimpleFormatter.format", "%4$s: %5$s %n")
		
	}

	@Test
	def void testInterpreteGlace2D()
	{       
		val model = readFileAsString(examplesProjectPath + "src/glace2d/Glace2d.nabla")
		// We use a dedicated genmodel to replaceAllreductions and not to generate code
		val genmodel = readFileAsString("src/glace2d/Glace2d.nablagen")

		val irModule = compilationHelper.getIrModule(model, genmodel)
		val handler = new FileHandler("src/glace2d/InterpreteGlace2d.log")
		val formatter = new SimpleFormatter
		handler.setFormatter(formatter)
		//val handler = new ConsoleHandler
		handler.level = Level::FINE
		val moduleInterpreter = new ModuleInterpreter(irModule, handler)
		moduleInterpreter.interprete
	}

	@Test
	def void testInterpreteHeatEquation()
	{
		val model = readFileAsString(examplesProjectPath + "src/heatequation/HeatEquation.nabla")
		// We use a dedicated genmodel to replaceAllreductions and not to generate code
		val genmodel = readFileAsString("src/heatequation/HeatEquation.nablagen")
		
		val irModule = compilationHelper.getIrModule(model, genmodel)
		val handler = new FileHandler("src/heatequation/InterpreteHeatEquation.log")
		val formatter = new SimpleFormatter
		handler.setFormatter(formatter)
		//val handler = new ConsoleHandler
		handler.level = Level::FINEST
		val moduleInterpreter = new ModuleInterpreter(irModule, handler)
		for (var i = 0 ; i < 1 ; i++) 
		{
 			moduleInterpreter.info("Execution " + i)
			moduleInterpreter.interprete
		}
	}
}