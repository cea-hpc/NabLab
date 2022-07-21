/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.ir.DefaultExtensionProvider
import fr.cea.nabla.ir.ir.ExecuteTimeLoopJob
import fr.cea.nabla.ir.ir.InstructionBlock
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.Synchronize
import fr.cea.nabla.ir.ir.TimeVariable
import fr.cea.nabla.ir.ir.Variable
import java.util.ArrayList
import java.util.HashMap
import org.eclipse.emf.ecore.util.EcoreUtil
import java.util.List
import fr.cea.nabla.ir.JobDependencies
import java.util.Map

class ComputeOverSynchronize extends IrTransformationStep
{
	override getDescription()
	{
		"Compute when a variable is synchronized and already update. And removes or not the synchronization"
	}

	override transform(IrRoot ir, (String)=>void traceNotifier)
	{	
		// Map initialisation for Init entry
		val mapUpdate = new HashMap<Variable, Boolean>
		// TODO filtre les variables de connectivités
		for(v : ir.variables)
		{
			val isUpdate = (v === ir.nodeCoordVariable) || (v === ir.initNodeCoordVariable) ? true : false
			mapUpdate.put(v, isUpdate)	
		}
		
		// Analyze Init job
		val initJob = ir.main.calls.filter[x | !(x instanceof ExecuteTimeLoopJob)]
		for(j : initJob)
			analyzeJob(j, mapUpdate)
			
		// Process for executeTimeLoop
		val executeTimeLoopJob = ir.main.calls.filter(ExecuteTimeLoopJob).head
		// TODO check si "ir.main.calls.filter(ExecuteTimeLoopJob)" a une size == 1
		
		// TODO faire une récursion sur les executeTimeLoopJob pour géner les cas ou il y en a plusieurs
		val varReadOnlyWithSyncho = getReadOnlyVarWithSynchronization(executeTimeLoopJob)
		if(!varReadOnlyWithSyncho.empty)
		{
			val at = executeTimeLoopJob.at - 1
			
			val newSynchronizejob = createSynchronizeJob(varReadOnlyWithSyncho, at)
			ir.modules.findFirst[x | x.main].jobs.add(newSynchronizejob)
			
			val index = ir.main.calls.indexOf(executeTimeLoopJob)
			ir.main.calls.add(index, newSynchronizejob)
			
			ir.jobs.add(newSynchronizejob)
			
			ir.jobs.forEach[x | JobDependencies.computeAndSetNextJobs(x)]
			
			for(v : varReadOnlyWithSyncho)
				mapUpdate.replace(v, true)
		}
		
		for(j : executeTimeLoopJob.calls)
		{
			for(v : j.outVars)
				mapUpdate.replace(v, false)
			
			for(v : j.inVars.filter(TimeVariable))
				mapUpdate.replace(v, false)
		}
		
		// Analyze ExecuteTimeLoop job
		for(j : executeTimeLoopJob.calls)
			analyzeJob(j , mapUpdate)
	}

	override transform(DefaultExtensionProvider dep, (String)=>void traceNotifier)
	{
		throw new RuntimeException("Not yet implemented")
	}
	
	private static def void analyzeJob(Job job, Map<Variable, Boolean> map)
	{
		if(job.instruction instanceof InstructionBlock)
		{
			val synchronizesToDelete = new ArrayList<Synchronize>
			
			val instructionBlock = job.instruction as InstructionBlock
			for(synchronize : instructionBlock.instructions.filter(Synchronize))
			{	
				if(map.get(synchronize.variable) === true)
					synchronizesToDelete += synchronize
				map.replace(synchronize.variable, true)
			}
			
			for(synchronize : synchronizesToDelete)
				EcoreUtil.delete(synchronize)
		}
	}
	
	private static def ArrayList<Variable> getReadOnlyVarWithSynchronization(ExecuteTimeLoopJob jobCaller)
	{		
		val res = new ArrayList<Variable>
		
		for(j : jobCaller.calls)
		{
			if(j.instruction instanceof InstructionBlock)
			{
				val instructionBlock = j.instruction as InstructionBlock
				for(s : instructionBlock.instructions.filter(Synchronize))
				{
					if(!(s.variable instanceof TimeVariable))
						res += s.variable
				}
			}	
		}
		
		for(o : jobCaller.allOutVars)
		{
			if(res.contains(o))
			{
				res.removeAll(o)
			}
		}
		
		return res
	}
	
	private def create IrFactory::eINSTANCE.createJob createSynchronizeJob(List<Variable> variables, double _at)
	{
		name = "SynchronizeBeforeTimeLoop"
		at = _at
		onCycle = false
		inVars.addAll(variables)
		
		val synchronizesinstructionBlock = IrFactory.eINSTANCE.createInstructionBlock
		for(v : variables)
		{
			synchronizesinstructionBlock.instructions += IrFactory.eINSTANCE.createSynchronize => [variable = v]
			inVars += v	
		}
		instruction = synchronizesinstructionBlock
		
		timeLoopJob = false
	}
}
