/*******************************************************************************
 * Copyright (c) 2022 CEA
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
import fr.cea.nabla.generator.CodeGenerator
import fr.cea.nabla.generator.ir.IrRootBuilder
import fr.cea.nabla.ir.interpreter.IrInterpreter
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.nabla.NablaRoot
import fr.cea.nabla.nablagen.NablagenApplication
import fr.cea.nabla.nablagen.NablagenRoot
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
	@Inject extension TestUtils
	@Inject Provider<CodeGenerator> codeGeneratorProvider
	@Inject Provider<IrRootBuilder> irRootBuilderProvider
	@Inject Provider<ResourceSet> resourceSetProvider

	val nablaSetup = new NablaStandaloneSetup
	val nablaInjector = nablaSetup.createInjectorAndDoEMFRegistration
	val ParseHelper<NablaRoot> nablaParseHelper = nablaInjector.getInstance(ParseHelper)

	val nablagenSetup = new NablagenStandaloneSetup
	val nablagenInjector = nablagenSetup.createInjectorAndDoEMFRegistration
	val ParseHelper<NablagenRoot> nablagenParseHelper = nablagenInjector.getInstance(ParseHelper)

	/** 
	 * Returns a module ready for interpretation i.e. with no reduction instruction.
	 */
	def getIrForInterpretation(CharSequence model, CharSequence genModel)
	{
		getIrForInterpretation(#[model], genModel)
	}

	def getIrForInterpretation(CharSequence[] models, CharSequence genModel)
	{
		val irRootBuilder = irRootBuilderProvider.get
		val wsPath = TestUtils.PluginsBasePath + ".ui/examples"
		val ngen = getNgenApp(models, genModel)
		return irRootBuilder.buildInterpreterIr(ngen, wsPath)
	}

	def getRawIr(CharSequence model, CharSequence genModel)
	{
		val irRootBuilder = irRootBuilderProvider.get
		val ngen = getNgenApp(#[model], genModel)
		return irRootBuilder.buildRawIr(ngen)
	}

	def getIrForGeneration(CharSequence model, CharSequence genModel)
	{
		val irRootBuilder = irRootBuilderProvider.get
		val ngen = getNgenApp(#[model], genModel)
		return irRootBuilder.buildGeneratorGenericIr(ngen)
	}

	def getNgenApp(CharSequence[] models, CharSequence genModel)
	{
		val rs = resourceSetProvider.get

		nablaParseHelper.parse(readFileAsString(TestUtils.CartesianMesh2DPath), rs)
		nablagenParseHelper.parse(readFileAsString(TestUtils.CartesianMesh2DGenPath), rs)
		nablaParseHelper.parse(readFileAsString(TestUtils.AssertPath), rs)
		nablaParseHelper.parse(readFileAsString(TestUtils.MathPath), rs)
		nablaParseHelper.parse(readFileAsString(TestUtils.LinearAlgebraPath), rs)
		nablagenParseHelper.parse(readFileAsString(TestUtils.LinearAlgebraGenPath), rs)

		for (model : models)
		{
			val nablaRoot = nablaParseHelper.parse(model, rs)
			nablaRoot.assertNoErrors
			rs.resources.add(nablaRoot.eResource)
		}

		val ngenApp = nablagenParseHelper.parse(genModel, rs) as NablagenApplication
		ngenApp.assertNoErrors

		return ngenApp
	}

	def getInterpreterContext(IrRoot ir, String jsonContent)
	{
		val handler = new ConsoleHandler
		handler.level = Level::OFF
		val interpreter = new IrInterpreter(handler)
		val testProjectPath = System.getProperty("user.dir")
		val wsPath = testProjectPath + "/../../"
		return interpreter.interprete(ir, jsonContent, wsPath)
	}

	def void generateCode(CharSequence[] models, CharSequence genModel, String wsPath, String projectName)
	{
		val generator = codeGeneratorProvider.get
		val ngen = getNgenApp(models, genModel)
		generator.generateCode(ngen, wsPath, projectName)
	}
}
