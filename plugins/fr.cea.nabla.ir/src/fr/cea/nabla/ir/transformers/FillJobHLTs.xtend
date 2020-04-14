/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.ir.AfterTimeLoopJob
import fr.cea.nabla.ir.ir.BeforeTimeLoopJob
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.JobContainer
import fr.cea.nabla.ir.ir.TimeLoop
import fr.cea.nabla.ir.ir.TimeLoopCopyJob
import fr.cea.nabla.ir.ir.TimeLoopJob
import java.util.ArrayList
import java.util.HashSet
import org.jgrapht.alg.cycle.CycleDetector
import org.jgrapht.alg.shortestpath.FloydWarshallShortestPaths
import org.jgrapht.graph.DefaultWeightedEdge
import org.jgrapht.graph.DirectedWeightedPseudograph

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.JobExtensions.*

class FillJobHLTs implements IrTransformationStep
{
	static val SourceNodeLabel = 'SourceNode'
	val outputTraces = new ArrayList<String>

	override getDescription() 
	{
		'Compute Hierarchical Logical Time (HLT) of each jobs'
	}

	/**
	 * Set the '@ attribute of every jobs of IrModule.
	 * The jgrapht library is used to compute the longest path to each node.
	 * Return false if the graph contains cycle (computing 'at' values is then impossible), true otherwise.
	 * If the graph contains cycles, nodes on cycle have their 'onCyle' attribute set to true.
	 */
	override transform(IrModule m)
	{
		if (m.jobs.empty) return true

		// check that IrModule has no job cycles (except timestep cycles)
		if (m.hasCycles) 
		{
			// All jobs belongs to the module. No dispatch possible.
			// Jobs are put in module inner jobs for graph display...
			m.innerJobs.addAll(m.jobs)
			return false
		}

		// No cycles => create subgraphs (i.e. JobContainer instances) corresponding to time loops
		m.dispatchJobsInTimeLoops

		// compute at for each subGraph
		val subGraphs = m.jobs.groupBy[jobContainer]
		for (subGraph : subGraphs.values)
			subGraph.fillAt

		return true
	}

	override getOutputTraces()
	{
		outputTraces
	}

//	private def print(DirectedWeightedPseudograph<Job, DefaultWeightedEdge> g)
//	{
//		println('Graph nodes : ')
//		g.vertexSet.forEach[x|println('  ' + x.name)]
//		println('Graph arcs : ')
//		g.edgeSet.forEach[x|println('  ' + g.getEdgeSource(x).name + ' -> ' + g.getEdgeTarget(x).name)]
//	}

	/** Build the jgrapht graph corresponding to IrModule and check if it has cycles */
	private def hasCycles(IrModule it)
	{
		val g = createGraph(jobs.reject(TimeLoopJob))

		val cycles = g.findCycle
		val hasCycles = (cycles !== null)
		if (hasCycles)
		{
			outputTraces += '*** HLT impossible calculation: graph contains cycles.'
			outputTraces += '*** ' + cycles.map[name].join(' -> ')
		}

		return hasCycles
	}

	/** Return a graph created from the list of nodes */
	private def createGraph(Iterable<Job> jobs)
	{
		// Create nodes 
		val g = new DirectedWeightedPseudograph<Job, DefaultWeightedEdge>(DefaultWeightedEdge)
		jobs.forEach[x | g.addVertex(x)]

		// Create edges: no outgoing edges from NextTimeLoopIterationJob instances to break time cycles.
		for (from : jobs)
			for (to : from.nextJobs.filter[jobContainer == from.jobContainer])
				g.addEdge(from, to)

		// Add a source node and edges to nodes with no incoming edges
		val sourceNode = IrFactory::eINSTANCE.createInstructionJob => [ name = SourceNodeLabel ]
		g.addVertex(sourceNode)
		for (startNode : g.vertexSet.filter[v | v !== sourceNode && g.incomingEdgesOf(v).empty])
			g.addEdge(sourceNode, startNode)

		// display graph
		// g.print
		return g
	}

	/** Return the nodes list implied in at least one cycle. Return null if no cycle */
	private def findCycle(DirectedWeightedPseudograph<Job, DefaultWeightedEdge> g)
	{
		val cycleDetector = new CycleDetector<Job, DefaultWeightedEdge>(g)
		if (cycleDetector.detectCycles) 
		{
			val nodesOnCycle = cycleDetector.findCycles
			nodesOnCycle.forEach[onCycle = true]
			return nodesOnCycle
		}
		else return null
	}

	/** 
	 * Split jobs in their corresponding time loops 
	 * i.e. add them to 'jobs' of TimeLoopJob instance.
	 * Warning: the module must not contain job cycles.
	 */
	private def void dispatchJobsInTimeLoops(IrModule it)
	{
		// distribute TimeLoopJob instances
		if (mainTimeLoop !== null)
		{
			distributeTimeLoopJobs(jobs.filter(TimeLoopCopyJob), it, mainTimeLoop)

			var tl = mainTimeLoop
			// Begin with the most inner time loop
			while (tl.innerTimeLoop !== null) tl = tl.innerTimeLoop
			do
			{
				val tlJob = tl.associatedJob
				//println("distribute jobs of time loop : " + tlJob.name)
				val tlInVariables = tlJob.copies.map[destination]
				val tlNextJobs = new HashSet<Job>
				tlInVariables.forEach[v | tlNextJobs += v.nextJobs]
				for (next : tlNextJobs.filterJobs)
					distributeJobsInTimeLoops(tl, next, '')
				tl = tl.outerTimeLoop
			}
			while (tl !== null)
		}

		// job with no container depends on module
		val jobsWithNoContainer = jobs.filter[jobContainer === null]
		for (j : jobsWithNoContainer) j.jobContainer = it
	}

	private def void distributeTimeLoopJobs(Iterable<TimeLoopCopyJob> jobs, JobContainer container, TimeLoop tl)
	{
		//println("distributeJobsInTimeLoops 1(" + container + ", " + tl.name + ")")
		//println("   inner jobs before : " + container.innerJobs.map[name].join(', '))
		container.innerJobs += jobs.filter[timeLoop === tl]
		//println("   inner jobs after : " + container.innerJobs.map[name].join(', '))

		if (tl.innerTimeLoop !== null)
			distributeTimeLoopJobs(jobs, tl.associatedJob, tl.innerTimeLoop)
	}

	private def void distributeJobsInTimeLoops(TimeLoop tl, Job j, String prefix)
	{
		//println(prefix + "distributeJobsInTimeLoops 2(" + tl.name + ", " + j.name + ")")
		switch j
		{
			BeforeTimeLoopJob:
			{
				// Start of another time loop. Do not follow next.
			}
			AfterTimeLoopJob:
			{
				if (tl.outerTimeLoop !== null)
					j.nextJobs.filterJobs.forEach[x | distributeJobsInTimeLoops(tl.outerTimeLoop, x, prefix + '\t')]
			}
			default:
			{
				tl.associatedJob.innerJobs += j
				j.nextJobs.filterJobs.forEach[x | distributeJobsInTimeLoops(tl, x, prefix + '\t')]
			}
		}
	}

	private def Iterable<Job> filterJobs(Iterable<Job> l)
	{
		l.filter[x | !(x instanceof TimeLoopJob) && x.jobContainer === null]
	}

	/*
	 * Compute 'at' values of time loop nodes starting from sourceNode.
	 * We need the longest path to each node. The jgrapht algorithm computes the shortest path.
	 * To get the longest path, edges weight is set to -1.
	 */
	private def void fillAt(Iterable<Job> jobs)
	{
		val g = createGraph(jobs)
		val jalgo = new FloydWarshallShortestPaths<Job, DefaultWeightedEdge>(g)

		var maxAtValue = 0.0
		g.edgeSet.forEach[e | g.setEdgeWeight(e, -1)]
		val sourceNode = g.vertexSet.findFirst[x | x.name == SourceNodeLabel]
		for (v : g.vertexSet.filter[v | v != sourceNode])
		{
			val graphPath = jalgo.getPath(sourceNode, v)
			if (graphPath!==null) 
			{
				val atValue = Math::abs(graphPath.weight)
				graphPath.endVertex.at = atValue
				if (atValue > maxAtValue) maxAtValue = atValue
			}
		}
	}
}
