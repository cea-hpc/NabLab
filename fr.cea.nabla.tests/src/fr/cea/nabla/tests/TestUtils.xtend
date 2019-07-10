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
 * 	Jean-Sylvan Camier - Nabla generation support
 *******************************************************************************/
package fr.cea.nabla.tests

import fr.cea.nabla.nabla.BaseType
import fr.cea.nabla.nabla.Connectivity
import fr.cea.nabla.nabla.PrimitiveType
import fr.cea.nabla.typing.DefinedType
import fr.cea.nabla.typing.ExpressionType
import fr.cea.nabla.typing.RealArrayType
import org.junit.Assert

class TestUtils 
{
	static def void assertEquals(PrimitiveType expectedRoot, int[] expectedSizes, BaseType actual)
	{
		Assert.assertEquals(expectedRoot, actual.root)
		Assert.assertArrayEquals(expectedSizes, actual.sizes)
	}

	static def void assertEquals(PrimitiveType expectedRoot, int[] expectedSizes, Connectivity[] expectedConnectivities, ExpressionType actual)
	{
		switch actual
		{
			RealArrayType:
			{
				Assert.assertEquals(expectedRoot, PrimitiveType::REAL)
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
}