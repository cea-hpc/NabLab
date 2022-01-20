/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator

import fr.cea.nabla.ir.ir.DefaultExtensionProvider
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.transformers.IrTransformationStep

interface IrCodeGenerator
{
	static val TracePrefix = "    IR -> Code: "

	def String getName()
	def IrTransformationStep[] getIrTransformationSteps()
	def Iterable<GenerationContent> getGenerationContents(IrRoot ir, (String)=>void traceNotifier)
	def Iterable<GenerationContent> getGenerationContents(DefaultExtensionProvider provider, (String)=>void traceNotifier)
}