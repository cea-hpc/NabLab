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
import fr.cea.nabla.typing.ExpressionType
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
}