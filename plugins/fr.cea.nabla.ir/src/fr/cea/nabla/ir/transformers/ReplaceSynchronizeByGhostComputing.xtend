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
import java.util.LinkedHashSet
import java.util.Map
import org.eclipse.emf.ecore.util.EcoreUtil

class ReplaceSynchronizeByGhostComputing extends IrTransformationStep
{
	override getDescription()
	{
		"Compute when a variable synchronization can be replace by ghost computing"
	}

	override transform(IrRoot ir, (String)=>void traceNotifier)
	{	
		val varStatueMap = getVariableStatusByJob(ir)
		val jobWithSynchronisationAndSynchronization = getJobsWithSynchronization(ir)
		val lastWriteMap = getLastWrite(ir)
		
		println
		printVarStatus(varStatueMap)
		println
		printJobAndVarWithSynchronization(jobWithSynchronisationAndSynchronization)
		println
		printGetLastWrite(lastWriteMap)
		println

		val jobsAllItem = new ArrayList<Job>
		while(!jobWithSynchronisationAndSynchronization.empty)
		{
			while(!jobWithSynchronisationAndSynchronization.head.value.empty)
			{
				val lastWrite = lastWriteMap.get(jobWithSynchronisationAndSynchronization.head.key).get(jobWithSynchronisationAndSynchronization.head.value.head.variable)
				
				print("\non traite " + jobWithSynchronisationAndSynchronization.head.key.name)
				print(" -> " + ArcaneUtils.getCodeName(jobWithSynchronisationAndSynchronization.head.value.head.variable))
				
				val bufferJobsAllItem = new ArrayList<Job>
				var done = true
				for(lw : lastWrite)
				{
					println(" | last write : " + lw.name + " pour " + jobWithSynchronisationAndSynchronization.head.value.head.variable.name + " (" + lastWrite.size + ")")
					if(!analyzeJob(lw, jobsAllItem, bufferJobsAllItem, varStatueMap, lastWriteMap))
					{
						done = false
						//break
					}
				}
				if(done === true)
				{
					EcoreUtil.delete(jobWithSynchronisationAndSynchronization.head.value.head)
					println("suppression synchro de " + jobWithSynchronisationAndSynchronization.head.value.head.variable.name + " dans " + jobWithSynchronisationAndSynchronization.head.key.name)
					print("bufferpath : ") for(jxx : bufferJobsAllItem) print(jxx.name + " ") println
					jobsAllItem += bufferJobsAllItem
				}
				
				jobWithSynchronisationAndSynchronization.head.value.remove(0)
			}
			jobWithSynchronisationAndSynchronization.remove(0)
		}
		convertOwnToAll(ir, jobsAllItem, varStatueMap)
		
		println
		println
		println
		printVarStatus(varStatueMap)
		println
		printJobAndVarWithSynchronization(jobWithSynchronisationAndSynchronization)
		println
	}

	override transform(DefaultExtensionProvider dep, (String)=>void traceNotifier)
	{
		throw new RuntimeException("Not yet implemented")
	}
	
	private static def Boolean analyzeJob(Job job, ArrayList<Job> path, ArrayList<Job> bufferPath, Map<Job, Map<Variable, Boolean>> varStatusMap, HashMap<Job, HashMap<Variable, ArrayList<Job>>> lastWriteMap)
	{
		println("on annalyse " + job.name)
		if(canIteredAllItem(job) === true)
		{
			if(!path.contains(job))
				bufferPath += job
					
			val notUpdatedInVars = getNotUpdateVars(job, varStatusMap.get(job))
			if(!notUpdatedInVars.empty)
			{
				print("pas tout les var sont update {") for(xx : notUpdatedInVars) print(xx.name + " ") println("}")
				
				for(v : notUpdatedInVars)
				{
					val lastWriteJob = lastWriteMap.get(job).get(v)
					for(lwj : lastWriteJob)
					{
						if(!path.contains(lwj) && !bufferPath.contains(lwj) && !analyzeJob(lwj, path, bufferPath, varStatusMap, lastWriteMap))
							return false
					}
				}
				
			}
			println("le job " + job.name + " a toutes ses vars update")
			
			return true
		}
		else
			println("bad Connectivity")
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
			/*if(j.instruction instanceof InstructionBlock)
			{
				val instructionBlock = j.instruction as InstructionBlock
				for(synchronize : instructionBlock.instructions.filter(Synchronize))
					mapUpdate.replace(synchronize.variable, true)
			}
			
			val map = new HashMap<Variable, Boolean>
			for(in : j.inVars)
			{
				if(!TypeContentProvider.isArcaneScalarType(in.type))
					map.put(in, mapUpdate.get(in))
			}*/
			res.put(j, new HashMap(allVariablesStatus.filter[k, v | j.inVars.contains(k)]))
		}
		
		val executeTimeLoopJob = ir.main.calls.filter(ExecuteTimeLoopJob).head
		
		// Prepare for ExecuteTimeLoop job
		for(v : executeTimeLoopJob.outVars)
			allVariablesStatus.replace(v, false)
		
		getVariableStatusByJobETLJ(executeTimeLoopJob, res, allVariablesStatus)
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
				if(job.instruction instanceof InstructionBlock)
				{
					val instructionBlock = job.instruction as InstructionBlock
					for(synchronize : instructionBlock.instructions.filter(Synchronize))
						mapUpdate.replace(synchronize.variable, true)
				}
				val map = new HashMap<Variable, Boolean>
				for(in : job.inVars)
				{
					if(!TypeContentProvider.isArcaneScalarType(in.type))
						map.put(in, mapUpdate.get(in))
				}
				statuts.put(job, map)
			}
		}
	}
	
	private static def ArrayList<Pair<Job, ArrayList<Synchronize>>> getJobsWithSynchronization(IrRoot ir)
	{
		val res = new ArrayList<Pair<Job, ArrayList<Synchronize>>>
		for(j : ir.jobs)
		{
			println("ICI C4EST CARR2 " + j.name + " " + j.eAllContents.filter(Synchronize).size)
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
		
		
		val executeTimeLoopJob = ir.main.calls.filter(ExecuteTimeLoopJob).head
		val allETLJob = getAllJobsETLJ(executeTimeLoopJob)
		for(job : allETLJob)
		{
			val mapVar = new HashMap<Variable, ArrayList<Job>>
			for(v : job.inVars)
			{
				if(!TypeContentProvider.isArcaneScalarType(v.type))
				{
					val listJob = new ArrayList<Job>
					for(previous : job.previousJobs.filter[x | !(x instanceof ExecuteTimeLoopJob)])
					{
						if(previous.outVars.contains(v))
						{
							listJob += previous
						}
					}
					
					if(v instanceof TimeVariable)
					{
						var timeVar = v as TimeVariable
						for(j : allETLJob)
						{
							val outTimeVar = j.outVars.filter(TimeVariable)
							for(otv : outTimeVar)
							{
								if(otv.originName === timeVar.originName &&
								   otv.timeIterator === timeVar.timeIterator &&
								   (otv.timeIteratorIndex === timeVar.timeIteratorIndex || otv.timeIteratorIndex >= timeVar.timeIteratorIndex) &&
								   !(listJob.contains(j))
								   )
								{
									listJob += j
								}
							}
						}
					}
					mapVar.put(v, listJob)
				}	
			}
			res.put(job, mapVar)
		}		
		return res
	}
	
	private static def ArrayList<Job> getAllJobsETLJ(ExecuteTimeLoopJob executeTimeLoopJob)
	{
		val res = new ArrayList<Job>
		for(j : executeTimeLoopJob.calls)
		{
			if(j instanceof ExecuteTimeLoopJob)
			{
				val jETLJ = j as ExecuteTimeLoopJob
				res += getAllJobsETLJ(jETLJ)
			}
			else
				res += j
		}
		return res
	}
	
	private static def void convertOwnToAll(IrRoot ir, ArrayList<Job> jobs, Map<Job, Map<Variable, Boolean>> map)
	{
		val timeVarsList = new LinkedHashSet<TimeVariable>
		
		print("On convertie ")
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
			print(j.name + " ")
			
			for(v : j.outVars.filter(TimeVariable))
				timeVarsList += v
		}
		
		
		val executeTimeLoopJobs = new LinkedHashSet<Job>
		for(timeVar : timeVarsList)
			executeTimeLoopJobs += timeVar.timeIterator.timeLoopJob

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
				if(affectation.left.target instanceof TimeVariable)
				{
					val timeVar = affectation.left.target as TimeVariable
					if(timeVarsList.contains(timeVar))
					{
						changeToAll = true
						//break
					}
				}
			}
			
			if(changeToAll === true)
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
		
		println("en allItem")
	}
	
	private static def Boolean canIteredAllItem(Job job)
	{
		for(l : job.eAllContents.filter(Loop).toIterable)
		{
			val iterationblock = l.iterationBlock
			if(iterationblock instanceof Iterator)
			{
				val iteratorBlock = iterationblock as Iterator
				val connectivityCall = ContainerExtensions.getConnectivityCall(iteratorBlock.container)

				println("connectivity " + connectivityCall.connectivity.name + " local : " + connectivityCall.connectivity.local)
				if(!connectivityCall.connectivity.local || connectivityCall.group !== null)
					return false
			}		
		}
		return true
	}
	
	private static def ArrayList<Variable> getNotUpdateVars(Job job, Map<Variable, Boolean> mapStatus)
	{
		val res = new ArrayList<Variable>
		for(v : job.inVars)
		{
			if(mapStatus.get(v) === false)
				res += v
		}
		return res
	}
	
	/////////////////////////////////////////////////////////////////////////
	
	/*private static def Boolean validConnectivity(Connectivity connectivity)
	{
		if(connectivity.name == "cells" ||
		   connectivity.name == "faces" ||
		   connectivity.name == "nodes" ||
		   connectivity.name == "nodesOfCell" ||
		   connectivity.name == "nodesOfFace" ||
		   connectivity.name == "firstNodeOfFace" ||
		   connectivity.name == "secondNodeOfFace" ||
		   connectivity.name == "facesOfCell" ||
		   connectivity.name == "topFaceOfCell" ||
		   connectivity.name == "bottomFaceOfCell" ||
		   connectivity.name == "leftFaceOfCell" ||
		   connectivity.name == "rightFaceOfCell")
		{
			return true	
		}
		return false
	}*/
	
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
			println(i.key.name + "{")
			for(j : i.value.entrySet)
			{
				println("\t" + j.key.name + "[")
				for(k : j.value)
				{
					println("\t\t" + k.name)
				}
				println("\t]")
			}
			println("\n}")	
		}
	}
}











