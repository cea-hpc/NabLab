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
import fr.cea.nabla.nabla.ArgOrVar
import fr.cea.nabla.nabla.ConnectivityVar
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.SimpleVar
import fr.cea.nabla.nabla.SimpleVarDefinition
import fr.cea.nabla.nabla.Var
import fr.cea.nabla.nabla.VarGroupDeclaration

class ArgOrVarExtensions 
{
	def dispatch getType(ConnectivityVar it)
	{
		(eContainer as VarGroupDeclaration).type
	}

	def dispatch getType(SimpleVar it)
	{
		val decl = eContainer
		switch decl
		{
			SimpleVarDefinition : decl.type
			VarGroupDeclaration : decl.type
		}
	}

	def dispatch getType(Arg it)
	{
		val f = eContainer as Function
		val i = f.inArgs.indexOf(it)
		f.inTypes.get(i)
	}

	def dispatch boolean isConst(Arg it)
	{
		true
	}

	def dispatch boolean isConst(Var it)
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

	def int getDimension(ArgOrVar it) { type.sizes.size }
}