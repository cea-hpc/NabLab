/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.ArgOrVarRefIteratorRef
import fr.cea.nabla.ir.ir.If
import fr.cea.nabla.ir.ir.InstructionBlock
import fr.cea.nabla.ir.ir.IntervalIterationBlock
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.IteratorRef
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.ReductionInstruction
import fr.cea.nabla.ir.ir.Return
import fr.cea.nabla.ir.ir.SpaceIterationBlock
import fr.cea.nabla.ir.ir.VarDefinition

import static fr.cea.nabla.ir.interpreter.DimensionInterpreter.*
import static fr.cea.nabla.ir.interpreter.ExpressionInterpreter.*
import static fr.cea.nabla.ir.interpreter.NablaValueSetter.*
import static fr.cea.nabla.ir.interpreter.VariableValueFactory.*

import static extension fr.cea.nabla.ir.generator.IteratorRefExtensions.*

class InstructionInterpreter
{
	static def dispatch NablaValue interprete(VarDefinition it, Context context)
	{
		context.logFinest("Interprete VarDefinition")
		for (v : variables)
			context.addVariableValue(v, createValue(v, context))
		return null
	}

	static def dispatch NablaValue interprete(InstructionBlock it, Context context)
	{
		context.logFinest("Interprete InstructionBlock")
		val innerContext = new Context(context)
		for (i : instructions)
		{
			val ret = interprete(i, innerContext)
			if (ret !== null)
				return ret
		}
		return null
	}

	static def dispatch NablaValue interprete(Affectation it, Context context)
	{
		context.logFinest("Interprete Affectation")
		val rightValue = interprete(right, context)
		val allIndices = left.iterators.map[x | context.getIndexValue(x)] + left.indices.map[x | interprete(x, context)]
		setValue(context.getVariableValue(left.target), allIndices.toList, rightValue)
		return null
	}

	static def dispatch NablaValue interprete(ReductionInstruction it, Context context)
	{
		// All reductionInstruction have been replaced by specific Ir Transformation Step
		throw new RuntimeException('Wrong path...')
	}

	static def dispatch NablaValue interprete(Loop it, Context context)
	{
		val b = iterationBlock
		switch b
		{
			SpaceIterationBlock:
			{
				context.logFinest("On traite la boucle " + b.range.container.connectivity.name)
				val connectivityName = b.range.container.connectivity.name
				val argIds =  b.range.container.args.map[x | context.getIdValue(x)]
				val container = context.meshWrapper.getElements(connectivityName, argIds)
				context.addIndexValue(b.range, 0)
				for (loopIteratorValue : 0..<container.size)
				{
					context.setIndexValue(b.range, loopIteratorValue)
					setIndices(b, context)
					val ret = interprete(body, context)
					if (ret !== null)
						return ret
				}
			}
			IntervalIterationBlock:
			{
				val nbElems = interprete(b.nbElems, context)
				context.addDimensionValue(b.index, 0)
				for (i : 0..<nbElems)
				{
					context.setDimensionValue(b.index, i)
					val ret = interprete(body, context)
					if (ret !== null)
						return ret
				}
			}
		}
		return null
	}

	static def dispatch NablaValue interprete(If it, Context context)
	{
		context.logFinest("Interprete If")
		val cond = interprete(condition, context) as NV0Bool
		if (cond.data) return interprete(thenInstruction, context)
		else if (elseInstruction !== null) return interprete(elseInstruction, context)
	}

	static def dispatch NablaValue interprete(Return it, Context context)
	{
		context.logFinest("Interprete Return")
		return interprete(expression, context)
	}

	private static def void setIndices(SpaceIterationBlock it, Context context)
	{
		setIndices(range, context)
		for (s : singletons)
		{
			context.addIndexValue(s, context.getSingleton(s))
			setIndices(s, context)
		}
	}

	private static def void setIndices(Iterator it, Context context)
	{
		// Not  necessary to look for neededId and neededIndex at each iteration
		for (neededId : context.getNeededIdsInContext(it))
			context.addIdValue(neededId, getIndexToId(neededId, context))
		for (neededIndex : context.getNeededIndicesInContext(it))
			context.addIndexValue(neededIndex, getIdToIndex(neededIndex, context))
	}

	private	static def getIndexToId(IteratorRef it, Context context)
	{
		val indexValue = getIndexValue(it, context)

		if (target.container.connectivity.indexEqualId || target.singleton)
			indexValue
		else
		{
			//TODO : Plus efficace de faire une méthode pour indexValue in container ?
			val connectivityName = target.container.connectivity.name
			val args =  target.container.args.map[x | context.getIdValue(x)]
			context.meshWrapper.getElements(connectivityName, args).get(indexValue)
		}
	}

	private static def getIdToIndex(ArgOrVarRefIteratorRef it, Context context)
	{
		val idValue = context.getIdValue(it)
		if (varContainer.indexEqualId) idValue
		else context.getIndexOf(it, idValue)
	}

	private static def getIndexValue(IteratorRef it, Context context)
	{
		val iteratorRefIndex = context.getIndexValue(target)
		if (shift === 0)
			return iteratorRefIndex
		else
		{
			val nbElems = context.connectivitySizes.get(target.container.connectivity)
			return (iteratorRefIndex + shift + nbElems)%nbElems
		}
	}
}