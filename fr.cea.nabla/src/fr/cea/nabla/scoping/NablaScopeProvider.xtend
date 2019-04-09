/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 * 	Benoit Lelandais - initial implementation
 * 	Marie-Pierre Oudot - initial implementation
 * 	Jean-Sylvain Camier - Nabla generation support
 *******************************************************************************/
package fr.cea.nabla.scoping

import fr.cea.nabla.nabla.ConnectivityCall
import fr.cea.nabla.nabla.Instruction
import fr.cea.nabla.nabla.InstructionBlock
import fr.cea.nabla.nabla.Job
import fr.cea.nabla.nabla.Loop
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.ScalarVarDefinition
import fr.cea.nabla.nabla.SingleSpaceIterator
import fr.cea.nabla.nabla.VarGroupDeclaration
import fr.cea.nabla.nabla.VarRef
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
	/*** Scope des itérateurs **********************************************************/
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
		val previousIterators = iteratorsDeclaredBefore(c, context.dependantIterators)
		if (context.iterator.call === c)
			Scopes::scopeFor(previousIterators, context.eContainer.iteratorsDefinedBefore(c))
		else
			Scopes::scopeFor(#[context.iterator] + previousIterators, context.eContainer.iteratorsDefinedBefore(c))
	}
	
	private def dispatch IScope iteratorsDefinedBefore(ReductionCall context, ConnectivityCall c) 
	{ 
		val previousIterators = iteratorsDeclaredBefore(c, context.dependantIterators)
		if (context.iterator.call === c)
			Scopes::scopeFor(previousIterators, context.eContainer.iteratorsDefinedBefore(c))
		else
			Scopes::scopeFor(#[context.iterator] + previousIterators, context.eContainer.iteratorsDefinedBefore(c))
	}

	private def iteratorsDeclaredBefore(ConnectivityCall c, List<SingleSpaceIterator> list) 
	{
		if (c !== null && !list.empty) 
		{
			val index = list.map[call].indexOf(c)
			if (index != -1) return list.subList(0, index)	
		}
		return list
	}

	/*** Scope des variables ***********************************************************/
	def scope_VarRef_variable(Instruction context, EReference r) 
	{
		context.eContainer.variablesDefinedBefore(context)
	}

	private def dispatch IScope variablesDefinedBefore(EObject context, EObject o) 
	{
		context.eContainer.variablesDefinedBefore(o.eContainer)
	}

	private def dispatch IScope variablesDefinedBefore(NablaModule context, EObject o) 
	{
		Scopes::scopeFor(context.variables.variablesDeclaredBefore(o))
	}
		
	private def dispatch IScope variablesDefinedBefore(InstructionBlock context, EObject o) 
	{
		Scopes::scopeFor(context.instructions.variablesDeclaredBefore(o), context.eContainer.variablesDefinedBefore(o.eContainer))
	}
	
	private def variablesDeclaredBefore(List<? extends EObject> list, EObject o) 
	{
		val vars1 = list.subList(0, list.indexOf(o)).filter(VarGroupDeclaration).map[variables].flatten
		val vars2 = list.subList(0, list.indexOf(o)).filter(ScalarVarDefinition).map[variable]
		return vars1 + vars2
	}
}
