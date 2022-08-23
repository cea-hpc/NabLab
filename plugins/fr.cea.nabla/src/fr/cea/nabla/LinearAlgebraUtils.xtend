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

import com.google.inject.Inject
import fr.cea.nabla.nabla.Affectation
import fr.cea.nabla.nabla.Arg
import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.BaseType
import fr.cea.nabla.nabla.ConnectivityVar
import fr.cea.nabla.nabla.DefaultExtension
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.FunctionInTypeDeclaration
import fr.cea.nabla.nabla.FunctionReturnTypeDeclaration
import fr.cea.nabla.nabla.NablaRoot
import fr.cea.nabla.nabla.PrimitiveType
import fr.cea.nabla.nabla.SimpleVar
import fr.cea.nabla.nabla.Var
import fr.cea.nabla.nabla.VarDeclaration
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.EcoreUtil2

class LinearAlgebraUtils
{
	@Inject extension ArgOrVarExtensions

	def DefaultExtension getLinearAlgebraExtension(EObject o)
	{
		switch o
		{
			case null: return null
			Affectation: return o.right.linearAlgebraExtension
			FunctionCall: return o.function.linearAlgebraExtension
			Function:
			{
				val ext = EcoreUtil2.getContainerOfType(o, DefaultExtension)
				if (ext !== null && ext.linearAlgebra) ext
				else null
			}
			Var case o.linearAlgebraEligible:
			{
				val refsOfO = o.nablaRoot.eAllContents.filter[x | x instanceof ArgOrVarRef && (x as ArgOrVarRef).target == o]
				for (refOfO : refsOfO.toIterable)
				{
					val la = refOfO.eContainer.linearAlgebraExtension
					if (la !== null) return la
				}
				return null
			}
			Arg case o.linearAlgebraEligible: return o.eContainer.linearAlgebraExtension
			BaseType case o.linearAlgebraEligible: return o.eContainer.linearAlgebraExtension
			FunctionInTypeDeclaration: return o.eContainer.linearAlgebraExtension
			FunctionReturnTypeDeclaration: return o.eContainer.linearAlgebraExtension
			default: return null
		}
	}

	private def boolean isLinearAlgebraEligible(EObject it)
	{
		switch it
		{
			case null: false
			Arg: isLinearAlgebraEligible(type.primitive, dimension)
			SimpleVar case eContainer instanceof VarDeclaration: isLinearAlgebraEligible((eContainer as VarDeclaration).type.primitive, dimension)
			ConnectivityVar: isLinearAlgebraEligible(type.primitive, dimension)
			BaseType: isLinearAlgebraEligible(primitive, sizes.size)
			default: false
		}
	}

	private def boolean isLinearAlgebraEligible(PrimitiveType p, int dimension)
	{
		p == PrimitiveType::REAL && (dimension == 1 || dimension == 2)
	}

	private def getNablaRoot(EObject o)
	{
		EcoreUtil2.getContainerOfType(o, NablaRoot)
	}
}