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
import fr.cea.nabla.nabla.DimensionVar
import fr.cea.nabla.nabla.DimensionVarReference
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.IndexLoop
import fr.cea.nabla.nabla.Instruction
import fr.cea.nabla.nabla.InstructionBlock
import fr.cea.nabla.nabla.IteratorLoop
import fr.cea.nabla.nabla.Job
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.Reduction
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.SimpleVarDefinition
import fr.cea.nabla.nabla.SingletonSpaceIterator
import fr.cea.nabla.nabla.Var
import fr.cea.nabla.nabla.VarGroupDeclaration
import fr.cea.nabla.nabla.VarRef
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
		val s = context.eContainer.iteratorsDefinedBefore(context)
//		println("scope for connectivity call " + context.connectivity.name + " : " + s)
		return s
	}

	def scope_SpaceIteratorRef_target(VarRef context, EReference r)
	{
		val s = context.eContainer.iteratorsDefinedBefore(null)
//		println("scope for variable " + context.variable.name + " : " + s)
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

	private def dispatch IScope iteratorsDefinedBefore(IteratorLoop context, ConnectivityCall c)
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
//		println('scope_VarRef_variable(' + context.class.simpleName + ', ' + r.name + ')')
		context.eContainer.variablesDefinedBefore(context, '\t')
	}

	def scope_VarRef_variable(Reduction context, EReference r)
	{
//		println('scope_VarRef_variable(' + context.class.simpleName + ', ' + r.name + ')')
		IScope::NULLSCOPE
	}

	def scope_VarRef_variable(Function context, EReference r)
	{
//		println('scope_VarRef_variable(' + context.class.simpleName + ', ' + r.name + ')')
		IScope::NULLSCOPE
	}

	private def dispatch IScope variablesDefinedBefore(EObject context, Instruction o, String prefix)
	{
//		println(prefix + '[EObject] variablesDefinedBefore(' + context.class.simpleName + ', ' + o.class.simpleName + ')')
		switch (context)
		{
			IndexLoop: Scopes::scopeFor(#[context.index], context.eContainer.variablesDefinedBefore(context, prefix + '\t'))
			Instruction: context.eContainer.variablesDefinedBefore(context, prefix + '\t')
			Job: Scopes::scopeFor((context.eContainer as NablaModule).variables.allVariables)
			Function: Scopes.scopeFor(context.inArgs)
			default: IScope::NULLSCOPE
		}
	}

	private def dispatch IScope variablesDefinedBefore(NablaModule context, Instruction o, String prefix)
	{
//		println(prefix + '[NablaModule] variablesDefinedBefore(' + context.class.simpleName + ', ' + o.class.simpleName + ')')
		if (o instanceof SimpleVarDefinition || o instanceof VarGroupDeclaration)
			Scopes::scopeFor(context.variables.variablesDeclaredBefore(o, prefix + '\t'))
		else
			Scopes::scopeFor(context.variables.allVariables)
	}

	private def dispatch IScope variablesDefinedBefore(InstructionBlock context, Instruction o, String prefix)
	{
//		println(prefix + '[InstructionBlock] variablesDefinedBefore(' + context.class.simpleName + ', ' + o.class.simpleName + ')')
		Scopes::scopeFor(context.instructions.variablesDeclaredBefore(o, prefix + '\t'), context.eContainer.variablesDefinedBefore(context, prefix + '\t'))
	}

	private def variablesDeclaredBefore(List<? extends Instruction> list, Instruction o, String prefix)
	{
		val variables = list.subList(0, list.indexOf(o)).allVariables
//		println(prefix + 'variablesDeclaredBefore(' + o.class.simpleName + ') : ' + variables.map[name].join(', '))
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

	/*** Scope for dimension variables of functions **********************************/
	def scope_DimensionVarReference_target(DimensionVarReference context, EReference r)
	{
		val variables = context.dimensionVariables
		if (variables.empty) IScope::NULLSCOPE
		else Scopes.scopeFor(variables)
	}

	private def List<DimensionVar> getDimensionVariables(EObject o)
	{
		if (o === null) #[]
		else switch o
		{
			Function: o.dimVars
			Reduction: o.dimVars
			default: o.eContainer.dimensionVariables
		}
	}
}
