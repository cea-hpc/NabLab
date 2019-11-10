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
import fr.cea.nabla.nabla.Array1D
import fr.cea.nabla.nabla.Array2D
import fr.cea.nabla.nabla.BaseTypeConstant
import fr.cea.nabla.nabla.BoolConstant
import fr.cea.nabla.nabla.Comparison
import fr.cea.nabla.nabla.ConnectivityCall
import fr.cea.nabla.nabla.ContractedIf
import fr.cea.nabla.nabla.DimensionIndex
import fr.cea.nabla.nabla.DimensionInt
import fr.cea.nabla.nabla.DimensionIterationBlock
import fr.cea.nabla.nabla.DimensionOperation
import fr.cea.nabla.nabla.DimensionSymbolReference
import fr.cea.nabla.nabla.DimensionVar
import fr.cea.nabla.nabla.Equality
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.If
import fr.cea.nabla.nabla.InitTimeIterator
import fr.cea.nabla.nabla.InstructionBlock
import fr.cea.nabla.nabla.IntConstant
import fr.cea.nabla.nabla.IntMatrixConstant
import fr.cea.nabla.nabla.IntVectorConstant
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
import fr.cea.nabla.nabla.RealConstant
import fr.cea.nabla.nabla.RealMatrixConstant
import fr.cea.nabla.nabla.RealVectorConstant
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.Return
import fr.cea.nabla.nabla.Scalar
import fr.cea.nabla.nabla.SimpleVarDefinition
import fr.cea.nabla.nabla.SingletonSpaceIterator
import fr.cea.nabla.nabla.SpaceIterationBlock
import fr.cea.nabla.nabla.SpaceIteratorRef
import fr.cea.nabla.nabla.UnaryMinus
import fr.cea.nabla.nabla.VarGroupDeclaration
import fr.cea.nabla.nabla.VarRef

import static extension fr.cea.nabla.ir.Utils.*

class LabelServices
{
	// JOBS
	static def dispatch String getLabel(Job it) { name + ' : ' + instruction?.label }

	// INSTRUCTIONS	
	static def dispatch String getLabel(SimpleVarDefinition it) { type?.label + ' ' + variable.name + '=' + defaultValue?.label }
	static def dispatch String getLabel(VarGroupDeclaration it) { type?.label + ' ' + variables.map[x|x.name].join(', ') }
	static def dispatch String getLabel(InstructionBlock it) { '...' }
	static def dispatch String getLabel(Loop it) { '\u2200 ' + iterationBlock?.label + ', ' + body?.label }
	static def dispatch String getLabel(Affectation it) { varRef?.label + ' = ' + expression?.label }
	static def dispatch String getLabel(If it) { 'if ' + condition?.label }
	static def dispatch String getLabel(Return it) { 'return ' + expression?.label }

	// ITERATEURS
	static def dispatch String getLabel(SpaceIterationBlock it) { range?.label }
	static def dispatch String getLabel(DimensionIterationBlock it) { index?.label }

	static def dispatch String getLabel(RangeSpaceIterator it) { name + '\u2208 ' + container?.label }
	static def dispatch String getLabel(SingletonSpaceIterator it) { name + '=' + container?.label }
	static def dispatch String getLabel(ConnectivityCall it) { connectivity.name + '(' + args.map[label].join(',') + ')' }
	static def dispatch String getLabel(SpaceIteratorRef it) 
	{ 
		if (inc > 0) target?.name + '+' + inc
		else if (dec > 0) target?.name + dec
		else target?.name
	}

	static def dispatch String getLabel(InitTimeIterator it) { 'n=0' }
	static def dispatch String getLabel(NextTimeIterator it) {  if (hasDiv) 'n+1/' + div else 'n+1' }

	// FUNCTIONS AND REDUCTIONS ARGS AND INDEX
	static def dispatch String getLabel(DimensionIndex it) { name + '\u2208 [' + from + ';' + to + (if (lte) ']' else'[') }
	static def dispatch String getLabel(DimensionVar it) { name }
	static def dispatch String getLabel(DimensionOperation it) { left?.label + ' ' + op + ' ' + right?.label }
	static def dispatch String getLabel(DimensionInt it) { value.toString }
	static def dispatch String getLabel(DimensionSymbolReference it) { target?.name }
	
	// EXPRESSIONS
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
	static def dispatch String getLabel(VarRef it)
	{
		var label = variable.name
		if (timeIterator !== null) label += '^{' + timeIterator?.label + '}'
		if (!spaceIterators.empty) label += '{' + spaceIterators.map[x | x?.label].join(',') + '}'
		if (!indices.empty) label += '[' + indices.map[x | x?.label].join(',') + ']'
		return label
	}

	static def dispatch String getLabel(IntVectorConstant it) { '[' + values.join(',') + ']' }
	static def dispatch String getLabel(IntMatrixConstant it) { '[' + values.map[label].join(',') + ']' }
	static def dispatch String getLabel(RealVectorConstant it) { '[' + values.join(',') + ']' }
	static def dispatch String getLabel(RealMatrixConstant it) { '[' + values.map[label].join(',') + ']' }
	static def dispatch String getLabel(BaseTypeConstant it) { type?.label + '(' + value?.label + ')' }

	static def dispatch getLabel(Scalar it) { primitive.literal }
	static def dispatch getLabel(Array1D it) { primitive.literal + size.utfExponent }
	static def dispatch getLabel(Array2D it) { primitive.literal + nbRows.utfExponent + '\u02E3' + nbCols.utfExponent }
}