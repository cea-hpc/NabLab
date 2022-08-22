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

import fr.cea.nabla.ir.ContainerExtensions
import fr.cea.nabla.ir.JobExtensions
import fr.cea.nabla.ir.generator.arcane.ArcaneUtils
import fr.cea.nabla.ir.generator.arcane.TypeContentProvider
import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.ArgOrVarRef
import fr.cea.nabla.ir.ir.DefaultExtensionProvider
import fr.cea.nabla.ir.ir.ExecuteTimeLoopJob
import fr.cea.nabla.ir.ir.InstructionBlock
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.Synchronize
import fr.cea.nabla.ir.ir.TimeVariable
import fr.cea.nabla.ir.ir.Variable
import java.util.ArrayList
import java.util.HashMap
import java.util.HashSet
import java.util.Map
import java.util.Set
import org.eclipse.emf.ecore.util.EcoreUtil

/* TODO
 * - Implémenter getLastWrite lorsque l'on a plusieur ExecuteTimeLoopJob dans JobCaller main
 */

class ReplaceSynchronizeByGhostComputing extends IrTransformationStep
{
	override getDescription()
	{
		"Compute when a variable synchronization can be replace by ghost computing"
	}

	override transform(IrRoot ir, (String)=>void traceNotifier)
	{
		val variablesStatue = getVariableStatusByJob(ir)
		val synchronizesInJobs = getJobsWithSynchronization(ir)
		val variablesLastWrite = getLastWrite(ir)
		
		val jobsToConvertToAllItem = new ArrayList<Job>
		val timeVariablesActualizationToAllItem = new HashSet<Variable>
		
		while(!synchronizesInJobs.empty)
		{
			while(!synchronizesInJobs.head.value.empty)
			{
				val lastWrite = variablesLastWrite.get(synchronizesInJobs.head.key).get(synchronizesInJobs.head.value.head.variable)
				
				val bufferJobsAllItem = new ArrayList<Job>
				val bufferTimeVariableActualizationToAllItem = new HashSet<Variable>
				var done = true
				for(lw : lastWrite)
				{
					if(!analyzeJob(lw, jobsToConvertToAllItem, bufferJobsAllItem, bufferTimeVariableActualizationToAllItem, variablesStatue, variablesLastWrite, synchronizesInJobs.head.value.head.variable))
					{
						done = false
						//break
					}
				}
				if(done === true)
				{
					EcoreUtil.delete(synchronizesInJobs.head.value.head)
					// TODO check si job vide et le supprimer
					jobsToConvertToAllItem += bufferJobsAllItem
					timeVariablesActualizationToAllItem += bufferTimeVariableActualizationToAllItem
				}
				synchronizesInJobs.head.value.remove(0)
			}
			synchronizesInJobs.remove(0)
		}
		convertJobsOwnToAll(ir, jobsToConvertToAllItem)
		convertTimeVariablesActializationOwnToAll(ir, timeVariablesActualizationToAllItem)
	}

	override transform(DefaultExtensionProvider dep, (String)=>void traceNotifier)
	{
		throw new RuntimeException("Not yet implemented")
	}
	
	private static def Boolean analyzeJob(Job job, ArrayList<Job> path, ArrayList<Job> bufferPath, Set<Variable> timeVariablesActualization, Map<Job, Map<Variable, Boolean>> varStatusMap, HashMap<Job, HashMap<Variable, ArrayList<Job>>> lastWriteMap, Variable variable)
	{
		if(JobExtensions.canIterateAllItem(job))
		{
			if(!path.contains(job) && !(job instanceof ExecuteTimeLoopJob))
				bufferPath += job
					
			val notUpdatedInVars = new ArrayList<Variable>
			if(job instanceof ExecuteTimeLoopJob)
			{	
				val tvariable = variable as TimeVariable
				// Only one actualization of TimeVariable in ExecuteTimeLoop is possible
				var keys = lastWriteMap.get(job).keySet.filter(TimeVariable).filter[x | x.originName === tvariable.originName]
				notUpdatedInVars += keys
				timeVariablesActualization += variable
			}
			else
				notUpdatedInVars += JobExtensions.getNoUpdatedVariables(job, varStatusMap.get(job))
				
			if(!notUpdatedInVars.empty)
			{
				for(v : notUpdatedInVars)
				{
					val lastWriteJob = lastWriteMap.get(job).get(v)
					for(lwj : lastWriteJob)
					{
						if(!path.contains(lwj) && !bufferPath.contains(lwj) && !analyzeJob(lwj, path, bufferPath, timeVariablesActualization, varStatusMap, lastWriteMap, v))
							return false
					}
				}
			}
			return true
		}
		return false
	}
	
	private static def Map<Job, Map<Variable, Boolean>> getVariableStatusByJob(IrRoot ir)
	{
		val res = new HashMap<Job, Map<Variable, Boolean>>

		val allVariablesStatus = new HashMap<Variable, Boolean>
		for(v : ir.variables.filter[x | !TypeContentProvider.isArcaneScalarType(x.type)])
		{
			val isUpdate = (v === ir.nodeCoordVariable) || (v === ir.initNodeCoordVariable) ? true : false
			allVariablesStatus.put(v, isUpdate)	
		}
		
		// Init Job
		val initJob = ir.main.calls.filter[x | !(x instanceof ExecuteTimeLoopJob)]
		for(j : initJob)
		{
			JobExtensions.updateVariablesStatus(j, allVariablesStatus)
			res.put(j, new HashMap(allVariablesStatus.filter[k, v | j.inVars.contains(k)]))
		}
		
		val executeTimeLoopJobs = ir.main.calls.filter(ExecuteTimeLoopJob)
		
		// Prepare for ExecuteTimeLoop job
		for(executeTimeLoopJob : executeTimeLoopJobs)
		{
			for(v : executeTimeLoopJob.allOutVars)
				allVariablesStatus.replace(v, false)
			for(v : executeTimeLoopJob.allInVars.filter(TimeVariable))
				allVariablesStatus.replace(v, false)
		
			getVariableStatusByJobETLJ(executeTimeLoopJob, res, allVariablesStatus)
		}
		return res
	}
	
	private static def void getVariableStatusByJobETLJ(ExecuteTimeLoopJob executeTimeLoopJob, Map<Job, Map<Variable, Boolean>> statuts, HashMap<Variable, Boolean> mapUpdate)
	{
		for(job : executeTimeLoopJob.calls)
		{
			if(job instanceof ExecuteTimeLoopJob)
			{
				val j = job as ExecuteTimeLoopJob
				getVariableStatusByJobETLJ(j, statuts, mapUpdate)
			}
			else
			{
				JobExtensions.updateVariablesStatus(job, mapUpdate)
				statuts.put(job, new HashMap(mapUpdate.filter[k, v | job.inVars.contains(k)]))
			}
		}
	}
	
	private static def ArrayList<Pair<Job, ArrayList<Synchronize>>> getJobsWithSynchronization(IrRoot ir)
	{
		val res = new ArrayList<Pair<Job, ArrayList<Synchronize>>>
		for(j : ir.jobs)
		{
			if(j.instruction instanceof InstructionBlock)
			{
				val instructionsSynchronize = new ArrayList<Synchronize>
				
				val instructionBlock = j.instruction as InstructionBlock
				for(synchronize : instructionBlock.instructions.filter(Synchronize))
				{
					instructionsSynchronize += synchronize
				}

				if(!instructionsSynchronize.empty)
				{
					val pair = new Pair<Job, ArrayList<Synchronize>>(j,instructionsSynchronize)
					res += pair
				}
			}
		}
		return res
	}
	
	private def HashMap<Job, HashMap<Variable, ArrayList<Job>>> getLastWrite(IrRoot ir)
	{
		val res = new HashMap<Job, HashMap<Variable, ArrayList<Job>>>
		
		val initJob = ir.main.calls.filter[x | !(x instanceof ExecuteTimeLoopJob)]
		for(j : initJob)
		{
			val mapVar = new HashMap<Variable, ArrayList<Job>>
			for(v : j.inVars)
			{
				if(!TypeContentProvider.isArcaneScalarType(v.type))
				{
					val listJob = new ArrayList<Job>
					for(previous : j.previousJobs)
					{
						if(previous.outVars.contains(v))
						{
							listJob += previous
						}
					}
					mapVar.put(v, listJob)
				}
			}
			res.put(j, mapVar) 
		}
		
		if(ir.main.calls.filter(ExecuteTimeLoopJob).size !== 1)
			throw new Exception("Not yet implemented")
		
		val executeTimeLoopJob = ir.main.calls.filter(ExecuteTimeLoopJob).head
		val allJobs = getAllJobs(executeTimeLoopJob)
		
		for(job : allJobs)
		{
			val mapVar = new HashMap<Variable, ArrayList<Job>>
			
			val variablesToCompute = new ArrayList<Variable>
			if(job instanceof ExecuteTimeLoopJob)
				variablesToCompute += getInVariables(job as ExecuteTimeLoopJob)
			else
				variablesToCompute += job.inVars.filter[x | !TypeContentProvider.isArcaneScalarType(x.type)]
			
			for(v : variablesToCompute)
			{
				val listJob = new ArrayList<Job>
				var needFindInit = true
				for(previous : job.previousJobsWithSameCaller.filter[x | !(x instanceof ExecuteTimeLoopJob)])
				{
					if(previous.outVars.contains(v))
					{
						listJob += previous
						needFindInit = false		
					}
				}
				
				if(needFindInit)
				{
					for(previous : job.previousJobs.filter[x | !(x instanceof ExecuteTimeLoopJob)])
					{
						if(previous.outVars.contains(v) && !listJob.contains(previous))
							listJob += previous
					}
				}
				
				if(v instanceof TimeVariable)
				{
					var timeVar = v as TimeVariable
					for(j : allJobs)
					{
						val outTimeVar = new ArrayList<Variable>
						if(j instanceof ExecuteTimeLoopJob)
							outTimeVar += getOutVariables(j as ExecuteTimeLoopJob)
						else
							outTimeVar += j.outVars.filter(TimeVariable)
						
						for(otv : outTimeVar)
						{
							if(otv.name === timeVar.name && !listJob.contains(j))
								listJob += j
						}
					}
				}
				mapVar.put(v, listJob)
			}
			res.put(job, mapVar)
		}
		return res
	}
	
	private static def ArrayList<Variable> getOutVariables(ExecuteTimeLoopJob executeTimeLoopJob)
	{
		val res = new ArrayList<Variable>
		
		val instruction = executeTimeLoopJob.instruction
		for(affectation : instruction.eAllContents.filter(Affectation).toIterable)
		{
			if(affectation.left.target instanceof Variable)
			{
				val variable = affectation.left.target as Variable
				
				if((variable instanceof TimeVariable) && !TypeContentProvider.isArcaneScalarType(variable.type))
					res += variable
			}
		}
		return res
	}
	
	private static def ArrayList<Variable> getInVariables(ExecuteTimeLoopJob executeTimeLoopJob)
	{
		val res = new ArrayList<Variable>
		
		val instruction = executeTimeLoopJob.instruction
		for(affectation : instruction.eAllContents.filter(Affectation).toIterable)
		{
			if(affectation.right instanceof ArgOrVarRef)
			{
				val argOrVarRef = affectation.right as ArgOrVarRef
				val argOrVar = argOrVarRef.target
				val variable = argOrVar as Variable
				
				if((variable instanceof TimeVariable) && !TypeContentProvider.isArcaneScalarType(variable.type))
					res += variable
			}
		}
		return res
	}
	
	private static def ArrayList<Job> getAllJobs(ExecuteTimeLoopJob executeTimeLoopJob)
	{
		val res = new ArrayList<Job>
		res += executeTimeLoopJob
		for(j : executeTimeLoopJob.calls)
		{
			if(j instanceof ExecuteTimeLoopJob)
			{
				val jETLJ = j as ExecuteTimeLoopJob
				res += getAllJobs(jETLJ)
			}
			else
				res += j
		}
		return res
	}
	
	
	private static def void convertJobsOwnToAll(IrRoot ir, ArrayList<Job> jobs)
	{
		for(j : jobs)
		{
			for(l : j.eAllContents.filter(Loop).toIterable)
			{
				val iterationblock = l.iterationBlock
				if(iterationblock instanceof Iterator)
				{
					val iteratorBlock = iterationblock as Iterator
					val connectivityCall = ContainerExtensions.getConnectivityCall(iteratorBlock.container)
					connectivityCall.allItems = true
				}		
			}
		}
	}
	
	private static def void convertTimeVariablesActializationOwnToAll(IrRoot ir, Set<Variable> timeVariablesActualization)
	{
		val executeTimeLoopJobs = ir.jobs.filter(ExecuteTimeLoopJob)

		val loopsList = new ArrayList<Loop>
		for(executeTimeLoopJob : executeTimeLoopJobs)
		{
			if(executeTimeLoopJob.instruction instanceof InstructionBlock)
			{
				val instructionBlock = executeTimeLoopJob.instruction as InstructionBlock
				for(loop : instructionBlock.instructions.filter(Loop))
					loopsList += loop
			}
			else if(executeTimeLoopJob.instruction instanceof Loop)
			{
				val loop = executeTimeLoopJob.instruction as Loop
				loopsList += loop
			}
		}
		
		for(loop : loopsList)
		{
			var changeToAll = false
			for(affectation : loop.eAllContents.filter(Affectation).toIterable)
			{
				if(affectation.left.target instanceof Variable)
				{
					val variable = affectation.left.target as Variable
					if(timeVariablesActualization.contains(variable))
					{
						changeToAll = true
						// break
					}
				}	
			}
			
			if(changeToAll)
			{
				val iterationblock = loop.iterationBlock
				if(iterationblock instanceof Iterator)
				{
					val iteratorBlock = iterationblock as Iterator
					val connectivityCall = ContainerExtensions.getConnectivityCall(iteratorBlock.container)
					connectivityCall.allItems = true
				}
			}
		}
	}
	
	/////////////////////////////////////////////////////////////////////////
	
	private def void printVarStatus(Map<Job, Map<Variable, Boolean>> varStatus)
	{
		println("varStatus : ")
		for(job : varStatus.entrySet)
		{
			print(job.key.name + " [")
			for(status : job.value.entrySet)
			{
				print(status.key.name + " -> " + status.value + "   ")
			}
			print("]")
			println
		}
	}
	
	private def printJobAndVarWithSynchronization(ArrayList<Pair<Job, ArrayList<Synchronize>>> jobAndVarWithSynchronization)
	{
		println("jobAndVarWithSynchronization : ")
		for(i : jobAndVarWithSynchronization)
		{
			print(i.key.name + " [")
			for(j : i.value)
			{
				print(j.variable.name + " ")
			}
			println("]")
		}
	}
	
	private def printGetLastWrite(HashMap<Job, HashMap<Variable, ArrayList<Job>>> lastWriteMap)
	{
		println("getLastWrite :")
		for(i : lastWriteMap.entrySet)
		{
			println(i.key.name + " " + i.key.at + "{")
			for(j : i.value.entrySet)
			{
				println("\t" + j.key.name + "[")
				for(k : j.value)
				{
					println("\t\t" + k.name + " " + k.at)
				}
				println("\t]")
			}
			println("\n}")	
		}
	}
}