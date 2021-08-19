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

import fr.cea.nabla.ir.annotations.EnumUtils
import fr.cea.nabla.ir.annotations.TargetDispatchAnnotation
import fr.cea.nabla.ir.annotations.TargetType
import fr.cea.nabla.ir.annotations.VariableRegionAnnotation
import fr.cea.nabla.ir.ir.Expression
import fr.cea.nabla.ir.ir.Function
import fr.cea.nabla.ir.ir.Instruction
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.Job
import org.eclipse.emf.common.util.EList
import fr.cea.nabla.ir.annotations.RegionType

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

		val (boolean)=>TargetType couldToTarget = [ b | b ? TargetType.GPU : TargetType.CPU ]
		val getJobsRegions = [ EList<Job> jobs |
			jobs.map[ j |
				EnumUtils::RegionFromTarget(TargetDispatchAnnotation::get(j).targetType)
			]
		]

		// Apply strategy to dispatch things to CPU or GPU.
		// First the leaf to root pass

		ir.eAllContents.filter(Expression).forEach[ x |
			val dispatch = couldToTarget.apply(strategy.couldRunOnGPU(x))
			x.annotations += TargetDispatchAnnotation::create(dispatch).irAnnotation
		]

		ir.eAllContents.filter(Instruction).forEach[ x |
			val dispatch = couldToTarget.apply(strategy.couldRunOnGPU(x))
			x.annotations += TargetDispatchAnnotation::create(dispatch).irAnnotation
		]
		
		ir.eAllContents.filter(Function).forEach[ x |
			val dispatch = couldToTarget.apply(strategy.couldRunOnGPU(x))
			x.annotations += TargetDispatchAnnotation::create(dispatch).irAnnotation
		]

		ir.eAllContents.filter(Job).forEach[ x |
			val dispatch = couldToTarget.apply(strategy.couldRunOnGPU(x))
			x.annotations += TargetDispatchAnnotation::create(dispatch).irAnnotation
		]
		
		// Now the root to leaf pass. This is the same with any strategy
		// TODO

		// With any strategy the region read/write is the same

		ir.variables.forEach[ v |
			val RegionType readRegion  = EnumUtils::FuseRegions(getJobsRegions.apply(v.consumerJobs))
			val RegionType writeRegion = EnumUtils::FuseRegions(getJobsRegions.apply(v.producerJobs))
			v.annotations += VariableRegionAnnotation::create(readRegion, writeRegion).irAnnotation
		]

		return true
	}
}