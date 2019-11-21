package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.If
import fr.cea.nabla.ir.ir.InstructionBlock
import fr.cea.nabla.ir.ir.IterableInstruction
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.IteratorRef
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.ReductionInstruction
import fr.cea.nabla.ir.ir.VarDefinition
import fr.cea.nabla.ir.ir.VarRefIteratorRef

import static fr.cea.nabla.ir.interpreter.ExpressionInterpreter.*
import static fr.cea.nabla.ir.interpreter.NablaValueSetter.*
import static fr.cea.nabla.ir.interpreter.VariableValueFactory.*

import static extension fr.cea.nabla.ir.generator.IteratorExtensions.*
import static extension fr.cea.nabla.ir.generator.IteratorRefExtensions.*

class InstructionInterpreter 
{
	static def dispatch void interprete(VarDefinition it, Context context)
	{ 
		//println("Dans interprete de VarDefinition")
		for (v : variables)
			context.setVariableValue(v, createValue(v, context))
	}
	
	static def dispatch void interprete(InstructionBlock it, Context context)
	{
		//println("Dans interprete de InstructionBlock")
		val innerContext = new Context(context)
		for (i : instructions)
			interprete(i, innerContext)
	}
	
	static def dispatch void interprete(Affectation it, Context context)
	{
		//println("Dans interprete de Affectation")
		val rightValue = interprete(right, context)
		val allIndices = left.iterators.map[x | context.getIndexValue(x)] + left.indices
		setValue(context.getVariableValue(left.variable), allIndices.toList, rightValue)
	}

	static def dispatch void interprete(ReductionInstruction it, Context context)
	{
		// All reductionInstruction have been replaced by specific Ir Transformation Step
		throw new RuntimeException('Wrong path...')
	}

	static def dispatch void interprete(Loop it, Context context)
	{
		//println("Dans interprete de Loop")
		val connectivityName = range.container.connectivity.name
		val argIds =  range.container.args.map[x | context.getIdValue(x)]
		val container = context.meshWrapper.getElements(connectivityName, argIds)
		for (loopIteratorValue : 0..<container.size)
		{
			context.setIndexValue(range, loopIteratorValue)
			defineIndices(it, context)
			body.interprete(context)
		}
	}

	static def dispatch void interprete(If it, Context context)
	{
		//println("Dans interprete de If")
		val cond = interprete(condition, context) as NV0Bool
		if (cond.data) interprete(thenInstruction, context)
		else if (elseInstruction !== null) interprete(elseInstruction, context)
	}

 	private static def void defineIndices(IterableInstruction it, Context context)
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
			//TODO : Plus efficace de faire une méthode pour indexValue in container
			val connectivityName = target.container.connectivity.name
			val args =  target.container.args.map[x | context.getIdValue(x)]
			context.meshWrapper.getElements(connectivityName, args).get(indexValue)
		}
	}
	
	private static def getIdToIndex(VarRefIteratorRef it, Context context)
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