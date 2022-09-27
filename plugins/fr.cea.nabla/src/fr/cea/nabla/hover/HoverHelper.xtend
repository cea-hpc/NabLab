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

import com.google.inject.Inject
import fr.cea.nabla.LabelServices
import fr.cea.nabla.nabla.ArgOrVar
import fr.cea.nabla.nabla.BaseType
import fr.cea.nabla.nabla.Expression
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.Instruction
import fr.cea.nabla.nabla.Job
import fr.cea.nabla.nabla.NablaRoot
import fr.cea.nabla.nabla.Reduction
import fr.cea.nabla.typing.ArgOrVarTypeProvider
import fr.cea.nabla.typing.BaseTypeTypeProvider
import fr.cea.nabla.typing.ExpressionTypeProvider
import org.eclipse.emf.ecore.EObject

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
			Function,
			Reduction: o
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
			Reduction: o.name.reductionName + '(' + o.typeDeclaration.type.typeText + ')'
			Function: o.name.functionName + '(' + o.intypesDeclaration.map[inTypes.typeText].join(', ') + ')'
		}
	}
	
	private static def String getFunctionName(String name)
	{
		switch (name)
		{
			case 'sqrt': '\u221A'
			default: name
		}
	}
	
		private static def String getReductionName(String name)
	{
		switch (name)
		{
			case 'sum': '\u2211'
			case 'prod': '\u220F'
			default: name
		}
	}

	def String getTypeText(EObject o)
	{
		switch o
		{
			Expression: LabelServices.getLabel(o.typeFor?.primitive)
			ArgOrVar: LabelServices.getLabel(o.typeFor?.primitive)
			Function: o.returnTypeDeclaration.returnType?.typeFor?.label.replace(o.returnTypeDeclaration.returnType?.typeFor?.primitive.toString, LabelServices.getLabel(o.returnTypeDeclaration.returnType?.typeFor?.primitive))
			Reduction: o.typeDeclaration.type?.typeFor?.label.replace(o.typeDeclaration.type?.typeFor?.primitive.toString, LabelServices.getLabel(o.typeDeclaration.type?.typeFor?.primitive))
			BaseType: o.typeFor?.label.replace(o.typeFor?.primitive.toString, LabelServices.getLabel(o.typeFor?.primitive))
		}
	}
}
