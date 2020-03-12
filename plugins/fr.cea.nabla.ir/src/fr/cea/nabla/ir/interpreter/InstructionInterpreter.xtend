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
import fr.cea.nabla.ir.ir.If
import fr.cea.nabla.ir.ir.Instruction
import fr.cea.nabla.ir.ir.InstructionBlock
import fr.cea.nabla.ir.ir.IntervalIterationBlock
import fr.cea.nabla.ir.ir.IrIndex
import fr.cea.nabla.ir.ir.IrUniqueId
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.ReductionInstruction
import fr.cea.nabla.ir.ir.Return
import fr.cea.nabla.ir.ir.SpaceIterationBlock
import fr.cea.nabla.ir.ir.VarDefinition
import java.util.Arrays

import static fr.cea.nabla.ir.interpreter.DimensionInterpreter.*
import static fr.cea.nabla.ir.interpreter.ExpressionInterpreter.*
import static fr.cea.nabla.ir.interpreter.NablaValueSetter.*
import static fr.cea.nabla.ir.interpreter.VariableValueFactory.*

class InstructionInterpreter
{

	// Switch to more efficient dispatch (also clearer for profiling)
	static def NablaValue interprete(Instruction it, Context context)
	{
		if (it instanceof Loop) {
			return interpreteLoop(context)
		} else if (it instanceof ReductionInstruction) {
			return interpreteReductionInstruction(context)
		} else if (it instanceof Affectation) {
			return interpreteAffectation(context)
		} else if (it instanceof If) {
			return interpreteIf(context)
		} else if (it instanceof InstructionBlock) {
			return interpreteInstructionBlock(context)
		} else if (it instanceof Return) {
			return interpreteReturn(context)
		} else if (it instanceof VarDefinition) {
			return interpreteVarDefinition(context)
		} else {
			throw new IllegalArgumentException("Unhandled parameter types: " +
				Arrays.<Object>asList(it, context).toString());
		}
	}

	static def NablaValue interpreteVarDefinition(VarDefinition it, Context context)
	{
		context.logFinest("Interprete VarDefinition")
		for (v : variables)
			context.addVariableValue(v, createValue(v, context))
		return null
	}

	static def NablaValue interpreteInstructionBlock(InstructionBlock it, Context context)
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

	static def NablaValue interpreteAffectation(Affectation it, Context context)
	{
		context.logFinest("Interprete Affectation")
		val rightValue = interprete(right, context)
		// Switch to more efficient implementation (avoid costly toList calls)
		val allIndices = newArrayList
		left.iterators.forEach[x|allIndices.add(context.getIndexValue(x))]
		left.indices.forEach[x|allIndices.add(interprete(x, context))]
		setValue(context.getVariableValue(left.target), allIndices, rightValue)
		return null
	}

	static def NablaValue interpreteReductionInstruction(ReductionInstruction it, Context context)
	{
		// All reductionInstruction have been replaced by specific Ir Transformation Step
		throw new RuntimeException('Wrong path...')
	}

	static def NablaValue interpreteLoop(Loop it, Context context)
	{
		val b = iterationBlock
		switch b
		{
			SpaceIterationBlock:
			{
				val itIndex = b.range.index
				val connectivityName = itIndex.container.connectivity.name
				context.logFinest("On traite la boucle " + connectivityName)
				val argIds =  itIndex.container.args.map[x | context.getIdValue(x)]
				val container = context.meshWrapper.getElements(connectivityName, argIds)
				context.addIndexValue(itIndex, 0)
				for (loopIteratorValue : 0..<container.size)
				{
					context.setIndexValue(itIndex, loopIteratorValue)
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

	static def NablaValue interpreteIf(If it, Context context)
	{
		context.logFinest("Interprete If")
		val cond = interprete(condition, context) as NV0Bool
		if (cond.data) return interprete(thenInstruction, context)
		else if (elseInstruction !== null) return interprete(elseInstruction, context)
	}

	static def NablaValue interpreteReturn(Return it, Context context)
	{
		context.logFinest("Interprete Return")
		return interprete(expression, context)
	}

	private static def void setIndices(SpaceIterationBlock it, Context context)
	{
		setIndices(range, context)
		for (s : singletons)
		{
			context.addIndexValue(s.index, context.getSingleton(s))
			setIndices(s, context)
		}
	}

	private static def void setIndices(Iterator it, Context context)
	{
		// Not  necessary to look for neededId and neededIndex at each iteration
		for (neededId : neededIds)
			context.addIdValue(neededId, getIndexToId(neededId, context))
		for (neededIndex : neededIndices)
			context.addIndexValue(neededIndex, getIdToIndex(neededIndex, context))
	}

	private static def getIndexToId(IrUniqueId it, Context context)
	{
		val indexValue = getIndexValue(it, context)

		if (defaultValueIndex.container.connectivity.indexEqualId)
			indexValue
		else
		{
			//TODO : Plus efficace de faire une méthode pour indexValue in container ?
			val connectivityName = defaultValueIndex.container.connectivity.name
			val args =  defaultValueIndex.container.args.map[x | context.getIdValue(x)]
			context.meshWrapper.getElements(connectivityName, args).get(indexValue)
		}
	}

	private static def getIdToIndex(IrIndex it, Context context)
	{
		val idValue = context.getIdValue(defaultValueId)
		if (container.connectivity.indexEqualId) idValue
		else 
		{
			val connectivityName = container.connectivity.name
			val args =  container.args.map[x | context.getIdValue(x)]
			val elements = context.meshWrapper.getElements(connectivityName, args)
			elements.indexOf(idValue)
		}
	}

	private static def getIndexValue(IrUniqueId it, Context context)
	{
		val iteratorRefIndex = context.getIndexValue(defaultValueIndex)
		if (shift === 0)
			return iteratorRefIndex
		else
		{
			val nbElems = context.connectivitySizes.get(defaultValueIndex.container.connectivity)
			return (iteratorRefIndex + shift + nbElems)%nbElems
		}
	}
}