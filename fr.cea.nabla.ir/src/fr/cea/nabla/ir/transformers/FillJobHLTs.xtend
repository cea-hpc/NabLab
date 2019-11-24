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
	 * Prend en paramètre une instance de IrModule et renseigne l'attribut @ des jobs
	 * en utilisant des fonctionnalités de la bibliothèque de graphe jgrapht.
	 * Retourne faux si le graphe a des cycles et que le calcul des @ est impossible, vrai sinon.
	 * Si le graphe a des cycles, les noeuds impliqués ont leur attribut onCycle à vrai.
	 */
	override transform(IrModule m)
	{
		if (m.jobs.empty) return true

		// creation du graphe
		val globalSourceNode = IrFactory::eINSTANCE.createInstructionJob => [ name = GlobalSourceNodeLabel ]
		val timeLoopSourceNode = IrFactory::eINSTANCE.createInstructionJob => [ name = TimeLoopSourceNodeLabel ]
		val g = m.createGraph(globalSourceNode, timeLoopSourceNode)
		
		// calcul des @
		val cycles = g.findCycle
		val hasCycles = (cycles !== null)
		if (hasCycles)
		{
			outputTraces += '*** HLT calculation impossible: graph contains cycles.'
			outputTraces += '*** ' + cycles.map[name].join(' -> ')
		}
		else
		{
			val jalgo = new FloydWarshallShortestPaths<Job, DefaultWeightedEdge>(g)	
			
			// Calcul des at des noeuds de boucle en temps à partir de timeLoopSourceNode
			// Les at correspondent au plus long chemin. L'algo recherche le plus court. Il faut travailler avec l'inverse.
			// On initialise donc les arcs à -1
			g.edgeSet.forEach[e | g.setEdgeWeight(e, -1)]
			for (v : g.vertexSet.filter[v | v!=timeLoopSourceNode])
			{
				val graphPath = jalgo.getPath(timeLoopSourceNode, v)
				if (graphPath!==null) graphPath.endVertex.at = Math::abs(graphPath.weight)
			}
			
			// Calcul des at des noeuds d'init qui sont les noeuds restants (ceux avec at inchangé ; à 0).
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
		}
		return !hasCycles
	}
		
	override getOutputTraces() 
	{
		outputTraces
	}

	/** 
	 * Création d'un graphe correspondant à l'IR. 
	 * 2 noeuds sources sont ajoutés : 1 correspondant à un noeud source global 
	 * et l'autre à l'entrée de la boucle en temps. Notons que les arcs sortants
	 * des jobs de type EndOfTimeLoopJob ne sont pas construits pour éviter les cycles.
	 */
	private def createGraph(IrModule it, Job globalSourceNode, Job timeLoopSourceNode)
	{	
		val g = new DirectedWeightedPseudograph<Job, DefaultWeightedEdge>(DefaultWeightedEdge)
		jobs.forEach[x|g.addVertex(x)]
		g.addVertex(timeLoopSourceNode)
		for (from : jobs)
			for (to : from.nextJobs)
				if (from instanceof EndOfTimeLoopJob)
					g.addEdge(timeLoopSourceNode, to)
				else
					g.addEdge(from, to)	
		
		// ajout du noeud source global
		g.addVertex(globalSourceNode)
		g.vertexSet.filter[v | v!==globalSourceNode && v!==timeLoopSourceNode && g.incomingEdgesOf(v).empty].forEach[x | g.addEdge(globalSourceNode, x)]

		// affichage du graphe
		// g.print
		
		return g				
	}
	
//	private def print(DirectedWeightedPseudograph<Job, DefaultWeightedEdge> g)
//	{
//		println('Graph nodes : ')
//		g.vertexSet.forEach[x|println('  ' + x.name)]
//		println('Graph arcs : ')
//		g.edgeSet.forEach[x|println('  ' + g.getEdgeSource(x).name + ' -> ' + g.getEdgeTarget(x).name)]
//	}
	
	/** Retourne la liste des noeuds du graphe impliqués dans au moins un cycle, null si pas de cycle */
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
