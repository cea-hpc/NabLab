/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.javalib.mesh.CartesianMesh2D
import fr.cea.nabla.javalib.mesh.CartesianMesh2DGenerator

class MeshWrapper 
{
	val CartesianMesh2D mesh

	new(int nbXQuads, int nbYQuads, double xSize, double ySize)
	{
		mesh = CartesianMesh2DGenerator.generate(nbXQuads, nbYQuads, xSize, ySize)
	}

	def int[] getElements(String connectivityName, int[] args)
	{
		switch connectivityName {
			case "nodes" : mesh.nodes
			case "cells" : mesh.cells
			case "faces" : mesh.faces
			case "innerNodes" : mesh.innerNodes
			case "outerFaces" : mesh.outerFaces
			case "nodesOfCell" : mesh.getNodesOfCell(args.get(0))
			case "cellsOfNode" : mesh.getCellsOfNode(args.get(0))
			case "nodesOfFace" : mesh.getNodesOfFace(args.get(0))
			case "neighbourCells" : mesh.getNeighbourCells(args.get(0))
			case "cellsOfFace" : mesh.getCellsOfFace(args.get(0))
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
			case "commonFace" : mesh.getCommonFace(params.get(0), params.get(1))
			default : throw new RuntimeException("Not implemented yet (" + connectivityName + ")")
		}
	}

	def double[][] getNodes()
	{
		mesh.geometry.nodes
	}

	def int getNbElems(String connectivityName)
	{
		switch connectivityName {
			case "nodes" : mesh.nbNodes
			case "cells" : mesh.nbCells
			case "faces" : mesh.nbFaces
			case "outerFaces" : mesh.nbOuterFaces
			case "innerNodes" : mesh.nbInnerNodes
			default : throw new RuntimeException("Not implemented yet")
		}
	}

	def int getMaxNbElems(String connectivityName)
	{
		switch connectivityName {
			case "nodesOfCell" : CartesianMesh2D::MaxNbNodesOfCell
			case "nodesOfFace" : CartesianMesh2D::MaxNbNodesOfFace
			case "cellsOfNode" : CartesianMesh2D::MaxNbCellsOfNode
			case "cellsOfFace" : CartesianMesh2D::MaxNbCellsOfFace
			case "neighbourCells" : CartesianMesh2D::MaxNbNeighbourCells
			default : throw new RuntimeException("Not implemented yet")
		}
	}

	def getQuads()
	{
		mesh.geometry.quads
	}
}