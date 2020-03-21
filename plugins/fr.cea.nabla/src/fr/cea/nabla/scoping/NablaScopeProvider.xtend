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
import fr.cea.nabla.nabla.NablaModule
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
	/*** Scope for iterators **********************************************************/
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

	def scope_ItemRef_target(ItemDefinition context, EReference r)
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

	/*** Scope for variables ***********************************************************/
	def IScope scope_ArgOrVarRef_target(Instruction context, EReference r)
	{
		//println('scope_VarRef_variable(' + context.class.simpleName + ', ' + r.name + ')')
		variablesDefinedBefore(context.eContainer, context, '\t')
	}

	def IScope scope_ArgOrVarRef_target(TimeIterator context, EReference r)
	{
		//println('1. scope_VarRef_variable(' + context.class.simpleName + ', ' + r.name + ')')
		val definition = context.eContainer as TimeIteratorDefinition 
		val iteratorsAndVars = new ArrayList<ArgOrVar>
		val module = EcoreUtil2.getContainerOfType(context, NablaModule)
		iteratorsAndVars += module.allVariables
		iteratorsAndVars += subList(definition.iterators, context)
		iteratorsAndVars += context
		Scopes::scopeFor(iteratorsAndVars)
	}

	def IScope scope_ArgOrVarRef_target(NablaModule context, EReference r)
	{
		//println('scope_VarRef_variable(' + context.class.simpleName + ', ' + r.name + ')')
		IScope::NULLSCOPE
	}

	private def dispatch IScope variablesDefinedBefore(Instruction context, Instruction i, String prefix)
	{
		//println(prefix + 'variablesDefinedBefore(' + context.class.simpleName + ', ' + i.class.simpleName + ')')
		variablesDefinedBefore(context.eContainer, context, prefix + '\t')
	}

	private def dispatch IScope variablesDefinedBefore(Job context, Instruction i, String prefix)
	{
		//println(prefix + 'variablesDefinedBefore(' + context.class.simpleName + ', ' + i.class.simpleName + ')')
		Scopes::scopeFor((context.eContainer as NablaModule).allVariables)
	}

	private def dispatch IScope variablesDefinedBefore(NablaModule context, Instruction i, String prefix)
	{
		//println(prefix + 'variablesDefinedBefore(' + context.class.simpleName + ', ' + i.class.simpleName + ')')
		Scopes::scopeFor(variablesDeclaredBefore(context.instructions, i))
	}

	private def dispatch IScope variablesDefinedBefore(FunctionOrReduction context, Instruction i, String prefix)
	{
		//println(prefix + 'variablesDefinedBefore(' + context.class.simpleName + ', ' + i.class.simpleName + ')')
		Scopes::scopeFor(context.inArgs)
	}

	private def dispatch IScope variablesDefinedBefore(InstructionBlock context, Instruction i, String prefix)
	{
		//println(prefix + 'variablesDefinedBefore(' + context.class.simpleName + ', ' + i.class.simpleName + ')')
		val containerScope = variablesDefinedBefore(context.eContainer, context, prefix + '\t')
		Scopes::scopeFor(variablesDeclaredBefore(context.instructions, i), containerScope)
	}

	private def variablesDeclaredBefore(List<? extends Instruction> list, Instruction i)
	{
		subList(list, i).allVariables
	}

	private def getAllVariables(NablaModule it) { instructions.allVariables }
	private def getAllVariables(List<? extends Instruction> instructions)
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

	/*** Scope for dimension symbols **********************************/
	def IScope scope_SizeTypeSymbolRef_target(Iterable context, EReference r)
	{
		//println('scope_DimensionSymbolRef_target(' + context.class.simpleName + ', ' + r.name + ')')
		symbolsDefinedBefore(context.eContainer, '\t')
	}

	def IScope scope_SizeTypeSymbolRef_target(ArgOrVarRef context, EReference r)
	{
		//println('scope_DimensionSymbolRef_target(' + context.class.simpleName + ', ' + r.name + ')')
		symbolsDefinedBefore(context.eContainer, '\t')
	}

	def IScope scope_SizeTypeSymbolRef_target(BaseType context, EReference r)
	{
		//println('scope_DimensionSymbolRef_target(' + context.class.simpleName + ', ' + r.name + ')')
		symbolsDefinedBefore(context.eContainer, '\t')
	}

	def IScope scope_SizeTypeSymbolRef_target(NablaModule context, EReference r)
	{
		//println('scope_DimensionSymbolRef_target(' + context.class.simpleName + ', ' + r.name + ')')
		IScope::NULLSCOPE
	}

	private def IScope symbolsDefinedBefore(EObject o, String prefix)
	{
		//println(prefix + 'symbolsDefinedBefore(' + o.class.simpleName + ')')
		if (o === null || o instanceof NablaModule) IScope.NULLSCOPE
		else switch o
		{
			FunctionOrReduction: Scopes.scopeFor(o.vars)
			Iterable case (o.iterationBlock instanceof Interval):
				Scopes.scopeFor(#[(o.iterationBlock as Interval).index], symbolsDefinedBefore(o.eContainer, prefix + '\t'))
			default: symbolsDefinedBefore(o.eContainer, prefix + '\t')
		}
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
