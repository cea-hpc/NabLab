/*******************************************************************************
 * Copyright (c) 2020 CEA
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
import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.If
import fr.cea.nabla.ir.ir.Instruction
import fr.cea.nabla.ir.ir.InstructionBlock
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.IteratorRef
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.ReductionInstruction
import fr.cea.nabla.ir.ir.Return
import fr.cea.nabla.ir.ir.SimpleVariable
import fr.cea.nabla.ir.ir.SpaceIterationBlock
import fr.cea.nabla.ir.ir.VarDefinition

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.generator.IteratorExtensions.*
import static extension fr.cea.nabla.ir.generator.IteratorRefExtensions.*
import static extension fr.cea.nabla.ir.generator.Utils.*
import static extension fr.cea.nabla.ir.generator.java.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.generator.java.ExpressionContentProvider.*
import static extension fr.cea.nabla.ir.generator.java.IterationBlockExtensions.*

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
			«left.target.getCodeName('.')».set(«FOR r : left.iterators SEPARATOR ', ' AFTER ', '»«r.indexName»«ENDFOR»«FOR d : left.indices SEPARATOR ', ' AFTER ', '»«d»«ENDFOR»«right.content»);
		«ELSE»
			«left.content» = «right.content»;
		«ENDIF»
	'''

	static def dispatch CharSequence getContent(ReductionInstruction it)
	'''
		«result.javaType» «result.name»«result.defaultValueContent»;
		{
			«iterationBlock.defineInterval('''
			«result.name» = IntStream.range(0, «iterationBlock.nbElems»).boxed().parallel().reduce
			(
				«result.defaultValue.content»,
				«IF innerReductions.empty»
				(accu, «iterationBlock.indexName») -> «binaryFunction.getCodeName('.')»(accu, «lambda.content»),
				«ELSE»
				(accu, «iterationBlock.indexName») ->
				{
					«IF iterationBlock instanceof SpaceIterationBlock»«defineIndices(iterationBlock as SpaceIterationBlock)»«ENDIF»
					«FOR innerReduction : innerReductions»
					«innerReduction.content»
					«ENDFOR»
					return «binaryFunction.getCodeName('.')»(accu, «lambda.content»);
				},
				«ENDIF»
				(r1, r2) -> «binaryFunction.getCodeName('.')»(r1, r2)
			);''')»
		}
	'''

	static def dispatch CharSequence getContent(Loop it)
	{
		iterationBlock.defineInterval(
		'''
			«IF topLevelLoop»
			IntStream.range(0, «iterationBlock.nbElems»).parallel().forEach(«iterationBlock.indexName» -> 
			«ELSE»
			for (int «iterationBlock.indexName»=0; «iterationBlock.indexName»<«iterationBlock.nbElems»; «iterationBlock.indexName»++)
			«ENDIF»
			{
				«IF iterationBlock instanceof SpaceIterationBlock»«defineIndices(iterationBlock as SpaceIterationBlock)»«ENDIF»
				«body.innerContent»
			}«IF topLevelLoop»);«ENDIF»
		''')
	}

	static def dispatch CharSequence getContent(If it) 
	'''
		if («condition.content»)
		«val thenContent = thenInstruction.content»
		«IF !(thenContent.charAt(0) == '{'.charAt(0))»	«ENDIF»«thenContent»
		«IF (elseInstruction !== null)»
			«val elseContent = elseInstruction.content»
			else
			«IF !(elseContent.charAt(0) == '{'.charAt(0))»	«ENDIF»«elseContent»
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

	/** Define all needed ids and indexes at the beginning of an iteration, ie Loop or ReductionInstruction  */
	private static def defineIndices(SpaceIterationBlock it)
	'''
		«range.defineIndices»
		«FOR s : singletons»
			final int «s.indexName» = «s.accessor»;
			«s.defineIndices»
		«ENDFOR»
	'''

	private static def defineIndices(Iterator it)
	'''
		«FOR neededId : neededIds»
			final int «neededId.idName» = «neededId.indexToId»;
		«ENDFOR»
		«FOR neededIndex : neededIndices»
			final int «neededIndex.indexName» = «neededIndex.idToIndex»;
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
}