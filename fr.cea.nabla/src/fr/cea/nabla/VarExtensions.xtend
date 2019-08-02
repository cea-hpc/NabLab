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

import fr.cea.nabla.nabla.ConnectivityVar
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.ScalarVarDefinition
import fr.cea.nabla.nabla.SimpleVar
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
	
	def getDimensions(Var it)
	{
		switch it 
		{
			SimpleVar : #[]
			ConnectivityVar : dimensions
		}		
	}
	
	/**
	 * Returns true if the variable has at least 2 connectivities which takes no argument, false otherwise.
	 * For example, X{cells, nodesOfCell} returns false but X{cells, cells} or X{cells, nodes} returns true.
	 */
	def isConnectivityMatrix(ConnectivityVar it)
	{
		println('Connectivity Var : ' + name)
		println('  ' + dimensions.map[name].join(', '))
		val fullConnectivities = dimensions.filter[x | x.inTypes.empty]
		println('  ' + fullConnectivities.map[name].join(', '))
		return (fullConnectivities.size > 1)
	}
}