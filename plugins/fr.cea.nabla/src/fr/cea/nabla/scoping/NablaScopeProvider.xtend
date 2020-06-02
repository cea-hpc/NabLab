/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.scoping

import com.google.inject.Inject
import fr.cea.nabla.NablaModuleExtensions
import fr.cea.nabla.nabla.ArgOrVar
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.FunctionOrReduction
import fr.cea.nabla.nabla.FunctionTypeDeclaration
import fr.cea.nabla.nabla.Instruction
import fr.cea.nabla.nabla.InstructionBlock
import fr.cea.nabla.nabla.Interval
import fr.cea.nabla.nabla.Item
import fr.cea.nabla.nabla.ItemDefinition
import fr.cea.nabla.nabla.Iterable
import fr.cea.nabla.nabla.IterationBlock
import fr.cea.nabla.nabla.Job
import fr.cea.nabla.nabla.Loop
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NablaPackage
import fr.cea.nabla.nabla.Reduction
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.ReductionTypeDeclaration
import fr.cea.nabla.nabla.SetDefinition
import fr.cea.nabla.nabla.SimpleVarDefinition
import fr.cea.nabla.nabla.SingletonDefinition
import fr.cea.nabla.nabla.SpaceIterator
import fr.cea.nabla.nabla.TimeIterator
import fr.cea.nabla.nabla.TimeIteratorDefinition
import fr.cea.nabla.nabla.VarGroupDeclaration
import java.util.ArrayList
import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.scoping.IScope
import org.eclipse.xtext.scoping.Scopes
import org.eclipse.xtext.scoping.impl.AbstractDeclarativeScopeProvider
import org.eclipse.xtext.util.IResourceScopeCache

/**
 * This class contains custom scoping description.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#scoping
 * on how and when to use it.
 */
class NablaScopeProvider extends AbstractDeclarativeScopeProvider
{
	@Inject NablaModuleExtensions nablaModuleExtensions
	@Inject IResourceScopeCache scopeCache

	override IScope getScope(EObject context, EReference r)
	{
		switch r
		{
			case NablaPackage.Literals.ARG_OR_VAR_REF__TARGET: getArgOrVarRefScope(context)
			case NablaPackage.Literals.ITEM_REF__TARGET: getItemRefScope(context)
			case NablaPackage.Literals.SET_REF__TARGET: getSetRefScope(context)
			default: super.getScope(context, r)
		}
	}


	/*** Scope for items *****************************************************/
	private def IScope getItemRefScope(EObject context)
	{
		//println('getItemRefScope(' + context.class.simpleName + ') ' + context)
		val s = switch context
		{
			FunctionOrReduction, NablaModule, Job:
				IScope::NULLSCOPE
			IterationBlock:
			{
				val c = context.eContainer as Iterable
				val cOuterScope = getItemRefScope(c.eContainer)
				switch c
				{
					Loop: Scopes::scopeFor(itemsDefinedBefore(c.eContainer, c), cOuterScope)
					ReductionCall: cOuterScope
				}
			}
			SingletonDefinition:
			{
				val spaceIterator = context.eContainer as SpaceIterator
				val iterable = spaceIterator.eContainer as Iterable
				val itemList = new ArrayList<Item>
				itemList += subList(spaceIterator.singletons, context).allItems
				itemList += spaceIterator.item
				if (iterable instanceof Loop)
					itemList += itemsDefinedBefore(iterable.eContainer, iterable)
				Scopes::scopeFor(itemList, getItemRefScope(iterable.eContainer))
			}
			Iterable case (context.iterationBlock instanceof SpaceIterator):
			{
				val itemList = new ArrayList<Item>
				val block = context.iterationBlock
				if (block instanceof SpaceIterator)
				{
					val spaceIt = context.iterationBlock as SpaceIterator
					itemList += spaceIt.item
					itemList += spaceIt.singletons.map[item]
				}
				if (context instanceof Loop)
					itemList += itemsDefinedBefore(context.eContainer, context)
				Scopes::scopeFor(itemList, getItemRefScope(context.eContainer))
			}
			Instruction:
				Scopes::scopeFor(itemsDefinedBefore(context.eContainer, context), getItemRefScope(context.eContainer))
			default:
				getItemRefScope(context.eContainer)
		}
		//println('--> ' + s)
		return s
	}

	private def java.lang.Iterable<Item> itemsDefinedBefore(Object context, Instruction i)
	{
		//println('itemsDefinedBefore(' + context.class.simpleName + ', ' + i.class.simpleName + ')')
		switch context
		{
			InstructionBlock:
				subList(context.instructions, i).allItems
			Instruction, Job, NablaModule, FunctionOrReduction:
				#[]
			default:
				throw new RuntimeException("Unexpected type in scope provider: " + context.class.name)
		}
	}

	private def getAllItems(SingletonDefinition[] list) { list.map[item] }
	private def getAllItems(Instruction[] list) { list.filter(ItemDefinition).map[item] }



	/*** Scope for sets ******************************************************/
	private def IScope getSetRefScope(EObject context)
	{
		//println('getItemRefScope(' + context.class.simpleName + ') ' + context)
		val s = switch context
		{
			FunctionOrReduction, NablaModule, Job:
				IScope::NULLSCOPE
			Instruction:
				Scopes::scopeFor(setsDefinedBefore(context.eContainer, context), getSetRefScope(context.eContainer))
			default:
				getSetRefScope(context.eContainer)
		}
		//println('--> ' + s)
		return s
	}

	private def java.lang.Iterable<SetDefinition> setsDefinedBefore(EObject context, Instruction i)
	{
		//println('setsDefinedBefore(' + context.class.simpleName + ', ' + i.class.simpleName + ')')
		switch context
		{
			InstructionBlock:
				subList(context.instructions, i).allSets
			Instruction, Job, NablaModule, FunctionOrReduction:
				#[]
			default:
				throw new RuntimeException("Unexpected type in scope provider: " + context.class.name)
		}
	}

	private def getAllSets(List<? extends Instruction> list)
	{
		list.filter(SetDefinition)
	}



	/*** Scope for variables *************************************************/
	private def IScope getArgOrVarRefScope(EObject context)
	{
		//println('getArgOrVarRefScope(' + context.class.simpleName + ')')
		val scope = switch context
		{
			FunctionOrReduction, NablaModule:
				IScope::NULLSCOPE
			FunctionTypeDeclaration:
				Scopes::scopeFor((context.eContainer as Function).variables)
			ReductionTypeDeclaration:
				Scopes::scopeFor((context.eContainer as Reduction).variables)
			IterationBlock:
			{
				val c = context.eContainer as Iterable
				val cOuterScope = getArgOrVarRefScope(c.eContainer)
				switch c
				{
					Loop: Scopes::scopeFor(variablesDefinedBefore(c.eContainer, c), cOuterScope)
					ReductionCall: cOuterScope
				}
			}
			Iterable:
			{
				val varList = new ArrayList<ArgOrVar>
				val block = context.iterationBlock
				switch block
				{
					Interval: varList += block.index
					SpaceIterator case block.counter !== null: varList += block.counter
				}
				if (context instanceof Loop)
					varList += variablesDefinedBefore(context.eContainer, context)
				Scopes::scopeFor(varList, getArgOrVarRefScope(context.eContainer))
			}
			Instruction:
				Scopes::scopeFor(variablesDefinedBefore(context.eContainer, context), getArgOrVarRefScope(context.eContainer))
			TimeIterator:
			{
				val definition = context.eContainer as TimeIteratorDefinition 
				val module = EcoreUtil2.getContainerOfType(context, NablaModule)
				val iteratorsAndVars = new ArrayList<ArgOrVar>
				iteratorsAndVars += module.allVars
				iteratorsAndVars += subList(definition.iterators, context)
				iteratorsAndVars += context
				Scopes::scopeFor(iteratorsAndVars)
			}
			default:
				getArgOrVarRefScope(context.eContainer)
		}
		//println('--> ' + scope)
		return scope
	}

	private def java.lang.Iterable<? extends ArgOrVar> variablesDefinedBefore(Object context, Instruction i)
	{
		//println('variablesDefinedBefore(' + context.class.simpleName + ', ' + i.class.simpleName + ')')
		switch context
		{
			InstructionBlock:
				subList(context.instructions, i).allVars
			Instruction:
				#[]
			FunctionOrReduction:
				(context.variables + context.inArgs)
			Job:
				(context.eContainer as NablaModule).allVars
			NablaModule:
				subList((context.definitions + context.declarations).toList, i).allVars
			default:
				throw new RuntimeException("Unexpected type in scope provider: " + context.class.name)
		}
	}

	private def getAllVars(NablaModule module)
	{
		scopeCache.get(module, module.eResource, [nablaModuleExtensions.getAllVars(module)])
	}

	private def getAllVars(List<? extends Instruction> instructions)
	{
		val variables = new ArrayList<ArgOrVar>
		for (i : instructions)
			switch i
			{
				VarGroupDeclaration : variables += i.variables
				SimpleVarDefinition : variables += i.variable
			}
		return variables
	}

	private def <T extends EObject> subList(List<? extends T> listOfElts, T eltInList)
	{
		var List<? extends T> iterators
		val iIndex = listOfElts.indexOf(eltInList)
		if (iIndex == -1) 
			iterators = #[]
		else
			iterators = listOfElts.subList(0, iIndex)
		return iterators
	}
}
