package fr.cea.nabla.javalib.mesh.test

import fr.cea.nabla.javalib.mesh.Quad
import org.junit.jupiter.api.Test

import static org.junit.jupiter.api.Assertions.*

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