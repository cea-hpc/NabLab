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

import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.transformers.IrTransformationStep
import java.util.Map
import org.eclipse.xtend.lib.annotations.Data

@Data
abstract class CodeGenerator
{
	val String name

	def boolean needIrTransformation() { irTransformationStep !== null }
	def IrTransformationStep getIrTransformationStep() { null }
	def Map<String, CharSequence> getFileContentsByName(IrModule it)
}