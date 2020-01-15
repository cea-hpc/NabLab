/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator

import fr.cea.nabla.ir.ir.SizeTypeInt
import fr.cea.nabla.ir.ir.SizeTypeOperation
import fr.cea.nabla.ir.ir.SizeTypeSymbolRef

class SizeTypeContentProvider 
{
	static def dispatch CharSequence getContent(SizeTypeInt it) '''«value»'''
	static def dispatch CharSequence getContent(SizeTypeSymbolRef it) '''«target.name»'''
	static def dispatch CharSequence getContent(SizeTypeOperation it) '''«left.content» «operator» «right.content»'''
}