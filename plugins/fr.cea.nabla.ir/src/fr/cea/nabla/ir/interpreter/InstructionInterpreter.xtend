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
import fr.cea.nabla.ir.ir.Interval
import fr.cea.nabla.ir.ir.ItemIdDefinition
import fr.cea.nabla.ir.ir.ItemIdValueCall
import fr.cea.nabla.ir.ir.ItemIdValueIterator
import fr.cea.nabla.ir.ir.ItemIndexDefinition
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.ReductionInstruction
import fr.cea.nabla.ir.ir.Return
import fr.cea.nabla.ir.ir.VariablesDefinition
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
		} else if (it instanceof VariablesDefinition) {
			return interpreteVariablesDefinition(context)
		} else if (it instanceof ItemIdDefinition) {
			return interpreteItemIdDefinition(context)
		} else if (it instanceof ItemIndexDefinition) {
			return interpreteItemIndexDefinition(context)
		} else {
			throw new IllegalArgumentException("Unhandled parameter types: " +
				Arrays.<Object>asList(it, context).toString());
		}
	}

	static def NablaValue interpreteVariablesDefinition(VariablesDefinition it, Context context)
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
			Iterator:
			{
				context.logFinest("We deal with loop " + b.container.connectivity.name)
				val connectivityName = b.container.connectivity.name
				val argIds =  b.container.args.map[x | context.getIdValue(x)]
				val container = context.meshWrapper.getElements(connectivityName, argIds)
				context.addIndexValue(b.index, 0)
				for (loopIteratorValue : 0..<container.size)
				{
					context.setIndexValue(b.index, loopIteratorValue)
					val ret = interprete(body, context)
					if (ret !== null)
						return ret
				}
			}
			Interval:
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

	static def NablaValue interpreteItemIndexDefinition(ItemIndexDefinition it, Context context)
	{
		context.logFinest("Interprete ItemIndexDefinition")
		val idValue = context.getIdValue(value.id)
		if (value.container.connectivity.indexEqualId) 
			context.addIndexValue(index, idValue)
		else 
		{
			val connectivityName = value.container.connectivity.name
			val args =  value.container.args.map[x | context.getIdValue(x)]
			val elements = context.meshWrapper.getElements(connectivityName, args)
			context.addIndexValue(index, elements.indexOf(idValue))
		}
		return null
	}

	static def NablaValue interpreteItemIdDefinition(ItemIdDefinition it, Context context)
	{
		context.logFinest("Interprete ItemIdDefinition")
		val idValue = getIdValue(value, context)
		context.addIdValue(id, idValue)
		return null
	}

	static def NablaValue interpreteReturn(Return it, Context context)
	{
		context.logFinest("Interprete Return")
		return interprete(expression, context)
	}

	private static dispatch def getIdValue(ItemIdValueCall it, Context context)
	{
		context.getSingleton(call)
	}

	private static dispatch def getIdValue(ItemIdValueIterator it, Context context)
	{
		if (iterator.container.connectivity.indexEqualId)
			getIndexValue(context)
		else
		{
			//TODO : Plus efficace de faire une méthode pour indexValue in container ?
			val connectivityName = iterator.container.connectivity.name
			val args =  iterator.container.args.map[x | context.getIdValue(x)]
			val index = getIndexValue(context)
			context.meshWrapper.getElements(connectivityName, args).get(index)
		}
	}

	private static def getIndexValue(ItemIdValueIterator it, Context context)
	{
		val iteratorRefIndex = context.getIndexValue(iterator.index)
		if (shift === 0)
			return iteratorRefIndex
		else
		{
			val nbElems = context.connectivitySizes.get(iterator.container.connectivity)
			return (iteratorRefIndex + shift + nbElems)%nbElems
		}
	}
}