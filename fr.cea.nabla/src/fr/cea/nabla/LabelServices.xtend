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
import fr.cea.nabla.nabla.BoolConstant
import fr.cea.nabla.nabla.Comparison
import fr.cea.nabla.nabla.ContractedIf
import fr.cea.nabla.nabla.Equality
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.If
import fr.cea.nabla.nabla.InstructionBlock
import fr.cea.nabla.nabla.IntConstant
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
import fr.cea.nabla.nabla.Real2Constant
import fr.cea.nabla.nabla.Real2x2Constant
import fr.cea.nabla.nabla.Real3Constant
import fr.cea.nabla.nabla.Real3x3Constant
import fr.cea.nabla.nabla.RealConstant
import fr.cea.nabla.nabla.RealXCompactConstant
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.ScalarVarDefinition
import fr.cea.nabla.nabla.SpaceIterator
import fr.cea.nabla.nabla.SpaceIteratorRange
import fr.cea.nabla.nabla.SpaceIteratorRef
import fr.cea.nabla.nabla.UnaryMinus
import fr.cea.nabla.nabla.VarGroupDeclaration
import fr.cea.nabla.nabla.VarRef

class LabelServices 
{
	// JOBS
	static def dispatch String getLabel(Job it) { name + ' : ' + instruction.label }
	
	// INSTRUCTIONS	
	static def dispatch String getLabel(ScalarVarDefinition it) { type.literal + ' ' + variable.name + '=' + defaultValue.label }
	static def dispatch String getLabel(VarGroupDeclaration it) { type.literal + ' ' + variables.map[x|x.name].join(', ') }
	static def dispatch String getLabel(InstructionBlock it) { '...' }
	static def dispatch String getLabel(Affectation it) { varRef?.label + ' = ' + expression?.label }
	static def dispatch String getLabel(Loop it) { '\u2200' + iterator.label + ', ' + body.label }
	static def dispatch String getLabel(If it) { 'if ' + condition.label }

	// ITERATEURS
	static def dispatch String getLabel(SpaceIterator it) { name + '\u2208 ' + range.label }
	static def dispatch String getLabel(SpaceIteratorRange it) { connectivity.name + '(' + args.map[label].join(',') + ')' }
	static def dispatch String getLabel(SpaceIteratorRef it) 
	{ 
		if (next) iterator.name + '+1'
		else if (prev) iterator.name + '-1'
		else iterator.name
	}

	// EXPRESSIONS
	static def dispatch String getLabel(ContractedIf it) { condition.label + ' ? ' + then.label + ' : ' + ^else.label }
	static def dispatch String getLabel(Or it) { left.label + ' || ' + right.label }
	static def dispatch String getLabel(And it) { left.label + ' && ' + right.label }
	static def dispatch String getLabel(Equality it) { left.label + ' == ' + right.label }
	static def dispatch String getLabel(Comparison it) { left.label + ' ' + op + ' ' + right.label }
	static def dispatch String getLabel(Plus it) { left.label + ' + ' + right.label }
	static def dispatch String getLabel(Minus it) { left.label + ' - ' + right.label }
	static def dispatch String getLabel(MulOrDiv it) { left.label + ' ' + op + ' ' + right.label }
	static def dispatch String getLabel(Modulo it) { left.label + ' ' + op + ' ' + right.label }
	static def dispatch String getLabel(Parenthesis it) { '(' + expression.label + ')' }
	static def dispatch String getLabel(UnaryMinus it) { '-' + expression.label }
	static def dispatch String getLabel(Not it) { '!' + expression.label }
	static def dispatch String getLabel(IntConstant it) { value.toString }
	static def dispatch String getLabel(RealConstant it) { value.toString }
	static def dispatch String getLabel(Real2Constant it) { '{' + x + ',' + y + '}' }	
	static def dispatch String getLabel(Real3Constant it) { '{' + x + ',' + y + ',' + z + '}' }	
	static def dispatch String getLabel(Real2x2Constant it) { '{' + x.label + ',' + y.label + '}' }	
	static def dispatch String getLabel(Real3x3Constant it) { '{' + x.label + ',' + y.label + ',' + z.label + '}' }	
	static def dispatch String getLabel(BoolConstant it) { value.toString }
	static def dispatch String getLabel(RealXCompactConstant it) { type.literal + '(' + value + ')' }
	static def dispatch String getLabel(MinConstant it) { '-\u221E' }
	static def dispatch String getLabel(MaxConstant it) { '-\u221E' }
	static def dispatch String getLabel(FunctionCall it) { function.name + '(' + args.map[label].join(',') + ')' }
	static def dispatch String getLabel(ReductionCall it) { reduction.name + '{' + iterator.label + '}(' + arg.label + ')' }
	static def dispatch String getLabel(VarRef it)
	{
		var label = variable.name
		if (!spaceIterators.empty) label += '{' + spaceIterators.map[x | x.label].join(',') + '}'
		if (hasTimeIterator) label += '^{n+1' + timeIteratorDiv.timeIteratorDivLabel + '}'
		for (f : fields) label += '.' + f
		return label
	}

	private static def String getTimeIteratorDivLabel(int timeIteratorDiv) 
	{ 
		if (timeIteratorDiv == 0) ''
		else '/' + timeIteratorDiv
	}	
}