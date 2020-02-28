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
import fr.cea.nabla.nabla.IntervalIterationBlock
import fr.cea.nabla.nabla.Iterable
import fr.cea.nabla.nabla.Job
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.RangeSpaceIterator
import fr.cea.nabla.nabla.SimpleVarDefinition
import fr.cea.nabla.nabla.SingletonSpaceIterator
import fr.cea.nabla.nabla.SpaceIterationBlock
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
	def scope_SpaceIteratorRef_target(RangeSpaceIterator context, EReference r)
	{
		//println('scope_SpaceIteratorRef_target(' + context.class.simpleName + ', ' + r.name + ')')
		val iterable = EcoreUtil2.getContainerOfType(context, Iterable)
		val s = iteratorsDefinedBefore(iterable.eContainer, '\t')
		//println('--> ' + s)
		return s
	}

	def scope_SpaceIteratorRef_target(SingletonSpaceIterator context, EReference r)
	{
		//println('scope_SpaceIteratorRef_target(' + context.class.simpleName + ', ' + r.name + ')')
		val block = context.eContainer as SpaceIterationBlock
		val previousIterators = tObjectsDeclaredBeforeInList(block.singletons, context)
		val scopeIterators = new ArrayList<SpaceIterator>
		scopeIterators += block.range
		scopeIterators += previousIterators
		val iterable = EcoreUtil2.getContainerOfType(context, Iterable)
		val s = Scopes::scopeFor(scopeIterators, iteratorsDefinedBefore(iterable.eContainer, '\t'))
		//println('--> ' + s)
		return s
	}

	def scope_SpaceIteratorRef_target(ArgOrVarRef context, EReference r)
	{
		//println('scope_SpaceIteratorRef_target(' + context.class.simpleName + ', ' + r.name + ')')
		val s = iteratorsDefinedBefore(context.eContainer, '\t')
		//println('--> ' + s)
		return s
	}

	private def IScope iteratorsDefinedBefore(EObject o, String prefix)
	{
		//println(prefix + 'iteratorsDefinedBefore(' + o.class.simpleName + ')')
		if (o === null || o instanceof Job) IScope.NULLSCOPE
		else switch o
		{
			Iterable case (o.iterationBlock instanceof SpaceIterationBlock):
			{
				val b = o.iterationBlock as SpaceIterationBlock
				val scopeIterators = new ArrayList<SpaceIterator>
				scopeIterators += b.range
				scopeIterators += b.singletons
				Scopes::scopeFor(scopeIterators, iteratorsDefinedBefore(o.eContainer, prefix + '\t'))
			}
			default: iteratorsDefinedBefore(o.eContainer, prefix + '\t')
		}
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
		iteratorsAndVars += tObjectsDeclaredBeforeInList(definition.iterators, context)
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
		Scopes::scopeFor(variablesDeclaredBefore(context.instructions, i, prefix + '\t'))
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
		Scopes::scopeFor(variablesDeclaredBefore(context.instructions, i, prefix + '\t'), containerScope)
	}

	private def variablesDeclaredBefore(List<? extends Instruction> list, Instruction i, String prefix)
	{
		var List<ArgOrVar> variables
		val iIndex = list.indexOf(i)
		if (iIndex == -1) 
			variables = #[]
		else
			variables = list.subList(0, iIndex).allVariables
		//println(prefix + 'variablesDeclaredBefore(' + i.class.simpleName + ') : ' + variables.map[name].join(', '))
		return variables
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
			Iterable case (o.iterationBlock instanceof IntervalIterationBlock):
				Scopes.scopeFor(#[(o.iterationBlock as IntervalIterationBlock).index], symbolsDefinedBefore(o.eContainer, prefix + '\t'))
			default: symbolsDefinedBefore(o.eContainer, prefix + '\t')
		}
	}

	private def <T extends EObject> tObjectsDeclaredBeforeInList(List<T> listOfElts, T eltInList)
	{
		var List<T> iterators
		val iIndex = listOfElts.indexOf(eltInList)
		if (iIndex == -1) 
			iterators = #[]
		else
			iterators = listOfElts.subList(0, iIndex)
		return iterators
	}
}
