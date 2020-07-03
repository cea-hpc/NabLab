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

public class VtkFileContent {
	private  int iteration;
	private  double time;
	private  double[][] nodes;
	private  Quad[] cells;

	private  LinkedHashMap<String, double[]> cellScalars = new LinkedHashMap<String, double[]>();
	private  LinkedHashMap<String, double[]> nodeScalars = new LinkedHashMap<String, double[]>();
	private  LinkedHashMap<String, double[][]> cellVectors = new LinkedHashMap<String, double[][]>();
	private  LinkedHashMap<String, double[][]> nodeVectors = new LinkedHashMap<String, double[][]>();

	public VtkFileContent( int iteration,  double time,  double[][] nodes,  Quad[] cells) {
		this.iteration = iteration;
		this.time = time;
		this.nodes = nodes;
		this.cells = cells;
	}

	public void addCellVariable( String name,  double[] data) {
		this.cellScalars.put(name, data);
	}

	public void addCellVariable( String name,  double[][] data) {
		this.cellVectors.put(name, data);
	}

	public void addNodeVariable( String name,  double[] data) {
		this.nodeScalars.put(name, data);
	}

	public void addNodeVariable( String name,  double[][] data) {
		this.nodeVectors.put(name, data);
	}

	protected boolean hasCellData() {
		return (!(this.cellScalars.isEmpty() && this.cellVectors.isEmpty()));
	}

	protected boolean hasNodeData() {
		return (!(this.nodeScalars.isEmpty() && this.nodeVectors.isEmpty()));
	}

	public int getIteration() {
		return this.iteration;
	}

	public double getTime() {
		return this.time;
	}

	public double[][] getNodes() {
		return this.nodes;
	}

	public Quad[] getCells() {
		return this.cells;
	}

	protected LinkedHashMap<String, double[]> getCellScalars() {
		return this.cellScalars;
	}

	protected LinkedHashMap<String, double[]> getNodeScalars() {
		return this.nodeScalars;
	}

	protected LinkedHashMap<String, double[][]> getCellVectors() {
		return this.cellVectors;
	}

	protected LinkedHashMap<String, double[][]> getNodeVectors() {
		return this.nodeVectors;
	}
}
