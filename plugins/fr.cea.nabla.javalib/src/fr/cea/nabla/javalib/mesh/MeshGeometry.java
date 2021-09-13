/**
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 * 
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 */
package fr.cea.nabla.javalib.mesh;

public class MeshGeometry 
{
	private  double[][] nodes;
	private  Edge[] edges;
	private  Quad[] quads;

	public MeshGeometry( double[][] nodes,  Edge[] edges,  Quad[] quads) {
		this.nodes = nodes;
		this.edges = edges;
		this.quads = quads;
	}

	public double[][] getNodes() 
	{
		return this.nodes;
	}

	public Edge[] getEdges() 
	{
		return this.edges;
	}

	public Quad[] getQuads() 
	{
		return this.quads;
	}

	public void dump()
	{
		System.out.println("Mesh Geometry");
		String nodesList = "";
		String edgesList = "";
		String quadsList = "";
		for (int i = 0; i < nodes.length; i++)
			nodesList += "[" + nodes[i][0] + ", " + nodes[i][1] + "]" + (i < nodes.length-1 ? ", " : "");
		System.out.println("  nodes (" + nodes.length + ") : " + nodesList);
		for (int i = 0; i < edges.length; i++)
			edgesList += edges[i].toString() + (i < edges.length-1 ? ", " : "");
		System.out.println("  edges (" + edges.length + ") : " + edgesList);
		for (int i = 0; i < quads.length; i++)
			quadsList += quads[i].toString() + (i < quads.length-1 ? ", " : "");
		System.out.println("  quads (" + quads.length + ") : " + quadsList);
	}
}
