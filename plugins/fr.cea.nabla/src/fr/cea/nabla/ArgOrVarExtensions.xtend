/*******************************************************************************
 * Copyright (c) 2020 CEA
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
import fr.cea.nabla.nabla.BaseType
import fr.cea.nabla.nabla.ConnectivityVar
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.Reduction
import fr.cea.nabla.nabla.SimpleVarDefinition
import fr.cea.nabla.nabla.Var
import fr.cea.nabla.nabla.VarGroupDeclaration

/**
 * Allow to access the type of ArgOrVar except SimpleVar
 * that needs a type provider to evaluate its defaultValue.
 */
class ArgOrVarExtensions 
{
	def BaseType getType(ConnectivityVar it)
	{
		(eContainer as VarGroupDeclaration).type
	}

	def BaseType getType(Arg it)
	{
		val fOrR = eContainer
		switch (fOrR)
		{
			Function: 
			{
				val i = fOrR.inArgs.indexOf(it)
				fOrR.inTypes.get(i)
			}
			Reduction:
				fOrR.type
		}
	}

	def dispatch boolean isConst(ArgOrVar it)
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
}