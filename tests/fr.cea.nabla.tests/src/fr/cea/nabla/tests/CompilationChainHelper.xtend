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
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nablagen.NablagenModule
import java.nio.file.Files
import java.nio.file.Paths
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

	def getIrModule(CharSequence model, CharSequence genModel)
	{
		val testProjectPath = System.getProperty("user.dir")
		val pluginsPath = testProjectPath + "/../../plugins/"
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

		if (nablaGenModule.config !== null)
		{
			var interpreter = interpreterProvider.get
			val irModule = interpreter.launch(nablaGenModule.config, pluginsPath + "fr.cea.nabla.ui/examples/NablaExamples")
			return irModule
		}
		else
			return null
	}
}
