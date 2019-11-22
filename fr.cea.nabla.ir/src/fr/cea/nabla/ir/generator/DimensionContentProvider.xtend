/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator

import fr.cea.nabla.ir.ir.DimensionInt
import fr.cea.nabla.ir.ir.DimensionOperation
import fr.cea.nabla.ir.ir.DimensionSymbolRef

class DimensionContentProvider 
{
	static def dispatch CharSequence getContent(DimensionInt it) '''«value»'''
	static def dispatch CharSequence getContent(DimensionSymbolRef it) '''«target.name»'''
	static def dispatch CharSequence getContent(DimensionOperation it) '''«left.content» «operator» «right.content»'''
}