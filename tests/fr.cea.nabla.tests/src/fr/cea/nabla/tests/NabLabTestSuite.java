/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.tests;

import org.junit.runner.RunWith;
import org.junit.runners.Suite;

import fr.cea.nabla.tests.interpreter.NabLabInterpreterTestSuite;
import fr.cea.nabla.tests.typeprovider.NabLabTypeProviderTestSuite;
import fr.cea.nabla.tests.validation.NabLabValidationTestSuite;

@RunWith(Suite.class)

@Suite.SuiteClasses
({
	// base parsing
	NablaParsingTest.class,
	NablagenParsingTest.class,

	// scope providers
	NablagenScopeProviderTest.class,
	NablaScopeProviderTest.class,

	IteratorExtensionsTest.class,

	NabLabTypeProviderTestSuite.class,
	NabLabValidationTestSuite.class,

	ConstExprServicesTest.class,
	DeclarationProviderTest.class,

	// integrated tests
	NabLabInterpreterTestSuite.class,
	NabLabTestsTest.class,
	NabLabExamplesTest.class,
})

public class NabLabTestSuite {}
