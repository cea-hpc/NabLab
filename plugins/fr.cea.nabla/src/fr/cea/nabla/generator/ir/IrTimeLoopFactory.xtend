/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.generator.ir

import com.google.inject.Inject
import fr.cea.nabla.ir.ir.IrFactory
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.Job
import fr.cea.nabla.ir.ir.SimpleVariable
import fr.cea.nabla.ir.ir.TimeLoop
import fr.cea.nabla.ir.ir.TimeLoopContainer
import fr.cea.nabla.ir.ir.Variable
import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.CurrentTimeIteratorRef
import fr.cea.nabla.nabla.InitTimeIteratorRef
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NextTimeIteratorRef
import fr.cea.nabla.nabla.TimeIterator
import fr.cea.nabla.nabla.TimeIteratorBlock
import fr.cea.nabla.nabla.TimeIteratorRef
import fr.cea.nabla.nabla.Var
import java.util.ArrayList
import java.util.List

class IrTimeLoopFactory 
{
	@Inject extension IrJobFactory
	@Inject extension IrExpressionFactory
	@Inject extension IrArgOrVarFactory
	@Inject extension IrAnnotationHelper

	def dispatch ArrayList<SimpleVariable> createTimeLoopsAndIterationCounters(TimeLoopContainer tlContainer, TimeIteratorBlock nablaTimeIterator)
	{
		val timeLoopVariables = new ArrayList<SimpleVariable>
		for (ti : nablaTimeIterator.iterators)
			timeLoopVariables += createTimeLoopsAndIterationCounters(tlContainer, ti)
		return timeLoopVariables
	}

	def dispatch ArrayList<SimpleVariable> createTimeLoopsAndIterationCounters(TimeLoopContainer tlContainer, TimeIterator nablaTimeIterator)
	{
		val timeLoopVariables = new ArrayList<SimpleVariable>
		val ic = nablaTimeIterator.toIrIterationCounter
		timeLoopVariables += ic
		val timeLoop = nablaTimeIterator.toIrTimeLoop => [ iterationCounter = ic ]
		tlContainer.innerTimeLoops += timeLoop
		if (nablaTimeIterator.innerIterator !== null)
		{
			timeLoopVariables += createTimeLoopsAndIterationCounters(timeLoop, nablaTimeIterator.innerIterator)
		}
		return timeLoopVariables
	}

	def create IrFactory::eINSTANCE.createTimeLoop toIrTimeLoop(TimeIterator ti)
	{
		annotations += ti.toIrAnnotation
		name = ti.name
		whileCondition = ti.condition.toIrExpression
	}

	/**
	 * Create all needed time loop jobs:
	 * - a container job, instance of TimeLoopJob, for all time loop jobs,
	 * - a job to copy variables at each end of iteration, instance of NextTimeLoopIterationJob,
	 * - a set up job, instance of BeforeTimeLoopJob, to copy init variables if they exist,
	 * - a tear down job, instance of AfterTimeLoopJob only if the loop is nested into another one.
	 */
	def List<Job> createTimeLoopJobs(TimeLoopContainer tlContainer)
	{
		val createdJobs = new ArrayList<Job>
		for (tl : tlContainer.innerTimeLoops)
		{
			createdJobs += tl.toIrTimeLoopJob
			if (tlContainer instanceof TimeLoop || tl.variables.exists[init !== null]) createdJobs += tl.toIrBeforeTimeLoopJob
			if (tlContainer instanceof TimeLoop) createdJobs += tl.toIrAfterTimeLoopJob

			createdJobs += tl.createTimeLoopJobs
		}
		return createdJobs
	}

	/**
	 * If v variable is referenced with time iterators, create the associated time variables.
	 * If v is referenced with a time iterator n, v_n and v_nplus1 are necessarily created.
	 * If the time iterator is an instance of InitTimeIterator (n=0) then v_n0 is also created.
	 * Note that, if there are several iterators, for example v^{n+1, k}, v_nplus1 and v_n are
	 * created even if there are not directly referenced (useful for variables copy at the end of loop).
	 * Of course, in this case, v_nplus_k and v_nplus1_kplus1 are also created.
	 */
	def createIrVariablesFor(NablaModule m, Var v)
	{
		val createdVariables = new ArrayList<Variable>

		// Find all v references with time iterators
		val vRefsWithTimeIterators = m.eAllContents.filter(ArgOrVarRef).filter[target == v && !timeIterators.empty].toList

		// Is v a time variable ? 
		if (vRefsWithTimeIterators.empty)
			createdVariables += v.toIrVariable
		else
		{
			// Fill time loop variables for all iterators
			for (vRefsWithTimeIterator : vRefsWithTimeIterators)
			{
				for (tiRef : vRefsWithTimeIterator.timeIterators)
				{
					val ti = tiRef.target
					val tl = ti.toIrTimeLoop

					// Are variables for this timeloop already created ?
					if (!tl.variables.exists[name == v.name])
					{
						val hasInitTimeIterator = vRefsWithTimeIterators.exists[timeIterators.exists[x | x instanceof InitTimeIteratorRef && x.target == ti]]
						createdVariables += createIrTimeLoopVariablesFor(v, tl, hasInitTimeIterator)
					}
				}
			}
		}

		return createdVariables
	}

	private def createIrTimeLoopVariablesFor(Var v, TimeLoop tl, boolean mustCreateInitVariable)
	{
		val createdVariables = new ArrayList<Variable>
		val timeLoopVariable = IrFactory::eINSTANCE.createTimeLoopVariable => [ name = v.name ]
		tl.variables += timeLoopVariable

		// Current and next time variables necessarily exist.
		timeLoopVariable.current = v.toIrVar(getIrTimeSuffix(tl, currentName))
		timeLoopVariable.next = v.toIrVar(getIrTimeSuffix(tl, nextName))
		createdVariables += timeLoopVariable.current
		createdVariables += timeLoopVariable.next

		// The time variables can have no explicit affectation and consequently be created const
		// But at the end of time loop, the variable will be affected by the time loop job => must be non const
		if (timeLoopVariable.current instanceof SimpleVariable) (timeLoopVariable.current as SimpleVariable).const = false

		// Init time variable created on demand (if v is referenced with '=0')
		if (mustCreateInitVariable)
		{
			timeLoopVariable.init = v.toIrVar(getIrTimeSuffix(tl, initName))
			createdVariables += timeLoopVariable.init
		}

		return createdVariables
	}

	def getIrTimeSuffix(ArgOrVarRef it) 
	{ 
		if (timeIterators.empty) ''
		else timeIterators.suffixes
	}

	private def dispatch String getIrTimeSuffix(IrModule it, String type) { '' }
	private def dispatch String getIrTimeSuffix(TimeLoop it, String type) { getIrTimeSuffix(container, nextName) + '_' + name + type }

	private def getSuffixes(Iterable<TimeIteratorRef> timeIterators)
	{
		if (timeIterators === null || timeIterators.empty) ''
		else timeIterators.map['_' + target.name + typeName].join('')
	}

	private def dispatch getTypeName(CurrentTimeIteratorRef it) { currentName }
	private def dispatch getTypeName(InitTimeIteratorRef it) { initName }
	private def dispatch getTypeName(NextTimeIteratorRef it) { nextName }

	private def getCurrentName() { '' }
	private def getInitName() { '0' }
	private def getNextName() { 'plus1' }
}