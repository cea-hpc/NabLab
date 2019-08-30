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

import fr.cea.nabla.nabla.ConnectivityCall
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.Instruction
import fr.cea.nabla.nabla.InstructionBlock
import fr.cea.nabla.nabla.Job
import fr.cea.nabla.nabla.Loop
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.Reduction
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.ScalarVarDefinition
import fr.cea.nabla.nabla.SingletonSpaceIterator
import fr.cea.nabla.nabla.VarGroupDeclaration
import fr.cea.nabla.nabla.VarRef
import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.scoping.IScope
import org.eclipse.xtext.scoping.Scopes
import org.eclipse.xtext.scoping.impl.AbstractDeclarativeScopeProvider
import java.util.ArrayList
import fr.cea.nabla.nabla.Var

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
		val s = context.eContainer.iteratorsDefinedBefore(context)
		//println("scope for connectivity call " + context.connectivity.name + " : " + s)
		return s
	}

	def scope_SpaceIteratorRef_target(VarRef context, EReference r)
	{
		val s = context.eContainer.iteratorsDefinedBefore(null)
		//println("scope for variable " + context.variable.name + " : " + s)
		return s
	}

	private def dispatch IScope iteratorsDefinedBefore(EObject context, ConnectivityCall c) 
	{ 
		context.eContainer.iteratorsDefinedBefore(c)
	}
	
	private def dispatch IScope iteratorsDefinedBefore(Job context, ConnectivityCall c) 
	{ 
		IScope::NULLSCOPE
	}
	
	private def dispatch IScope iteratorsDefinedBefore(Loop context, ConnectivityCall c) 
	{ 
		val previousIterators = iteratorsDeclaredBefore(c, context.singletons)
		if (context.range.container === c)
			Scopes::scopeFor(previousIterators, context.eContainer.iteratorsDefinedBefore(c))
		else
			Scopes::scopeFor(#[context.range] + previousIterators, context.eContainer.iteratorsDefinedBefore(c))
	}
	
	private def dispatch IScope iteratorsDefinedBefore(ReductionCall context, ConnectivityCall c) 
	{ 
		val previousIterators = iteratorsDeclaredBefore(c, context.singletons)
		if (context.range.container === c)
			Scopes::scopeFor(previousIterators, context.eContainer.iteratorsDefinedBefore(c))
		else
			Scopes::scopeFor(#[context.range] + previousIterators, context.eContainer.iteratorsDefinedBefore(c))
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
	def scope_VarRef_variable(Instruction context, EReference r) 
	{
		context.eContainer.variablesDefinedBefore(context)
	}

	def scope_VarRef_variable(Reduction context, EReference r) 
	{
		IScope::NULLSCOPE
	}

	def scope_VarRef_variable(Function context, EReference r) 
	{
		IScope::NULLSCOPE
	}

	private def dispatch IScope variablesDefinedBefore(EObject context, Instruction o) 
	{
		context.eContainer.variablesDefinedBefore(o)
	}
	
	private def dispatch IScope variablesDefinedBefore(NablaModule context, Instruction o) 
	{
		if (o instanceof ScalarVarDefinition || o instanceof VarGroupDeclaration)
			Scopes::scopeFor(context.variables.variablesDeclaredBefore(o))
		else
		{
			val globalVariables = new ArrayList<Var>
			for (v : context.variables)
				switch v
				{
					VarGroupDeclaration : globalVariables += v.variables
					ScalarVarDefinition : globalVariables += v.variable
				}	
			Scopes::scopeFor(globalVariables)	
		}
	}
		
	private def dispatch IScope variablesDefinedBefore(InstructionBlock context, Instruction o) 
	{
		Scopes::scopeFor(context.instructions.variablesDeclaredBefore(o), context.eContainer.variablesDefinedBefore(context))
	}
	
	private def variablesDeclaredBefore(List<? extends Instruction> list, Instruction o) 
	{
		val vars1 = list.subList(0, list.indexOf(o)).filter(VarGroupDeclaration).map[variables].flatten
		val vars2 = list.subList(0, list.indexOf(o)).filter(ScalarVarDefinition).map[variable]
		return vars1 + vars2
	}
}
