package fr.cea.nabla.javalib.mesh.test

import fr.cea.nabla.javalib.mesh.CartesianMesh2DGenerator
import fr.cea.nabla.javalib.mesh.PvdFileWriter2D
import fr.cea.nabla.javalib.mesh.VtkFileContent
import org.junit.Test

class VtkFileWriter2DTest
{
	@Test
	def testWriteFile()
	{
		val nbXQuads = 4
		val nbYQuads = 3
		val xSize = 5.0
		val ySize = 10.0

		val mesh = CartesianMesh2DGenerator::generate(nbXQuads, nbYQuads, xSize, ySize)
		val writer = new PvdFileWriter2D("BasicMesh", "output");
		val content = new VtkFileContent(0, 0, mesh.geometry.nodes, mesh.geometry.quads);
		//content.addCellVariable("Density", rho);
		writer.writeFile(content);
	}
}
