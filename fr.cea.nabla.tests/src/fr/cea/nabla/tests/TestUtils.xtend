/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.tests

class TestUtils 
{
	// ===== CharSequence utils =====
	static def String getEmptyTestModule()
	'''
		module Test;
	'''

	//TODO These options should be filled in nablagen
	static def String getMandatoryOptions()
	'''
	// Options obligatoires pour générer
	const ℝ X_EDGE_LENGTH = 0.01;
	const ℝ Y_EDGE_LENGTH = X_EDGE_LENGTH;
	const ℕ X_EDGE_ELEMS = 100;
	const ℕ Y_EDGE_ELEMS = 10;
	const ℕ Z_EDGE_ELEMS = 1;
	const ℝ option_stoptime = 0.2;
	const ℕ option_max_iterations = 20000;
	'''
	
	static def String getConnectivities()
	'''
	items { node, cell }
	
	set nodes: → {node};
	set cells: → {cell};
	set nodesOfCell: cell → {node};
	'''

	static def String getNodesConnectivity()
	'''
	items { node }

	set nodes: → {node};
	'''

	static def String getMandatoryVariables()
	'''
	ℝ t;
	ℝ[2] X{nodes};
	'''
		
	static def CharSequence getTestModule()
	{
		emptyTestModule + connectivities + mandatoryOptions + mandatoryVariables
	}
	
	static def getTestModuleWithCustomFunctions(CharSequence functions)
	{
		emptyTestModule + connectivities + functions + mandatoryOptions + mandatoryVariables
	}

	static def getTestModuleWithCustomConnectivities(CharSequence connectivities)
	{
		emptyTestModule + connectivities + mandatoryOptions + mandatoryVariables
	}

	//Useful to prevent warnings
	static def getTestModuleWithCoordVariable()
	{
		emptyTestModule + nodesConnectivity + mandatoryOptions + mandatoryVariables
	}	

	//Useful to prevent warnings
	static def getTestModuleWithCoordVariableWithCustomVars(CharSequence variables)
	{
		emptyTestModule + nodesConnectivity + mandatoryOptions + mandatoryVariables + variables
	}

	//Useful to prevent warnings
	static def getTestModuleWithCoordVariableWithCustomFunctions(CharSequence functions)
	{
		emptyTestModule + nodesConnectivity + functions + mandatoryOptions + mandatoryVariables
	}

	//Useful to prevent warnings
	static def getTestModuleWithCoordVariableWithCustomConnectivities(CharSequence connectivities)
	{
		emptyTestModule + connectivities + mandatoryOptions + mandatoryVariables
	}
}