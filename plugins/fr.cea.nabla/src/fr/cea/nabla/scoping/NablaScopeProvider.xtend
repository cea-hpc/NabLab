/*******************************************************************************
 * Copyright (c) 2022 CEA
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
import fr.cea.nabla.nabla.FunctionInTypeDeclaration
import fr.cea.nabla.nabla.FunctionOrReduction
import fr.cea.nabla.nabla.FunctionReturnTypeDeclaration
import fr.cea.nabla.nabla.Instruction
import fr.cea.nabla.nabla.InstructionBlock
import fr.cea.nabla.nabla.Interval
import fr.cea.nabla.nabla.ItemSet
import fr.cea.nabla.nabla.Iterable
import fr.cea.nabla.nabla.IterationBlock
import fr.cea.nabla.nabla.Job
import fr.cea.nabla.nabla.Loop
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NablaPackage
import fr.cea.nabla.nabla.Reduction
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.ReductionTypeDeclaration
import fr.cea.nabla.nabla.SimpleVarDeclaration
import fr.cea.nabla.nabla.SpaceIterator
import fr.cea.nabla.nabla.TimeIterator
import fr.cea.nabla.nabla.Var
import fr.cea.nabla.nabla.VarDeclaration
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
			case NablaPackage.Literals.SPACE_ITERATOR_REF__TARGET: getSpaceIteratorRefScope(context)
			case NablaPackage.Literals.ITEM_SET_REF__TARGET: getItemSetRefScope(context)
			case NablaPackage.Literals.TIME_ITERATOR_REF__TARGET: getTimeIteratorRefScope(context)
			default: super.getScope(context, r)
		}
	}


	/*** Scope for items *****************************************************/
	private def IScope getSpaceIteratorRefScope(EObject context)
	{
		//println('getSpaceIteratorRefScope(' + context.class.simpleName + ') ' + context)
		val s = switch context
		{
			FunctionOrReduction, NablaModule, Job:
				IScope::NULLSCOPE
			IterationBlock:
			{
				val c = context.eContainer as Iterable
				getSpaceIteratorRefScope(c.eContainer)
			}
			Iterable case (context.iterationBlock instanceof SpaceIterator):
			{
				val block = context.iterationBlock
				if (block instanceof SpaceIterator)
					Scopes::scopeFor(#[context.iterationBlock as SpaceIterator], getSpaceIteratorRefScope(context.eContainer))
				else
					getSpaceIteratorRefScope(context.eContainer)
			}
			default:
				getSpaceIteratorRefScope(context.eContainer)
		}
		//println('--> ' + s)
		return s
	}



	/*** Scope for sets ******************************************************/
	private def IScope getItemSetRefScope(EObject context)
	{
		//println('getItemRefScope(' + context.class.simpleName + ') ' + context)
		val s = switch context
		{
			FunctionOrReduction, NablaModule, Job:
				IScope::NULLSCOPE
			Instruction:
				Scopes::scopeFor(setsDefinedBefore(context.eContainer, context), getItemSetRefScope(context.eContainer))
			default:
				getItemSetRefScope(context.eContainer)
		}
		//println('--> ' + s)
		return s
	}

	private def java.lang.Iterable<ItemSet> setsDefinedBefore(EObject context, Instruction i)
	{
		//println('setsDefinedBefore(' + context.class.simpleName + ', ' + i.class.simpleName + ')')
		switch context
		{
			InstructionBlock:
				subList(context.instructions, i).filter(ItemSet)
			Instruction, Job, NablaModule, FunctionOrReduction:
				#[]
			default:
				throw new RuntimeException("Unexpected type in scope provider: " + context.class.name)
		}
	}



	/*** Scope for time iterators ********************************************/
	private def IScope getTimeIteratorRefScope(EObject context)
	{
		//println('getTimeIteratorRefScope(' + context.class.simpleName + ')')
		val module = EcoreUtil2.getContainerOfType(context, NablaModule)
		if (module === null || module.iteration === null) return IScope::NULLSCOPE
		val iterators = module.iteration.eAllContents.filter(TimeIterator).toList
		Scopes::scopeFor(iterators)
	}



	/*** Scope for variables *************************************************/
	private def IScope getArgOrVarRefScope(EObject context)
	{
		//println('getArgOrVarRefScope(' + context.class.simpleName + ')')
		val scope = switch context
		{
			FunctionOrReduction, NablaModule:
				IScope::NULLSCOPE
			FunctionInTypeDeclaration, FunctionReturnTypeDeclaration:
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
				val module = EcoreUtil2.getContainerOfType(context, NablaModule)
				val iterators = module.iteration.eAllContents.filter(TimeIterator).toList
				val iteratorsAndVars = new ArrayList<ArgOrVar>
				iteratorsAndVars += module.allVars.filter(Var) // filter TimeIterator
				iteratorsAndVars += subList(iterators, context)
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
				subList(context.instructions, i).instructionsVars
			Instruction:
				#[]
			FunctionOrReduction:
				(context.variables + context.inArgs)
			Job:
				(context.eContainer as NablaModule).allVars
			NablaModule:
				subList(context.declarations.toList, i as VarDeclaration).declarationsVars
			default:
				throw new RuntimeException("Unexpected type in scope provider: " + context.class.name)
		}
	}

	private def getAllVars(NablaModule module)
	{
		scopeCache.get(module, module.eResource, [nablaModuleExtensions.getAllVars(module)])
	}

	private def getInstructionsVars(List<? extends Instruction> instructions)
	{
		val variables = new ArrayList<ArgOrVar>
		for (i : instructions)
			switch i
			{
				VarGroupDeclaration : variables += i.variables
				SimpleVarDeclaration : variables += i.variable
			}
		return variables
	}

	private def getDeclarationsVars(List<? extends VarDeclaration> declarations)
	{
		val allVars = new ArrayList<Var>
		for (d : declarations)
			switch d
			{
				SimpleVarDeclaration: allVars += d.variable
				VarGroupDeclaration: allVars += d.variables
			}
		return allVars
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
