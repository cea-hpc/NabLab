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
import fr.cea.nabla.ir.annotations.AcceleratorAnnotation
import fr.cea.nabla.ir.annotations.AcceleratorAnnotation.ViewDirection
import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.ArgOrVarRef
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.ConnectivityCall
import fr.cea.nabla.ir.ir.Container
import fr.cea.nabla.ir.ir.Exit
import fr.cea.nabla.ir.ir.Function
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
import fr.cea.nabla.ir.ir.While

import static fr.cea.nabla.ir.generator.arcane.TypeContentProvider.*

import static extension fr.cea.nabla.ir.ArgOrVarExtensions.*
import static extension fr.cea.nabla.ir.ContainerExtensions.*
import static extension fr.cea.nabla.ir.IrTypeExtensions.*
import static extension fr.cea.nabla.ir.generator.arcane.ExpressionContentProvider.*
import static extension fr.cea.nabla.ir.generator.arcane.ItemIndexAndIdValueContentProvider.*

class InstructionContentProvider
{
	static def dispatch CharSequence getContent(VariableDeclaration it)
	'''
		«val annot = AcceleratorAnnotation.tryToGet(variable)»
		«IF annot !== null»
			«IF TypeContentProvider.isArcaneScalarType(variable.type)»
				«IF annot.viewDirection == ViewDirection.In»
					auto «variable.name» = «ArcaneUtils.getCodeName((variable.defaultValue as ArgOrVarRef).target)»;
				«ELSE»
					fatal("Scalar out variables not yet implemented for accelerator loops");
				«ENDIF»
			«ELSE»
				auto «variable.name» = ax::view«annot.viewDirection.toString»(command, «ArcaneUtils.getCodeName((variable.defaultValue as ArgOrVarRef).target)»);
			«ENDIF»
		«ELSE»
			«IF !variable.type.baseTypeConstExpr»// Dynamic allocation not allowed with accelerators ?«ENDIF»
			«IF variable.const»const «ENDIF»«getTypeName(variable.type)» «ArcaneUtils.getCodeName(variable)»«getVariableDefaultValue(variable)»;
		«ENDIF»
	'''

	static def dispatch CharSequence getContent(InstructionBlock it)
	'''
		{
			«innerContent»
		}'''

	static def dispatch CharSequence getContent(Affectation it)
	{
		if (left.target.linearAlgebra && !(left.iterators.empty && left.indices.empty))
			'''«left.codeName».setValue(«formatIteratorsAndIndices(left.target, left.iterators, left.indices)», «right.content»);'''
		else
			'''
				«left.content» = «right.content»;
				«val irRoot = IrUtils.getContainerOfType(it, IrRoot)»
				«IF irRoot !== null && irRoot.timeStepVariable == left.target»
				m_global_deltat = «left.content»;
				«ENDIF»
			'''
	}

	/**
	 * ReductionInstrution are only encountered on Accelerator API.
	 * Transformation pass is done for the other Arcane backends.
	 */
	static def dispatch CharSequence getContent(ReductionInstruction it)
	{
		val b = iterationBlock
		switch b
		{
			Iterator:
			'''
				«val iterator = iterationBlock as Iterator»
				«val c = iterator.container»
				ax::Reducer«getReducerType(binaryFunction)»<«TypeContentProvider.getTypeName(result.type)»> reducer(command);
				command << RUNCOMMAND_ENUMERATE(«c.itemType.name.toFirstUpper», «iterator.index.name», «c.accessor»)
				{
					«FOR innerInstruction : innerInstructions»
						«innerInstruction.content»
					«ENDFOR»
					reducer.«getReducerType(binaryFunction).toLowerCase»(«lambda.content»);
				};
				«result.name» = reducer.reduce();
			'''
			Interval:
				throw new RuntimeException("Not")
		}
	}

	static def dispatch CharSequence getContent(Loop it)
	{
		val b = iterationBlock
		switch b
		{
			Iterator case AcceleratorAnnotation.tryToGet(it) !== null:
			'''
				«val iterator = iterationBlock as Iterator»
				«val c = iterator.container»
				command << RUNCOMMAND_ENUMERATE(«c.itemType.name.toFirstUpper», «iterator.index.name», «c.accessor»)
				{
					«body.innerContent»
				};
			'''
			Iterator case multithreadable:
			'''
				«val c = b.container»
				arcaneParallelForeach(«c.accessor», [&](«c.itemType.name.toFirstUpper»VectorView view)
				{
					ENUMERATE_«c.itemType.name.toUpperCase»(«b.index.name», view)
					{
						«body.innerContent»
					}
				});
			'''
			Iterator:
			'''
				«val c = b.container»
				«IF c.connectivityCall.args.empty»
					ENUMERATE_«c.itemType.name.toUpperCase»(«b.index.name», «c.accessor»)
					{
						«body.innerContent»
					}
				«ELSE»
					{
						«IF c instanceof ConnectivityCall»«getSetDefinitionContent(c.uniqueName, c)»«ENDIF»
						const Int32 «c.nbElemsVar»(«c.uniqueName».size());
						for (Int32 «b.index.name»=0; «b.index.name»<«c.nbElemsVar»; «b.index.name»++)
						{
							«body.innerContent»
						}
					}
				«ENDIF»
			'''
			Interval case AcceleratorAnnotation.tryToGet(it) !== null:
			'''
				command << RUNCOMMAND_LOOP1(«b.index.name», «b.nbElems.content»)
				{
					«body.innerContent»
				};
			'''
			Interval:
			'''
				for (Int32 «b.index.name»=0; «b.index.name»<«b.nbElems.content»; «b.index.name»++)
				{
					«body.innerContent»
				}
			'''
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
		'''return «expression.content»;'''
	}

	static def dispatch CharSequence getContent(Exit it)
	'''
		ARCANE_FATAL("«message»");
	'''

	static def getInnerContent(Instruction it)
	{
		if (it instanceof InstructionBlock)
			'''
			«IF AcceleratorAnnotation.tryToGet(it) !== null»
			auto command = makeCommand(m_default_queue);
			«ENDIF»
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

	private static def getVariableDefaultValue(Variable it)
	{
		if (defaultValue === null)
		{
			if (getTypeName(type).startsWith("NumArray"))
				// NumArray => type is BaseType
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
			ConnectivityCall case group !== null: '''«connectivity.returnType.name.toFirstUpper»Group(m_mesh->getGroup("«group»"))'''
			ConnectivityCall case args.empty && group === null: '''all«connectivity.name.toFirstUpper»()'''
			ConnectivityCall: '''m_mesh->«accessor»'''
			SetRef: target.name
		}
	}

	private static def getReducerType(Function f)
	{
		if (f.name.startsWith("min")) "Min"
		else if (f.name.startsWith("max")) "Max"
		else if (f.name.startsWith("sum")) "Sum"
		else throw new RuntimeException("Reduction type not implemented in Arcane accelerator API: " + f.name)
	}
}
