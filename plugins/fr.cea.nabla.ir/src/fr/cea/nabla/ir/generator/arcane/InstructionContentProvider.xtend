/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.arcane

import fr.cea.nabla.ir.IrUtils
import fr.cea.nabla.ir.generator.Utils
import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.ConnectivityCall
import fr.cea.nabla.ir.ir.Container
import fr.cea.nabla.ir.ir.Exit
import fr.cea.nabla.ir.ir.If
import fr.cea.nabla.ir.ir.Instruction
import fr.cea.nabla.ir.ir.InstructionBlock
import fr.cea.nabla.ir.ir.Interval
import fr.cea.nabla.ir.ir.IrRoot
import fr.cea.nabla.ir.ir.ItemIdDefinition
import fr.cea.nabla.ir.ir.ItemIndexDefinition
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.Loop
import fr.cea.nabla.ir.ir.ReductionInstruction
import fr.cea.nabla.ir.ir.Return
import fr.cea.nabla.ir.ir.SetDefinition
import fr.cea.nabla.ir.ir.SetRef
import fr.cea.nabla.ir.ir.Variable
import fr.cea.nabla.ir.ir.VariableDeclaration
import fr.cea.nabla.ir.ir.VectorConstant
import fr.cea.nabla.ir.ir.While

import static fr.cea.nabla.ir.generator.arcane.TypeContentProvider.*

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.ContainerExtensions.*
import static extension fr.cea.nabla.ir.IrTypeExtensions.*
import static extension fr.cea.nabla.ir.generator.arcane.ExpressionContentProvider.*
import static extension fr.cea.nabla.ir.generator.arcane.ItemIndexAndIdValueContentProvider.*
import static extension fr.cea.nabla.ir.generator.arcane.VariableExtensions.*

class InstructionContentProvider
{
	static def dispatch CharSequence getContent(VariableDeclaration it)
	'''
		«IF variable.type.baseTypeConstExpr»
			«IF variable.const»const «ENDIF»«getTypeName(variable.type)» «variable.codeName»«getVariableDefaultValue(variable)»;
		«ELSE»
			throw Exception("Not Yet Implemented");
		«ENDIF»
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
			'''
				«left.content» = «right.content»;
				«val irRoot = IrUtils.getContainerOfType(it, IrRoot)»
				«IF irRoot !== null && irRoot.timeStepVariable == left.target»
				m_global_deltat = «left.content»;
				«ENDIF»
			'''
	}

	static def dispatch CharSequence getContent(ReductionInstruction it)
	{
		throw new RuntimeException("ReductionInstruction must have been replaced before using this code generator")
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

	// no index definition in Arcane => item instead
	static def dispatch CharSequence getContent(ItemIndexDefinition it)
	'''
		const auto «index.name»(«value.content»);
	'''

	static def dispatch CharSequence getContent(ItemIdDefinition it)
	'''
		const auto «id.name»(«value.content»);
	'''

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
	{
		if (expression instanceof VectorConstant)
			'''return «TypeContentProvider.getTypeName(expression.type)»«expression.content»;'''
		else
			'''return «expression.content»;'''
	}

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
		const auto «setName»(m_mesh->«call.accessor»);
	'''

	private static def getParallelLoopContent(Iterator iterator, Instruction loopBody)
	'''
		«val c = iterator.container»
		arcaneParallelForeach(«c.accessor», [&](«c.itemType.name.toFirstUpper»VectorView view)
		{
			ENUMERATE_«c.itemType.name.toUpperCase»(«iterator.index.name», view)
			{
				«loopBody.innerContent»
			}
		});
	'''

	private static def getSequentialLoopContent(Iterator iterator, Instruction loopBody)
	'''
		«val c = iterator.container»
		«IF c.connectivityCall.indexEqualId»
			ENUMERATE_«c.itemType.name.toUpperCase»(«iterator.index.name», «c.accessor»)
			{
				«loopBody.innerContent»
			}
		«ELSE»
			{
				«IF iterator.container instanceof ConnectivityCall»«getSetDefinitionContent(iterator.container.uniqueName, iterator.container as ConnectivityCall)»«ENDIF»
				const Int32 «iterator.container.nbElemsVar»(«iterator.container.uniqueName».size());
				for (Int32 «iterator.index.name»=0; «iterator.index.name»<«iterator.container.nbElemsVar»; «iterator.index.name»++)
				{
					«loopBody.innerContent»
				}
			}
		«ENDIF»
	'''

	private static def getSequentialLoopContent(Interval iterator, Instruction loopBody)
	'''
		for (Int32 «iterator.index.name»=0; «iterator.index.name»<«iterator.nbElems.content»; «iterator.index.name»++)
		{
			«loopBody.innerContent»
		}
	'''

	private static def getVariableDefaultValue(Variable it)
	{
		if (defaultValue === null)
		{
			if (getTypeName(type).startsWith("UniqueArray"))
				// UniqueArray => type is BaseType
				'''(«FOR s : (type as BaseType).sizes SEPARATOR ", "»«s.content»«ENDFOR»)'''
			else
				''''''
		}
		else
		{
			val econtent = defaultValue.content
			if (econtent.charAt(0).compareTo('{') == 0) econtent
			else '''(«econtent»)'''
		}
	}

	private static def getAccessor(Container it)
	{
		switch it
		{
			ConnectivityCall case group !== null: '''mesh()->findGroup("«group»")'''
			ConnectivityCall case args.empty && group === null: '''all«connectivity.name.toFirstUpper»()'''
			ConnectivityCall: '''m_mesh->«accessor»'''
			SetRef: target.name
		}
	}
}
