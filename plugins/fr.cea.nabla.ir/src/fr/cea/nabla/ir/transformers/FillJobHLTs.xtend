/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.transformers

import fr.cea.nabla.ir.ir.EndOfTimeLoopJob
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.Job
import java.util.ArrayList
import java.util.HashMap
import org.jgrapht.alg.cycle.CycleDetector
import org.jgrapht.alg.shortestpath.FloydWarshallShortestPaths
import org.jgrapht.graph.DefaultWeightedEdge
import org.jgrapht.graph.DirectedWeightedPseudograph

import static extension fr.cea.nabla.ir.JobExtensions.*
import fr.cea.nabla.ir.ir.NextTimeLoopIterationJob

class FillJobHLTs implements IrTransformationStep
{
	static val TimeLoopSourceNodeLabel = 'TimeLoopSourceNode'
	static val GlobalSourceNodeLabel = 'GlobalSourceNode'
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
		if (m.hasCycles) return false

		// No cyles => create TimeLoopBody instances
		

		// Graph creation
		val globalSourceNode = IrFactory::eINSTANCE.createInstructionJob => [ name = GlobalSourceNodeLabel ]
		val timeLoopSourceNode = IrFactory::eINSTANCE.createInstructionJob => [ name = TimeLoopSourceNodeLabel ]
		val g = m.createGraph(globalSourceNode, timeLoopSourceNode)

		// Computing 'at' values
		val cycles = g.findCycle
		val hasCycles = (cycles !== null)
		if (hasCycles)
		{
			outputTraces += '*** HLT impossible calculation: graph contains cycles.'
			outputTraces += '*** ' + cycles.map[name].join(' -> ')
		}
		else
		{
			val jalgo = new FloydWarshallShortestPaths<Job, DefaultWeightedEdge>(g)	

			/*
			 * Compute 'at' values of time loop nodes starting from timeLoopSourceNode.
			 * We need the longest path to each node. The jgrapht algorithm computes the shortest path.
			 * To get the longest path, edges weight is set to -1.
			 */
			var maxAtValue = 0.0
			g.edgeSet.forEach[e | g.setEdgeWeight(e, -1)]
			for (v : g.vertexSet.filter[v | v!=timeLoopSourceNode])
			{
				val graphPath = jalgo.getPath(timeLoopSourceNode, v)
				if (graphPath!==null) 
				{
					val atValue = Math::abs(graphPath.weight)
					graphPath.endVertex.at = atValue
					if (atValue > maxAtValue) maxAtValue = atValue
				}
			}

			// Compute 'at' values of init nodes. They are non initialized nodes with 'at' == 0.
			val weightByJobs = new HashMap<Job, Double>
			for (v : g.vertexSet.filter[v | v!=globalSourceNode && (v.at as int)==0])
			{
				val graphPath = jalgo.getPath(globalSourceNode, v)
				if (graphPath!==null) weightByJobs.put(graphPath.endVertex, graphPath.weight)
			}
			if (!weightByJobs.empty)
			{
				val minWeight = weightByJobs.values.min
				for (j : weightByJobs.keySet) j.at = minWeight - weightByJobs.get(j) - 1
			}

			/* 
			 * At this point, 'at' values of each node are ok.
			 * EndOfTimeLoop nodes (Xn = Xn+1) are not executed at the end: the earlier 'at' has been set.
			 * No problem if Xn+1 is copied into Xn but they are optimized: values are just swapped Xn <-> Xn+1.
			 * So, if a job executed after that takes Xn+1 as an in variable, it will use Xn because of the swap.
			 * Consequently, EndOfTimeLoop nodes are executed at the last level of 'at'.
			 */
			for (j : g.vertexSet.filter(EndOfTimeLoopJob))
				j.at = maxAtValue
		}

		return !hasCycles
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
		// Create nodes 
		val g = new DirectedWeightedPseudograph<Job, DefaultWeightedEdge>(DefaultWeightedEdge)
		jobs.forEach[x | g.addVertex(x)]

		// Create edges: no outgoing edges from NextTimeLoopIterationJob instances to break time cycles.
		for (from : jobs.reject(NextTimeLoopIterationJob))
			for (to : from.nextJobs)
				g.addEdge(from, to)

		// Add a global source node and edges to nodes with no incoming edges
		val globalSourceNode = IrFactory::eINSTANCE.createInstructionJob => [ name = GlobalSourceNodeLabel ]
		g.addVertex(globalSourceNode)
		g.vertexSet.filter[v | v!==globalSourceNode && g.incomingEdgesOf(v).empty].forEach[x | g.addEdge(globalSourceNode, x)]

		// display graph
		// g.print

		val cycles = g.findCycle
		val hasCycles = (cycles !== null)
		if (hasCycles)
		{
			outputTraces += '*** HLT impossible calculation: graph contains cycles.'
			outputTraces += '*** ' + cycles.map[name].join(' -> ')
		}

		return hasCycles
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
}
