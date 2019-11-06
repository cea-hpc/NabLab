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

import fr.cea.nabla.nabla.Arg
import fr.cea.nabla.nabla.Array1D
import fr.cea.nabla.nabla.Array2D
import fr.cea.nabla.nabla.BaseType
import fr.cea.nabla.nabla.ConnectivityVar
import fr.cea.nabla.nabla.LoopIndex
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.Scalar
import fr.cea.nabla.nabla.SimpleVar
import fr.cea.nabla.nabla.SimpleVarDefinition
import fr.cea.nabla.nabla.Var
import fr.cea.nabla.nabla.VarGroupDeclaration

class VarExtensions 
{
	def getBaseType(ConnectivityVar it) 
	{
		(eContainer as VarGroupDeclaration).type
	}

	def getBaseType(SimpleVar it) 
	{
		val decl = eContainer
		switch decl
		{
			SimpleVarDefinition : decl.type
			VarGroupDeclaration : decl.type
		}
	}

	def boolean isConst(Var it) 
	{ 
		val decl = eContainer
		switch decl
		{
			SimpleVarDefinition : decl.const
			default : false
		}
	}

	def isGlobal(Var it) 
	{ 
		eContainer.eContainer instanceof NablaModule
	}

	def getDefaultValue(Var it)
	{
		val decl = eContainer
		switch decl
		{
			SimpleVarDefinition : decl.defaultValue
			default : null
		}
	}

	def dispatch int getDimension(SimpleVar it) { baseType.typeDimension }
	def dispatch int getDimension(ConnectivityVar it) { baseType.typeDimension }
	def dispatch int getDimension(LoopIndex it) { 0 }
	def dispatch int getDimension(Arg it) { type.indices.size }

	private def int getTypeDimension(BaseType t)
	{
		switch t
		{
			Scalar: 0
			Array1D: 1
			Array2D: 2
			default: -1
		}
	}
}