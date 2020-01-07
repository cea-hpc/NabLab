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

import com.google.inject.Inject
import fr.cea.nabla.ArgOrVarExtensions
import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.BaseType
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.Instruction
import fr.cea.nabla.nabla.InstructionBlock
import fr.cea.nabla.nabla.IntervalIterationBlock
import fr.cea.nabla.nabla.Iterable
import fr.cea.nabla.nabla.Job
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.PrimitiveType
import fr.cea.nabla.nabla.RangeSpaceIterator
import fr.cea.nabla.nabla.Reduction
import fr.cea.nabla.nabla.SimpleVar
import fr.cea.nabla.nabla.SimpleVarDefinition
import fr.cea.nabla.nabla.SingletonSpaceIterator
import fr.cea.nabla.nabla.SpaceIterationBlock
import fr.cea.nabla.nabla.SpaceIterator
import fr.cea.nabla.nabla.TimeIterator
import fr.cea.nabla.nabla.TimeIteratorDefinition
import fr.cea.nabla.nabla.Var
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
	@Inject extension ArgOrVarExtensions

	def scope_TimeIterator_counter(TimeIterator context, EReference r)
	{
		//println('scope_TimeIterator_counter(' + context.class.simpleName + ', ' + r.name + ')')
		val module = EcoreUtil2.getContainerOfType(context, NablaModule)
		if (module !== null)
		{
			val allSimpleVars = module.instructions.allVariables.filter(SimpleVar)
			val candidates = allSimpleVars.filter[x | x.type.primitive == PrimitiveType::INT && x.type.sizes.empty ]
			return Scopes::scopeFor(candidates)
		}
		return IScope::NULLSCOPE
	}

	/*** Scope for iterators **********************************************************/
//	def scope_SpaceIteratorRef_target(ConnectivityCall context, EReference r)
//	{
//		println('scope_SpaceIteratorRef_target(' + context.class.simpleName + ', ' + r.name + ')')
//		val s = iteratorsDefinedBefore(context.eContainer, context, '\t')
//		println('--> ' + s)
//		return s
//	}

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
		val previousIterators = iteratorsDeclaredBefore(block.singletons, context, '\t')
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

	private def iteratorsDeclaredBefore(List<SingletonSpaceIterator> list, SingletonSpaceIterator i, String prefix)
	{
		var List<SingletonSpaceIterator> iterators
		val iIndex = list.indexOf(i)
		if (iIndex == -1) 
			iterators = #[]
		else
			iterators = list.subList(0, iIndex)
		return iterators
	}

	/*** Scope for variables ***********************************************************/
	def IScope scope_ArgOrVarRef_target(Instruction context, EReference r)
	{
		//println('scope_VarRef_variable(' + context.class.simpleName + ', ' + r.name + ')')
		variablesDefinedBefore(context.eContainer, context, '\t')
	}

	def IScope scope_ArgOrVarRef_target(TimeIteratorDefinition context, EReference r)
	{
		//println('scope_VarRef_variable(' + context.class.simpleName + ', ' + r.name + ')')
		Scopes::scopeFor((context.eContainer as NablaModule).instructions.allVariables)
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
			Function: Scopes.scopeFor(o.vars)
			Reduction: Scopes.scopeFor(o.vars)
			Iterable case (o.iterationBlock instanceof IntervalIterationBlock):
				Scopes.scopeFor(#[(o.iterationBlock as IntervalIterationBlock).index], symbolsDefinedBefore(o.eContainer, prefix + '\t'))
			default: symbolsDefinedBefore(o.eContainer, prefix + '\t')
		}
	}
}
