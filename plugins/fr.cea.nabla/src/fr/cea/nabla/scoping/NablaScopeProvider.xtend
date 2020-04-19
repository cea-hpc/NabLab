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
import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.BaseType
import fr.cea.nabla.nabla.FunctionOrReduction
import fr.cea.nabla.nabla.Instruction
import fr.cea.nabla.nabla.InstructionBlock
import fr.cea.nabla.nabla.Interval
import fr.cea.nabla.nabla.Item
import fr.cea.nabla.nabla.ItemDefinition
import fr.cea.nabla.nabla.Iterable
import fr.cea.nabla.nabla.Job
import fr.cea.nabla.nabla.Loop
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.OptDefinition
import fr.cea.nabla.nabla.ReductionCall
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

/**
 * This class contains custom scoping description.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#scoping
 * on how and when to use it.
 */
class NablaScopeProvider extends AbstractDeclarativeScopeProvider
{
	@Inject extension NablaModuleExtensions

	/*** Scope for items *****************************************************/
	def scope_ItemRef_target(SpaceIterator context, EReference r)
	{
		//println('scope_ItemRef_target(' + context.class.simpleName + ', ' + r.name + ')')
		val iterable = context.eContainer as Iterable
		val s = itemsDefinedBefore(iterable.eContainer, iterable, '\t')
		//println('--> ' + s)
		return s
	}

	def scope_ItemRef_target(SingletonDefinition context, EReference r)
	{
		//println('scope_ItemRef_target(' + context.class.simpleName + ', ' + r.name + ')')
		val spaceIterator = context.eContainer as SpaceIterator
		val iterable = spaceIterator.eContainer as Iterable
		val items = new ArrayList<Item>
		items += itemsDeclaredBefore(spaceIterator.singletons, context)
		items += spaceIterator.item
		val s = Scopes::scopeFor(items, itemsDefinedBefore(iterable.eContainer, iterable, '\t'))
		//println('--> ' + s)
		return s
	}

	def scope_ItemRef_target(Instruction context, EReference r)
	{
		//println('scope_ItemRef_target(' + context.class.simpleName + ', ' + r.name + ')')
		val s = itemsDefinedBefore(context.eContainer, context, '\t')
		//println('--> ' + s)
		return s
	}

	def scope_ItemRef_target(ArgOrVarRef context, EReference r)
	{
		//println('scope_ItemRef_target(' + context.class.simpleName + ', ' + r.name + ')')
		val s = itemsDefinedBefore(context.eContainer, context, '\t')
		//println('--> ' + s)
		return s
	}

	private def dispatch IScope itemsDefinedBefore(Iterable context, Object o, String prefix)
	{
		//println(prefix + 'itemsDefinedBefore(' + context.class.simpleName + ')')
		val spaceIterator = context.iterationBlock as SpaceIterator
		val items = new ArrayList<Item>
		items += spaceIterator.item
		items += spaceIterator.singletons.map[item]
		val s = Scopes::scopeFor(items, itemsDefinedBefore(context.eContainer, context, prefix + '\t'))
		//println(prefix + '--> ' + s)
		return s
	}

	private def dispatch IScope itemsDefinedBefore(InstructionBlock context, Object o, String prefix)
	{
		//println(prefix + 'itemsDefinedBefore IB(' + context.class.simpleName + ')')
		val outerScope = itemsDefinedBefore(context.eContainer, context, prefix + '\t')
		val s = if (o !== null && o instanceof Instruction) 
					Scopes::scopeFor(itemsDeclaredBefore(context.instructions, o as Instruction), outerScope)
				else
					outerScope
		//println(prefix + '--> ' + s)
		return s
	}

	private def dispatch IScope itemsDefinedBefore(EObject context, Object o, String prefix)
	{
		//println(prefix + 'itemsDefinedBefore O(' + context.class.simpleName + ')')
		val s = if (context === null || context instanceof Job || context instanceof NablaModule)
					IScope::NULLSCOPE
				else 
					itemsDefinedBefore(context.eContainer, context, prefix + '\t')
		//println(prefix + '--> ' + s)
		return s
	}

	private def itemsDeclaredBefore(List<? extends SingletonDefinition> list, SingletonDefinition i)
	{
		subList(list, i).map[item]
	}

	private def itemsDeclaredBefore(List<? extends Instruction> list, Instruction i)
	{
		subList(list, i).filter(ItemDefinition).map[item]
	}



	/*** Scope for sets ******************************************************/
	def IScope scope_SetRef_target(SpaceIterator context, EReference r)
	{
		val instruction = EcoreUtil2::getContainerOfType(context, Instruction)
		setsDefinedBefore(instruction.eContainer, instruction, '\t')
	}

	def IScope scope_SetRef_target(Instruction context, EReference r)
	{
		setsDefinedBefore(context.eContainer, context, '\t')
	}

	private def dispatch IScope setsDefinedBefore(InstructionBlock context, EObject o, String prefix)
	{
		//println(prefix + 'setsDefinedBefore(' + context.class.simpleName + ', ' + o.class.simpleName + ')')
		val containerScope = setsDefinedBefore(context.eContainer, context, prefix + '\t')
		Scopes::scopeFor(setsDeclaredBefore(context.instructions, o as Instruction), containerScope)
	}

	private def dispatch IScope setsDefinedBefore(Instruction context, EObject o, String prefix)
	{
		//println(prefix + 'setsDefinedBefore(' + context.class.simpleName + ', ' + o.class.simpleName + ')')
		setsDefinedBefore(context.eContainer, context, prefix + '\t')
	}

	private def dispatch IScope setsDefinedBefore(EObject context, EObject o, String prefix)
	{
		//println(prefix + 'setsDefinedBefore(' + context.class.simpleName + ', ' + o.class.simpleName + ')')
		IScope::NULLSCOPE
	}

	private def setsDeclaredBefore(List<? extends Instruction> list, Instruction i)
	{
		val upperInstructions = subList(list, i)
		upperInstructions.filter(SetDefinition)
	}



	/*** Scope for variables *************************************************/
	/**
	 * ArgOrVarRef must be intercepted because they can be arguments of ReductionCall.
	 * The ReductionCall interval must be intercepted.
	 */ 
	def IScope scope_ArgOrVarRef_target(ArgOrVarRef context, EReference r)
	{
		//println('scope_ArgOrVarRef_target(' + context.class.simpleName + ', ' + r.name + ')')
		val s = variablesDefinedBefore(context.eContainer, context, '\t')
		//println('--> ' + s)
		return s
	}

	def IScope scope_ArgOrVarRef_target(OptDefinition context, EReference r)
	{
		//println('scope_ArgOrVarRef_target(' + context.class.simpleName + ', ' + r.name + ')')
		val s = variablesDefinedBefore(context.eContainer, context, '\t')
		//println('--> ' + s)
		return s
	}

	def IScope scope_ArgOrVarRef_target(Instruction context, EReference r)
	{
		//println('scope_ArgOrVarRef_target(' + context.class.simpleName + ', ' + r.name + ')')
		val s = variablesDefinedBefore(context.eContainer, context, '\t')
		//println('--> ' + s)
		return s
	}

	def IScope scope_ArgOrVarRef_target(TimeIterator context, EReference r)
	{
		//println('scope_ArgOrVarRef_target(' + context.class.simpleName + ', ' + r.name + ')')
		val definition = context.eContainer as TimeIteratorDefinition 
		val iteratorsAndVars = new ArrayList<ArgOrVar>
		val module = EcoreUtil2.getContainerOfType(context, NablaModule)
		iteratorsAndVars += module.allVars
		iteratorsAndVars += subList(definition.iterators, context)
		iteratorsAndVars += context
		val s = Scopes::scopeFor(iteratorsAndVars)
		//println('--> ' + s)
		return s
	}

	def IScope scope_ArgOrVarRef_target(BaseType context, EReference r)
	{
		//println('scope_ArgOrVarRef_target(' + context.class.simpleName + ', ' + r.name + ')')
		val s = variablesDefinedBefore(context.eContainer, context, '\t')
		//println('--> ' + s)
		return s
	}

	def IScope scope_ArgOrVarRef_target(NablaModule context, EReference r)
	{
		//println('scope_ArgOrVarRef_target(' + context.class.simpleName + ', ' + r.name + ')')
		val s = IScope::NULLSCOPE
		//println('--> ' + s)
		return s
	}

	private def dispatch IScope variablesDefinedBefore(InstructionBlock context, EObject o, String prefix)
	{
		//println(prefix + 'variablesDefinedBefore(' + context.class.simpleName + ', ' + o.class.simpleName + ')')
		val containerScope = variablesDefinedBefore(context.eContainer, context, prefix + '\t')
		Scopes::scopeFor(variablesDeclaredBefore(context.instructions, o as Instruction), containerScope)
	}

	private def dispatch IScope variablesDefinedBefore(Instruction context, EObject o, String prefix)
	{
		//println(prefix + 'variablesDefinedBefore(' + context.class.simpleName + ', ' + o.class.simpleName + ')')
		variablesDefinedBefore(context.eContainer, context, prefix + '\t')
	}

	private def dispatch IScope variablesDefinedBefore(Job context, EObject o, String prefix)
	{
		//println(prefix + 'variablesDefinedBefore(' + context.class.simpleName + ', ' + o.class.simpleName + ')')
		Scopes::scopeFor((context.eContainer as NablaModule).allVars)
	}

	private def dispatch IScope variablesDefinedBefore(NablaModule context, EObject o, String prefix)
	{
		//println(prefix + 'variablesDefinedBefore(' + context.class.simpleName + ', ' + o.class.simpleName + ')')
		val variables = new ArrayList<ArgOrVar>
		switch o
		{
			OptDefinition: subList(context.options, o).forEach[x | variables += x.variable]
			SimpleVarDefinition:
			{
				context.options.forEach[x | variables += x.variable]
				subList(context.definitions, o).forEach[x | variables += x.variable]
			}
			VarGroupDeclaration:
			{
				context.options.forEach[x | variables += x.variable]
				context.definitions.forEach[x | variables += x.variable]
				subList(context.declarations, o).forEach[x | variables += x.variables]
			}
		}
		Scopes::scopeFor(variables)
	}

	private def dispatch IScope variablesDefinedBefore(FunctionOrReduction context, EObject o, String prefix)
	{
		//println(prefix + 'variablesDefinedBefore(' + context.class.simpleName + ', ' + o.class.simpleName + ')')
		if (o instanceof BaseType)
			// it is the function header, args are not yet visible
			Scopes::scopeFor(context.vars)
		else 
			Scopes::scopeFor(context.vars + context.inArgs)
	}

	/**
	 * Dispatch does not work if Iterable is used in this function.
	 * Xtend generates code that tests "instanceof Instruction" before "instanceof Iterable".
	 * Loop matches Instruction before Iterable.
	 */
	private def dispatch IScope variablesDefinedBefore(Loop context, EObject o, String prefix)
	{
		variablesDefinedBeforeIterable(context, o, prefix)
	}

	private def dispatch IScope variablesDefinedBefore(ReductionCall context, EObject o, String prefix)
	{
		variablesDefinedBeforeIterable(context, o, prefix)
	}

	private def IScope variablesDefinedBeforeIterable(Iterable context, EObject o, String prefix)
	{
		//println(prefix + 'variablesDefinedBefore(' + context.class.simpleName + ', ' + o.class.simpleName + ')')
		val block = context.iterationBlock
		val containerScope = variablesDefinedBefore(context.eContainer, context, prefix + '\t')
		switch block
		{
			Interval: Scopes::scopeFor(#[block.index], containerScope)
			SpaceIterator case block.counter !== null: Scopes::scopeFor(#[block.counter], containerScope)
			default: containerScope
		}
	}

	private def variablesDeclaredBefore(List<? extends Instruction> list, Instruction i)
	{
		getAllVariables(subList(list, i))
	}

	private def getAllVariables(List<? extends Instruction> instructions)
	{
		val variables = new ArrayList<ArgOrVar>
		for (i : instructions)
			switch i
			{
				VarGroupDeclaration : variables += i.variables
				SimpleVarDefinition : variables += i.variable
				Iterable case (i.iterationBlock instanceof Interval):
					Scopes.scopeFor(#[(i.iterationBlock as Interval).index])
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
