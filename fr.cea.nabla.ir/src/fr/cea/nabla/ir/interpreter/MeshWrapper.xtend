package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.javalib.mesh.CartesianMesh2DGenerator
import fr.cea.nabla.javalib.mesh.Mesh

import java.util.ArrayList
import fr.cea.nabla.javalib.mesh.NumericMesh2D

class MeshWrapper 
{
	val Mesh gm
	val NumericMesh2D nm

	new(int nbXQuads, int nbYQuads, double xSize, double ySize)
	{
		gm = CartesianMesh2DGenerator.generate(nbXQuads, nbYQuads, xSize, ySize)
		nm = new NumericMesh2D(gm)
	}

	def int[] getContainer(Iterator iterator)
	{
		val connectivityName = iterator.container.connectivity.name
		switch connectivityName {
			case "nodes" : nm.nodes
			case "cells" : nm.cells
			case "faces" : nm.faces
			default : throw new RuntimeException("Not implemented yet")
		}
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

	def int getNbElems(String connectivityName)
	{
		switch connectivityName {
			case "nodes" : nm.nbNodes
			case "cells" : nm.nbCells
			case "faces" : nm.nbFaces
			case "nodesOfCell" : NumericMesh2D::MaxNbNodesOfCell
			case "nodesOfFace" : NumericMesh2D::MaxNbNodesOfFace
			case "cellsOfNode" : NumericMesh2D::MaxNbCellsOfNode
			case "cellsOfFace" : NumericMesh2D::MaxNbCellsOfFace
			case "neighbourCells" : NumericMesh2D::MaxNbNeighbourCells
			default : throw new RuntimeException("Not implemented yet")
		}
	}

	def int getMaxNbElems(String connectityName)
	{
		// MaxNbCellsOfNode
		throw new RuntimeException("Not implemented yet")
	}
}