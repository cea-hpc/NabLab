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
 * 	Jean-Sylvan Camier - Nabla generation support
 *******************************************************************************/
package fr.cea.nabla.scoping

import fr.cea.nabla.nabla.Expression
import fr.cea.nabla.nabla.Instruction
import fr.cea.nabla.nabla.InstructionBlock
import fr.cea.nabla.nabla.InstructionJob
import fr.cea.nabla.nabla.Loop
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.ScalarVarDefinition
import fr.cea.nabla.nabla.SpaceIterator
import fr.cea.nabla.nabla.TimeLoopJob
import fr.cea.nabla.nabla.VarGroupDeclaration
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
	enum IteratorType { Space, Time }
	
	/*** Scope des itérateurs pour les variables ***************************************/
	def scope_SpaceIteratorRef_iterator(Expression context, EReference r) 
	{
		//printDebug('\nscope_SpaceIteratorRef_iterator : ' + context, 0)
		context.eContainer.iteratorsDefinedBefore(IteratorType::Space, 0)
	}

	def scope_TimeIteratorRef_iterator(Expression context, EReference r) 
	{
		//printDebug('\nscope_TimeIteratorRef_iterator : ' + context, 0)
		context.eContainer.iteratorsDefinedBefore(IteratorType::Time, 0)
	}

	private def dispatch IScope iteratorsDefinedBefore(EObject context, IteratorType itType, int depth) 
	{
		//printDebug('iteratorsDefinedBefore - EObject (' + itType.name + ') : ' + context, depth)
		context.eContainer.iteratorsDefinedBefore(itType, depth + 1)
	}

	private def dispatch IScope iteratorsDefinedBefore(Loop context, IteratorType itType, int depth) 
	{
		//printDebug('iteratorsDefinedBefore - Loop (' + itType.name + ') : ' + context, depth)
		iteratorsForLoopOrReduction(context.iterator, context.eContainer, itType, depth)
	}

	private def dispatch IScope iteratorsDefinedBefore(ReductionCall context, IteratorType itType, int depth) 
	{
		//printDebug('iteratorsDefinedBefore - ReductionFunctionCall (' + itType.name + ') : ' + context, depth)
		iteratorsForLoopOrReduction(context.iterator, context.eContainer, itType, depth)
	}

	private def dispatch IScope iteratorsDefinedBefore(TimeLoopJob context, IteratorType itType, int depth)
	{
		//printDebug('iteratorsDefinedBefore - TimeLoopJob (' + itType.name + ') : ' + context, depth)
		if (itType==IteratorType::Time) Scopes::scopeFor(#[context.iterator])
		else IScope::NULLSCOPE
	}
	
	private def dispatch IScope iteratorsDefinedBefore(InstructionJob context, IteratorType itType, int depth)
	{
		//printDebug('iteratorsDefinedBefore - InstructionJob (' + itType.name + ') : ' + context, depth)
		IScope::NULLSCOPE 
	}
	
	private def dispatch IScope iteratorsDefinedBefore(NablaModule context, IteratorType itType, int depth)
	{
		//printDebug('iteratorsDefinedBefore - NablaModule (' + itType.name + ') : ' + context, depth)
		IScope::NULLSCOPE 
	}

	private def IScope iteratorsForLoopOrReduction(SpaceIterator contextIterator, EObject contextContainer, IteratorType itType, int depth) 
	{
		if (itType==IteratorType::Space) 
		{
			//printDebug('iterators', depth, #[contextIterator])
			Scopes::scopeFor(#[contextIterator], contextContainer.iteratorsDefinedBefore(itType, depth + 1))
		}
		else				
			contextContainer.iteratorsDefinedBefore(itType, depth + 1) 
	}
	

	/*** Scope des itérateurs pour les itérateurs **************************************/
	def scope_SpaceIteratorRange_args(Expression context, EReference r) 
	{
		//printDebug('\nscope_SpaceIteratorRange_args : ' + context, 0)
		context.eContainer.iteratorsDefinedBefore(IteratorType::Space, 0)
	}

	def scope_SpaceIteratorRange_args(Loop context, EReference r) 
	{
		//printDebug('\nscope_SpaceIteratorRange_args : ' + context, 0)
		context.eContainer.iteratorsDefinedBefore(IteratorType::Space, 0)
	}

	def scope_SpaceIteratorRange_args(ReductionCall context, EReference r) 
	{
		//printDebug('\nscope_SpaceIteratorRange_args : ' + context, 0)
		context.eContainer.iteratorsDefinedBefore(IteratorType::Space, 0)
	}

	/*** Scope des variables ***********************************************************/
	def scope_VarRef_variable(Instruction context, EReference r) 
	{
		//printDebug('\nscope_VarRef_variable : ' + context + ', ' + r.name, 0)
		context.eContainer.variablesDefinedBefore(context, 0)
	}

	private def dispatch IScope variablesDefinedBefore(EObject context, EObject o, int depth) 
	{
		//printDebug('variablesDefinedBefore - eobject : ' + context, depth)
		context.eContainer.variablesDefinedBefore(o.eContainer, depth + 1)
	}

	private def dispatch IScope variablesDefinedBefore(NablaModule context, EObject o, int depth) 
	{
		Scopes::scopeFor(context.variables.variablesDeclaredBefore(o, depth))
	}
		
	private def dispatch IScope variablesDefinedBefore(InstructionBlock context, EObject o, int depth) 
	{
		//printDebug('variablesDefinedBefore - InstructionBlock : ' + context, depth)
		Scopes::scopeFor(context.instructions.variablesDeclaredBefore(o, depth), context.eContainer.variablesDefinedBefore(o.eContainer, depth + 1))
	}
	
	private def variablesDeclaredBefore(List<? extends EObject> list, EObject o, int depth) 
	{
		val vars1 = list.subList(0, list.indexOf(o)).filter(VarGroupDeclaration).map[variables].flatten
		val vars2 = list.subList(0, list.indexOf(o)).filter(ScalarVarDefinition).map[variable]
		return vars1 + vars2
	}
	
	/*** Méthodes de debug et utilitaires **********************************************/
//	def private printDebug(String s, int depth) 
//	{ 
//		for (i : 0..<depth) print('\t')
//		println(s)		
//	}
//
//	def private printDebug(String s, int depth, Iterable<? extends Object> l) 
//	{ 
//		if (l.nullOrEmpty)
//		{
//			printDebug(s + ' (liste vide)', depth)
//		}
//		else
//		{
//			printDebug(s + ' (' + l.size + ') : ', depth)
//			l.forEach(e | printDebug('- ' + e, depth) )	
//		}
//	}
}
