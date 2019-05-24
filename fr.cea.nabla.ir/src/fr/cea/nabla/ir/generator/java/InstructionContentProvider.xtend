/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 * 	Benoit Lelandais - initial implementation
 * 	Marie-Pierre Oudot - initial implementation
 * 	Jean-Sylvain Camier - Nabla generation support
 *******************************************************************************/
package fr.cea.nabla.ir.generator.java

import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.ArrayVariable
import fr.cea.nabla.ir.ir.If
import fr.cea.nabla.ir.ir.Instruction
import fr.cea.nabla.ir.ir.InstructionBlock
import fr.cea.nabla.ir.ir.IterableInstruction
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.IteratorRef
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.Reduction
import fr.cea.nabla.ir.ir.ReductionInstruction
import fr.cea.nabla.ir.ir.ScalarVariable
import fr.cea.nabla.ir.ir.VarDefinition
import fr.cea.nabla.ir.ir.VarRefIteratorRef

import static extension fr.cea.nabla.ir.generator.IteratorExtensions.*
import static extension fr.cea.nabla.ir.generator.IteratorRefExtensions.*
import static extension fr.cea.nabla.ir.generator.Utils.*
import static extension fr.cea.nabla.ir.generator.java.ExpressionContentProvider.*
import static extension fr.cea.nabla.ir.generator.java.Ir2JavaUtils.*
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
		«IF v.const»const «ENDIF»«v.varContent»
		«ENDFOR»
	'''
	
	private static def dispatch getVarContent(ScalarVariable it)
	'''«javaType» «name»«IF defaultValue !== null» = «defaultValue.content»«ENDIF»;'''
	
	private static def dispatch getVarContent(ArrayVariable it)
	'''«javaType» «name»«IF defaultValue !== null» = «defaultValue.content»«ENDIF»;'''

	static def dispatch CharSequence getContent(InstructionBlock it) 
	'''
		{
			«FOR i : instructions»
			«i.content»
			«ENDFOR»
		}'''
	
	static def dispatch CharSequence getContent(Affectation it) 
	{
		if (left.variable.type.javaBasicType) 
			'''«left.content» «operator» «right.content»;'''
		else 
			'''«left.content».«operator.javaOperator»(«right.content»);'''
	}

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
		«FOR neededId : range.neededIds»
			int «neededId.id» = «neededId.indexToId»;
		«ENDFOR»
		«FOR neededIndex : range.indicesToDefined»
			int «neededIndex.indexName» = «neededIndex.idToIndex»;
		«ENDFOR»
		«FOR singleton : singletons»
			int «singleton.id» = «singleton.accessor»;
			«FOR neededIndex : singleton.indicesToDefined»
				int «neededIndex.indexName» = «neededIndex.idToIndex»;
			«ENDFOR»
		«ENDFOR»
	'''
	
	private	static def getIndexToId(IteratorRef it)
	{
		if (target.container.connectivity.indexEqualId || target.singleton) indexValue
		else target.containerName + '[' + indexValue + ']'		
	}
	
	private static def getIdToIndex(VarRefIteratorRef it)
	{
		if (indexEqualId) id
		else 'Utils.indexOf(' + accessor + ', ' + id + ')'
	}
	
	static def getAccessor(VarRefIteratorRef it) '''mesh.get«connectivity.name.toFirstUpper»(«connectivityArgs.map[id].join(', ')»)'''
	static def getAccessor(Iterator it)  '''mesh.get«container.connectivity.name.toFirstUpper»(«container.args.map[id].join(', ')»)'''

	private static def getJavaName(Reduction it) '''«provider»Functions.«name»'''
}