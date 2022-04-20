/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.hover

import fr.cea.nabla.LabelServices
import fr.cea.nabla.nabla.ArgOrVar
import fr.cea.nabla.nabla.BaseType
import fr.cea.nabla.nabla.Expression
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.Instruction
import fr.cea.nabla.nabla.Job
import fr.cea.nabla.nabla.NablaRoot
import fr.cea.nabla.typing.ArgOrVarTypeProvider
import fr.cea.nabla.typing.BaseTypeTypeProvider
import fr.cea.nabla.typing.ExpressionTypeProvider
import org.eclipse.emf.ecore.EObject
import com.google.inject.Inject

/**
 * Helper class used to gather common methods for implementing hover services in both RCP and LSP implementation
 */
class HoverHelper
{

	@Inject extension ExpressionTypeProvider
	@Inject extension ArgOrVarTypeProvider
	@Inject extension BaseTypeTypeProvider

	def EObject getFirstDisplayableObject(EObject o)
	{
		switch o
		{
			Expression,
			ArgOrVar,
			Function: o
			NablaRoot,
			Job,
			Instruction: null
			case (o.eContainer === null): null
			default: o.eContainer.firstDisplayableObject
		}
	}

	def buildLabel(EObject e)
	{
		'<b>' + e.text + '</b> of type <b>' + e.typeText + '</b>'
	}

	def String getText(EObject o)
	{
		switch o
		{
			Expression: LabelServices.getLabel(o)
			ArgOrVar: o.name
			Function: o.name + '(' + o.typeDeclaration.inTypes.map[typeText].join(', ') + ')'
		}
	}

	def String getTypeText(EObject o)
	{
		switch o
		{
			Expression: o.typeFor?.label
			ArgOrVar: o.typeFor?.label
			Function: o.typeDeclaration?.returnType?.typeFor?.label
			BaseType: o.typeFor?.label
		}
	}
}
