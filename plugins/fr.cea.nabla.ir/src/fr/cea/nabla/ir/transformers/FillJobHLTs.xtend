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

import fr.cea.nabla.ir.JobDependencies
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.JobContainer
import fr.cea.nabla.ir.ir.ExecuteTimeLoopJob
import org.eclipse.emf.common.util.ECollections
import org.eclipse.emf.common.util.EList
import org.jgrapht.alg.cycle.CycleDetector
import org.jgrapht.alg.shortestpath.FloydWarshallShortestPaths
import org.jgrapht.graph.DefaultWeightedEdge
import org.jgrapht.graph.DirectedWeightedPseudograph

class FillJobHLTs extends IrTransformationStep
{
	static val SourceNodeLabel = 'SourceNode'
	val extension JobDependencies = new JobDependencies
	val jobDispatcher = new JobDispatcher

	new()
	{
		super('Compute Hierarchical Logical Time (HLT) of each jobs')
	}

	/**
	 * Set the '@ attribute of every jobs of IrModule.
	 * The jgrapht library is used to compute the longest path to each node.
	 * Return false if the graph contains cycle (computing 'at' values is then impossible), true otherwise.
	 * If the graph contains cycles, nodes on cycle have their 'onCyle' attribute set to true.
	 */
	override transform(IrModule m)
	{
		trace('IR -> IR: ' + description)
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
		jobDispatcher.dispatchJobsInTimeLoops(m)

		// compute at for each subGraph
		val subGraphs = m.jobs.groupBy[jobContainer]
		for (subGraph : subGraphs.values)
			subGraph.fillAt

		// sort jobs by @at in IR
		m.jobs.sortByAtAndName
		m.innerJobs.sortByAtAndName
		m.jobs.filter(JobContainer).forEach[x | x.innerJobs.sortByAtAndName]
		return true
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
		val g = createGraph(jobs.reject(ExecuteTimeLoopJob))

		val cycles = g.findCycle
		val hasCycles = (cycles !== null)
		if (hasCycles)
		{
			trace('*** HLT error: graph contains cycles.')
			trace('*** ' + cycles.map[name].join(' -> '))
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
			for (to : from.nextJobs.filter[x | g.vertexSet.contains(x)])
				g.addEdge(from, to)

		// Add a source node and edges to nodes with no incoming edges
		val sourceNode = IrFactory::eINSTANCE.createInstructionJob => [ name = SourceNodeLabel ]
		g.addVertex(sourceNode)
		for (startNode : g.vertexSet.filter[v | v !== sourceNode && g.incomingEdgesOf(v).empty])
			g.addEdge(sourceNode, startNode)

		// display graph
		//g.print
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

	private def void sortByAtAndName(EList<Job> l)
	{
		ECollections.sort(l, [a, b | 
			if (a.at == b.at)
				a.name.compareTo(b.name)
			else // ascending order of at
				(a.at - b.at) as int
		])
	}
}
