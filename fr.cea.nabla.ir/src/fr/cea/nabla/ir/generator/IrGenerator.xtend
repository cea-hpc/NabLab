/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 * 	Benoit Lelandais - initial implementation
 * 	Marie-Pierre Oudot - initial implementation
 * 	Jean-Sylvain Camier - Nabla generation support
 *******************************************************************************/
package fr.cea.nabla.ir.generator

import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.transformers.IrTransformationStep
import java.util.List

interface IrGenerator 
{
	def String getFileExtension()
	def List<? extends IrTransformationStep> getTransformationSteps()
	def CharSequence getFileContent(IrModule it)	
}