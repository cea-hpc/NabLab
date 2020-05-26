/*******************************************************************************
 * Copyright (c) 2020 CEA
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
import fr.cea.nabla.nabla.Cardinality
import fr.cea.nabla.nabla.Comparison
import fr.cea.nabla.nabla.ContractedIf
import fr.cea.nabla.nabla.CurrentTimeIteratorRef
import fr.cea.nabla.nabla.Div
import fr.cea.nabla.nabla.Equality
import fr.cea.nabla.nabla.Exit
import fr.cea.nabla.nabla.Expression
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.FunctionTypeDeclaration
import fr.cea.nabla.nabla.If
import fr.cea.nabla.nabla.InitTimeIteratorRef
import fr.cea.nabla.nabla.InstructionBlock
import fr.cea.nabla.nabla.IntConstant
import fr.cea.nabla.nabla.Interval
import fr.cea.nabla.nabla.ItemDefinition
import fr.cea.nabla.nabla.ItemRef
import fr.cea.nabla.nabla.Job
import fr.cea.nabla.nabla.Loop
import fr.cea.nabla.nabla.MaxConstant
import fr.cea.nabla.nabla.MinConstant
import fr.cea.nabla.nabla.Minus
import fr.cea.nabla.nabla.Modulo
import fr.cea.nabla.nabla.Mul
import fr.cea.nabla.nabla.MultipleConnectivityCall
import fr.cea.nabla.nabla.NextTimeIteratorRef
import fr.cea.nabla.nabla.Not
import fr.cea.nabla.nabla.Or
import fr.cea.nabla.nabla.Parenthesis
import fr.cea.nabla.nabla.Plus
import fr.cea.nabla.nabla.RealConstant
import fr.cea.nabla.nabla.Reduction
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.ReductionTypeDeclaration
import fr.cea.nabla.nabla.Return
import fr.cea.nabla.nabla.SetDefinition
import fr.cea.nabla.nabla.SetRef
import fr.cea.nabla.nabla.SimpleVar
import fr.cea.nabla.nabla.SimpleVarDefinition
import fr.cea.nabla.nabla.SingleConnectivityCall
import fr.cea.nabla.nabla.SingletonDefinition
import fr.cea.nabla.nabla.SpaceIterator
import fr.cea.nabla.nabla.UnaryMinus
import fr.cea.nabla.nabla.VarGroupDeclaration
import fr.cea.nabla.nabla.VectorConstant
import java.util.List

import static extension fr.cea.nabla.ir.Utils.*

class LabelServices
{
	/* JOBS & INSTRUCTIONS ***********************************/
	static def dispatch String getLabel(Job it) { name + ' : ' + instruction?.label }
	static def dispatch String getLabel(SimpleVarDefinition it) { 'let ' + variable?.name + '=' + value?.label }
	static def dispatch String getLabel(VarGroupDeclaration it) { type?.label + ' ' + vars?.map[x|x?.name].join(', ') }
	static def dispatch String getLabel(InstructionBlock it) { '{ }' }
	static def dispatch String getLabel(Loop it) { '\u2200 ' + iterationBlock?.label + ', ' + body?.label }
	static def dispatch String getLabel(Affectation it) { left?.label + ' = ' + right?.label }
	static def dispatch String getLabel(If it) { 'if ' + condition?.label }
	static def dispatch String getLabel(ItemDefinition it) { 'item ' + item?.name + '=' + value?.label }
	static def dispatch String getLabel(SetDefinition it) { 'set ' + name + '=' + value?.label }
	static def dispatch String getLabel(Return it) { 'return ' + expression?.label }
	static def dispatch String getLabel(Exit it) { 'Exit "' + message + '"'}

	/* ITERATEURS ********************************************/
	static def dispatch String getLabel(SpaceIterator it) { item?.name + '\u2208 ' + container?.label }
	static def dispatch String getLabel(SingletonDefinition it) { item?.name + '=' + value?.label }
	static def dispatch String getLabel(Interval it) { index?.name + '\u2208' + nbElems?.label }
	static def dispatch String getLabel(SetRef it) { target?.name }
	static def dispatch String getLabel(MultipleConnectivityCall it) { connectivity?.name + '(' + args?.map[label].join(',') + ')' }
	static def dispatch String getLabel(SingleConnectivityCall it) { connectivity?.name + '(' + args?.map[label].join(',') + ')' }
	static def dispatch String getLabel(ItemRef it) 
	{ 
		if (inc > 0) target?.name + '+' + inc
		else if (dec > 0) target?.name + '-' + dec
		else target?.name
	}

	static def dispatch String getLabel(CurrentTimeIteratorRef it) { target?.name }
	static def dispatch String getLabel(InitTimeIteratorRef it) { target?.name + '=' + value }
	static def dispatch String getLabel(NextTimeIteratorRef it) { target?.name + '+' + value }

	/* FONCTIONS / REDUCTIONS ********************************/
	static def dispatch String getLabel(Function it) { 'def ' + name + ' : ' + getLabel(vars, typeDeclaration) }
	static def dispatch String getLabel(Reduction it) { 'def ' + name + ', ' + seed?.label + ' : ' + getLabel(vars, typeDeclaration) }

	private static def String getLabel(List<SimpleVar> vars, FunctionTypeDeclaration td)
	{
		var ret = ''
		if (vars !== null)
		{
			ret += vars.map[name].join(', ')
			if (!vars.empty) ret += ' | '
		}
		if (td !== null)
		{
			ret += td.inTypes?.map[label].join(' \u00D7 ')
			ret += ' \u2192 ' + td.returnType?.label
		}
		return ret
	}

	private static def String getLabel(List<SimpleVar> vars, ReductionTypeDeclaration td)
	{
		var ret = ''
		if (vars !== null)
		{
			ret += vars.map[name].join(', ')
			if (!vars.empty) ret += ' | '
		}
		if (td !== null)
			ret += td.type?.label
		return ret
	}

	/* EXPRESSIONS ******************************************/
	static def dispatch String getLabel(ContractedIf it) { condition?.label + ' ? ' + then?.label + ' : ' + ^else?.label }
	static def dispatch String getLabel(Or it) { getLabel(left, op, right) }
	static def dispatch String getLabel(And it) { getLabel(left, op, right) }
	static def dispatch String getLabel(Equality it) { getLabel(left, op, right) }
	static def dispatch String getLabel(Comparison it) { getLabel(left, op, right) }
	static def dispatch String getLabel(Plus it) { getLabel(left, op, right) }
	static def dispatch String getLabel(Minus it) { getLabel(left, op, right) }
	static def dispatch String getLabel(Mul it) { getLabel(left, op, right) }
	static def dispatch String getLabel(Div it) { getLabel(left, op, right) }
	static def dispatch String getLabel(Modulo it) { getLabel(left, op, right) }
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
	static def dispatch String getLabel(VectorConstant it) { '[' + values.map[label].join(',') + ']' }
	static def dispatch String getLabel(Cardinality it) { 'card(' + container?.label + ')' }
	static def dispatch String getLabel(ArgOrVarRef it)
	{
		var label = target.name
		if (!timeIterators.empty) label += '^{' + timeIterators.map[x | x?.label].join(', ') + '}'
		if (!spaceIterators.empty) label += '{' + spaceIterators.map[x | x?.label].join(',') + '}'
		if (!indices.empty) label += '[' + indices.map[x | x?.label].join(',') + ']'
		return label
	}

	private static def String getLabel(Expression left, String op, Expression right)
	{
		left?.label + ' ' + op + ' ' + right?.label
	}

	/* TYPES *************************************************/
	static def dispatch String getLabel(BaseType it) 
	{ 
		if (sizes.empty) 
			primitive.literal
		else if (sizes.forall[x | x instanceof IntConstant])
			primitive.literal + sizes.map[x | (x as IntConstant).value.utfExponent].join('\u02E3')
		else
			primitive.literal + '[' + sizes.map[label].join(',') + ']'
	}
}