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
import org.eclipse.xtend.lib.annotations.Accessors

abstract class IrGenerator 
{
	@Accessors(PUBLIC_GETTER, PUBLIC_SETTER) String generationDir
	@Accessors val String fileExtension
	@Accessors val List<? extends IrTransformationStep> transformationSteps

	new(String fileExtension, List<? extends IrTransformationStep> transformationSteps)
	{
		this.generationDir = null
		this.fileExtension = fileExtension
		this.transformationSteps = transformationSteps
	}
	
	abstract def CharSequence getFileContent(IrModule it)	
}