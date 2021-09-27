/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.arcane

import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.ConnectivityCall
import fr.cea.nabla.ir.ir.Container
import fr.cea.nabla.ir.ir.Exit
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
import fr.cea.nabla.ir.ir.SetDefinition
import fr.cea.nabla.ir.ir.SetRef
import fr.cea.nabla.ir.ir.VariableDeclaration
import fr.cea.nabla.ir.ir.While

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.ContainerExtensions.*
import static extension fr.cea.nabla.ir.generator.arcane.ExpressionContentProvider.*

class InstructionContentProvider
{
	static def dispatch CharSequence getContent(VariableDeclaration it)
	'''
«««		«IF variable.type.isBaseTypeStatic»
«««			«IF variable.const»const «ENDIF»«variable.type.typeName» «variable.name»«IF variable.defaultValue !== null»(«variable.defaultValue.content»)«ENDIF»;
«««		«ELSE»
«««			«IF variable.const»const «ENDIF»«variable.type.typeName» «variable.name»;
«««		«ENDIF»
	'''

	static def dispatch CharSequence getContent(InstructionBlock it)
	'''
		{
			«FOR i : instructions»
			«i.content»
			«ENDFOR»
		}'''

	static def dispatch CharSequence getContent(Affectation it)
	{
		if (left.target.linearAlgebra && !(left.iterators.empty && left.indices.empty))
			'''«left.codeName».setValue(«formatIteratorsAndIndices(left.target.type, left.iterators, left.indices)», «right.content»);'''
		else
			'''«left.content» = «right.content»;'''
	}

	static def dispatch CharSequence getContent(ReductionInstruction it)
	{
		throw new UnsupportedOperationException("ReductionInstruction must have been replaced before using this code generator")
	}

	static def dispatch CharSequence getContent(Loop it)
	{
		val b = iterationBlock
		switch b
		{
			Iterator case Utils.isParallelLoop(it): getParallelLoopContent(b, body)
			Iterator case !Utils.isParallelLoop(it): getSequentialLoopContent(b, body)
			Interval: getSequentialLoopContent(b, body)
		}
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
	''''''

	static def dispatch CharSequence getContent(ItemIdDefinition it)
	''''''

	static def dispatch CharSequence getContent(SetDefinition it)
	{
		getSetDefinitionContent(name, value)
	}

	static def dispatch CharSequence getContent(While it)
	'''
		while («condition.content»)
		«val iContent = instruction.content»
		«IF !(iContent.charAt(0) == '{'.charAt(0))»	«ENDIF»«iContent»
	'''

	static def dispatch CharSequence getContent(Return it)
	'''
		return «expression.content»;
	'''

	static def dispatch CharSequence getContent(Exit it)
	'''
		fatal("«message»");
	'''

	static def getInnerContent(Instruction it)
	{
		if (it instanceof InstructionBlock)
			'''
			«FOR i : instructions»
			«i.content»
			«ENDFOR»
			'''
		else
			content
	}

	private static def getSetDefinitionContent(String setName, ConnectivityCall call)
	'''
		const auto «setName»(mesh->«call.accessor»);
	'''

	private static def getParallelLoopContent(Iterator iterator, Instruction loopBody)
	'''
		arcaneParallelForeach(«getContainerCall(iterator.container)», [&](«iterator.container.itemType.name.toFirstUpper»VectorView view)
		{
			ENUMERATE_«iterator.container.itemType.name.toUpperCase»(«iterator.index.itemName», view)
			{
				«loopBody.innerContent»
			}
		});
	'''

	private static def getSequentialLoopContent(Iterator iterator, Instruction loopBody)
	'''
		for («iterator.container.itemType.name.toFirstUpper»LocalId «iterator.index.itemName» : «getContainerCall(iterator.container)»)
		{
			«loopBody.innerContent»
		}
	'''

	private static def getSequentialLoopContent(Interval iterator, Instruction loopBody)
	'''
		for (Integer «iterator.index.name»=0; «iterator.index.name»<«iterator.nbElems.content»; «iterator.index.name»++)
		{
			«loopBody.innerContent»
		}
	'''

	private static def getContainerCall(Container c)
	{
		switch c
		{
			SetRef: c.uniqueName
			ConnectivityCall: '''m_mesh->get«c.connectivity.name.toFirstUpper»(«c.args.map[itemName].join(', ')»)'''
		}
	}
}
