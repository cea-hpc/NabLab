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
	public static int MaxNbNodesOfFace = 2; 
	public static int MaxNbCellsOfNode = 4;
	public static int MaxNbCellsOfFace = 2;
	public static int MaxNbFacesOfCell = 4;
	public static int MaxNbNeighbourCells = 4;

	private  MeshGeometry geometry;

	private  int[] innerNodes;
	private  int[] topNodes;
	private  int[] bottomNodes;
	private  int[] leftNodes;
	private  int[] rightNodes;

	private int[] innerCells;
	private int[] outerCells;

	private int topLeftNode;
	private int topRightNode;
	private int bottomLeftNode;
	private int bottomRightNode;

	private int[] topCells;
	private int[] bottomCells;
	private int[] leftCells;
	private int[] rightCells;

	private int[] outerFaces;
	private int[] innerFaces;
	private int[] innerHorizontalFaces;
	private int[] innerVerticalFaces;

	private int[] topFaces;
	private int[] bottomFaces;
	private int[] leftFaces;
	private int[] rightFaces;

	private int xQuads;
	private int yQuads;

	public CartesianMesh2D(MeshGeometry meshGeometry, int[] innerNodeIds, int[] topNodeIds, int[] bottomNodeIds, int[] leftNodeIds, int[] rightNodeIds, int[] innerCellIds, int[] outerCellIds)
	{
		this.geometry = meshGeometry;
		this.innerNodes = innerNodeIds;
		this.topNodes = topNodeIds;
		this.bottomNodes = bottomNodeIds;
		this.leftNodes = leftNodeIds;
		this.rightNodes = rightNodeIds;

		this.innerCells = innerCellIds;
		this.outerCells = outerCellIds;

		this.xQuads = bottomNodeIds.length -1;
		this.yQuads = leftNodeIds.length -1;

		this.topLeftNode = (xQuads + 1) * yQuads;
		this.topRightNode = (xQuads + 1) * (yQuads +1) - 1;
		this.bottomLeftNode = 0;
		this.bottomRightNode = xQuads;

		Edge[] edges = geometry.getEdges();
		ArrayList<Integer> outFaces = new ArrayList<Integer>();
		ArrayList<Integer> inFaces = new ArrayList<Integer>();
		ArrayList<Integer> inVFaces = new ArrayList<Integer>();
		ArrayList<Integer> inHFaces = new ArrayList<Integer>();
		ArrayList<Integer> tFaces = new ArrayList<Integer>();
		ArrayList<Integer> bFaces = new ArrayList<Integer>();
		ArrayList<Integer> lFaces = new ArrayList<Integer>();
		ArrayList<Integer> rFaces = new ArrayList<Integer>();
		
		for (int edgeId = 0; edgeId <edges.length; edgeId ++)
		{
			// Top boundary faces
		    if (edgeId >= 2 * xQuads * yQuads + yQuads) tFaces.add(edgeId);
		    // Bottom boundary faces
		    if ((edgeId < 2 * xQuads) && (edgeId % 2 == 0)) bFaces.add(edgeId);
		    // Left boundary faces
		    if ((edgeId % (2 * xQuads + 1) == 1) && edgeId < 2 * xQuads * yQuads + yQuads) lFaces.add(edgeId);
		    // Right boundary faces
		    if (edgeId % (2 * xQuads + 1) == 2 * xQuads) rFaces.add(edgeId);

		    Edge edge = edges[edgeId];
			if (!isInnerEdge(edge))
				outFaces.add(edgeId);
			else
			{
				inFaces.add(edgeId);
				if (isVerticalEdge(edge))
					inVFaces.add(edgeId);
				else if (isHorizontalEdge(edge))
					inHFaces.add(edgeId);
				else
					throw new RuntimeException("The inner edge " + edgeId + " should be either vertical or horizontal");
			}
		}
		outerFaces = outFaces.stream().mapToInt(x->x).toArray();
		innerFaces = inFaces.stream().mapToInt(x->x).toArray();
		innerVerticalFaces = inVFaces.stream().mapToInt(x->x).toArray();
		innerHorizontalFaces = inHFaces.stream().mapToInt(x->x).toArray();

		topFaces = tFaces.stream().mapToInt(x->x).toArray();
		bottomFaces = bFaces.stream().mapToInt(x->x).toArray();
		leftFaces = lFaces.stream().mapToInt(x->x).toArray();
		rightFaces = rFaces.stream().mapToInt(x->x).toArray();

		// Construction of boundary cell sets
		topCells = cellsOfNodeCollection(topNodes);
		bottomCells = cellsOfNodeCollection(bottomNodes);
		leftCells = cellsOfNodeCollection(leftNodes);
		rightCells = cellsOfNodeCollection(rightNodes);

//		// Construction of boundary face sets
//		topFaces = new int[topCells.length];
//		bottomFaces = new int[bottomCells.length];
//		leftFaces = new int[leftCells.length];
//		rightFaces = new int[rightCells.length];
//
//		for (int i=0 ; i<topCells.length ; i++) topFaces[i] = getTopFaceOfCell(topCells[i]);
//		for (int i=0 ; i<bottomCells.length ; i++) bottomFaces[i] = getBottomFaceOfCell(bottomCells[i]);
//		for (int i=0 ; i<leftCells.length ; i++) leftFaces[i] = getLeftFaceOfCell(leftCells[i]);
//		for (int i=0 ; i<rightCells.length ; i++) rightFaces[i] = getRightFaceOfCell(rightCells[i]);
	}

	public MeshGeometry getGeometry() { return geometry; }

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

	public int getNbInnerCells() { return innerCells.length;}
	public int[] getInnerCells() { return innerCells; }
	public int getNbOuterCells() { return outerCells.length;}
	public int[] getOuterCells() { return outerCells; }
	public int getNbTopCells() { return topCells.length; }
	public int[] getTopCells() { return topCells; }
	public int getNbBottomCells() { return bottomCells.length; }
	public int[] getBottomCells() { return bottomCells; }
	public int getNbLeftCells() { return leftCells.length; }
	public int[] getLeftCells() { return leftCells; }
	public int getNbRightCells() { return rightCells.length; }
	public int[] getRightCells() { return rightCells; }

	public int getNbTopFaces() { return topFaces.length; }
	public int[] getTopFaces() { return topFaces; }
	public int getNbBottomFaces() { return bottomFaces.length; }
	public int[] getBottomFaces() { return bottomFaces; }
	public int getNbLeftFaces() { return leftFaces.length; }
	public int[] getLeftFaces() { return leftFaces; }
	public int getNbRightFaces() { return rightFaces.length; }
	public int[] getRightFaces() { return rightFaces; }
	public int getNbOuterFaces() { return outerFaces.length; }
	public int[] getOuterFaces() { return outerFaces; }
	public int getNbInnerFaces() { return innerFaces.length; }
	public int[] getInnerFaces() { return innerFaces; }
	public int getNbInnerHorizontalFaces() { return innerHorizontalFaces.length; }
	public int[] getInnerHorizontalFaces() { return innerHorizontalFaces; }
	public int getNbInnerVerticalFaces() { return innerVerticalFaces.length; }
	public int[] getInnerVerticalFaces() { return innerVerticalFaces; }

	// TODO: Temporary until single item is available in grammar
	public int getNbTopLeftNode() { return 1; }
	public int[] getTopLeftNode() { return new int[] {topLeftNode}; }
	// TODO: Temporary until single item is available in grammar
	public int getNbTopRightNode() { return 1; }
	public int[] getTopRightNode() { return new int[] {topRightNode}; }
	// TODO: Temporary until single item is available in grammar
	public int getNbBottomLeftNode() { return 1; }
	public int[] getBottomLeftNode() { return new int[] {bottomLeftNode}; }
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

	public int getBackCell(int faceId)
	{
		int[] cells = getCellsOfFace(faceId);
		if ( cells.length < 2) 
			throw new RuntimeException("Error in getBackCell(" + faceId + "): please consider using this method with inner face only.");
		else
			return cells[0];
	}

	public int getFrontCell(int faceId) 
	{
		int[] cells = getCellsOfFace(faceId);
		if ( cells.length < 2) 
			throw new RuntimeException("Error in getFrontCell(" + faceId + "): please consider using this method with inner face only.");
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

	public int getTopCell(int cellId)
	{
		Map.Entry<Integer, Integer> index = id2IndexCell(cellId);
		Integer i = index.getKey();
		Integer j = index.getValue();
		if (i == yQuads - 1) return cellId;
		return index2IdCell(i+1, j);
	}

	public int getBottomCell(int cellId)
	{
		Map.Entry<Integer, Integer> index = id2IndexCell(cellId);
		Integer i = index.getKey();
		Integer j = index.getValue();
		if (i == 0) return cellId;
		return index2IdCell(i-1, j);
	}

	public int getLeftCell(int cellId)
	{
		Map.Entry<Integer, Integer> index = id2IndexCell(cellId);
		Integer i = index.getKey();
		Integer j = index.getValue();
		if (j == 0) return cellId;
		return index2IdCell(i, j-1);
	}

	public int getRightCell(int cellId)
	{
		Map.Entry<Integer, Integer> index = id2IndexCell(cellId);
		Integer i = index.getKey();
		Integer j = index.getValue();
		if (j == xQuads-1) return cellId;
		return index2IdCell(i, j+1);
	}

	public int getBottomFaceNeighbour(int faceId)
	{
		  return (faceId - 2 * xQuads - 1);
	}

	public int getBottomLeftFaceNeighbour(int faceId)
	{
		Edge[] edges = geometry.getEdges();
		if(isVerticalEdge(edges[faceId]))
			return (faceId - 3);
		else
			return (faceId - 2 * xQuads);
	}

	public int getBottomRightFaceNeighbour(int faceId)
	{
		Edge[] edges = geometry.getEdges();
		if (isVerticalEdge(edges[faceId]))
		    return (faceId - 1);
		else  // horizontal
		    return ((faceId + 1) - 2 * xQuads + 1);
	}

	public int getTopFaceNeighbour(int faceId)
	{
		return (faceId + 2 * xQuads + 1);
	}

	public int getTopLeftFaceNeighbour(int faceId)
	{
		Edge[] edges = geometry.getEdges();
		if (isVerticalEdge(edges[faceId]))
			return ((faceId - 3) + 2 * xQuads + 1);
		else  // horizontal
		    return (faceId + 1);
	}

	public int getTopRightFaceNeighbour(int faceId)
	{
		Edge[] edges = geometry.getEdges();
		if (isVerticalEdge(edges[faceId]))
		    return ((faceId - 1) + 2 * xQuads + 1);
		  else  // horizontal
		    return (faceId + 3);
	}

	public int getRightFaceNeighbour(int faceId)
	{
		 return (faceId + 2);
	}

	public int getLeftFaceNeighbour(int faceId)
	{
		return (faceId - 2);
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
		Map.Entry<Integer, Integer> index1 = id2IndexNode(edge.getNodeIds()[0]);
		Integer i1 = index1.getKey();
		Integer j1 = index1.getValue();
		Map.Entry<Integer, Integer> index2 = id2IndexNode(edge.getNodeIds()[1]);
		Integer i2 = index2.getKey();
		Integer j2 = index2.getValue();
		  // If nodes are located on the same boundary, then the face is an outer one
		  if ((i1 == 0 && i2 == 0) || (i1 == yQuads && i2 == yQuads) ||
		      (j1 == 0 && j2 == 0) || (j1 == xQuads && j2 == xQuads))
		    return false;
		  // else it's an inner one
		  return true;
	}

	private boolean isVerticalEdge(Edge edge)
	{
		  return (edge.getNodeIds()[0] == edge.getNodeIds()[1] + xQuads + 1 ||
				  edge.getNodeIds()[1] == edge.getNodeIds()[0] + xQuads + 1);
	}

	private boolean isHorizontalEdge(Edge edge)
	{
		  return (edge.getNodeIds()[0] == edge.getNodeIds()[1] + 1 ||
				  edge.getNodeIds()[1] == edge.getNodeIds()[0] + 1);
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
