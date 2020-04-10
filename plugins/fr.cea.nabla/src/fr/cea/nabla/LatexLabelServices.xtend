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
import fr.cea.nabla.nabla.Comparison
import fr.cea.nabla.nabla.ContractedIf
import fr.cea.nabla.nabla.CurrentTimeIteratorRef
import fr.cea.nabla.nabla.Div
import fr.cea.nabla.nabla.Equality
import fr.cea.nabla.nabla.Expression
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.FunctionCall
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
import fr.cea.nabla.nabla.Return
import fr.cea.nabla.nabla.SimpleVar
import fr.cea.nabla.nabla.SimpleVarDefinition
import fr.cea.nabla.nabla.SingleConnectivityCall
import fr.cea.nabla.nabla.SingletonDefinition
import fr.cea.nabla.nabla.SpaceIterator
import fr.cea.nabla.nabla.UnaryMinus
import fr.cea.nabla.nabla.VarGroupDeclaration
import fr.cea.nabla.nabla.VectorConstant
import java.util.List
import fr.cea.nabla.nabla.SetRef
import fr.cea.nabla.nabla.SetDefinition
import fr.cea.nabla.nabla.Cardinality

class LatexLabelServices
{
	/* JOBS & INSTRUCTIONS ***********************************/
	static def dispatch String getLatex(Job it) { '\\texttt{' + name.pu + '} : '+ instruction.latex }
	static def dispatch String getLatex(SimpleVarDefinition it) { 'let~' + variable.name.pu + '=' + defaultValue.latex }
	static def dispatch String getLatex(VarGroupDeclaration it) { type.latex + '~' + variables.map[x|x.name.pu].join(', ') }
	static def dispatch String getLatex(InstructionBlock it) { '\\{ \\}' }
	static def dispatch String getLatex(Loop it) { '\\forall{' + iterationBlock.latex + '}, \\ ' + body.latex }
	static def dispatch String getLatex(Affectation it) { left?.latex + ' = ' + right?.latex }
	static def dispatch String getLatex(If it) { 'if~\\left(' + condition.latex + '\\right)'}
	static def dispatch String getLatex(ItemDefinition it) { 'item~' + item.name + '=' + value?.latex }
	static def dispatch String getLatex(SetDefinition it) { 'set~' + name + '=' + value?.latex }
	static def dispatch String getLatex(Return it) { 'return \\left(' + expression.latex + '\\right)'}

	/* ITERATEURS ********************************************/
	static def dispatch String getLatex(SpaceIterator it) { item.name.pu + '\\in ' + container.latex }
	static def dispatch String getLatex(SingletonDefinition it) { item.name + '=' + value?.latex }
	static def dispatch String getLatex(Interval it) { index.name + '\\in ' + nbElems.latex }
	static def dispatch String getLatex(SetRef it) { target.name }
	static def dispatch String getLatex(MultipleConnectivityCall it) { connectivity.name.pu + '(' + args.map[latex].join(',') + ')' }
	static def dispatch String getLatex(SingleConnectivityCall it) { connectivity.name.pu + '(' + args.map[latex].join(',') + ')' }
	static def dispatch String getLatex(ItemRef it) 
	{ 
		if (inc > 0) target.name.pu + '+' + inc
		else if (dec > 0) target.name.pu + '-' + dec
		else target.name.pu
	}

	static def dispatch String getLatex(CurrentTimeIteratorRef it) { target.name.pu }
	static def dispatch String getLatex(InitTimeIteratorRef it) { target.name.pu + '=' + value }
	static def dispatch String getLatex(NextTimeIteratorRef it) { target.name.pu + '+' + value }

	/* FONCTIONS / REDUCTIONS ********************************/
	static def dispatch String getLatex(Function it) { 'def~' + name.pu + '~:~' + vars.latexForVars + inTypes.map[latex].join(' \u00D7 ') + ' \u2192 ' + returnType.latex }
	static def dispatch String getLatex(Reduction it) { 'def~' + name.pu + '~:~' + vars.latexForVars + '(' + seed.latex + ', ' + type.latex + ')' }

	private static def getLatexForVars(List<SimpleVar> symbols)
	{
		if (symbols.empty) ''
		else symbols.map[name].join(', ') + '~|~'
	}

	/* EXPRESSIONS ******************************************/
	static def dispatch String getLatex(ContractedIf it) { condition.latex + ' ? ' + then.latex + ' : ' + ^else.latex }
	static def dispatch String getLatex(Or it) { left.latex + '~or~' + right.latex }
	static def dispatch String getLatex(And it) { left.latex + '~and~' + right.latex }
	static def dispatch String getLatex(Equality it) { left.latex + ' == ' + right.latex }
	static def dispatch String getLatex(Comparison it) { left.latex + ' ' + op + ' ' + right.latex }
	static def dispatch String getLatex(Plus it) { left.latex + ' + ' + right.latex }
	static def dispatch String getLatex(Minus it) { left.latex + ' - ' + right.latex }
	static def dispatch String getLatex(Mul it) { left.latex + ' \\cdot ' + right.latex }
	static def dispatch String getLatex(Div it) { '\\frac{' + left.latex + '}{' + right.latex + '}' }
	static def dispatch String getLatex(Modulo it) { left.latex + ' % ' + right.latex }	
	static def dispatch String getLatex(Parenthesis it) { '(' + expression.latex + ')' }
	static def dispatch String getLatex(UnaryMinus it) { '-' + expression.latex }
	static def dispatch String getLatex(Not it) { '\\neg {' + expression.latex + '}' }
	static def dispatch String getLatex(IntConstant it) { value.toString }
	static def dispatch String getLatex(RealConstant it) { value.toString }
	static def dispatch String getLatex(BoolConstant it) { value.toString }
	static def dispatch String getLatex(MinConstant it) { '-\u221E' }
	static def dispatch String getLatex(MaxConstant it) { '\u221E' }

	static def dispatch String getLatex(FunctionCall it) 
	{ 
		if (function.name == 'norm')
			'\\|' + args.map[latex].join(',') + '\\|'
		else
			function.name.pu + '\\left(' + args.map[latex].join(',') + '\\right)' 
	}

	static def dispatch String getLatex(ReductionCall it) 
	{ 
		switch (reduction.name)
		{
			case '\u2211': { '\\sum_{' + iterationBlock.latex + '}' + arg.latexArg }
			case '\u220F': { '\\prod_{' + iterationBlock.latex + '}' + arg.latexArg }
			default: reduction.name.pu + '_{' + iterationBlock.latex + '}' + arg.latexArg
		}
	}

	static def dispatch String getLatex(BaseTypeConstant it) { type.latex + '\\left(' + value.latex + '\\right)' }
	static def dispatch String getLatex(VectorConstant it) { '\\left[' + values.map[latex].join(',') + '\\right]' }
	static def dispatch String getLatex(Cardinality it) { 'card \\left(' + container.latex + '\\right)' }

	static def dispatch String getLatex(ArgOrVarRef it)
	{
		var label = target.name.pu
		if (!timeIterators.empty) label += '^{' + timeIterators.map[x | x.latex].join(', ') + '}'
		if (!spaceIterators.empty) label += '_{' + spaceIterators.map[x | x.latex].join('') + '}'
		if (!indices.empty) label += '\\left[' + indices.map[x | x.latex].join(',') + '\\right]'
		return label
	}

	/* TYPES *************************************************/
	static def dispatch String getLatex(BaseType it) 
	{ 
		if (sizes.empty)
			primitive.literal
		else
			primitive.literal + '^{' + sizes.map[x | x.latex].join(' \\times ') + '}'
	}

	private static def getLatexArg(Expression it)
	{
		if (it instanceof ReductionCall || it instanceof FunctionCall)
			latex
		else
			'\\left(' + latex + '\\right)'
	}

	// PRESERVE UNDERSCORES
	private static def String pu(String it) { if (!nullOrEmpty) replaceAll('_', '\\\\_') else '' }
}