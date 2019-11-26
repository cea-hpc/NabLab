package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.ArgOrVarRefIteratorRef
import fr.cea.nabla.ir.ir.DimensionIterationBlock
import fr.cea.nabla.ir.ir.If
import fr.cea.nabla.ir.ir.InstructionBlock
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

import static extension fr.cea.nabla.ir.generator.IteratorExtensions.*
import static extension fr.cea.nabla.ir.generator.IteratorRefExtensions.*

class InstructionInterpreter
{
	static def dispatch NablaValue interprete(VarDefinition it, Context context)
	{ 
		//println("Interprete VarDefinition")
		for (v : variables)
			context.setVariableValue(v, createValue(v, context))
		return null
	}

	static def dispatch NablaValue interprete(InstructionBlock it, Context context)
	{
		//println("Interprete InstructionBlock")
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
		//println("Interprete Affectation")
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
		//println("Interprete Loop")
		val b = iterationBlock
		switch b
		{
			SpaceIterationBlock:
			{
				val connectivityName = b.range.container.connectivity.name
				val argIds =  b.range.container.args.map[x | context.getIdValue(x)]
				val container = context.meshWrapper.getElements(connectivityName, argIds)
				for (loopIteratorValue : 0..<container.size)
				{
					context.setIndexValue(b.range, loopIteratorValue)
					defineIndices(b, context)
					val ret = interprete(body, context)
					if (ret !== null)
						return ret
				}
			}
			DimensionIterationBlock:
			{
				val from = interprete(b.from, context)
				var to = interprete(b.to, context)
				if (b.toIncluded) to = to + 1
				for (i : from..<to)
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
		//println("Interprete If")
		val cond = interprete(condition, context) as NV0Bool
		if (cond.data) return interprete(thenInstruction, context)
		else if (elseInstruction !== null) return interprete(elseInstruction, context)
	}

	static def dispatch NablaValue interprete(Return it, Context context)
	{
		//println("Interprete Return")
		return interprete(expression, context)
	}

 	private static def void defineIndices(SpaceIterationBlock it, Context context)
	{
		defineIndices(range, context)
		for (s : singletons)
			defineIndices(s, context)
	}

	private static def void defineIndices(Iterator it, Context context)
	{
		for (neededId : neededIds)
			context.setIdValue(neededId, getIndexToId(neededId, context))
		for (neededIndex : neededIndices)
			context.setIndexValue(neededIndex, getIdToIndex(neededIndex, context))
	}

	private	static def getIndexToId(IteratorRef it, Context context)
	{
		//println("Dans getIndexToId")
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