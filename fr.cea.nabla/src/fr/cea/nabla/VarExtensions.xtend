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

import fr.cea.nabla.nabla.ConnectivityVar
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.ScalarVarDefinition
import fr.cea.nabla.nabla.Var
import fr.cea.nabla.nabla.VarGroupDeclaration

class VarExtensions 
{
	def getBaseType(Var it) 
	{ 
		val decl = eContainer
		switch decl
		{
			ScalarVarDefinition : decl.type
			VarGroupDeclaration : decl.type
		}
	}

	def boolean isConst(Var it) 
	{ 
		val decl = eContainer
		switch decl
		{
			ScalarVarDefinition : decl.const
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
			ScalarVarDefinition : decl.defaultValue
			VarGroupDeclaration : null
		}
	}
	
	/**
	 * Returns true if the variable has at least 2 connectivities which takes no argument, false otherwise.
	 * For example, X{cells, nodesOfCell} returns false but X{cells, cells} or X{cells, nodes} returns true.
	 */
	def isConnectivityMatrix(ConnectivityVar it)
	{
		val fullConnectivities = dimensions.filter[x | x.inTypes.empty]
		return (fullConnectivities.size > 1)
	}
}