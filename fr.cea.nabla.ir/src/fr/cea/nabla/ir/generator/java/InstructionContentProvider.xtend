/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.java

import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.ArgOrVarRefIteratorRef
import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.DimensionIterationBlock
import fr.cea.nabla.ir.ir.If
import fr.cea.nabla.ir.ir.Instruction
import fr.cea.nabla.ir.ir.InstructionBlock
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.IteratorRef
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.Reduction
import fr.cea.nabla.ir.ir.ReductionInstruction
import fr.cea.nabla.ir.ir.Return
import fr.cea.nabla.ir.ir.SimpleVariable
import fr.cea.nabla.ir.ir.SpaceIterationBlock
import fr.cea.nabla.ir.ir.VarDefinition

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.generator.DimensionContentProvider.*
import static extension fr.cea.nabla.ir.generator.IteratorExtensions.*
import static extension fr.cea.nabla.ir.generator.IteratorRefExtensions.*
import static extension fr.cea.nabla.ir.generator.Utils.*
import static extension fr.cea.nabla.ir.generator.java.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.generator.java.ExpressionContentProvider.*

class InstructionContentProvider 
{
	static def dispatch CharSequence getContent(VarDefinition it) 
	'''
		«FOR v : variables»
		«IF v.const»final «ENDIF»«v.javaType» «v.name»«v.defaultValueContent»;
		«ENDFOR»
	'''

	static def dispatch CharSequence getContent(InstructionBlock it) 
	'''
		{
			«FOR i : instructions»
			«i.content»
			«ENDFOR»
		}'''

	static def dispatch CharSequence getContent(Affectation it)
	'''
		«IF left.target.linearAlgebra && !(left.iterators.empty && left.indices.empty)»
			«left.target.codeName».set(«FOR r : left.iterators SEPARATOR ', ' AFTER ', '»«r.indexName»«ENDFOR»«FOR d : left.indices SEPARATOR ', ' AFTER ', '»«d»«ENDFOR»«right.content»);
		«ELSE»
			«left.content» = «right.content»;
		«ENDIF»
	'''

	static def dispatch CharSequence getContent(ReductionInstruction it)
	{
		getContent(it, iterationBlock)
	} 

	static def dispatch CharSequence getContent(Loop it) 
	{
		if (topLevelLoop) getParallelContent(iterationBlock, it)
		else getSequentialContent(iterationBlock, it)
	}

	static def dispatch CharSequence getContent(If it) 
	'''
		if («condition.content») 
		«IF !(thenInstruction instanceof InstructionBlock)»	«ENDIF»«thenInstruction.content»
		«IF (elseInstruction !== null)»
		else 
		«IF !(elseInstruction instanceof InstructionBlock)»	«ENDIF»«elseInstruction.content»
		«ENDIF»
	'''

	static def dispatch CharSequence getContent(Return it) 
	'''
		return «expression.content»;
	'''

	static def dispatch getInnerContent(Instruction it) 
	{ 
		content
	}

	static def dispatch getInnerContent(InstructionBlock it)
	'''
		«FOR i : instructions»
		«i.content»
		«ENDFOR»
	'''

	private static def dispatch CharSequence getContent(ReductionInstruction it, SpaceIterationBlock b) 
	'''
		«result.javaType» «result.name» = IntStream.range(0, «b.range.container.connectivity.nbElems»).boxed().parallel().reduce(
			«result.defaultValue.content», 
			«IF innerReductions.empty»
			(r, «b.range.indexName») -> «getCall(reduction, 'r', arg.content.toString)»,
			(r1, r2) -> «getCall(reduction, 'r1', 'r2')»
			«ELSE»
			(r, «b.range.indexName») -> {
				«b.defineIndices»
				«FOR innerReduction : innerReductions»
				«innerReduction.content»
				«ENDFOR»
				return «getCall(reduction, 'r', arg.content.toString)»;
			},
			(r1, r2) -> «getCall(reduction, 'r1', 'r2')»
			«ENDIF»
		);
	'''

	private static def dispatch CharSequence getContent(ReductionInstruction it, DimensionIterationBlock b) 
	'''
		final int from = «b.from.content»;
		final int to = «b.to.content»«IF b.toIncluded»+1«ENDIF»;
		final int nbElems = from-to;
		«result.javaType» «result.name» = IntStream.range(from, nbElems).boxed().parallel().reduce(
			«result.defaultValue.content», 
			«IF innerReductions.empty»
			(r, «b.index.name») -> «getCall(reduction, 'r', arg.content.toString)»,
			(r1, r2) -> «getCall(reduction, 'r1', 'r2')»
			«ELSE»
			(r, «b.index.name») -> {
				«FOR innerReduction : innerReductions»
				«innerReduction.content»
				«ENDFOR»
				return «getCall(reduction, 'r', arg.content.toString)»;
			},
			(r1, r2) -> «getCall(reduction, 'r1', 'r2')»
			«ENDIF»
		);
	'''

	private static def getCall(Reduction it, String a, String b)
	{
		if (operator) a + ' ' + name + ' ' + b
		else getCodeName('.') + '(' + a + ', ' + b + ')'
	}

	private static def dispatch getSequentialContent(SpaceIterationBlock it, Loop l)
	'''
		{
			int[] «range.containerName» = «range.accessor»;
			for (int «range.indexName»=0; «range.indexName»<«range.containerName».length; «range.indexName»++)
			{
				«defineIndices»
				«l.body.innerContent»
			}
		}
	'''

	private static def dispatch getSequentialContent(DimensionIterationBlock it, Loop l)
	'''
		for (int «index.name»=«from.content»; «index.name»<«IF toIncluded»=«ENDIF»«to.content»; «index.name»++)
			«l.body.content»
	'''

	private static def dispatch getParallelContent(SpaceIterationBlock it, Loop l)
	'''
		«IF !range.container.connectivity.indexEqualId»int[] «range.containerName» = «range.accessor»;«ENDIF»
		IntStream.range(0, «range.container.connectivity.nbElems»).parallel().forEach(«range.indexName» -> 
		{
			«defineIndices»
			«l.body.innerContent»
		});
	'''

	private static def dispatch getParallelContent(DimensionIterationBlock it, Loop l)
	'''
		final int from = «from.content»;
		final int to = «to.content»«IF toIncluded»+1«ENDIF»;
		final int nbElems = from-to;
		IntStream.range(from, nbElems).parallel().forEach(«index.name» -> 
		{
			«l.body.innerContent»
		});
	'''

	/** Define all needed ids and indexes at the beginning of an iteration, ie Loop or ReductionInstruction  */
	private static def defineIndices(SpaceIterationBlock it)
	'''
		«range.defineIndices»
		«FOR s : singletons»
			int «s.indexName» = «s.accessor»;
			«s.defineIndices»
		«ENDFOR»
	'''
	
	private static def defineIndices(Iterator it)
	'''
		«FOR neededId : neededIds»
			int «neededId.idName» = «neededId.indexToId»;
		«ENDFOR»
		«FOR neededIndex : neededIndices»
			int «neededIndex.indexName» = «neededIndex.idToIndex»;
		«ENDFOR»
	'''

	private	static def getIndexToId(IteratorRef it)
	{
		if (target.container.connectivity.indexEqualId || target.singleton) indexValue
		else target.containerName + '[' + indexValue + ']'
	}

	private static def getIdToIndex(ArgOrVarRefIteratorRef it)
	{
		if (varContainer.indexEqualId) idName
		else 'Utils.indexOf(' + accessor + ', ' + idName + ')'
	}

	private static def dispatch getDefaultValueContent(SimpleVariable it)
	{
		if (defaultValue === null)
			javaAllocation
		else
			''' = «defaultValue.content»'''
	}

	private static def dispatch getDefaultValueContent(ConnectivityVariable it)
	'''«IF defaultValue !== null» = «defaultValue.content»«ENDIF»'''

	private static def getAccessor(ArgOrVarRefIteratorRef it) { getAccessor(varContainer, varArgs) }
	private static def getAccessor(Iterator it)  { getAccessor(container.connectivity, container.args) }
	private static def getAccessor(Connectivity c, Iterable<? extends IteratorRef> args)  
	'''mesh.get«c.name.toFirstUpper»(«args.map[idName].join(', ')»)'''
}