/**
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 * 
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 */
package fr.cea.nabla.javalib.mesh;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class CartesianMesh2D 
{
	public static int MaxNbNodesOfCell = 4;
	public static  int MaxNbNodesOfFace = 2; 
	public static  int MaxNbCellsOfNode = 4;
	public static  int MaxNbCellsOfFace = 2;
	public static  int MaxNbNeighbourCells = 4;

	private  MeshGeometry geometry;

	private  int[] innerNodes;
	private  int[] topNodes;
	private  int[] bottomNodes;
	private  int[] leftNodes;
	private  int[] rightNodes;

	private  int topLeftNode;
	private  int topRightNode;
	private  int bottomLeftNode;
	private  int bottomRightNode;

	private  int[] topCells;
	private  int[] bottomCells;
	private  int[] leftCells;
	private  int[] rightCells;

	private  ArrayList<Integer> outerFaces = new ArrayList<Integer>();
	private  ArrayList<Integer> innerFaces = new ArrayList<Integer>();
	private  ArrayList<Integer> innerHorizontalFaces = new ArrayList<Integer>();
	private  ArrayList<Integer> innerVerticalFaces = new ArrayList<Integer>();

	private  ArrayList<Integer> topFaces = new ArrayList<Integer>();
	private  ArrayList<Integer> bottomFaces = new ArrayList<Integer>();
	private  ArrayList<Integer> leftFaces = new ArrayList<Integer>();
	private  ArrayList<Integer> rightFaces = new ArrayList<Integer>();

	private  int xQuads;
	private  int yQuads;

	public CartesianMesh2D(MeshGeometry meshGeometry, int[] innerNodeIds, int[] topNodeIds, int[] bottomNodeIds, int[] leftNodeIds, int[] rightNodeIds)
	{
		this.geometry = meshGeometry;
		this.innerNodes = innerNodeIds;
		this.topNodes = topNodeIds;
		this.bottomNodes = bottomNodeIds;
		this.leftNodes = leftNodeIds;
		this.rightNodes = rightNodeIds;

		this.xQuads = bottomNodeIds.length -1;
		this.yQuads = leftNodeIds.length -1;

		this.topLeftNode = (xQuads + 1) * yQuads;
		this.topRightNode = (xQuads + 1) * (yQuads +1) - 1;
		this.bottomLeftNode = 0;
		this.bottomRightNode = xQuads;

		Edge[] edges = geometry.getEdges();
		for (int edgeId = 0; edgeId <edges.length; edgeId ++)
		{
			Edge edge = edges[edgeId];
			if (!isInnerEdge(edge))
				outerFaces.add(edgeId);
			else
			{
				innerFaces.add(edgeId);
				if (isInnerVerticalEdge(edge))
					innerVerticalFaces.add(edgeId);
				else if (isInnerHorizontalEdge(edge))
					innerHorizontalFaces.add(edgeId);
				else
					throw new RuntimeException("The inner edge " + edgeId + " should be either vertical or horizontal");
			}
		}

		// Construction of boundary cell sets
		topCells = cellsOfNodeCollection(topNodes);
		bottomCells = cellsOfNodeCollection(bottomNodes);
		leftCells = cellsOfNodeCollection(leftNodes);
		rightCells = cellsOfNodeCollection(rightNodes);

		// Construction of boundary cell faces
		for (int cellId : topCells) topFaces.add(getTopFaceOfCell(cellId));
		for (int cellId : bottomCells) bottomFaces.add(getBottomFaceOfCell(cellId));
		for (int cellId : leftCells) leftFaces.add(getLeftFaceOfCell(cellId));
		for (int cellId : rightCells) rightFaces.add(getRightFaceOfCell(cellId));
	}

	public MeshGeometry getGeometry() { return geometry; }
//	public int getXQuads() { return xQuads; }
//	public int getYQuads() { return yQuads; }

	public int getNbNodes() { return geometry.getNodes().length; }
	public int[] getNodes() { return IntStream.range(0, this.getNbNodes()).toArray(); }

	public int getNbCells() { return geometry.getQuads().length; }
	public int[] getCells() { return IntStream.range(0, this.getNbCells()).toArray(); }

	public int getNbFaces() { return geometry.getEdges().length; }
	public int[] getFaces() { return IntStream.range(0, this.getNbFaces()).toArray(); }

	public int getNbInnerNodes() { return innerNodes.length;}
	public int[] getInnerNodes() { return innerNodes; }
	public int getNbTopNodes() { return topNodes.length;}
	public int[] getTopNodes() { return topNodes; }
	public int getNbBottomNodes() { return bottomNodes.length;}
	public int[] getBottomNodes() { return bottomNodes; }
	public int getNbLeftNodes() { return leftNodes.length;}
	public int[] getLeftNodes() { return leftNodes; }
	public int getNbRightNodes() { return rightNodes.length;}
	public int[] getRightNodes() { return rightNodes; }

	public int getNbTopCells() { return topCells.length; }
	public int[] getTopCells() { return topCells; }
	public int getNbBottomCells() { return bottomCells.length; }
	public int[] getBottomCells() { return bottomCells; }
	public int getNbLeftCells() { return leftCells.length; }
	public int[] getLeftCells() { return leftCells; }
	public int getNbRightCells() { return rightCells.length; }
	public int[] getRightCells() { return rightCells; }

	public int getNbTopFaces() { return topFaces.size(); }
	public int[] getTopFaces() { return topFaces.stream().mapToInt(x->x).toArray(); }
	public int getNbBottomFaces() { return bottomFaces.size(); }
	public int[] getBottomFaces() { return bottomFaces.stream().mapToInt(x->x).toArray(); }
	public int getNbLeftFaces() { return leftFaces.size(); }
	public int[] getLeftFaces() { return leftFaces.stream().mapToInt(x->x).toArray(); }
	public int getNbRightFaces() { return rightFaces.size(); }
	public int[] getRightFaces() { return rightFaces.stream().mapToInt(x->x).toArray(); }
	public int getNbOuterFaces() { return outerFaces.size(); }
	public int[] getOuterFaces() { return outerFaces.stream().mapToInt(x->x).toArray(); }
	public int getNbInnerFaces() { return innerFaces.size(); }
	public int[] getInnerFaces() { return innerFaces.stream().mapToInt(x->x).toArray(); }
	public int getNbInnerHorizontalFaces() { return innerHorizontalFaces.size(); }
	public int[] getInnerHorizontalFaces() { return innerHorizontalFaces.stream().mapToInt(x->x).toArray(); }
	public int getNbInnerVerticalFaces() { return innerVerticalFaces.size(); }
	public int[] getInnerVerticalFaces() { return innerVerticalFaces.stream().mapToInt(x->x).toArray(); }

	// TODO: Temporary until single item is available in grammar
	public int getNbTopLeftNode() { return 1; }
	public int[] getTopLeftNode() { return new int[] {topLeftNode}; }
	// TODO: Temporary until single item is available in grammar
	public int getNbBottomLeftNode() { return 1; }
	public int[] getBottomLeftNode() { return new int[] {bottomLeftNode}; }
	// TODO: Temporary until single item is available in grammar
	public int getNbTopRighttNode() { return 1; }
	public int[] getTopRightNode() { return new int[] {topRightNode}; }
	// TODO: Temporary until single item is available in grammar
	public int getNbBottomRightNode() { return 1; }
	public int[] getBottomRightNode() { return new int[] {bottomRightNode}; }

	public int[] getNodesOfCell(int cellId)
	{
		return geometry.getQuads()[cellId].getNodeIds();
	}

	public int[] getNodesOfFace(int faceId)
	{
		return geometry.getEdges()[faceId].getNodeIds();
	}

	public int getFirstNodeOfFace(int faceId)
	{
		return this.getNodesOfFace(faceId)[0];
	}

	public int getSecondNodeOfFace(int faceId)
	{
		return this.getNodesOfFace(faceId)[1];
	}

	public int[] getCellsOfNode(int nodeId) 
	{
		Map.Entry<Integer, Integer> index = id2IndexNode(nodeId);
		int i = index.getKey();
		int j = index.getValue();
		
		ArrayList<Integer> cellsOfNode = new ArrayList<Integer>();
		if (i < yQuads && j < xQuads) cellsOfNode.add(index2IdCell(i, j));
		if (i < yQuads && j > 0) cellsOfNode.add(index2IdCell(i, j-1));
		if (i > 0 && j < xQuads) cellsOfNode.add(index2IdCell(i-1, j));
		if (i > 0 && j > 0) cellsOfNode.add(index2IdCell(i-1, j-1));
		Collections.sort(cellsOfNode);
		return cellsOfNode.stream().mapToInt(x->x).toArray();
	}

	public int[] getCellsOfFace(int faceId)
	{
		int i_f = (faceId / ((2 * this.xQuads) + 1));
		int k_f = (faceId - (i_f * ((2 * this.xQuads) + 1)));
		ArrayList<Integer> cellsOfFace = new ArrayList<Integer>();
		if (i_f < this.yQuads) // all except upper bound faces
		{
			if (k_f == (2 * this.xQuads))
				cellsOfFace.add(index2IdCell(i_f, xQuads - 1));
			else
			{
				if (k_f == 1) // left bound edge
					cellsOfFace.add(index2IdCell(i_f, 0));
				else
				{
					if (((k_f % 2) == 0)) // horizontal edge
					{
						cellsOfFace.add(index2IdCell(i_f, k_f / 2));
						if ((i_f > 0))  // Not bottom bound edge
							cellsOfFace.add(index2IdCell(i_f - 1, k_f / 2));
					} 
					else // vertical edge (neither left bound nor right bound)
					{
						cellsOfFace.add(index2IdCell(i_f, (((k_f - 1) / 2) - 1)));
						cellsOfFace.add(index2IdCell(i_f, ((k_f - 1) / 2)));
					}
				}
			}
		} 
		else  // upper bound faces
			cellsOfFace.add(index2IdCell(i_f - 1, k_f));
		return cellsOfFace.stream().mapToInt(x->x).toArray();
	}

	public int[] getNeighbourCells(int cellId) 
	{
		Map.Entry<Integer, Integer> index = id2IndexCell(cellId);
		int i = index.getKey();
		int j = index.getValue();
		ArrayList<Integer> neighbourCells = new ArrayList<Integer>();
		if (i >= 1)	neighbourCells.add(index2IdCell(i-1, j));
		if (i < yQuads - 1) neighbourCells.add(index2IdCell(i+1, j));
		if (j >= 1) neighbourCells.add(index2IdCell(i, j-1));
		if (j < (xQuads - 1)) neighbourCells.add(index2IdCell(i, j+1));
		Collections.sort(neighbourCells);
		return neighbourCells.stream().mapToInt(x->x).toArray();
	}

	
	public int[] getFacesOfCell(int cellId)
	{
		Map.Entry<Integer, Integer> index = id2IndexCell(cellId);
		int i = index.getKey();
		int j = index.getValue();
		int bottomFace = (2 * j + i * (2 * xQuads + 1));
		int leftFace = bottomFace + 1;
		int rightFace = bottomFace + (j == xQuads-1 ? 2 : 3);
		int topFace = bottomFace + (i < yQuads-1 ? 2 * xQuads + 1 : 2 * xQuads + 1 - j);
		return new int[] {bottomFace, leftFace, rightFace, topFace};
  	}
	
	public int getCommonFace(int cell1, int cell2)
	{
		int[] cell1Faces = getFacesOfCell(cell1);
		int[] cell2Faces = getFacesOfCell(cell2);
		
		Set<Integer> set = new HashSet<>(Arrays.stream(cell1Faces).boxed().collect(Collectors.toList()));
	    set.retainAll(Arrays.stream(cell2Faces).boxed().collect(Collectors.toList()));
	    if (set.isEmpty()) 
	    	return -1;
	    else 
	    	return new ArrayList<>(set).get(0);
	}

	public int getBackCell(int faceId) throws Exception
	{
		int[] cells = getCellsOfFace(faceId);
		if ( cells.length < 2) 
			throw new Exception("Error in getBackCell(" + faceId + "): please consider using this method with inner face only.");
		else
			return cells[0];
	}

	public int getFrontCell(int faceId) throws Exception 
	{
		int[] cells = getCellsOfFace(faceId);
		if ( cells.length < 2) 
			throw new Exception("Error in getFrontCell(" + faceId + "): please consider using this method with inner face only.");
		else
			return cells[1];
	}

	public int getTopFaceOfCell(int cellId)
	{
		Map.Entry<Integer, Integer> index = id2IndexCell(cellId);
		int i = index.getKey();
		int j = index.getValue();
		int bottomFace = 2 * j + i * (2 * xQuads + 1);
		int topFace = bottomFace + (i < yQuads - 1 ? 2 * xQuads + 1 :2 * xQuads + 1 - j);
		return topFace;
	}

	public int getBottomFaceOfCell(int cellId)
	{
		Map.Entry<Integer, Integer> index = id2IndexCell(cellId);
		int i = index.getKey();
		int j = index.getValue();
		int bottomFace = 2 * j + i * (2 * xQuads + 1);
		return bottomFace;
	}
	
	public int getLeftFaceOfCell(int cellId)
	{
		int bottomFace = this.getBottomFaceOfCell(cellId);
		int leftFace = bottomFace + 1;
		return leftFace;
	}

	public int getRightFaceOfCell(int cellId)
	{
		Map.Entry<Integer, Integer> index = id2IndexCell(cellId);
		Integer i = index.getKey();
		Integer j = index.getValue();
		int bottomFace = 2 * j + i * (2 * xQuads + 1);
		int rightFace = bottomFace + (j == xQuads - 1 ? 2 : 3);
		return rightFace;
	}

	public void dump()
	{
		geometry.dump();
		System.out.println("Mesh Topology");
		dumpItemCollection("	inner nodes	:	", innerNodes);
		dumpItemCollection("	top nodes	:	", topNodes);
		dumpItemCollection("	bottom nodes	:	", bottomNodes);
		dumpItemCollection("	left nodes	:	", leftNodes);
		dumpItemCollection("	right nodes	:	", rightNodes);
		dumpItemCollection("	outer faces	:	", getOuterFaces());		
	}

	private void dumpItemCollection(String desc, int[] collection)
	{
		System.out.print(desc);
		for (int i=0; i < collection.length; i++)
				System.out.print(collection[i] + (i < collection.length -1 ? ", " : "\n"));
	}
	
	private boolean isInnerEdge(Edge edge)
	{
		int firstNode = edge.getNodeIds()[0];
		int secondNode = edge.getNodeIds()[1];
		int maxNode = secondNode;
		if (secondNode < firstNode)
			maxNode = firstNode;
		for (int i : innerNodes)
		{
			if (i == firstNode || i == secondNode)
				return true;
			if ( i > maxNode)
				return false;
		}
		return false;
	}

	private boolean isInnerVerticalEdge(Edge edge)
	{
		// Optimisation : we have already checked it 
//		if (!isInnerEdge(edge))
//			return false;
		return (edge.getNodeIds()[0] == edge.getNodeIds()[1] + xQuads + 1 || edge.getNodeIds()[1] == edge.getNodeIds()[0] + xQuads + 1);
	}

	private boolean isInnerHorizontalEdge(Edge edge)
	{
		// Optimisation : we have already checked it 
//		if (!isInnerEdge(edge))
//			return false;
		return ((edge.getNodeIds()[0] == edge.getNodeIds()[1] + 1) || (edge.getNodeIds()[1] == edge.getNodeIds()[0] + 1));
	}

	private int index2IdCell(int i, int j)
	{
		return ((i * this.xQuads) + j);
	}

	private Map.Entry<Integer, Integer> id2IndexCell(int cellId)
	{
		int i = Math.abs((cellId / this.xQuads));
		int j = (cellId % this.xQuads);
		return Map.entry(i, j);
	}

	private Map.Entry<Integer, Integer> id2IndexNode(int nodeId)
	{
		int i = Math.abs((nodeId / (this.xQuads + 1)));
		int j = (nodeId % (this.xQuads + 1));
		return Map.entry(i, j);
	}

	private int[] cellsOfNodeCollection(int[] nodeIds)
	{
		HashSet<Integer> cellsOfNode = new HashSet<Integer>();
		for (int nodeId : nodeIds)
		{
			for (int cellId : getCellsOfNode(nodeId))
				cellsOfNode.add(cellId);
		}
		return cellsOfNode.stream().mapToInt(x->x).toArray();
	}
}
