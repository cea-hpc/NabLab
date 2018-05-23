package fr.cea.nabla.javalib.mesh.test

import fr.cea.nabla.javalib.mesh.Edge
import org.junit.jupiter.api.Test

import static org.junit.jupiter.api.Assertions.*

class EdgeTest 
{
	@Test
	def test() 
	{
		val q = new Edge(10, 20)
		assertEquals(2, q.nodeIds.length)
		assertEquals(10, q.nodeIds.get(0))
		assertEquals(20, q.nodeIds.get(1))
	}
}