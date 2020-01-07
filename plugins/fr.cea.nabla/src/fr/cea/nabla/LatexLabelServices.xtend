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
import fr.cea.nabla.nabla.CurrentTimeIteratorRef
import fr.cea.nabla.nabla.Equality
import fr.cea.nabla.nabla.Expression
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.If
import fr.cea.nabla.nabla.InitTimeIteratorRef
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
import fr.cea.nabla.nabla.NextTimeIteratorRef
import fr.cea.nabla.nabla.Not
import fr.cea.nabla.nabla.Or
import fr.cea.nabla.nabla.Parenthesis
import fr.cea.nabla.nabla.Plus
import fr.cea.nabla.nabla.RangeSpaceIterator
import fr.cea.nabla.nabla.RealConstant
import fr.cea.nabla.nabla.Reduction
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
import fr.cea.nabla.nabla.UnaryMinus
import fr.cea.nabla.nabla.VarGroupDeclaration
import fr.cea.nabla.nabla.VectorConstant
import java.util.List

class LatexLabelServices
{
	/* JOBS & INSTRUCTIONS ***********************************/
	static def dispatch String getLatex(Job it) { '\\texttt{' + name.pu + '} : '+ instruction.latex }
	static def dispatch String getLatex(SimpleVarDefinition it) { type.latex + '~' + variable.name.pu + '=' + defaultValue.latex }
	static def dispatch String getLatex(VarGroupDeclaration it) { type.latex + '~' + variables.map[x|x.name.pu].join(', ') }
	static def dispatch String getLatex(InstructionBlock it) { '\\{ \\}' }
	static def dispatch String getLatex(Loop it) { '\\forall{' + iterationBlock.latex + '}, \\ ' + body.latex }
	static def dispatch String getLatex(Affectation it) { left?.latex + ' = ' + right?.latex }
	static def dispatch String getLatex(If it) { 'if~(' + condition.latex + ')'}
	static def dispatch String getLatex(Return it) { 'return (' + expression.latex + ')'}

	/* ITERATEURS ********************************************/
	static def dispatch String getLatex(SpaceIterationBlock it) { range.latex }
	static def dispatch String getLatex(IntervalIterationBlock it) { index.latex + '\\in [' + from.latex + ';' + to.latex + (if (toIncluded) ']' else'[') }

	static def dispatch String getLatex(RangeSpaceIterator it) { name.pu + '\\in ' + container.latex }
	static def dispatch String getLatex(SingletonSpaceIterator it) { name.pu + '=' + container.latex }
	static def dispatch String getLatex(ConnectivityCall it) { connectivity.name.pu + '(' + args.map[latex].join(',') + ')' }
	static def dispatch String getLatex(SpaceIteratorRef it) 
	{ 
		if (inc > 0) target.name.pu + '+' + inc
		else if (dec > 0) target.name.pu + dec
		else target.name.pu
	}

	static def dispatch String getLatex(CurrentTimeIteratorRef it) { target.name.pu }
	static def dispatch String getLatex(InitTimeIteratorRef it) { target.name.pu + '=' + value }
	static def dispatch String getLatex(NextTimeIteratorRef it) { target.name.pu + '+' + value }

	/* FONCTIONS / REDUCTIONS ********************************/
	static def dispatch String getLatex(Function it) { 'def~' + name.pu + '~:~' + vars.latexForVars + inTypes.map[latex].join(' \u00D7 ') + ' \u2192 ' + returnType.latex }
	static def dispatch String getLatex(Reduction it) { 'def~' + name.pu + '~:~' + vars.latexForVars + '(' + seed.latex + ', ' + collectionType.latex + ') \u2192 ' + returnType.latex }
	private static def getLatexForVars(List<SizeTypeSymbol> symbols)
	{
		if (symbols.empty) ''
		else symbols.map[latex].join(', ') + '~|~'
	}

	/* EXPRESSIONS ******************************************/
	static def dispatch String getLatex(ContractedIf it) { condition.latex + ' ? ' + then.latex + ' : ' + ^else.latex }
	static def dispatch String getLatex(Or it) { left.latex + '~or~' + right.latex }
	static def dispatch String getLatex(And it) { left.latex + '~and~' + right.latex }
	static def dispatch String getLatex(Equality it) { left.latex + ' == ' + right.latex }
	static def dispatch String getLatex(Comparison it) { left.latex + ' ' + op + ' ' + right.latex }
	static def dispatch String getLatex(Plus it) { left.latex + ' + ' + right.latex }
	static def dispatch String getLatex(Minus it) { left.latex + ' - ' + right.latex }
	static def dispatch String getLatex(MulOrDiv it) 
	{ 
		if (op == '/')  '\\frac{' + left.latex + '}{' + right.latex + '}'
		else left.latex + ' \\cdot ' + right.latex
	}
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

	static def dispatch String getLatex(BaseTypeConstant it) { type.latex + '(' + value.latex + ')' }
	static def dispatch String getLatex(VectorConstant it) { '[' + values.map[latex].join(',') + ']' }

	static def dispatch String getLatex(ArgOrVarRef it)
	{
		var label = target.name.pu
		if (!timeIterators.empty) label += '^{' + timeIterators.map[x | x.latex].join(', ') + '}'
		if (!spaceIterators.empty) label += '_{' + spaceIterators.map[x | x.latex].join('') + '}'
		if (!indices.empty) label += '[' + indices.map[x | x.latex].join(',') + ']'
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

	static def dispatch String getLatex(SizeTypeOperation it) { left?.latex + ' ' + op + ' ' + right?.latex }
	static def dispatch String getLatex(SizeTypeInt it) { value.toString }
	static def dispatch String getLatex(SizeTypeSymbolRef it) { target?.name.pu }
	static def dispatch String getLatex(SizeTypeSymbol it) { name.pu }

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