/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.scoping

import fr.cea.nabla.nabla.ArgType
import fr.cea.nabla.nabla.ConnectivityCall
import fr.cea.nabla.nabla.DimensionIterationBlock
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.Instruction
import fr.cea.nabla.nabla.InstructionBlock
import fr.cea.nabla.nabla.Iterable
import fr.cea.nabla.nabla.Job
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.Reduction
import fr.cea.nabla.nabla.SimpleVarDefinition
import fr.cea.nabla.nabla.SingletonSpaceIterator
import fr.cea.nabla.nabla.SpaceIterationBlock
import fr.cea.nabla.nabla.Var
import fr.cea.nabla.nabla.VarGroupDeclaration
import fr.cea.nabla.nabla.ArgOrVarRef
import java.util.ArrayList
import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
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
	def scope_SpaceIteratorRef_target(ConnectivityCall context, EReference r)
	{
		val s = iteratorsDefinedBefore(context.eContainer, context)
		return s
	}

	def scope_SpaceIteratorRef_target(ArgOrVarRef context, EReference r)
	{
		val s = iteratorsDefinedBefore(context.eContainer, null)
		return s
	}

	private def dispatch IScope iteratorsDefinedBefore(EObject context, ConnectivityCall c)
	{
		iteratorsDefinedBefore(context.eContainer, c)
	}

	private def dispatch IScope iteratorsDefinedBefore(Job context, ConnectivityCall c)
	{
		IScope::NULLSCOPE
	}

	private def dispatch IScope iteratorsDefinedBefore(Iterable context, ConnectivityCall c)
	{
		val containerScope = iteratorsDefinedBefore(context.eContainer, c)
		if (context.iterationBlock instanceof SpaceIterationBlock)
		{
			val b = context.iterationBlock as SpaceIterationBlock
			val previousIterators = iteratorsDeclaredBefore(c, b.singletons)
			if (b.range.container === c)
				Scopes::scopeFor(previousIterators, containerScope)
			else
				Scopes::scopeFor(#[b.range] + previousIterators, containerScope)			
		}
	}

	private def iteratorsDeclaredBefore(ConnectivityCall c, List<SingletonSpaceIterator> list)
	{
		if (c !== null && !list.empty) 
		{
			val index = list.map[container].indexOf(c)
			if (index != -1) return list.subList(0, index)
		}
		return list
	}

	/*** Scope for variables ***********************************************************/
	def IScope scope_ArgOrVarRef_target(Instruction context, EReference r)
	{
		//println('scope_VarRef_variable(' + context.class.simpleName + ', ' + r.name + ')')
		variablesDefinedBefore(context.eContainer, context, '\t')
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
		Scopes::scopeFor((context.eContainer as NablaModule).instructions.allVariables)
	}

	private def dispatch IScope variablesDefinedBefore(NablaModule context, Instruction i, String prefix)
	{
		//println(prefix + 'variablesDefinedBefore(' + context.class.simpleName + ', ' + i.class.simpleName + ')')
		Scopes::scopeFor(variablesDeclaredBefore(context.instructions, i, prefix + '\t'))
	}

	private def dispatch IScope variablesDefinedBefore(Function context, Instruction i, String prefix)
	{
		//println(prefix + 'variablesDefinedBefore(' + context.class.simpleName + ', ' + i.class.simpleName + ')')
		Scopes::scopeFor(context.inArgs)
	}

	private def dispatch IScope variablesDefinedBefore(InstructionBlock context, Instruction i, String prefix)
	{
		//println(prefix + 'variablesDefinedBefore(' + context.class.simpleName + ', ' + i.class.simpleName + ')')
		val containerScope = variablesDefinedBefore(context.eContainer, context, prefix + '\t')
		Scopes::scopeFor(variablesDeclaredBefore(context.instructions, i, prefix + '\t'), containerScope)
	}

	private def variablesDeclaredBefore(List<? extends Instruction> list, Instruction i, String prefix)
	{
		var List<Var> variables
		val iIndex = list.indexOf(i)
		if (iIndex == -1) 
			variables = #[]
		else
			variables = list.subList(0, iIndex).allVariables		
		//println(prefix + 'variablesDeclaredBefore(' + i.class.simpleName + ') : ' + variables.map[name].join(', '))
		return variables
	}

	private def getAllVariables(List<? extends Instruction> instructions)
	{
		val variables = new ArrayList<Var>
		for (i : instructions)
			switch i
			{
				VarGroupDeclaration : variables += i.variables
				SimpleVarDefinition : variables += i.variable
			}				
		return variables
	}

	/*** Scope for dimension symbols **********************************/
	def IScope scope_DimensionSymbolRef_target(Iterable context, EReference r)
	{
		//println('scope_DimensionSymbolRef_target(' + context.class.simpleName + ', ' + r.name + ')')
		symbolsDefinedBefore(context.eContainer, '\t')
	}

	def IScope scope_DimensionSymbolRef_target(ArgOrVarRef context, EReference r)
	{
		//println('scope_DimensionSymbolRef_target(' + context.class.simpleName + ', ' + r.name + ')')
		symbolsDefinedBefore(context.eContainer, '\t')
	}

	def IScope scope_DimensionSymbolRef_target(ArgType context, EReference r)
	{
		//println('scope_DimensionSymbolRef_target(' + context.class.simpleName + ', ' + r.name + ')')
		symbolsDefinedBefore(context.eContainer, '\t')
	}

	def IScope scope_DimensionSymbolRef_target(NablaModule context, EReference r)
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
			Function: Scopes.scopeFor(o.dimVars)
			Reduction: Scopes.scopeFor(o.dimVars)
			Iterable case (o.iterationBlock instanceof DimensionIterationBlock):
				Scopes.scopeFor(#[(o.iterationBlock as DimensionIterationBlock).index], symbolsDefinedBefore(o.eContainer, prefix + '\t'))
			default: symbolsDefinedBefore(o.eContainer, prefix + '\t')
		}
	}
}
