/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.javalib.mesh

import java.util.LinkedHashMap
import org.eclipse.xtend.lib.annotations.Accessors

class VtkFileContent
{
	@Accessors val int iteration
	@Accessors val double time
	@Accessors val double[][] nodes
	@Accessors val Quad[] cells

	@Accessors(PROTECTED_GETTER) val cellScalars = new LinkedHashMap<String, double[]>
	@Accessors(PROTECTED_GETTER) val nodeScalars = new LinkedHashMap<String, double[]>
	@Accessors(PROTECTED_GETTER) val cellVectors = new LinkedHashMap<String, double[][]>
	@Accessors(PROTECTED_GETTER) val nodeVectors = new LinkedHashMap<String, double[][]>

	new(int iteration, double time, double[][] nodes, Quad[] cells)
	{
		this.iteration = iteration
		this.time = time
		this.nodes = nodes
		this.cells = cells
	}

	def void addCellVariable(String name, double[] data) { cellScalars.put(name, data) }
	def void addCellVariable(String name, double[][] data) { cellVectors.put(name, data) }
	def void addNodeVariable(String name, double[] data) { nodeScalars.put(name, data) }
	def void addNodeVariable(String name, double[][] data) { nodeVectors.put(name, data) }

	protected def boolean hasCellData() { !(cellScalars.empty && cellVectors.empty) }
	protected def boolean hasNodeData() { !(nodeScalars.empty && nodeVectors.empty) }
}