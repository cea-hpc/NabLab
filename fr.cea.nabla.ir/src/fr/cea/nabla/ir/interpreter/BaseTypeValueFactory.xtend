/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.ir.Array1D
import fr.cea.nabla.ir.ir.Array2D
import fr.cea.nabla.ir.ir.Scalar

import static fr.cea.nabla.ir.interpreter.NablaValueFactory.*

class BaseTypeValueFactory
{
	static def dispatch NablaValue createValue(Scalar t) { createValue(t) }
	static def dispatch NablaValue createValue(Array1D t) { createValue(t, t.size)}
	static def dispatch NablaValue createValue(Array2D t) { createValue(t, t.nbRows, t.nbCols) }
}