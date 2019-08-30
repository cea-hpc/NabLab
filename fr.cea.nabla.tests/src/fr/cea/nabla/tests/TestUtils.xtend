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

import fr.cea.nabla.nabla.BaseType
import fr.cea.nabla.nabla.Connectivity
import fr.cea.nabla.nabla.PrimitiveType
import fr.cea.nabla.typing.ArrayType
import fr.cea.nabla.typing.DefinedType
import org.junit.Assert
import fr.cea.nabla.typing.AbstractType

class TestUtils 
{
	static def void assertEquals(PrimitiveType expectedRoot, int[] expectedSizes, BaseType actual)
	{
		Assert.assertEquals(expectedRoot, actual.root)
		Assert.assertArrayEquals(expectedSizes, actual.sizes)
	}

	static def void assertEquals(PrimitiveType expectedRoot, int[] expectedSizes, Connectivity[] expectedConnectivities, AbstractType actual)
	{
		switch actual
		{
			ArrayType:
			{
				Assert.assertEquals(expectedRoot, actual.root)
				Assert.assertArrayEquals(expectedSizes, actual.sizes)				
				Assert.assertArrayEquals(expectedConnectivities, actual.connectivities)				
			}
			DefinedType: 
			{
				Assert.assertEquals(expectedRoot, actual.root)
				Assert.assertArrayEquals(expectedSizes, #[])				
				Assert.assertArrayEquals(expectedConnectivities, actual.connectivities)				
			}
			default: Assert.fail
		}
	}
	
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
	
	connectivities {
		nodes: → {node};
		cells: → {cell};
		nodesOfCell: cell → {node};
	}
	'''

	static def String getNodesConnectivity()
	'''
	items { node }
	
	connectivities 
	{
		nodes: → {node};
	}
	'''

	static def String getCoordVariable()
	'''
	ℝ[2] X{nodes};
	ℝ[2] orig = [0.0 , 0.0] ;
	'''
	
	static def String getIniX()
	'''
	IniX: ∀r∈nodes(), X{r} = orig;
	'''
	
	static def CharSequence getTestModule()
	{
		emptyTestModule + connectivities + mandatoryOptions
	}
	
	static def getTestModuleWithCustomFunctions(CharSequence functions)
	{
		emptyTestModule + connectivities + functions + mandatoryOptions
	}

	static def getTestModuleWithCustomConnectivities(CharSequence connectivities)
	{
		emptyTestModule + connectivities + mandatoryOptions
	}

	//Useful to prevent warnings
	static def getTestModuleWithCoordVariable()
	{
		emptyTestModule + nodesConnectivity + coordVariable + mandatoryOptions + iniX
	}	

	//Useful to prevent warnings
	static def getTestModuleWithCoordVariableWithCustomVars(CharSequence variables)
	{
		emptyTestModule + nodesConnectivity + coordVariable + mandatoryOptions + variables + iniX
	}

	//Useful to prevent warnings
	static def getTestModuleWithCoordVariableWithCustomFunctions(CharSequence functions)
	{
		emptyTestModule + nodesConnectivity + functions + coordVariable + mandatoryOptions + iniX
	}

	//Useful to prevent warnings
	static def getTestModuleWithCoordVariableWithCustomConnectivities(CharSequence connectivities)
	{
		emptyTestModule + connectivities + coordVariable + mandatoryOptions + iniX
	}
}