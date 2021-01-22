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
import fr.cea.nabla.nabla.NablaRoot
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
import fr.cea.nabla.NablaextStandaloneSetup
import fr.cea.nabla.nablaext.NablaextRoot

@RunWith(XtextRunner)
@InjectWith(NablaInjectorProvider)
class CompilationChainHelper
{
	@Inject extension ValidationTestHelper
	@Inject Provider<NablagenInterpreter> interpreterProvider
	@Inject Provider<ResourceSet> resourceSetProvider

	val nablaSetup = new NablaStandaloneSetup
	val nablaInjector = nablaSetup.createInjectorAndDoEMFRegistration
	val ParseHelper<NablaRoot> nablaParseHelper = nablaInjector.getInstance(ParseHelper)

	val nablagenSetup = new NablagenStandaloneSetup
	val nablagenInjector = nablagenSetup.createInjectorAndDoEMFRegistration
	val ParseHelper<NablagenRoot> nablagenParseHelper = nablagenInjector.getInstance(ParseHelper)

	val nablaextSetup = new NablaextStandaloneSetup
	val nablaextInjector = nablaextSetup.createInjectorAndDoEMFRegistration
	val ParseHelper<NablaextRoot> nablaextParseHelper = nablaextInjector.getInstance(ParseHelper)

	val testProjectPath = System.getProperty("user.dir")
	val pluginsPath = testProjectPath + "/../../plugins/"

	/** 
	 * Returns a module ready for interpretation i.e. with no reduction instruction.
	 */
	def getIrForInterpretation(CharSequence model, CharSequence genModel)
	{
		val interpreter = interpreterProvider.get
		val projectDir = pluginsPath + "fr.cea.nabla.ui/examples/NablaExamples"
		val ngen = getNgen(model, genModel)
		return interpreter.buildInterpreterIr(ngen, projectDir)
	}

	def getNgen(CharSequence model, CharSequence genModel)
	{
		val rs = resourceSetProvider.get

		// Read Math
		val mathPath = pluginsPath + "fr.cea.nabla/nablalib/math.nabla"
		nablaParseHelper.parse(new String(Files.readAllBytes(Paths.get(mathPath))), rs)

		// Read LinearAlgebra
		val linearAlgebraPath = pluginsPath + "fr.cea.nabla/nablalib/linearalgebra.nabla"
		nablaParseHelper.parse(new String(Files.readAllBytes(Paths.get(linearAlgebraPath))), rs)

		// Read LinearAlgebra.ext
		val linearAlgebraExtPath = pluginsPath + "fr.cea.nabla/nablalib/linearalgebra.nablaext"
		nablaextParseHelper.parse(new String(Files.readAllBytes(Paths.get(linearAlgebraExtPath))), rs)

		val nablaRoot = nablaParseHelper.parse(model, rs)
		nablaRoot.assertNoErrors
		rs.resources.add(nablaRoot.eResource)

		val ngen = nablagenParseHelper.parse(genModel, rs)
		ngen.assertNoErrors

		return ngen
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
		val ngen = getNgen(model, genModel)
		interpreter.generateCode(ngen, projectDir)
	}
}
