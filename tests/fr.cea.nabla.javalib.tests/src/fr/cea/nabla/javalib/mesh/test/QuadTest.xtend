/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.javalib.mesh.test

import fr.cea.nabla.javalib.mesh.Quad
import org.junit.Test

import static org.junit.Assert.*

class QuadTest
{
	@Test
	def test() 
	{
		val q = new Quad(10, 20, 30, 40)
		assertEquals(4, q.nodeIds.length)
		assertEquals(10, q.nodeIds.get(0))
		assertEquals(20, q.nodeIds.get(1))
		assertEquals(30, q.nodeIds.get(2))
		assertEquals(40, q.nodeIds.get(3))
	}
}