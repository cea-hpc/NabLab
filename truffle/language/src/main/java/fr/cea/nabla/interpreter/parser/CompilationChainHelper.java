/**
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 * 
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 */
package fr.cea.nabla.interpreter.parser;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.List;

import org.apache.log4j.Logger;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.xtext.testing.InjectWith;
import org.eclipse.xtext.testing.util.ParseHelper;
import org.eclipse.xtext.testing.validation.ValidationTestHelper;
import org.eclipse.xtext.validation.Issue;
import org.eclipse.xtext.xbase.lib.Exceptions;
import org.eclipse.xtext.xbase.lib.Extension;
import org.eclipse.xtext.xbase.lib.InputOutput;

import com.google.inject.Inject;
import com.google.inject.Injector;
import com.google.inject.Provider;

import fr.cea.nabla.NablaStandaloneSetup;
import fr.cea.nabla.NablagenStandaloneSetup;
import fr.cea.nabla.generator.IrModuleTransformer;
import fr.cea.nabla.generator.NablagenInterpreter;
import fr.cea.nabla.ir.ir.IrModule;
import fr.cea.nabla.ir.transformers.ReplaceReductions;
import fr.cea.nabla.nabla.NablaModule;
import fr.cea.nabla.nablagen.NablagenModule;

@InjectWith(NablaInjectorProvider.class)
@SuppressWarnings("all")
public class CompilationChainHelper {
	@Inject
	@Extension
	private ValidationTestHelper validationTestHelper;

	@Inject
	private Provider<NablagenInterpreter> interpreterProvider;

	@Inject
	private Provider<ResourceSet> resourceSetProvider;

	@Inject
	private IrModuleTransformer transformer;

	private NablaStandaloneSetup nablaSetup = new NablaStandaloneSetup();

	private Injector nablaInjector = this.nablaSetup.createInjectorAndDoEMFRegistration();

	private ParseHelper<NablaModule> nablaParseHelper = this.nablaInjector.<ParseHelper>getInstance(ParseHelper.class);

	private NablagenStandaloneSetup nablagenSetup = new NablagenStandaloneSetup();

	private Injector nablagenInjector = this.nablagenSetup.createInjectorAndDoEMFRegistration();

	private ParseHelper<NablagenModule> nablagenParseHelper = this.nablagenInjector
			.<ParseHelper>getInstance(ParseHelper.class);

	public IrModule getIrModule(final CharSequence model, final CharSequence genModel) {
		final String mathFunctionsPath = "/nablalib/mathfunctions.nabla";
		final String linearAlgebraFunctionsPath = "/nablalib/linearalgebrafunctions.nabla";
		return getIrModule(model, genModel, mathFunctionsPath, linearAlgebraFunctionsPath);
	}
	
	private InputStream getNablaResourceAsStream(String path) throws FileNotFoundException {
		InputStream result = getClass().getResourceAsStream(path);
		if (result == null) {
			final String testProjectPath = System.getProperty("user.dir");
			final String nablaPluginsPath = testProjectPath + "/../../plugins/";
			final String mathFunctionsPath = nablaPluginsPath + "fr.cea.nabla";
			result = new FileInputStream(new File(mathFunctionsPath + path));
		}
		return result;
	}

	public IrModule getIrModule(final CharSequence model, final CharSequence genModel, String mathFunctionsPath,
			String linearAlgebraFunctionsPath) {
		try {
			final InputStream inMath = getNablaResourceAsStream(mathFunctionsPath);
			final InputStream inLinear = getNablaResourceAsStream(linearAlgebraFunctionsPath);
			final String mathFunctions = new BufferedReader(new InputStreamReader(inMath)).lines()
					.reduce((s1, s2) -> s1 + "\n" + s2).get();
			final String linearAlgebraFunctions = new BufferedReader(new InputStreamReader(inLinear)).lines()
					.reduce((s1, s2) -> s1 + "\n" + s2).get();
			final ResourceSet rs = resourceSetProvider.get();
			nablaParseHelper.parse(mathFunctions, rs);
			nablaParseHelper.parse(linearAlgebraFunctions, rs);
			final NablaModule nablaModule = nablaParseHelper.parse(model, rs);
			validate(nablaModule);
			rs.getResources().add(nablaModule.eResource());
			final NablagenModule nablaGenModule = nablagenParseHelper.parse(genModel, rs);
			validate(nablaGenModule);
			if (nablaGenModule.getConfig() != null) {
				final NablagenInterpreter interpreter = interpreterProvider.get();
				final IrModule irModule = interpreter.buildIrModule(nablaGenModule.getConfig(), "");
				final ReplaceReductions replaceReductions = new ReplaceReductions(true);
				transformer.transformIr(replaceReductions, irModule, msg -> InputOutput.<String>println(msg));
				return irModule;
			} else {
				return null;
			}
		} catch (Throwable _e) {
			throw Exceptions.sneakyThrow(_e);
		}
	}
	
	private void validate(EObject modelElement) {
		final List<Issue> issues = validationTestHelper.validate(modelElement);
		if (!issues.isEmpty()) {
			final String msg = issues.stream().map(i -> "At line " + i.getLineNumber() + ": " + i.getMessage())
					.reduce((i1, i2) -> i1 + "\n" + i2).get();
			throw new IllegalArgumentException(msg);
		}
	}
}
