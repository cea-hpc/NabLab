package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.javalib.mesh.CartesianMesh2DGenerator
import fr.cea.nabla.javalib.mesh.Mesh
import fr.cea.nabla.javalib.mesh.NumericMesh2D
import java.util.ArrayList

class MeshWrapper 
{
	val Mesh<double[]> gm
	val NumericMesh2D nm

	new(int nbXQuads, int nbYQuads, double xSize, double ySize)
	{
		gm = CartesianMesh2DGenerator.generate(nbXQuads, nbYQuads, xSize, ySize)
		nm = new NumericMesh2D(gm)
	}

	def int[] getContainer(Iterator iterator)
	{

	}

	def int getIndexOf(Iterator iterator, int id)
	{
		throw new RuntimeException("Not implemented yet")
	}

	def int invokeSingleton(String methodName, int[] params)
	{
		throw new RuntimeException("Not implemented yet")
	}

	def ArrayList<double[]> getNodes()
	{
		gm.nodes
	}

	def int getNbElems(String connectityName)
	{
		//getNbNodes
		throw new RuntimeException("Not implemented yet")
	}

	def int getMaxNbElems(String connectityName)
	{
		// MaxNbCellsOfNode
		throw new RuntimeException("Not implemented yet")
	}
}