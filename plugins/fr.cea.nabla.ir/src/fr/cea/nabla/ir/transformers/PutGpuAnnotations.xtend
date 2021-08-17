/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.annotations.VariableRegionAnnotation
import fr.cea.nabla.ir.annotations.VariableRegionAnnotation.RegionType
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.Variable

class PutGpuAnnotations extends IrTransformationStep
{
	new()
	{
		super('Place GPU annotations on the IR tree')
	}
	
	override protected transform(IrRoot ir)
	{
		trace('    IR -> IR: ' + description)
		
		// Default to all CPU for now
		ir.eAllContents.filter(Variable).forEach[ v |
			VariableRegionAnnotation::create(RegionType.CPU, RegionType.CPU).put(v)
		]

		return true
	}
}