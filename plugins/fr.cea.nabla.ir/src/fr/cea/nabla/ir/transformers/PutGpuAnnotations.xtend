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
import fr.cea.nabla.ir.annotations.RegionType
import fr.cea.nabla.ir.annotations.TargetDispatchAnnotation
import fr.cea.nabla.ir.annotations.TargetType
import fr.cea.nabla.ir.annotations.VariableRegionAnnotation
import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.Expression
import fr.cea.nabla.ir.ir.Function
import fr.cea.nabla.ir.ir.Instruction
import fr.cea.nabla.ir.ir.InstructionBlock
import fr.cea.nabla.ir.ir.IrAnnotable
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.Job
import java.util.HashSet
import java.util.Iterator
import java.util.Set
import org.eclipse.emf.common.util.EList

class PutGpuAnnotations extends IrTransformationStep
{
	val GpuDispatchStrategy strategy
	
	new(GpuDispatchStrategy strategy)
	{
		super('Place GPU annotations on the IR tree')
		this.strategy = strategy
		this.strategy.init([ String str | trace(str) ])
	}

	override protected transform(IrRoot ir)
	{
		trace('    IR -> IR: ' + description)

		// Apply strategy to dispatch things to CPU or GPU.
		// First the leaf to root pass

		val (boolean)=>TargetType couldToTarget = [ b | b ? TargetType.GPU : TargetType.CPU ]

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
		// FIXME: Back propagation doesn't seems to work well...
		// FIXME: To verify: now the back propagation seems to work well

		ir.eAllContents.filter(Job).forEach[ x |
			x.instruction.backTargetPropagation(true)
		]

		// With any strategy the region read/write is the same

		val getJobsRegions = [ EList<Job> jobs |
			jobs.map[ j |
				EnumUtils::RegionFromTarget(TargetDispatchAnnotation::get(j).targetType)
			]
		]
		
		// For each individual variables, e.g. X_n, alpha, deltat, etc

		ir.variables.forEach[ v |
			val RegionType readRegion  = EnumUtils::FuseRegions(getJobsRegions.apply(v.consumerJobs))
			val RegionType writeRegion = EnumUtils::FuseRegions(getJobsRegions.apply(v.producerJobs))
			val oldAnnotation = VariableRegionAnnotation::get(v)

			if (oldAnnotation !== null) {
				val newAnnotation = VariableRegionAnnotation::create(readRegion, writeRegion)
				v.annotations += VariableRegionAnnotation::fuse(newAnnotation, oldAnnotation).irAnnotation
			} else {
				v.annotations += VariableRegionAnnotation::create(readRegion, writeRegion).irAnnotation
			}
		]

		// Link variables if needed, e.g. X_n0 <-> X_n <-> X_nplus1
		// FIXME: Only look at the current time iterator for now

		val Set<String> visitedNames = new HashSet<String>()
		ir.variables.forEach[ v |
			val timeIterator = v.timeIterator
			if (timeIterator !== null && !visitedNames.contains(v.originName)) {
				visitedNames.add(v.originName)

				val discretizedVars       = timeIterator.variables.filter[ originName == v.originName ]
				val initRegion            = VariableRegionAnnotation::get(v)
				val fusedVariableRegion   = VariableRegionAnnotation::fuse(discretizedVars.map[ ov | VariableRegionAnnotation::get(ov) ])
				val reFusedVariableRegion = VariableRegionAnnotation::fuse(fusedVariableRegion, initRegion)

				VariableRegionAnnotation::del(v)
				v.annotations += reFusedVariableRegion.irAnnotation
			}
		]

		return true
	}

	private def void backTargetPropagation(Instruction it, boolean toplevel)
	{
		val (IrAnnotable)=>void lambda = [ x |
			TargetDispatchAnnotation::del(x)
			x.annotations += TargetDispatchAnnotation::create(TargetType.CPU).irAnnotation
		]

		switch it
		{
			InstructionBlock:
			{
				instructions.forEach[ x | x.backTargetPropagation(toplevel) ]
				lambda.apply(it)
			}

			Affectation: if (toplevel || containsGpuBlacklistedElement)
			{
				lambda.apply(it)
				eAllContents.filter(Expression).forEach[ x | lambda.apply(x) ]
				eAllContents.filter(Instruction).forEach[ x | lambda.apply(x) ]
			}

			default: if (containsGpuBlacklistedElement)
			{
				lambda.apply(it)
				eAllContents.filter(Expression).forEach[ x | lambda.apply(x) ]
				eAllContents.filter(Instruction).forEach[ x | lambda.apply(x) ]
			}
		}
	}

	private def boolean containsGpuBlacklistedElement(IrAnnotable it)
	{
		val (Iterator<TargetDispatchAnnotation>)=>boolean lambda = [ x1 |
			if (x1 === null || x1.size == 0)
				return false;

			val x2 = x1.reject[null]
			if (x2.size == 0)
				return false;

			val x3 = x2.filter[targetType == TargetType.CPU]
			return x3.size >= 1
		]

		lambda.apply(eAllContents.filter(Expression).map[x | TargetDispatchAnnotation::get(x)]) ||
		lambda.apply(eAllContents.filter(Instruction).map[x | TargetDispatchAnnotation::get(x)])
	}
}