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

import fr.cea.nabla.ir.JobDependencies
import fr.cea.nabla.ir.generator.arcane.TypeContentProvider
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
import java.util.List
import java.util.Map
import org.eclipse.emf.ecore.util.EcoreUtil

class ComputeOverSynchronize extends IrTransformationStep
{
	override getDescription()
	{
		"Compute when a variable is synchronized and already update. And removes or not the synchronization"
	}

	override transform(IrRoot ir, (String)=>void traceNotifier)
	{	
		val variablesStatus = new HashMap<Variable, Boolean>

		// variablesStatus map initialization for Init entry
		for(v : ir.variables.filter[x | !TypeContentProvider.isArcaneScalarType(x.type)])
		{
			val isUpdate = (v === ir.nodeCoordVariable) || (v === ir.initNodeCoordVariable) ? true : false
			variablesStatus.put(v, isUpdate)
		}
		
		// Analyze Init job
		val initJob = ir.main.calls.filter[x | !(x instanceof ExecuteTimeLoopJob)]
		for(j : initJob)
			analyzeJob(j, variablesStatus)
			
		// Process for ExecuteTimeLoop
		val executeTimeLoopJobs = ir.main.calls.filter(ExecuteTimeLoopJob)
		
		val variablesReadOnlyWithSyncho = new ArrayList<Variable>
		for(executeTimeLoopJob : executeTimeLoopJobs)
			variablesReadOnlyWithSyncho += getReadOnlyVarWithSynchronization(executeTimeLoopJob)
		
		// New job creation for synchronize updated read only variables
		if(!variablesReadOnlyWithSyncho.empty)
		{
			val at = executeTimeLoopJobs.head.at - 1
			
			val newSynchronizejob = createSynchronizeJob(variablesReadOnlyWithSyncho, at)
			ir.modules.findFirst[x | x.main].jobs.add(newSynchronizejob)
			
			val index = ir.main.calls.indexOf(executeTimeLoopJobs.head)
			ir.main.calls.add(index, newSynchronizejob)
			ir.jobs.add(newSynchronizejob)
			
			ir.jobs.forEach[x | JobDependencies.computeAndSetNextJobs(x)]
			
			for(v : variablesReadOnlyWithSyncho)
				variablesStatus.replace(v, true)
		}
		
		// variablesStatus map initialization for executeTimeLoopJobs
		for(v : executeTimeLoopJobs.head.allOutVars)
			variablesStatus.replace(v, false)
		for(v : executeTimeLoopJobs.head.allInVars.filter(TimeVariable))
			variablesStatus.replace(v, false)
		
		// Analyze the top ExecuteTimeLoopJob
		for(executeTimeLoopJob : executeTimeLoopJobs)
			for(j : executeTimeLoopJobs.head.calls)
				analyzeJob(j , variablesStatus)
	}

	override transform(DefaultExtensionProvider dep, (String)=>void traceNotifier)
	{
		throw new RuntimeException("Not yet implemented")
	}
	
	private static def void analyzeJob(Job job, Map<Variable, Boolean> variablesStatus)
	{
		if(job instanceof ExecuteTimeLoopJob)
		{
			for(j : job.calls)
				analyzeJob(j, variablesStatus)
		}
		else if(job.instruction instanceof InstructionBlock)
		{
			val synchronizesToDelete = new ArrayList<Synchronize>
			
			val instructionBlock = job.instruction as InstructionBlock
			for(synchronize : instructionBlock.instructions.filter(Synchronize))
			{	
				if(variablesStatus.get(synchronize.variable) === true)
					synchronizesToDelete += synchronize
				variablesStatus.replace(synchronize.variable, true)
			}
			
			for(synchronize : synchronizesToDelete)
				EcoreUtil.delete(synchronize)
		}
	}	
	
	private static def List<Variable> getReadOnlyVarWithSynchronization(ExecuteTimeLoopJob job)
	{		
		val res = new ArrayList<Variable>
		
		for(j : job.calls)
		{
			if(j instanceof ExecuteTimeLoopJob)
			{
				val executeTimeLoopJob = j as ExecuteTimeLoopJob
				res += getReadOnlyVarWithSynchronization(executeTimeLoopJob)
			}
			else
			{
				val synchronizes = j.eAllContents.filter(Synchronize)
				for(synchronize : synchronizes.toIterable)
				{
					if(!(synchronize.variable instanceof TimeVariable))
						res += synchronize.variable
				}
			}
		}
		
		for(o : job.allOutVars)
		{
			if(res.contains(o))
				res.removeAll(o)
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
