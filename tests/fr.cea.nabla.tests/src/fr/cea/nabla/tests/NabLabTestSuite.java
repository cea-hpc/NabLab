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

@RunWith(Suite.class)

@Suite.SuiteClasses({
	BasicValidatorTest.class,
	TypeValidatorTest.class,
	DeclarationProviderTest.class,
	ExpressionTypeProviderTest.class,
	IteratorExtensionsTest.class,
	NablaScopeProviderTest.class,
	NablaParsingTest.class,
	NablagenParsingTest.class,
	ExpressionInterpreterTest.class,
	BinaryOperationsInterpreterTest.class,
	InstructionInterpreterTest.class,
	JobInterpreterTest.class,
	ModuleInterpreterTest.class
})

public class NabLabTestSuite {}
