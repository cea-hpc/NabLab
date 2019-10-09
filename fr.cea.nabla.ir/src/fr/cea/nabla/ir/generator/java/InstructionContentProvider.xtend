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

import fr.cea.nabla.ir.Utils
import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.If
import fr.cea.nabla.ir.ir.Instruction
import fr.cea.nabla.ir.ir.InstructionBlock
import fr.cea.nabla.ir.ir.IterableInstruction
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.IteratorRef
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.Reduction
import fr.cea.nabla.ir.ir.ReductionInstruction
import fr.cea.nabla.ir.ir.SimpleVariable
import fr.cea.nabla.ir.ir.VarDefinition
import fr.cea.nabla.ir.ir.VarRefIteratorRef

import static extension fr.cea.nabla.ir.VariableExtensions.*
import static extension fr.cea.nabla.ir.generator.IteratorExtensions.*
import static extension fr.cea.nabla.ir.generator.IteratorRefExtensions.*
import static extension fr.cea.nabla.ir.generator.Utils.*
import static extension fr.cea.nabla.ir.generator.java.ExpressionContentProvider.*
import static extension fr.cea.nabla.ir.generator.java.VariableExtensions.*

class InstructionContentProvider 
{
	static def dispatch getInnerContent(Instruction it) { content }
	static def dispatch getInnerContent(InstructionBlock it)
	'''
		«FOR i : instructions»
		«i.content»
		«ENDFOR»
	'''
	
	/**
	 * Les réductions à l'intérieur des boucles ont été remplacées dans l'IR par des boucles.
	 * Ne restent que les réductions au niveau des jobs => reduction //
	 */
	static def dispatch CharSequence getContent(ReductionInstruction it) 
	'''
		«result.javaType» «result.name» = IntStream.range(0, «range.container.connectivity.nbElems»).boxed().parallel().reduce(
			«result.defaultValue.content», 
			«IF innerReductions.empty»
			(r, «range.indexName») -> «reduction.javaName»(r, «arg.content»),
			(r1, r2) -> «reduction.javaName»(r1, r2)
			«ELSE»
			(r, «range.indexName») -> {
				«defineIndices»
				«FOR innerReduction : innerReductions»
				«innerReduction.content»
				«ENDFOR»
				return «reduction.javaName»(r, «arg.content»);
			},
			(r1, r2) -> «reduction.javaName»(r1, r2)
			«ENDIF»
		);
	'''

	static def dispatch CharSequence getContent(VarDefinition it) 
	'''
		«FOR v : variables»
		«IF v.const»final «ENDIF»«v.varContent»
		«ENDFOR»
	'''
	
	private static def dispatch getVarContent(SimpleVariable it)
	'''«javaType» «name»«IF defaultValue !== null» = «defaultValue.content»«ENDIF»;'''
	
	private static def dispatch getVarContent(ConnectivityVariable it)
	'''«javaType» «name»«IF defaultValue !== null» = «defaultValue.content»«ENDIF»;'''

	static def dispatch CharSequence getContent(InstructionBlock it) 
	'''
		{
			«FOR i : instructions»
			«i.content»
			«ENDFOR»
		}'''
	
	static def dispatch CharSequence getContent(Affectation it)
	'''
		«IF left.variable.linearAlgebra && !(left.iterators.empty && left.indices.empty)»
			«left.variable.codeName».set(«FOR r : left.iterators SEPARATOR ', ' AFTER ', '»«r.indexName»«ENDFOR»«FOR d : left.indices SEPARATOR ', ' AFTER ', '»«d»«ENDFOR»«right.content»);
		«ELSE»
			«left.content» = «right.content»;
		«ENDIF»
	'''

	static def dispatch CharSequence getContent(Loop it) 
	{
		if (topLevelLoop) parallelContent
		else sequentialContent
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
	
	private static def getParallelContent(Loop it)
	'''
		«IF !range.container.connectivity.indexEqualId»int[] «range.containerName» = «range.accessor»;«ENDIF»
		IntStream.range(0, «range.container.connectivity.nbElems»).parallel().forEach(«range.indexName» -> 
		{
			«defineIndices»
			«body.innerContent»
		});
	'''

	private static def getSequentialContent(Loop it)
	'''
		{
			int[] «range.containerName» = «range.accessor»;
			for (int «range.indexName»=0; «range.indexName»<«range.containerName».length; «range.indexName»++)
			{
				«defineIndices»
				«body.innerContent»
			}
		}
	'''
	
	/** Define all needed ids and indexes at the beginning of an iteration, ie Loop or ReductionInstruction  */
	private static def defineIndices(IterableInstruction it)
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
	
	private static def getIdToIndex(VarRefIteratorRef it)
	{
		if (varContainer.indexEqualId) idName
		else 'Utils.indexOf(' + accessor + ', ' + idName + ')'
	}
	
	private static def getAccessor(VarRefIteratorRef it) { getAccessor(varContainer, varArgs) }
	private static def getAccessor(Iterator it)  { getAccessor(container.connectivity, container.args) }
	private static def getAccessor(Connectivity c, Iterable<? extends IteratorRef> args)  
	'''mesh.get«c.name.toFirstUpper»(«args.map[idName].join(', ')»)'''

	private static def getJavaName(Reduction it) '''«provider»«Utils::FunctionAndReductionproviderSuffix».«name»'''
}