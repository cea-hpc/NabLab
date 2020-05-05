/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir

import fr.cea.nabla.ir.ir.ArgOrVarRef
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.BaseTypeConstant
import fr.cea.nabla.ir.ir.BinaryExpression
import fr.cea.nabla.ir.ir.BoolConstant
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.ContractedIf
import fr.cea.nabla.ir.ir.FunctionCall
import fr.cea.nabla.ir.ir.IntConstant
import fr.cea.nabla.ir.ir.IrType
import fr.cea.nabla.ir.ir.MaxConstant
import fr.cea.nabla.ir.ir.MinConstant
import fr.cea.nabla.ir.ir.Parenthesis
import fr.cea.nabla.ir.ir.RealConstant
import fr.cea.nabla.ir.ir.UnaryExpression
import fr.cea.nabla.ir.ir.VectorConstant

import static extension fr.cea.nabla.ir.Utils.*

class IrTypeExtensions
{
	static def dispatch boolean hasDynamicDimension(ConnectivityType it) { base.hasDynamicDimension }
	static def dispatch boolean hasDynamicDimension(BaseType it) { false /*sizes.empty || sizes.forall[x | x instanceof IntConstant]*/ }

	static def dispatch String getLabel(ConnectivityType it)
	{
		if (it === null) null
		else base.label + '{' + connectivities.map[name].join(',') + '}'
	}

	static def dispatch String getLabel(BaseType it)
	{
		if (it === null)
			'Undefined'
		else if (sizes.empty) 
			primitive.literal
		else if (sizes.forall[x | x instanceof IntConstant])
			primitive.literal + sizes.map[x | (x as IntConstant).value.utfExponent].join('\u02E3')
		else
			primitive.literal + '[' + sizes.map[expressionLabel].join(',') + ']'
	}

	static def dispatch int getDimension(BaseType it) { sizes.size }
	static def dispatch int getDimension(ConnectivityType it) { base.sizes.size + connectivities.size }

	static def isScalar(IrType t)
	{
		(t instanceof BaseType) && (t as BaseType).sizes.empty
	}

	static def getPrimitive(IrType t)
	{
		switch t
		{
			ConnectivityType: t.base.primitive
			BaseType: t.primitive
		}
	}

	private static def dispatch String getExpressionLabel(ContractedIf it) { condition?.expressionLabel + ' ? ' + thenExpression?.expressionLabel + ' : ' + elseExpression?.expressionLabel }
	private static def dispatch String getExpressionLabel(BinaryExpression it) { left?.expressionLabel + ' ' + operator + ' ' + right?.expressionLabel }
	private static def dispatch String getExpressionLabel(UnaryExpression it) { operator + expression?.expressionLabel }
	private static def dispatch String getExpressionLabel(Parenthesis it) { '(' + expression?.expressionLabel + ')' }
	private static def dispatch String getExpressionLabel(IntConstant it) { value.toString }
	private static def dispatch String getExpressionLabel(RealConstant it) { value.toString }
	private static def dispatch String getExpressionLabel(BoolConstant it) { value.toString }
	private static def dispatch String getExpressionLabel(MinConstant it) { '-\u221E' }
	private static def dispatch String getExpressionLabel(MaxConstant it) { '-\u221E' }
	private static def dispatch String getExpressionLabel(BaseTypeConstant it) { type?.label + '(' + value?.expressionLabel + ')' }
	private static def dispatch String getExpressionLabel(VectorConstant it) { '[' + values.map[expressionLabel].join(',') + ']' }
	private static def dispatch String getExpressionLabel(FunctionCall it) { function.name + '(' + args.map[expressionLabel].join(',') + ')' }
	private static def dispatch String getExpressionLabel(ArgOrVarRef it)
	{
		var label = target.name
		if (!iterators.empty) label += '{' + iterators.map[x | x?.name].join(',') + '}'
		if (!indices.empty) label += '[' + indices.map[x | x?.expressionLabel].join(',') + ']'
		return label
	}
}