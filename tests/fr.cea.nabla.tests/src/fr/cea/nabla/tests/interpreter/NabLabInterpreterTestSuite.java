/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.tests.interpreter;

import org.junit.runner.RunWith;
import org.junit.runners.Suite;

import fr.cea.nabla.tests.interpreter.BinaryOperationsInterpreterTest;
import fr.cea.nabla.tests.interpreter.ExpressionInterpreterTest;
import fr.cea.nabla.tests.interpreter.InstructionInterpreterTest;
import fr.cea.nabla.tests.interpreter.JobInterpreterTest;
import fr.cea.nabla.tests.interpreter.ModuleInterpreterTest;

@RunWith(Suite.class)

@Suite.SuiteClasses
({
	BinaryOperationsInterpreterTest.class,
	ExpressionInterpreterTest.class,
	InstructionInterpreterTest.class,
	JobInterpreterTest.class,
	ModuleInterpreterTest.class
})

public class NabLabInterpreterTestSuite {}
