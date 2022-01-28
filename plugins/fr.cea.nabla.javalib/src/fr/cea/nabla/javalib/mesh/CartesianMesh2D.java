/**
 * Copyright (c) 2022 CEA
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
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

public class CartesianMesh2D
{
	// NODES
	public static String AllNodes = "AllNodes";
	public static String InnerNodes = "InnerNodes";
	public static String OuterNodes = "OuterNodes";
	public static String TopNodes = "TopNodes";
	public static String BottomNodes = "BottomNodes";
	public static String LeftNodes = "LeftNodes";
	public static String RightNodes = "RightNodes";
	public static String TopLeftNode = "TopLeftNode";
	public static String TopRightNode = "TopRightNode";
	public static String BottomLeftNode = "BottomLeftNode";
	public static String BottomRightNode = "BottomRightNode";

	// CELLS
	public static String AllCells = "AllCells";
	public static String InnerCells = "InnerCells";
	public static String OuterCells = "OuterCells";
	public static String TopCells = "TopCells";
	public static String BottomCells = "BottomCells";
	public static String LeftCells = "LeftCells";
	public static String RightCells = "RightCells";

	// FACES
	public static String AllFaces = "AllFaces";
	public static String InnerFaces = "InnerFaces";
	public static String OuterFaces = "OuterFaces";
	public static String InnerHorizontalFaces = "InnerHorizontalFaces";
	public static String InnerVerticalFaces = "InnerVerticalFaces";
	public static String TopFaces = "TopFaces";
	public static String BottomFaces = "BottomFaces";
	public static String LeftFaces = "LeftFaces";
	public static String RightFaces = "RightFaces";

	private MeshGeometry geometry;
	private int nbXQuads;
	private int nbYQuads;
	private HashMap<String, int[]> groups = new HashMap<String, int[]>();

	public CartesianMesh2D(int nbXQuads, int nbYQuads, double xSize, double ySize)
	{
		create(nbXQuads, nbYQuads, xSize, ySize);
	}

	/** Constructor for Json creation */
	public CartesianMesh2D() {}

	public void jsonInit(final String jsonContent)
	{
		final JsonObject o = JsonParser.parseString(jsonContent).getAsJsonObject();
		assert(o.has("nbXQuads"));
		final JsonElement valueof_nbXQuads = o.get("nbXQuads");
		assert(valueof_nbXQuads.isJsonPrimitive());
		int nbXQuads = valueof_nbXQuads.getAsJsonPrimitive().getAsInt();
		assert(o.has("nbYQuads"));
		final JsonElement valueof_nbYQuads = o.get("nbYQuads");
		assert(valueof_nbYQuads.isJsonPrimitive());
		int nbYQuads = valueof_nbYQuads.getAsJsonPrimitive().getAsInt();
		assert(o.has("xSize"));
		final JsonElement valueof_xSize = o.get("xSize");
		assert(valueof_xSize.isJsonPrimitive());
		double xSize = valueof_xSize.getAsJsonPrimitive().getAsDouble();
		assert(o.has("ySize"));
		final JsonElement valueof_ySize = o.get("ySize");
		assert(valueof_ySize.isJsonPrimitive());
		double ySize = valueof_ySize.getAsJsonPrimitive().getAsDouble();

		create(nbXQuads, nbYQuads, xSize, ySize);
	}

	public MeshGeometry getGeometry() { return geometry; }

	public int getNbNodes() { return geometry.getNodes().length; }
	public int getNbCells() { return geometry.getQuads().length; }
	public int getNbFaces() { return geometry.getEdges().length; }

	public int[] getNodes() { return groups.get(AllNodes); }
	public int[] getCells() { return groups.get(AllCells); }
	public int[] getFaces() { return groups.get(AllFaces); }

	public int[] getGroup(String name)
	{
		int[] group = groups.get(name);
		if (group == null)
			throw new RuntimeException("Invalid item group: " + name);
		return group;
	}

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
		if (i < nbYQuads && j < nbXQuads) cellsOfNode.add(index2IdCell(i, j));
		if (i < nbYQuads && j > 0) cellsOfNode.add(index2IdCell(i, j-1));
		if (i > 0 && j < nbXQuads) cellsOfNode.add(index2IdCell(i-1, j));
		if (i > 0 && j > 0) cellsOfNode.add(index2IdCell(i-1, j-1));
		Collections.sort(cellsOfNode);
		return cellsOfNode.stream().mapToInt(x->x).toArray();
	}

	public int[] getCellsOfFace(int faceId)
	{
		int i_f = (faceId / ((2 * nbXQuads) + 1));
		int k_f = (faceId - (i_f * ((2 * nbXQuads) + 1)));
		ArrayList<Integer> cellsOfFace = new ArrayList<Integer>();
		if (i_f < nbYQuads) // all except upper bound faces
		{
			if (k_f == (2 * nbXQuads))
				cellsOfFace.add(index2IdCell(i_f, nbXQuads - 1));
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
		if (i < nbYQuads - 1) neighbourCells.add(index2IdCell(i+1, j));
		if (j >= 1) neighbourCells.add(index2IdCell(i, j-1));
		if (j < (nbXQuads - 1)) neighbourCells.add(index2IdCell(i, j+1));
		Collections.sort(neighbourCells);
		return neighbourCells.stream().mapToInt(x->x).toArray();
	}

	public int[] getFacesOfCell(int cellId)
	{
		Map.Entry<Integer, Integer> index = id2IndexCell(cellId);
		int i = index.getKey();
		int j = index.getValue();
		int bottomFace = (2 * j + i * (2 * nbXQuads + 1));
		int leftFace = bottomFace + 1;
		int rightFace = bottomFace + (j == nbXQuads-1 ? 2 : 3);
		int topFace = bottomFace + (i < nbYQuads-1 ? 2 * nbXQuads + 1 : 2 * nbXQuads + 1 - j);
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
		int bottomFace = 2 * j + i * (2 * nbXQuads + 1);
		int topFace = bottomFace + (i < nbYQuads - 1 ? 2 * nbXQuads + 1 :2 * nbXQuads + 1 - j);
		return topFace;
	}

	public int getBottomFaceOfCell(int cellId)
	{
		Map.Entry<Integer, Integer> index = id2IndexCell(cellId);
		int i = index.getKey();
		int j = index.getValue();
		int bottomFace = 2 * j + i * (2 * nbXQuads + 1);
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
		int bottomFace = 2 * j + i * (2 * nbXQuads + 1);
		int rightFace = bottomFace + (j == nbXQuads - 1 ? 2 : 3);
		return rightFace;
	}

	public int getTopCell(int cellId)
	{
		Map.Entry<Integer, Integer> index = id2IndexCell(cellId);
		Integer i = index.getKey();
		Integer j = index.getValue();
		if (i == nbYQuads - 1) return cellId;
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
		if (j == nbXQuads-1) return cellId;
		return index2IdCell(i, j+1);
	}

	public int getBottomFaceNeighbour(int faceId)
	{
		  return (faceId - (2 * nbXQuads + 1));
	}

	public int getBottomLeftFaceNeighbour(int faceId)
	{
		Edge[] edges = geometry.getEdges();
		if(isVerticalEdge(edges[faceId]))
			return (faceId - 3);
		else
			return ((faceId + 1) - (2 * nbXQuads + 1));
	}

	public int getBottomRightFaceNeighbour(int faceId)
	{
		Edge[] edges = geometry.getEdges();
		if (isVerticalEdge(edges[faceId]))
		    return (faceId - 1);
		else  // horizontal
		    return ((faceId + 3) - (2 * nbXQuads + 1));
	}

	public int getTopFaceNeighbour(int faceId)
	{
		return (faceId + (2 * nbXQuads + 1));
	}

	public int getTopLeftFaceNeighbour(int faceId)
	{
		Edge[] edges = geometry.getEdges();
		if (isVerticalEdge(edges[faceId]))
			return ((faceId - 3) + (2 * nbXQuads + 1));
		else  // horizontal
			return (faceId + 1);
	}

	public int getTopRightFaceNeighbour(int faceId)
	{
		Edge[] edges = geometry.getEdges();
		if (isVerticalEdge(edges[faceId]))
			return ((faceId - 1) + (2 * nbXQuads + 1));
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
		dumpItemCollection("	inner nodes	:	", getGroup(InnerNodes));
		dumpItemCollection("	top nodes	:	", getGroup(TopNodes));
		dumpItemCollection("	bottom nodes	:	", getGroup(BottomNodes));
		dumpItemCollection("	left nodes	:	", getGroup(LeftNodes));
		dumpItemCollection("	right nodes	:	", getGroup(RightNodes));
		dumpItemCollection("	outer faces	:	", getGroup(OuterFaces));
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
		if ((i1 == 0 && i2 == 0) || (i1 == nbYQuads && i2 == nbYQuads) ||
				(j1 == 0 && j2 == 0) || (j1 == nbXQuads && j2 == nbXQuads))
			return false;
		// else it's an inner one
		return true;
	}

	private boolean isVerticalEdge(Edge edge)
	{
		return (edge.getNodeIds()[0] == edge.getNodeIds()[1] + nbXQuads + 1 ||
				edge.getNodeIds()[1] == edge.getNodeIds()[0] + nbXQuads + 1);
	}

	private boolean isHorizontalEdge(Edge edge)
	{
		return (edge.getNodeIds()[0] == edge.getNodeIds()[1] + 1 ||
				edge.getNodeIds()[1] == edge.getNodeIds()[0] + 1);
	}

	private int index2IdCell(int i, int j)
	{
		return ((i * nbXQuads) + j);
	}

	private Map.Entry<Integer, Integer> id2IndexCell(int cellId)
	{
		int i = Math.abs((cellId / nbXQuads));
		int j = (cellId % nbXQuads);
		return Map.entry(i, j);
	}

	private Map.Entry<Integer, Integer> id2IndexNode(int nodeId)
	{
		int i = Math.abs((nodeId / (nbXQuads + 1)));
		int j = (nodeId % (nbXQuads + 1));
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

	private void create(int nbXQuads, int nbYQuads, double xSize, double ySize)
	{
		if (nbXQuads == -1 || nbYQuads == -1 || xSize == -1 || ySize == -1)
			throw new RuntimeException("Mesh attributes uninitialized");

		this.nbXQuads = nbXQuads;
		this.nbYQuads = nbYQuads;

		double[][] nodes = new double[(nbXQuads + 1) * (nbYQuads + 1)][2];
		Quad[] quads = new Quad[nbXQuads * nbYQuads];
		Edge[] edges = new Edge[2 * quads.length + nbXQuads + nbYQuads];

		int[] outerNodes = new int[2 * (nbXQuads + nbYQuads)];
		int[] innerNodes = new int[nodes.length - outerNodes.length];
		int[] topNodes = new int[nbXQuads + 1];
		int[] bottomNodes = new int[nbXQuads + 1];
		int[] leftNodes = new int[nbYQuads + 1];
		int[] rightNodes = new int[nbYQuads + 1];

		int[] innerCells = new int[(nbXQuads - 2)*(nbYQuads - 2)];
		int[] outerCells = new int[2 * nbXQuads + 2 * (nbYQuads - 2)];

		int nodeId = 0;
		int outerNodeId = 0;
		int innerNodeId = 0;
		int topNodeId = 0;
		int bottomNodeId = 0;
		int leftNodeId = 0;
		int rightNodeId = 0;

		// node creation
		for (int j = 0; j <=nbYQuads; j++)
			for (int i = 0; i<=nbXQuads; i++)
			{
				nodes[nodeId][0] = xSize * i;
				nodes[nodeId][1] = ySize * j;
				if (i!=0 && j!=0 && i!=nbXQuads && j!=nbYQuads)
					innerNodes[innerNodeId++] = nodeId;
				else
				{
					outerNodes[outerNodeId++] = nodeId;
					if (j==0) bottomNodes[bottomNodeId++] =nodeId;
					if (j==nbYQuads) topNodes[topNodeId++] = nodeId;
					if (i==0) leftNodes[leftNodeId++] = nodeId;
					if (i==nbXQuads) rightNodes[rightNodeId++] = nodeId;
				}
				nodeId++;
		}

		// edge creation
		int nbXNodes = nbXQuads+1;
		int edgeId = 0;
		for (int i = 0; i<nodes.length; i++)
		{
			int rightNodeIndex = i+1;
			if (rightNodeIndex%nbXNodes!=0) edges[edgeId++] = new Edge(i, rightNodeIndex);
			int belowNodeIndex = i + nbXNodes;
			if (belowNodeIndex<nodes.length) edges[edgeId++] = new Edge(i, belowNodeIndex);
		}

		// quad creation
		int quadId = 0;
		int innerCellId = 0;
		int outerCellId = 0;
		for (int j = 0; j < nbYQuads; j++)
			for (int i = 0; i < nbXQuads; i++)
			{
				if( (i != 0) && (i != nbXQuads - 1) && (j != 0) && (j!= nbYQuads - 1) )
					innerCells[innerCellId++] = quadId;
				else
					outerCells[outerCellId++] = quadId;

				int upperLeftNodeIndex = (j*nbXNodes)+i;
				int lowerLeftNodeIndex = upperLeftNodeIndex + nbXNodes;
				quads[quadId++] = new Quad(upperLeftNodeIndex, upperLeftNodeIndex+1, lowerLeftNodeIndex+1, lowerLeftNodeIndex);
			}

		geometry = new MeshGeometry(nodes, edges, quads);

		ArrayList<Integer> outFaces = new ArrayList<Integer>();
		ArrayList<Integer> inFaces = new ArrayList<Integer>();
		ArrayList<Integer> inVFaces = new ArrayList<Integer>();
		ArrayList<Integer> inHFaces = new ArrayList<Integer>();
		ArrayList<Integer> tFaces = new ArrayList<Integer>();
		ArrayList<Integer> bFaces = new ArrayList<Integer>();
		ArrayList<Integer> lFaces = new ArrayList<Integer>();
		ArrayList<Integer> rFaces = new ArrayList<Integer>();

		for (edgeId = 0; edgeId <edges.length; edgeId ++)
		{
			// Top boundary faces
			if (edgeId >= 2 * nbXQuads * nbYQuads + nbYQuads) tFaces.add(edgeId);
			// Bottom boundary faces
			if ((edgeId < 2 * nbXQuads) && (edgeId % 2 == 0)) bFaces.add(edgeId);
			// Left boundary faces
			if ((edgeId % (2 * nbXQuads + 1) == 1) && (edgeId < (2 * nbXQuads + 1) * nbYQuads)) lFaces.add(edgeId);
			// Right boundary faces
			if (edgeId % (2 * nbXQuads + 1) == 2 * nbXQuads) rFaces.add(edgeId);

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

		// NODES
		groups.put(AllNodes, IntStream.range(0, nodes.length).toArray());
		groups.put(InnerNodes, innerNodes);
		groups.put(OuterNodes, outerNodes);
		groups.put(TopNodes, topNodes);
		groups.put(BottomNodes, bottomNodes);
		groups.put(LeftNodes, leftNodes);
		groups.put(RightNodes, rightNodes);
		groups.put(TopLeftNode, new int[] { (nbXQuads + 1) * nbYQuads });
		groups.put(TopRightNode, new int[] { (nbXQuads + 1) * (nbYQuads +1) - 1 });
		groups.put(BottomLeftNode, new int[] { 0 });
		groups.put(BottomRightNode, new int[] { nbXQuads });

		// CELLS
		groups.put(AllCells, IntStream.range(0, quads.length).toArray());
		groups.put(InnerCells, innerCells);
		groups.put(OuterCells, outerCells);
		groups.put(TopCells, cellsOfNodeCollection(topNodes));
		groups.put(BottomCells, cellsOfNodeCollection(bottomNodes));
		groups.put(LeftCells, cellsOfNodeCollection(leftNodes));
		groups.put(RightCells, cellsOfNodeCollection(rightNodes));

		// FACES
		groups.put(AllFaces, IntStream.range(0, edges.length).toArray());
		groups.put(InnerFaces, inFaces.stream().mapToInt(x->x).toArray());
		groups.put(OuterFaces, outFaces.stream().mapToInt(x->x).toArray());
		groups.put(InnerHorizontalFaces, inHFaces.stream().mapToInt(x->x).toArray());
		groups.put(InnerVerticalFaces, inVFaces.stream().mapToInt(x->x).toArray());
		groups.put(TopFaces, tFaces.stream().mapToInt(x->x).toArray());
		groups.put(BottomFaces, bFaces.stream().mapToInt(x->x).toArray());
		groups.put(LeftFaces, lFaces.stream().mapToInt(x->x).toArray());
		groups.put(RightFaces, rFaces.stream().mapToInt(x->x).toArray());
	}
}
