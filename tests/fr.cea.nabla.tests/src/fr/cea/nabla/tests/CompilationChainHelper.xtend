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
import fr.cea.nabla.generator.application.NablagenApplicationGenerator
import fr.cea.nabla.generator.ir.IrRootBuilder
import fr.cea.nabla.ir.interpreter.IrInterpreter
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.nabla.NablaRoot
import fr.cea.nabla.nablagen.NablagenApplication
import fr.cea.nabla.nablagen.NablagenRoot
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
	@Inject Provider<NablagenApplicationGenerator> ngenAppGeneratorProvider
	@Inject Provider<IrRootBuilder> irRootBuilderProvider
	@Inject Provider<ResourceSet> resourceSetProvider

	val nablaSetup = new NablaStandaloneSetup
	val nablaInjector = nablaSetup.createInjectorAndDoEMFRegistration
	val ParseHelper<NablaRoot> nablaParseHelper = nablaInjector.getInstance(ParseHelper)

	val nablagenSetup = new NablagenStandaloneSetup
	val nablagenInjector = nablagenSetup.createInjectorAndDoEMFRegistration
	val ParseHelper<NablagenRoot> nablagenParseHelper = nablagenInjector.getInstance(ParseHelper)

	val testProjectPath = System.getProperty("user.dir")
	val pluginsPath = testProjectPath + "/../../plugins/"

	/** 
	 * Returns a module ready for interpretation i.e. with no reduction instruction.
	 */
	def getIrForInterpretation(CharSequence model, CharSequence genModel)
	{
		val irRootBuilder = irRootBuilderProvider.get
		val projectDir = pluginsPath + "fr.cea.nabla.ui/examples/NablaExamples"
		val ngen = getNgenApp(model, genModel)
		return irRootBuilder.buildInterpreterIr(ngen, projectDir)
	}

	def getNgenApp(CharSequence model, CharSequence genModel)
	{
		val rs = resourceSetProvider.get

		// Read math.nabla
		val mathPath = pluginsPath + "fr.cea.nabla/nablalib/math.n"
		nablaParseHelper.parse(new String(Files.readAllBytes(Paths.get(mathPath))), rs)

		// Read linearalgebra.n
		val linearAlgebraPath = pluginsPath + "fr.cea.nabla/nablalib/linearalgebra.n"
		nablaParseHelper.parse(new String(Files.readAllBytes(Paths.get(linearAlgebraPath))), rs)

		// Read linearalgebra.ngen
		val linearAlgebraGenPath = pluginsPath + "fr.cea.nabla/nablalib/linearalgebra.ngen"
		nablagenParseHelper.parse(new String(Files.readAllBytes(Paths.get(linearAlgebraGenPath))), rs)

		val nablaRoot = nablaParseHelper.parse(model, rs)
		nablaRoot.assertNoErrors
		rs.resources.add(nablaRoot.eResource)

		val ngenApp = nablagenParseHelper.parse(genModel, rs) as NablagenApplication
		ngenApp.assertNoErrors

		return ngenApp
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
		val generator = ngenAppGeneratorProvider.get
		val ngen = getNgenApp(model, genModel)
		generator.generateApplication(ngen, projectDir)
	}
}
