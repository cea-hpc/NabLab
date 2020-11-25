/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.tests.validation;

import org.junit.runner.RunWith;
import org.junit.runners.Suite;

@RunWith(Suite.class)

@Suite.SuiteClasses
({
	ArgOrVarRefValidatorTest.class,
	BasicValidatorTest.class,
	ExpressionValidatorTest.class,
	FunctionOrReductionValidatorTest.class,
	InstructionValidatorTest.class,
	NablagenValidatorTest.class,
	UniqueNameValidatorTest.class,
	UnusedValidatorTest.class,
})

public class NabLabValidationTestSuite {}
