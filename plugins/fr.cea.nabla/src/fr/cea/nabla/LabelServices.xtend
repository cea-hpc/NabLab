/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla

import fr.cea.nabla.nabla.Affectation
import fr.cea.nabla.nabla.And
import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.BaseType
import fr.cea.nabla.nabla.BaseTypeConstant
import fr.cea.nabla.nabla.BoolConstant
import fr.cea.nabla.nabla.Comparison
import fr.cea.nabla.nabla.ConnectivityCall
import fr.cea.nabla.nabla.ContractedIf
import fr.cea.nabla.nabla.Equality
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.If
import fr.cea.nabla.nabla.InstructionBlock
import fr.cea.nabla.nabla.IntConstant
import fr.cea.nabla.nabla.IntervalIterationBlock
import fr.cea.nabla.nabla.Job
import fr.cea.nabla.nabla.Loop
import fr.cea.nabla.nabla.MaxConstant
import fr.cea.nabla.nabla.MinConstant
import fr.cea.nabla.nabla.Minus
import fr.cea.nabla.nabla.Modulo
import fr.cea.nabla.nabla.MulOrDiv
import fr.cea.nabla.nabla.Not
import fr.cea.nabla.nabla.Or
import fr.cea.nabla.nabla.Parenthesis
import fr.cea.nabla.nabla.Plus
import fr.cea.nabla.nabla.RangeSpaceIterator
import fr.cea.nabla.nabla.RealConstant
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.Return
import fr.cea.nabla.nabla.SimpleVarDefinition
import fr.cea.nabla.nabla.SingletonSpaceIterator
import fr.cea.nabla.nabla.SizeTypeInt
import fr.cea.nabla.nabla.SizeTypeOperation
import fr.cea.nabla.nabla.SizeTypeSymbol
import fr.cea.nabla.nabla.SizeTypeSymbolRef
import fr.cea.nabla.nabla.SpaceIterationBlock
import fr.cea.nabla.nabla.SpaceIteratorRef
import fr.cea.nabla.nabla.TimeIteratorRef
import fr.cea.nabla.nabla.UnaryMinus
import fr.cea.nabla.nabla.VarGroupDeclaration
import fr.cea.nabla.nabla.VectorConstant

import static extension fr.cea.nabla.ir.Utils.*

class LabelServices
{
	/* JOBS & INSTRUCTIONS ***********************************/
	static def dispatch String getLabel(Job it) { name + ' : ' + instruction?.label }
	static def dispatch String getLabel(SimpleVarDefinition it) { type?.label + ' ' + variable.name + '=' + defaultValue?.label }
	static def dispatch String getLabel(VarGroupDeclaration it) { type?.label + ' ' + variables.map[x|x.name].join(', ') }
	static def dispatch String getLabel(InstructionBlock it) { '{ }' }
	static def dispatch String getLabel(Loop it) { '\u2200 ' + iterationBlock?.label + ', ' + body?.label }
	static def dispatch String getLabel(Affectation it) { left?.label + ' = ' + right?.label }
	static def dispatch String getLabel(If it) { 'if ' + condition?.label }
	static def dispatch String getLabel(Return it) { 'return ' + expression?.label }

	/* ITERATEURS ********************************************/
	static def dispatch String getLabel(SpaceIterationBlock it) { range?.label }
	static def dispatch String getLabel(IntervalIterationBlock it) { index?.label + '\u2208 [' + from.label + ';' + to.label + (if (toIncluded) ']' else'[') }

	static def dispatch String getLabel(RangeSpaceIterator it) { name + '\u2208 ' + container?.label }
	static def dispatch String getLabel(SingletonSpaceIterator it) { name + '=' + container?.label }
	static def dispatch String getLabel(ConnectivityCall it) { connectivity.name + '(' + args.map[label].join(',') + ')' }
	static def dispatch String getLabel(SpaceIteratorRef it) 
	{ 
		if (inc > 0) target?.name + '+' + inc
		else if (dec > 0) target?.name + dec
		else target?.name
	}

	static def dispatch String getLabel(TimeIteratorRef it) { target.name + type.literal }

	/* EXPRESSIONS ******************************************/
	static def dispatch String getLabel(ContractedIf it) { condition?.label + ' ? ' + then?.label + ' : ' + ^else?.label }
	static def dispatch String getLabel(Or it) { left?.label + ' || ' + right?.label }
	static def dispatch String getLabel(And it) { left?.label + ' && ' + right?.label }
	static def dispatch String getLabel(Equality it) { left?.label + ' == ' + right?.label }
	static def dispatch String getLabel(Comparison it) { left?.label + ' ' + op + ' ' + right?.label }
	static def dispatch String getLabel(Plus it) { left?.label + ' + ' + right?.label }
	static def dispatch String getLabel(Minus it) { left?.label + ' - ' + right?.label }
	static def dispatch String getLabel(MulOrDiv it) { left?.label + ' ' + op + ' ' + right?.label }
	static def dispatch String getLabel(Modulo it) { left?.label + ' ' + op + ' ' + right?.label }
	static def dispatch String getLabel(Parenthesis it) { '(' + expression?.label + ')' }
	static def dispatch String getLabel(UnaryMinus it) { '-' + expression?.label }
	static def dispatch String getLabel(Not it) { '!' + expression?.label }
	static def dispatch String getLabel(IntConstant it) { value.toString }
	static def dispatch String getLabel(RealConstant it) { value.toString }
	static def dispatch String getLabel(BoolConstant it) { value.toString }
	static def dispatch String getLabel(MinConstant it) { '-\u221E' }
	static def dispatch String getLabel(MaxConstant it) { '-\u221E' }
	static def dispatch String getLabel(FunctionCall it) { function.name + '(' + args.map[label].join(',') + ')' }
	static def dispatch String getLabel(ReductionCall it) { reduction.name + '{' + iterationBlock?.label + '}(' + arg?.label + ')' }
	static def dispatch String getLabel(BaseTypeConstant it) { type?.label + '(' + value?.label + ')' }
	static def dispatch String getLabel(VectorConstant it) { '[' + values.join(',') + ']' }
	static def dispatch String getLabel(ArgOrVarRef it)
	{
		var label = target.name
		if (!timeIterators.empty) label += '^{' + timeIterators.map[x | x?.label].join(', ') + '}'
		if (!spaceIterators.empty) label += '{' + spaceIterators.map[x | x?.label].join(',') + '}'
		if (!indices.empty) label += '[' + indices.map[x | x?.label].join(',') + ']'
		return label
	}

	/* TYPES *************************************************/
	static def dispatch String getLabel(BaseType it) 
	{ 
		if (sizes.empty) 
			primitive.literal
		else if (sizes.exists[x | !(x instanceof SizeTypeInt)])
			primitive.literal + '[' + sizes.map[x | x.label].join(',') + ']'
		else
			primitive.literal + sizes.map[x | (x as SizeTypeInt).value.utfExponent].join('\u02E3')
	}

	static def dispatch String getLabel(SizeTypeOperation it) { left?.label + ' ' + op + ' ' + right?.label }
	static def dispatch String getLabel(SizeTypeInt it) { value.toString }
	static def dispatch String getLabel(SizeTypeSymbolRef it) { target?.name }
	static def dispatch String getLabel(SizeTypeSymbol it) { name }
}