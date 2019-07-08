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
import fr.cea.nabla.nabla.PrimitiveType
import fr.cea.nabla.typing.BoolType
import fr.cea.nabla.typing.ExpressionType
import fr.cea.nabla.typing.IntType
import fr.cea.nabla.typing.RealArrayType
import fr.cea.nabla.typing.RealType
import org.junit.Assert

class TestUtils 
{
	static def void assertEquals(PrimitiveType expectedRoot, int[] expectedSizes, BaseType actual)
	{
		Assert.assertEquals(expectedRoot, actual.root)
		Assert.assertArrayEquals(expectedSizes, actual.sizes)
	}

	static def void assertEquals(PrimitiveType expectedRoot, int[] expectedSizes, ExpressionType actual)
	{
		switch actual
		{
			IntType: 
			{
				Assert.assertEquals(expectedRoot, PrimitiveType::INT)
				Assert.assertArrayEquals(expectedSizes, #[])				
			}
			RealType:
			{
				Assert.assertEquals(expectedRoot, PrimitiveType::REAL)
				Assert.assertArrayEquals(expectedSizes, #[])				
			}
			BoolType: 
			{
				Assert.assertEquals(expectedRoot, PrimitiveType::BOOL)
				Assert.assertArrayEquals(expectedSizes, #[])				
			}
			RealArrayType:
			{
				Assert.assertEquals(expectedRoot, PrimitiveType::REAL)
				Assert.assertArrayEquals(expectedSizes, actual.sizes)				
			}
			default: Assert.fail
		}
	}
}