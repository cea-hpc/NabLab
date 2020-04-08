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
import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.If
import fr.cea.nabla.ir.ir.Instruction
import fr.cea.nabla.ir.ir.InstructionBlock
import fr.cea.nabla.ir.ir.Interval
import fr.cea.nabla.ir.ir.ItemIdDefinition
import fr.cea.nabla.ir.ir.ItemIndexDefinition
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.ReductionInstruction
import fr.cea.nabla.ir.ir.Return
import fr.cea.nabla.ir.ir.SimpleVariable
import fr.cea.nabla.ir.ir.VariablesDefinition

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.generator.ConnectivityCallExtensions.*
import static extension fr.cea.nabla.ir.generator.Utils.*
import static extension fr.cea.nabla.ir.generator.java.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.generator.java.ExpressionContentProvider.*
import static extension fr.cea.nabla.ir.generator.java.ItemIndexAndIdValueContentProvider.*

class InstructionContentProvider 
{
	static def dispatch CharSequence getContent(VariablesDefinition it) 
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
			«left.target.getCodeName('.')».set(«FOR r : left.iterators SEPARATOR ', ' AFTER ', '»«r.name»«ENDFOR»«FOR d : left.indices SEPARATOR ', ' AFTER ', '»«d»«ENDFOR»«right.content»);
		«ELSE»
			«left.content» = «right.content»;
		«ENDIF»
	'''

	static def dispatch CharSequence getContent(ReductionInstruction it)
	'''
		«result.javaType» «result.name»«result.defaultValueContent»;
		«iterationBlock.defineInterval('''
		«result.name» = IntStream.range(0, «iterationBlock.nbElems»).boxed().parallel().reduce
		(
			«result.defaultValue.content»,
			(accu, «iterationBlock.indexName») ->
			{
				«FOR innerInstruction : innerInstructions»
				«innerInstruction.content»
				«ENDFOR»
				return «binaryFunction.getCodeName('.')»(accu, «lambda.content»);
			},
			(r1, r2) -> «binaryFunction.getCodeName('.')»(r1, r2)
		);''')»
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

	static def dispatch CharSequence getContent(ItemIndexDefinition it)
	'''
		final int «index.name» = «value.content»;
	'''

	static def dispatch CharSequence getContent(ItemIdDefinition it)
	'''
		final int «id.name» = «value.content»;
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

	private static def dispatch getDefaultValueContent(SimpleVariable it)
	{
		if (defaultValue === null)
			javaAllocation
		else
			''' = «defaultValue.content»'''
	}

	private static def dispatch getDefaultValueContent(ConnectivityVariable it)
	'''«IF defaultValue !== null» = «defaultValue.content»«ENDIF»'''

	// ### IterationBlock Extensions ###
	private static def dispatch defineInterval(Iterator it, CharSequence innerContent)
	{
		if (container.connectivity.indexEqualId)
			innerContent
		else
		{
			'''
			{
				final int[] «container.name» = mesh.«container.accessor»;
				final int «nbElems» = «container.name».length;
				«innerContent»
			}
			'''
		}
	}

	private static def dispatch defineInterval(Interval it, CharSequence innerContent)
	{
		innerContent
	}

	private static def dispatch getIndexName(Iterator it) { index.name }
	private static def dispatch getIndexName(Interval it) { index.name }

	private static def dispatch getNbElems(Iterator it)
	{
		if (container.connectivity.indexEqualId)
			container.connectivity.nbElems
		else
			'nbElems' + indexName.toFirstUpper
	}

	private static def dispatch getNbElems(Interval it)
	{
		nbElems.content
	}
}