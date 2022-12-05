/*******************************************************************************
 * Copyright (c) 2022 CEA
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
import fr.cea.nabla.nabla.ConnectivityCall
import fr.cea.nabla.nabla.ContractedIf
import fr.cea.nabla.nabla.CurrentTimeIteratorRef
import fr.cea.nabla.nabla.Div
import fr.cea.nabla.nabla.Equality
import fr.cea.nabla.nabla.Exit
import fr.cea.nabla.nabla.Expression
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.FunctionInTypeDeclaration
import fr.cea.nabla.nabla.FunctionReturnTypeDeclaration
import fr.cea.nabla.nabla.If
import fr.cea.nabla.nabla.InitTimeIteratorRef
import fr.cea.nabla.nabla.Instruction
import fr.cea.nabla.nabla.InstructionBlock
import fr.cea.nabla.nabla.IntConstant
import fr.cea.nabla.nabla.Interval
import fr.cea.nabla.nabla.ItemSet
import fr.cea.nabla.nabla.ItemSetRef
import fr.cea.nabla.nabla.Job
import fr.cea.nabla.nabla.Loop
import fr.cea.nabla.nabla.MaxConstant
import fr.cea.nabla.nabla.MinConstant
import fr.cea.nabla.nabla.Minus
import fr.cea.nabla.nabla.Modulo
import fr.cea.nabla.nabla.Mul
import fr.cea.nabla.nabla.NextTimeIteratorRef
import fr.cea.nabla.nabla.Not
import fr.cea.nabla.nabla.Or
import fr.cea.nabla.nabla.Parenthesis
import fr.cea.nabla.nabla.Plus
import fr.cea.nabla.nabla.PrimitiveType
import fr.cea.nabla.nabla.RealConstant
import fr.cea.nabla.nabla.Reduction
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.ReductionTypeDeclaration
import fr.cea.nabla.nabla.Return
import fr.cea.nabla.nabla.SimpleVar
import fr.cea.nabla.nabla.SimpleVarDeclaration
import fr.cea.nabla.nabla.SpaceIterator
import fr.cea.nabla.nabla.SpaceIteratorRef
import fr.cea.nabla.nabla.UnaryMinus
import fr.cea.nabla.nabla.VarGroupDeclaration
import fr.cea.nabla.nabla.VectorConstant
import java.util.List
import org.eclipse.emf.ecore.EObject

class LatexLabelServices
{
	static val String[] GreekLetters = #['Alpha', 'Beta', 'Gamma', 'Delta', 'Epsilon', 'Zeta', 'Eta', 'Theta',
		'Iota', 'Kappa', 'Lambda', 'Mu', 'Nu', 'Xi', 'Omicron', 'Pi', 'Rho', 'Sigma', 'Tau', 'Upsilon', 'Phi', 'Chi',
		'Psi', 'Omega', 'alpha', 'beta', 'gamma', 'delta', 'epsilon', 'zeta', 'eta', 'theta', 'iota', 'kappa', 'lambda',
		'mu', 'nu', 'xi', 'omicron', 'pi', 'rho', 'sigma', 'tau', 'upsilon', 'phi', 'chi', 'psi', 'omega']

	/* JOBS & INSTRUCTIONS ***********************************/
	static def dispatch String getLatex(Job it) { '\\texttt{' + name.transformString + '} : '+ instruction?.latex }
	static def dispatch String getLatex(SimpleVarDeclaration it) { if (value === null) variable?.name.transformString else variable?.name.transformString + '=' + value.latex }
	static def dispatch String getLatex(VarGroupDeclaration it) { type.latex + '~' + variables.map[x|x.name.transformString].join(', ') }
	static def dispatch String getLatex(InstructionBlock it) { '\\{ ... \\}' }
	static def dispatch String getLatex(Loop it) { '\\forall{' + iterationBlock?.latex + '}, \\ ' + body.latex }
	static def dispatch String getLatex(Affectation it) { left?.latex + ' = ' + right?.latex }
	static def dispatch String getLatex(If it)
	{
		var txt = 'if~\\left(' + condition?.latex + '\\right)~' + then?.latex
		if (^else !== null) txt += '~else~' + ^else.latex
		return txt
	}
	static def dispatch String getLatex(ItemSet it) { 'set~' + name + '=' + value?.latex }
	static def dispatch String getLatex(Return it) { 'return~' + expression?.latex }
	static def dispatch String getLatex(Exit it) { 'exit~' + message }

	/* ITERATEURS ********************************************/
	static def dispatch String getLatex(SpaceIterator it) { name.transformString + '\\in ' + container?.latex }
	static def dispatch String getLatex(Interval it) { index?.name + '\\in ' + nbElems.latex }
	static def dispatch String getLatex(ItemSetRef it) { target?.name }
	static def dispatch String getLatex(ConnectivityCall it)
	{
		if (group === null)
			if (args.empty)
				connectivity?.name.transformString
			else
				connectivity?.name.transformString + '(' + args.map[latex].join(',') + ')'
		else
			group.pu
	}
	static def dispatch String getLatex(SpaceIteratorRef it) 
	{ 
		if (inc > 0) target.name.transformString + '+' + inc
		else if (dec > 0) target.name.transformString + '-' + dec
		else target.name.transformString
	}

	static def dispatch String getLatex(CurrentTimeIteratorRef it) { target?.name.transformString }
	static def dispatch String getLatex(InitTimeIteratorRef it) { target?.name.transformString + '=' + value }
	static def dispatch String getLatex(NextTimeIteratorRef it) { target?.name.transformString + '+' + value }

	/* FONCTIONS / REDUCTIONS ********************************/
	static def dispatch String getLatex(Function it) { 'def~ ' + name.transformString + '~:~' + getLatex(variables, it.intypesDeclaration, it.returnTypeDeclaration) }
	static def dispatch String getLatex(Reduction it) { 'red~ ' + name.transformString + ',~' + seed?.latex + '~:~' + getLatex(variables, typeDeclaration) }

	private static def String getLatex(List<SimpleVar> vars, List<FunctionInTypeDeclaration> itd, FunctionReturnTypeDeclaration rtd)
	{
		var ret = ''
		if (vars !== null)
		{
			ret += vars.map[name.transformString].join(', ')
			if (!vars.empty) ret += '~|~'
		}
		if (itd !== null && itd.size > 0)
		{
			ret += itd.map[inTypes.latex].join(' \\times ')
		}
		if (rtd !== null)
		{
			ret += ' \\rightarrow ' + rtd.returnType?.latex
		}
		return ret
	}

	private static def String getLatex(List<SimpleVar> vars, ReductionTypeDeclaration td)
	{
		var ret = ''
		if (vars !== null)
		{
			ret += vars.map[name.transformString].join(', ')
			if (!vars.empty) ret += '~|~'
		}
		if (td !== null)
			ret += td.type?.latex
		return ret
	}

	/* EXPRESSIONS ******************************************/
	static def dispatch String getLatex(ContractedIf it) { condition.latex + ' ? ' + then?.latex + ' : ' + ^else?.latex }
	static def dispatch String getLatex(Or it) { left.latex + '~or~' + right.latex }
	static def dispatch String getLatex(And it) { left.latex + '~and~' + right.latex }
	static def dispatch String getLatex(Equality it) { left.latex + ' == ' + right.latex }
	static def dispatch String getLatex(Comparison it) { left.latex + ' ' + op + ' ' + right.latex }
	static def dispatch String getLatex(Plus it) { left.latex + ' + ' + right.latex }
	static def dispatch String getLatex(Minus it) { left.latex + ' - ' + right.latex }
	static def dispatch String getLatex(Mul it) { left.latex + ' \\cdot ' + right.latex }
	static def dispatch String getLatex(Div it) { '\\frac{' + left.latex + '}{' + right.latex + '}' }
	static def dispatch String getLatex(Modulo it) { left.latex + ' % ' + right.latex }	
	static def dispatch String getLatex(Parenthesis it) { '\\left(' + expression.latex + '\\right)' }
	static def dispatch String getLatex(UnaryMinus it) { '-' + expression.latex }
	static def dispatch String getLatex(Not it) { '\\neg {' + expression.latex + '}' }
	static def dispatch String getLatex(IntConstant it) { value.toString }
	static def dispatch String getLatex(RealConstant it) { value.toString }
	static def dispatch String getLatex(BoolConstant it) { value.toString }
	static def dispatch String getLatex(MinConstant it) { '-\\infty' }
	static def dispatch String getLatex(MaxConstant it) { '\\infty' }

	static def dispatch String getLatex(FunctionCall it) 
	{ 
		switch (function.name)
		{
			case 'norm': { '\\|' + args.map[latex].join(',') + '\\|' }
			case 'sqrt': { '\\sqrt{' + args.map[latex].join(',') + '}' }
			default: function.name.transformString + '\\left(' + args.map[latex].join(',') + '\\right)'
		}
	}

	static def dispatch String getLatex(ReductionCall it) 
	{ 
		switch (reduction.name)
		{
			case 'sum': { '\\sum_{' + iterationBlock.latex + '}' + arg.latexArg }
			case 'prod': { '\\prod_{' + iterationBlock.latex + '}' + arg.latexArg }
			default: reduction.name.transformString + '_{' + iterationBlock.latex + '}' + arg.latexArg
		}
	}

	static def dispatch String getLatex(BaseTypeConstant it) { type.latex + '\\left(' + value.latex + '\\right)' }
	static def dispatch String getLatex(VectorConstant it) { '\\left[' + values.map[latex].join(',') + '\\right]' }
	static def dispatch String getLatex(Cardinality it) { 'card \\left(' + container.latex + '\\right)' }

	static def dispatch String getLatex(ArgOrVarRef it)
	{
		var label = target.name.transformString
		if (!timeIterators.empty) label += '^{' + timeIterators.map[x | x.latex].join(', ') + '}'
		if (!spaceIterators.empty) label += '_{' + spaceIterators.map[x | x.latex].join('') + '}'
		if (!indices.empty) label += '\\left[' + indices.map[x | x.latex].join(',') + '\\right]'
		return label
	}

	/* TYPES *************************************************/
	static def dispatch String getLatex(PrimitiveType it)
	{
		switch it
		{ 
			case REAL : '\u211D'
			case INT : '\u2115'
			case BOOL : '\u213E'
		} 
	}
	
	static def dispatch String getLatex(BaseType it) 
	{ 
		var primUnicode = getLatex(primitive)
		if (sizes.empty)
			primUnicode
		else
			primUnicode + '^{' + sizes.map[x | x.latex].join(' \\times ') + '}'
	}

	private static def getLatexArg(Expression it)
	{
		if (it instanceof ReductionCall || it instanceof FunctionCall)
			latex
		else
			'\\left(' + latex + '\\right)'
	}

	private static def String transformString(String it)
	{
		var ret = if (!nullOrEmpty) it.convertToUnicode.pu else ''
		return ret
	}

	// PRESERVE UNDERSCORES
	private static def String pu(String it)
	{
		it.replaceAll('_', '\\\\_')
	}

	private static def String convertToUnicode(String it)
	{
		var String[] splitIt = it.split("((?<=_)|(?>=_))")
		var List<String> splitRet = newArrayList
		val ite = splitIt.iterator
		while(ite.hasNext)
		{
			val subString = ite.next
			if (GreekLetters.contains(substring(0, subString.length()-1)) && subString.substring(subString.length() -1) == '_' && ite.hasNext)
				splitRet.add('\\'+ subString.substring(0, subString.length()-1) + ' ')
			else if(GreekLetters.contains(subString))
				splitRet.add('\\'+ subString)
			else
				splitRet.add(subString)
		}
		return splitRet.join
	}

	/** Return the highest displayable object, Job, Instruction or Expression */
	static def EObject getClosestDisplayableNablaElt(EObject elt)
	{
		switch elt
		{
			case null: null
			Job: elt
			Function: elt
			Reduction: elt
			InstructionBlock: null
			Instruction:
				if (elt.eContainer === null)
					null
				else 
					elt.eContainer.closestDisplayableNablaElt ?: elt
			Expression:
				if (elt.eContainer === null)
					null
				else 
					elt.eContainer.closestDisplayableNablaElt ?: elt
			default:
				if (elt.eContainer === null)
					null 
				else 
					elt.eContainer.closestDisplayableNablaElt
		}
	}
}