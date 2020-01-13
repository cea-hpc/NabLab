/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.tests

import com.google.inject.Inject
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.ir.ir.Job
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith

import static extension fr.cea.nabla.ir.IrModuleExtensions.*
import static extension fr.cea.nabla.ir.JobExtensions.*
import static extension fr.cea.nabla.ir.generator.IteratorExtensions.*
import static extension fr.cea.nabla.ir.generator.IteratorRefExtensions.*

@RunWith(XtextRunner)
@InjectWith(NablaInjectorProvider)
class IteratorExtensionsTest
{
	@Inject CompilationChainHelper compilationHelper

	var Job j1; Job j2; Job j3; Job j4;	Job j5;
	var Iterator j1_j; Iterator j2_j; Iterator j2_r; Iterator j3_j; Iterator j3_r;
	var Iterator j4_j; Iterator j4_r; Iterator j5_j1; Iterator j5_j2; Iterator j5_cf;

	var model =
	'''
	module Test;
	
	with Math.*;

	items { cell, node, face }
	
	set cells: → {cell};
	set nodes: → {node};
	set faces: → {face};
	set nodesOfCell: cell → {node};
	set cellsOfNode: node → {cell};
	set neighbourCells: cell → {cell};
	set commonFace: cell × cell → face;
	
	def ∑: (0.0, ℝ) → ℝ;
	def ∑: x | (0.0, ℝ[x]) → ℝ[x];
	def ∑: x | (0.0, ℝ[x, x]) → ℝ[x, x];
	'''
	+ TestUtils::mandatoryOptions + TestUtils::simulationVariables +
	'''
	ℝ x{cells}, f{cells}, Cjr{cells,nodesOfCell};
	ℝ[2] u{cells};
	ℝ surface{faces};
	ℝ a;
	
	J1: ∀j∈cells(), x{j} = 2.0;
	J2: ∀j∈cells(), ∀r∈nodesOfCell(j), Cjr{j,r} = 3.0;
	J3: ∀r∈nodes(), ∀j∈cellsOfNode(r), Cjr{j,r} = 1.0;
	J4: ∀j∈cells(), u{j} = 0.5 * ∑{r∈nodesOfCell(j)}(X{r} - X{r+1});
	J5: ∀j1∈cells(), f{j1} = a * ∑{j2∈neighbourCells(j1), cf=commonFace(j1,j2)}( (x{j2}-x{j1}) / surface{cf});	
	'''

	var genModel = TestUtils::testGenModel

	@Before
	def void setUpBefore() throws Exception
	{
		val irModule = compilationHelper.getIrModule(model, genModel)

		j1 = irModule.getJobByName("J1")
		j2 = irModule.getJobByName("J2")
		j3 = irModule.getJobByName("J3")
		j4 = irModule.getJobByName("J4")
		j5 = irModule.getJobByName("J5")

		j1_j = j1.getIteratorByName("j")
		j2_j = j2.getIteratorByName("j")
		j2_r = j2.getIteratorByName("r")
		j3_j = j3.getIteratorByName("j")
		j3_r = j3.getIteratorByName("r")
		j4_j = j4.getIteratorByName("j")
		j4_r = j4.getIteratorByName("r")
		j5_j1 = j5.getIteratorByName("j1")
		j5_j2 = j5.getIteratorByName("j2")
		j5_cf = j5.getIteratorByName("cf")
	}

	@Test
	def void testGetContainerName()
	{
		Assert.assertEquals("cells", j1_j.containerName)

		Assert.assertEquals("cells", j2_j.containerName)
		Assert.assertEquals("nodesOfCellJ", j2_r.containerName)

		Assert.assertEquals("nodes", j3_r.containerName)
		Assert.assertEquals("cellsOfNodeR", j3_j.containerName)

		Assert.assertEquals("cells", j4_j.containerName)
		Assert.assertEquals("nodesOfCellJ", j4_r.containerName)

		Assert.assertEquals("cells", j5_j1.containerName)
		Assert.assertEquals("neighbourCellsJ1", j5_j2.containerName)
		Assert.assertEquals("commonFaceJ1J2", j5_cf.containerName)
	}

	@Test
	def void testGetIndexName()
	{
		Assert.assertEquals("jCells", j1_j.indexName)

		Assert.assertEquals("jCells", j2_j.indexName)
		Assert.assertEquals("rNodesOfCellJ", j2_r.indexName)

		Assert.assertEquals("rNodes", j3_r.indexName)
		Assert.assertEquals("jCellsOfNodeR", j3_j.indexName)

		Assert.assertEquals("jCells", j4_j.indexName)
		Assert.assertEquals("rNodesOfCellJ", j4_r.indexName)

		Assert.assertEquals("j1Cells", j5_j1.indexName)
		Assert.assertEquals("j2NeighbourCellsJ1", j5_j2.indexName)
		Assert.assertEquals("cfCommonFaceJ1J2", j5_cf.indexName)
	}

	@Test
	def void testGetNeededIds()
	{
		Assert.assertArrayEquals(#[], j1_j.neededIds.map[idName])

		Assert.assertArrayEquals(#["jId"], j2_j.neededIds.map[idName])
		Assert.assertArrayEquals(#[], j2_r.neededIds.map[idName])

		Assert.assertArrayEquals(#["jId"], j3_j.neededIds.map[idName])
		Assert.assertArrayEquals(#["rId"], j3_r.neededIds.map[idName])

		Assert.assertArrayEquals(#["jId"], j4_j.neededIds.map[idName])
		Assert.assertArrayEquals(#["rId", "rPlus1Id"], j4_r.neededIds.map[idName])

		Assert.assertArrayEquals(#["j1Id"], j5_j1.neededIds.map[idName])
		Assert.assertArrayEquals(#["j2Id"], j5_j2.neededIds.map[idName])
		Assert.assertArrayEquals(#["cfId"], j5_cf.neededIds.map[idName])
	}

	@Test
	def void testGetNeededIndices()
	{
		Assert.assertArrayEquals(#[], j1_j.neededIndices.map[indexName])

		Assert.assertArrayEquals(#[], j2_j.neededIndices.map[indexName])
		Assert.assertArrayEquals(#[], j2_r.neededIndices.map[indexName])

		Assert.assertArrayEquals(#[], j3_r.neededIndices.map[indexName])
		Assert.assertArrayEquals(#["jCells", "rNodesOfCellJ"], j3_j.neededIndices.map[indexName])

		Assert.assertArrayEquals(#[], j4_j.neededIndices.map[indexName])
		Assert.assertArrayEquals(#["rNodes", "rPlus1Nodes"], j4_r.neededIndices.map[indexName])

		Assert.assertArrayEquals(#[], j5_j1.neededIndices.map[indexName])
		Assert.assertArrayEquals(#["j2Cells"], j5_j2.neededIndices.map[indexName])
		Assert.assertArrayEquals(#["cfFaces"], j5_cf.neededIndices.map[indexName])
	}
}
