package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.javalib.mesh.CartesianMesh2DGenerator
import fr.cea.nabla.javalib.mesh.Mesh
import fr.cea.nabla.javalib.mesh.NumericMesh2D
import java.util.ArrayList

class MeshWrapper 
{
	val Mesh gm
	val NumericMesh2D nm

	new(int nbXQuads, int nbYQuads, double xSize, double ySize)
	{
		gm = CartesianMesh2DGenerator.generate(nbXQuads, nbYQuads, xSize, ySize)
		nm = new NumericMesh2D(gm)
	}

	def int[] getElements(String connectivityName, int[] args)
	{
		//println("get" + connectivityName + if (args.size>0) "("+args.get(0)+")" else "")
		switch connectivityName {
			case "nodes" : nm.nodes
			case "cells" : nm.cells
			case "faces" : nm.faces
			case "innerNodes" : nm.innerNodes
			case "outerFaces" : nm.outerFaces
			case "nodesOfCell" : nm.getNodesOfCell(args.get(0))
			case "cellsOfNode" : nm.getCellsOfNode(args.get(0))
			case "nodesOfFace" : nm.getNodesOfFace(args.get(0))
			case "neighbourCells" : nm.getNeighbourCells(args.get(0))
			default : throw new RuntimeException("Not implemented yet (" + connectivityName + ")")
		}
	}

	def int getIndexOf(Iterator iterator, int id)
	{
		throw new RuntimeException("Not implemented yet")
	}

	def int getSingleton(String connectivityName, int[] params)
	{
		switch connectivityName {
			case "commonFace" : nm.getCommonFace(params.get(0), params.get(1))
			default : throw new RuntimeException("Not implemented yet (" + connectivityName + ")")
		}
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
			case "outerFaces" : nm.nbOuterFaces
			case "innerNodes" : nm.nbInnerNodes
			default : throw new RuntimeException("Not implemented yet")
		}
	}

	def int getMaxNbElems(String connectivityName)
	{
		switch connectivityName {
			case "nodesOfCell" : NumericMesh2D::MaxNbNodesOfCell
			case "nodesOfFace" : NumericMesh2D::MaxNbNodesOfFace
			case "cellsOfNode" : NumericMesh2D::MaxNbCellsOfNode
			case "cellsOfFace" : NumericMesh2D::MaxNbCellsOfFace
			case "neighbourCells" : NumericMesh2D::MaxNbNeighbourCells
			default : throw new RuntimeException("Not implemented yet")
		}
	}

	def getQuads()
	{
		nm.geometricMesh.quads
	}
}