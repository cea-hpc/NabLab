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
import com.google.inject.Provider
import fr.cea.nabla.NablaStandaloneSetup
import fr.cea.nabla.NablagenStandaloneSetup
import fr.cea.nabla.generator.NablagenInterpreter
import fr.cea.nabla.ir.interpreter.IrInterpreter
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.transformers.ReplaceReductions
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nablagen.NablagenModule
import java.nio.file.Files
import java.nio.file.Paths
import java.util.logging.ConsoleHandler
import java.util.logging.Level
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import org.junit.runner.RunWith

@RunWith(XtextRunner)
@InjectWith(NablaInjectorProvider)
class CompilationChainHelper
{
	@Inject extension ValidationTestHelper
	@Inject Provider<NablagenInterpreter> interpreterProvider
	@Inject Provider<ResourceSet> resourceSetProvider

	var nablaSetup = new NablaStandaloneSetup
	var nablaInjector = nablaSetup.createInjectorAndDoEMFRegistration
	var ParseHelper<NablaModule> nablaParseHelper = nablaInjector.getInstance(ParseHelper)

	var nablagenSetup = new NablagenStandaloneSetup
	var nablagenInjector = nablagenSetup.createInjectorAndDoEMFRegistration
	var ParseHelper<NablagenModule> nablagenParseHelper = nablagenInjector.getInstance(ParseHelper)

	val testProjectPath = System.getProperty("user.dir")
	val pluginsPath = testProjectPath + "/../../plugins/"

	/** 
	 * Returns a module ready for interpretation i.e. with no reduction instruction.
	 */
	def getIrForInterpretation(CharSequence model, CharSequence genModel)
	{
		val ir = getIr(model, genModel)
		// Suppress all reductions (replaced by loops)
		val t = new ReplaceReductions(true)
		t.transformIr(ir)
		return ir
	}

	def getNgen(CharSequence model, CharSequence genModel)
	{
		var rs = resourceSetProvider.get

		// Read MathFunctions
		val mathFunctionsPath = pluginsPath + "fr.cea.nabla/nablalib/mathfunctions.nabla"
		nablaParseHelper.parse(new String(Files.readAllBytes(Paths.get(mathFunctionsPath))), rs)

		// Read LinearAlgebraFunctions
		val linearAlgebraFunctionsPath = pluginsPath + "fr.cea.nabla/nablalib/linearalgebrafunctions.nabla"
		nablaParseHelper.parse(new String(Files.readAllBytes(Paths.get(linearAlgebraFunctionsPath))), rs)

		var nablaModule = nablaParseHelper.parse(model, rs)
		nablaModule.assertNoErrors

		rs.resources.add(nablaModule.eResource)
		var nablaGenModule = nablagenParseHelper.parse(genModel, rs)
		nablaGenModule.assertNoErrors

		return nablaGenModule
	}

	def getInterpreterContext(IrRoot ir, String jsonContent)
	{
		val handler = new ConsoleHandler
		handler.level = Level::OFF
		val moduleInterpreter = new IrInterpreter(ir, handler)
		return moduleInterpreter.interprete(jsonContent)
	}

	def void generateCode(CharSequence model, CharSequence genModel, String projectDir)
	{
		val interpreter = interpreterProvider.get
		val ir = getIr(model, genModel)
		val ngen = getNgen(model, genModel)
		interpreter.generateCode(ir, ngen.config.targets, ngen.config.simulation.iterationMax.name, ngen.config.simulation.timeMax.name, projectDir, ngen.config.levelDB)
	}

	private def getIr(CharSequence model, CharSequence genModel)
	{
		val interpreter = interpreterProvider.get
		val projectDir = pluginsPath + "fr.cea.nabla.ui/examples/NablaExamples"
		val ngen = getNgen(model, genModel)
		return interpreter.buildIr(ngen, projectDir)
	}
}
