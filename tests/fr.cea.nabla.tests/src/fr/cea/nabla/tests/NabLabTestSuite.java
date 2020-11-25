/*******************************************************************************
 * Copyright (c) 2020 CEA
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
import fr.cea.nabla.tests.validation.NabLabValidationTestSuite;

@RunWith(Suite.class)

@Suite.SuiteClasses
({
	DeclarationProviderTest.class,
	ExpressionTypeProviderTest.class,
	IteratorExtensionsTest.class,
	NablaExamplesTest.class,
	NablagenParsingTest.class,
	NablagenScopeProviderTest.class,
	NablaParsingTest.class,
	NablaScopeProviderTest.class,
	NabLabInterpreterTestSuite.class,
	NabLabValidationTestSuite.class
})

public class NabLabTestSuite {}
