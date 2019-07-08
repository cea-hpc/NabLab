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
package fr.cea.nabla

import fr.cea.nabla.nabla.Affectation
import fr.cea.nabla.nabla.And
import fr.cea.nabla.nabla.BaseType
import fr.cea.nabla.nabla.BoolConstant
import fr.cea.nabla.nabla.Comparison
import fr.cea.nabla.nabla.ConnectivityCall
import fr.cea.nabla.nabla.ContractedIf
import fr.cea.nabla.nabla.Equality
import fr.cea.nabla.nabla.Expression
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.If
import fr.cea.nabla.nabla.InitTimeIterator
import fr.cea.nabla.nabla.InstructionBlock
import fr.cea.nabla.nabla.IntConstant
import fr.cea.nabla.nabla.Job
import fr.cea.nabla.nabla.Loop
import fr.cea.nabla.nabla.MaxConstant
import fr.cea.nabla.nabla.MinConstant
import fr.cea.nabla.nabla.Minus
import fr.cea.nabla.nabla.Modulo
import fr.cea.nabla.nabla.MulOrDiv
import fr.cea.nabla.nabla.NextTimeIterator
import fr.cea.nabla.nabla.Not
import fr.cea.nabla.nabla.Or
import fr.cea.nabla.nabla.Parenthesis
import fr.cea.nabla.nabla.Plus
import fr.cea.nabla.nabla.RangeSpaceIterator
import fr.cea.nabla.nabla.RealBaseTypeConstant
import fr.cea.nabla.nabla.RealConstant
import fr.cea.nabla.nabla.RealVectorConstant
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.ScalarVarDefinition
import fr.cea.nabla.nabla.SingletonSpaceIterator
import fr.cea.nabla.nabla.SpaceIteratorRef
import fr.cea.nabla.nabla.UnaryMinus
import fr.cea.nabla.nabla.VarGroupDeclaration
import fr.cea.nabla.nabla.VarRef

class LatexLabelServices 
{
	// JOBS
	static def dispatch String getLatex(Job it) { '\\texttt{' + name.pu + '} : '+ instruction.latex }
	
	// INSTRUCTIONS	
	static def dispatch String getLatex(ScalarVarDefinition it) { type.latex + ' ' + variable.name.pu + '=' + defaultValue.latex }
	static def dispatch String getLatex(VarGroupDeclaration it) { type.latex + ' ' + variables.map[x|x.name.pu].join(', ') }
	static def dispatch String getLatex(InstructionBlock it) { '...' }
	static def dispatch String getLatex(Affectation it) { varRef?.latex + ' = ' + expression?.latex }
	static def dispatch String getLatex(Loop it) { '\\forall {' + range.latex + '}, \\ ' + body.latex }
	static def dispatch String getLatex(If it) { 'if (' + condition.latex + ')'}
	
	// ITERATEURS
	static def dispatch String getLatex(RangeSpaceIterator it) { name.pu + '\\in ' + container.latex }
	static def dispatch String getLatex(SingletonSpaceIterator it) { name.pu + '=' + container.latex }
	static def dispatch String getLatex(ConnectivityCall it) { connectivity.name.pu + '(' + args.map[latex].join(',') + ')' }
	static def dispatch String getLatex(SpaceIteratorRef it) 
	{ 
		if (inc > 0) target.name.pu + '+' + inc
		else if (dec > 0) target.name.pu + dec
		else target.name.pu
	}

	// EXPRESSIONS
	static def dispatch String getLatex(ContractedIf it) { condition.latex + ' ? ' + then.latex + ' : ' + ^else.latex }
	static def dispatch String getLatex(Or it) { left.latex + ' or ' + right.latex }
	static def dispatch String getLatex(And it) { left.latex + ' and ' + right.latex }
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
	static def dispatch String getLatex(RealVectorConstant it) { '{' + values.join(',') + '}' }
	static def dispatch String getLatex(RealBaseTypeConstant it) { type.latex + '(' + value + ')' }
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
			case '\u2211': { '\\sum_{' + range.latex + '}' + arg.latexArg }
			case '\u220F': { '\\prod_{' + range.latex + '}' + arg.latexArg }
			default: reduction.name.pu + '_{' + range.latex + '}' + arg.latexArg
		}
	}
	
	private static def getLatexArg(Expression it)
	{
		if (it instanceof ReductionCall || it instanceof FunctionCall)
			latex
		else
			'\\left(' + latex + '\\right)'		
	}
	
	static def dispatch String getLatex(VarRef it)
	{
		var label = variable.name.pu
		if (timeIterator === null) label += '^{n}'
		else label += '^{' + timeIterator.timeIteratorLabel + '}'
		if (!spaceIterators.empty) label += '_{' + spaceIterators.map[x | x.latex].join('') + '}'
		if (!indices.empty) label += '[' + indices.join(',') + ']'
		return label
	}

	
	static def dispatch getLatex(BaseType it)
	{
		if (sizes.empty) root.literal 
		else root.literal + '^{' + sizes.map[toString].join('x') + '}'
	}

	private static def dispatch getTimeIteratorLabel(InitTimeIterator it) '''n=0''' 
	private static def dispatch getTimeIteratorLabel(NextTimeIterator it) '''n+1«IF hasDiv»/«div»«ENDIF»''' 

	// PRESERVE UNDERSCORES
	private static def String pu(String it) { if (!nullOrEmpty) replaceAll('_', '\\\\_') else '' }
}