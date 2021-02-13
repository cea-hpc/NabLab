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

import java.util.LinkedHashMap;

import fr.cea.nabla.javalib.linearalgebra.Vector;

public class VtkFileContent
{
	private  int iteration;
	private  double time;
	private  double[][] nodes;
	private  Quad[] cells;

	private  LinkedHashMap<String, double[]> cellScalars = new LinkedHashMap<String, double[]>();
	private  LinkedHashMap<String, double[]> nodeScalars = new LinkedHashMap<String, double[]>();
	private  LinkedHashMap<String, double[][]> cellVectors = new LinkedHashMap<String, double[][]>();
	private  LinkedHashMap<String, double[][]> nodeVectors = new LinkedHashMap<String, double[][]>();

	public VtkFileContent(int iteration, double time, double[][] nodes, Quad[] cells)
	{
		this.iteration = iteration;
		this.time = time;
		this.nodes = nodes;
		this.cells = cells;
	}

	public void addCellVariable(String name, double[] data) { cellScalars.put(name, data); }
	public void addCellVariable(String name, Vector data) { cellScalars.put(name, data.getNativeVector().toArray()); }
	public void addCellVariable(String name, double[][] data) { cellVectors.put(name, data); }
	public void addNodeVariable(String name, double[] data) { nodeScalars.put(name, data); }
	public void addNodeVariable(String name, Vector data) { nodeScalars.put(name, data.getNativeVector().toArray()); }
	public void addNodeVariable(String name, double[][] data) { nodeVectors.put(name, data); }

	protected boolean hasCellData()
	{
		return (!(cellScalars.isEmpty() && cellVectors.isEmpty()));
	}

	protected boolean hasNodeData()
	{
		return (!(nodeScalars.isEmpty() && nodeVectors.isEmpty()));
	}

	public int getIteration() { return iteration; }
	public double getTime() { return time; }
	public double[][] getNodes() { return nodes; }
	public Quad[] getCells() { return cells; }

	protected LinkedHashMap<String, double[]> getCellScalars() { return cellScalars; }
	protected LinkedHashMap<String, double[]> getNodeScalars() { return nodeScalars; }
	protected LinkedHashMap<String, double[][]> getCellVectors() { return cellVectors; }
	protected LinkedHashMap<String, double[][]> getNodeVectors() { return nodeVectors; }
}
