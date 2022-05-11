/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.ConnectivityCall
import fr.cea.nabla.ir.ir.Exit
import fr.cea.nabla.ir.ir.If
import fr.cea.nabla.ir.ir.Instruction
import fr.cea.nabla.ir.ir.InstructionBlock
import fr.cea.nabla.ir.ir.Interval
import fr.cea.nabla.ir.ir.ItemIdDefinition
import fr.cea.nabla.ir.ir.ItemIdValueContainer
import fr.cea.nabla.ir.ir.ItemIdValueIterator
import fr.cea.nabla.ir.ir.ItemIndexDefinition
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.ReductionInstruction
import fr.cea.nabla.ir.ir.Return
import fr.cea.nabla.ir.ir.SetDefinition
import fr.cea.nabla.ir.ir.SetRef
import fr.cea.nabla.ir.ir.VariableDeclaration
import fr.cea.nabla.ir.ir.While
import java.util.Arrays
import java.util.stream.IntStream

import static fr.cea.nabla.ir.interpreter.ExpressionInterpreter.*
import static fr.cea.nabla.ir.interpreter.NablaValueSetter.*
import static fr.cea.nabla.ir.interpreter.VariableValueFactory.*

import static extension fr.cea.nabla.ir.ContainerExtensions.*

class InstructionInterpreter
{
	// Switch to more efficient dispatch (also clearer for profiling)
	static def NablaValue interprete(Instruction i, Context context)
	{
		switch i
		{
			Loop: interpreteLoop(i, context)
			ReductionInstruction: interpreteReductionInstruction(i, context)
			Affectation: interpreteAffectation(i, context)
			If: interpreteIf(i, context)
			InstructionBlock: interpreteInstructionBlock(i, context)
			While: interpreteWhile(i, context)
			Return: interpreteReturn(i, context)
			Exit: interpreteExit(i, context)
			VariableDeclaration: interpreteVariableDeclaration(i, context)
			ItemIdDefinition: interpreteItemIdDefinition(i, context)
			ItemIndexDefinition: interpreteItemIndexDefinition(i, context)
			SetDefinition: interpreteSetDefinition(i, context)
			default: throw new IllegalArgumentException("Unhandled parameter types: " +
				Arrays.<Object>asList(i, context).toString())
		}
	}

	private static def NablaValue interpreteVariableDeclaration(VariableDeclaration it, Context context)
	{
		context.logFinest("Interprete VarDefinition")
		context.addVariableValue(variable, createValue(variable.type, variable.name, variable.defaultValue, context))
		return null
	}

	private static def NablaValue interpreteInstructionBlock(InstructionBlock it, Context context)
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

	private static def NablaValue interpreteAffectation(Affectation it, Context context)
	{
		context.logFinest("Interprete Affectation")
		val rightValue = interprete(right, context)
		val allIndices = newIntArrayOfSize(left.iterators.size + left.indices.size)
		var i = 0
		for (iterator : left.iterators)
			allIndices.set(i++, context.getIndexValue(iterator))
		for (index : left.indices)
			allIndices.set(i++, interpreteSize(index, context))

		setValue(context.getVariableValue(left.target), allIndices, rightValue)
		return null
	}

	private static def NablaValue interpreteReductionInstruction(ReductionInstruction it, Context context)
	{
		// All reductionInstruction have been replaced by specific Ir Transformation Step
		throw new RuntimeException('Unexpected reduction instruction: apply the "ReplaceReduction(true)" transformation step')
	}

	private static def NablaValue interpreteLoop(Loop it, Context context)
	{
		val b = iterationBlock
		switch b
		{
			Iterator:
			{
				context.logFinest("We deal with loop " + b.container.uniqueName)
				val container = context.getContainerValue(b.container)
				if (multithreadable)
				{
					//NB Can't return in parallelForEach
					IntStream.range(0, container.size).parallel().forEach([loopIteratorValue |
					{
						val innerContext = new Context(context)
						innerContext.addIndexValue(b.index, loopIteratorValue)
						val ret = interprete(body, innerContext)
						if (ret !== null)
							throw new RuntimeException("Unexpected return in parallel loop: " + ret)
					}])
				}
				else
				{
					context.addIndexValue(b.index, 0)
					for (loopIteratorValue : 0..<container.size)
					{
						context.setIndexValue(b.index, loopIteratorValue)
						val ret = interprete(body, context)
						if (ret !== null)
							return ret
						context.checkInterrupted
					}
				}
			}
			Interval:
			{
				val nbElems = interprete(b.nbElems, context) as NV0Int
				context.addVariableValue(b.index, new NV0Int(0))
				for (i : 0..<nbElems.data)
				{
					context.setVariableValue(b.index, new NV0Int(i))
					val ret = interprete(body, context)
					if (ret !== null)
						return ret
				}
			}
		}
		return null
	}

	private static def NablaValue interpreteIf(If it, Context context)
	{
		context.logFinest("Interprete If")
		val cond = interprete(condition, context) as NV0Bool
		if (cond.data) return interprete(thenInstruction, context)
		else if (elseInstruction !== null) return interprete(elseInstruction, context)
	}

	private static def NablaValue interpreteItemIndexDefinition(ItemIndexDefinition it, Context context)
	{
		context.logFinest("Interprete ItemIndexDefinition")
		val idValue = context.getIdValue(value.id)
		if (value.container.indexEqualId) 
			context.addIndexValue(index, idValue)
		else 
		{
			val elements = context.getConnectivityCallValue(value.container)
			context.addIndexValue(index, elements.indexOf(idValue))
		}
		return null
	}

	private static def NablaValue interpreteItemIdDefinition(ItemIdDefinition it, Context context)
	{
		context.logFinest("Interprete ItemIdDefinition")
		val idValue = getIdValue(value, context)
		context.addIdValue(id, idValue)
		return null
	}

	private static def NablaValue interpreteSetDefinition(SetDefinition it, Context context)
	{
		context.logFinest("Interprete Return")
		if (value.connectivity.multiple)
			context.addSetValue(name, value)
		// else nothing to do for singleton
		return null
	}

	private static def NablaValue interpreteWhile(While it, Context context)
	{
		context.logFinest("Interprete While")
		var cond = interprete(condition, context) as NV0Bool
		while (cond.data)
		{
			interprete(instruction, context)
			cond = interprete(condition, context) as NV0Bool
			context.checkInterrupted
		}
		return null
	}

	private static def NablaValue interpreteReturn(Return it, Context context)
	{
		context.logFinest("Interprete Return")
		return interprete(expression, context)
	}

	private static def NablaValue interpreteExit(Exit it, Context context)
	{
		context.logFinest("Interprete Exit")
		throw new RuntimeException(message)
	}

	private static dispatch def getIdValue(ItemIdValueContainer it, Context context)
	{
		val c = container
		switch c
		{
			ConnectivityCall: context.getSingleton(c)
			SetRef: context.getSingleton(c.target.value)
		}
	}

	private static dispatch def getIdValue(ItemIdValueIterator it, Context context)
	{
		if (iterator.container.connectivityCall.indexEqualId)
			getIndexValue(context)
		else
		{
			val index = getIndexValue(context)
			context.getContainerValue(iterator.container).get(index)
		}
	}

	private static def getIndexValue(ItemIdValueIterator it, Context context)
	{
		val iteratorRefIndex = context.getIndexValue(iterator.index)
		if (shift === 0)
			return iteratorRefIndex
		else
		{
			val nbElems = context.mesh.getSize(iterator.container.connectivityCall)
			return (iteratorRefIndex + shift + nbElems)%nbElems
		}
	}
}
