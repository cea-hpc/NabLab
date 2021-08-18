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

import fr.cea.nabla.ir.annotations.TargetDispatchAnnotation
import fr.cea.nabla.ir.annotations.TargetType
import fr.cea.nabla.ir.annotations.VariableRegionAnnotation
import fr.cea.nabla.ir.annotations.VariableRegionAnnotation.RegionType
import fr.cea.nabla.ir.ir.Expression
import fr.cea.nabla.ir.ir.Function
import fr.cea.nabla.ir.ir.Instruction
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.Variable

class PutGpuAnnotations extends IrTransformationStep
{
	val GpuDispatchStrategy strategy
	
	new(GpuDispatchStrategy strategy)
	{
		super('Place GPU annotations on the IR tree')
		this.strategy = strategy
		this.strategy.init()
	}

	override protected transform(IrRoot ir)
	{
		trace('    IR -> IR: ' + description)

		// Apply strategy to dispatch things to CPU or GPU

		ir.eAllContents.filter(Instruction).forEach[ x |
			val dispatch = strategy.couldRunOnGPU(x) ? TargetType.GPU : TargetType.CPU
			x.annotations += TargetDispatchAnnotation::create(dispatch).irAnnotation
		]

		ir.eAllContents.filter(Function).forEach[ x |
			val dispatch = strategy.couldRunOnGPU(x) ? TargetType.GPU : TargetType.CPU
			x.annotations += TargetDispatchAnnotation::create(dispatch).irAnnotation
		]

		ir.eAllContents.filter(Job).forEach[ x |
			val dispatch = strategy.couldRunOnGPU(x) ? TargetType.GPU : TargetType.CPU
			x.annotations += TargetDispatchAnnotation::create(dispatch).irAnnotation
		]

		ir.eAllContents.filter(Expression).forEach[ x |
			val dispatch = strategy.couldRunOnGPU(x) ? TargetType.GPU : TargetType.CPU
			x.annotations += TargetDispatchAnnotation::create(dispatch).irAnnotation
		]

		// With any strategy the region read/write is the same

		val jobsOnCpu = ir.eAllContents.filter(Job).filter[ x |
			TargetDispatchAnnotation::get(x).targetType == TargetType.CPU
		]

		val variableReadOnCpu  = jobsOnCpu.map[inVars].toSet.flatten
		val variableWriteOnCpu = jobsOnCpu.map[outVars].toSet.flatten

		ir.eAllContents.filter(Variable).forEach[ v |
			val regionRead  = variableReadOnCpu.contains(v) ? RegionType.CPU : RegionType.GPU
			val regionWrite = variableWriteOnCpu.contains(v) ? RegionType.CPU : RegionType.GPU
			v.annotations += VariableRegionAnnotation::create(regionRead, regionWrite).irAnnotation
		]

		return true
	}
}