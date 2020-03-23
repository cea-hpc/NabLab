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
import fr.cea.nabla.NablaModuleExtensions
import fr.cea.nabla.generator.ir.IrItemIdDefinitionFactory
import fr.cea.nabla.generator.ir.IrItemIndexDefinitionFactory
import fr.cea.nabla.generator.ir.IrItemIndexFactory
import fr.cea.nabla.nabla.Job
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.SpaceIterator
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith

import static extension fr.cea.nabla.ConnectivityCallExtensions.*
import fr.cea.nabla.nabla.SingletonDefinition
import fr.cea.nabla.nabla.ItemDefinition

@RunWith(XtextRunner)
@InjectWith(NablaInjectorProvider)
class IteratorExtensionsTest
{
	@Inject extension TestUtils
	@Inject extension NablaModuleExtensions
	@Inject extension IrItemIndexFactory
	@Inject extension IrItemIdDefinitionFactory
	@Inject extension IrItemIndexDefinitionFactory
	@Inject ParseHelper<NablaModule> parseHelper

	Job j1; Job j2; Job j3; Job j4; Job j5; Job j6;
	SpaceIterator j1_j; SpaceIterator j2_j; SpaceIterator j2_r; SpaceIterator j3_j; SpaceIterator j3_r;
	SpaceIterator j4_j; SpaceIterator j4_r; SpaceIterator j5_j1; SpaceIterator j5_j2; SingletonDefinition j5_cf;
	ItemDefinition j6_cf;

	@Before
	def void setUpBefore() throws Exception
	{
		val model =
		'''
		module Test;
		
		with Math.*;

		itemtypes { cell, node, face }
		
		set cells: → {cell};
		set nodes: → {node};
		set faces: → {face};
		set nodesOfCell: cell → {node};
		set cellsOfNode: node → {cell};
		set neighbourCells: cell → {cell};
		item commonFace: cell × cell → face;

		def ∑: 0.0, ℝ, (a, b) → return a + b;
		def ∑: x | 0.0, ℝ[x], (a, b) → return a + b;
		def ∑: x | 0.0, ℝ[x, x], (a, b) → return a + b;
		'''
		+ mandatoryOptions + simulationVariables +
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
		J6: ∀j1∈cells(), ∀j2∈neighbourCells(j1), 
		    {
		    	face cf = commonFace(j1,j2);
		    	ℝ bidon = (x{j2}-x{j1}) / surface{cf});
		    }
		'''

		val nablaModule = parseHelper.parse(model)

		j1 = nablaModule.getJobByName("J1")
		j2 = nablaModule.getJobByName("J2")
		j3 = nablaModule.getJobByName("J3")
		j4 = nablaModule.getJobByName("J4")
		j5 = nablaModule.getJobByName("J5")
		j6 = nablaModule.getJobByName("J6")

		j1_j = j1.getIteratorByName("j")
		j2_j = j2.getIteratorByName("j")
		j2_r = j2.getIteratorByName("r")
		j3_j = j3.getIteratorByName("j")
		j3_r = j3.getIteratorByName("r")
		j4_j = j4.getIteratorByName("j")
		j4_r = j4.getIteratorByName("r")
		j5_j1 = j5.getIteratorByName("j1")
		j5_j2 = j5.getIteratorByName("j2")
		j5_cf = j5_j2.singletons.head
		j6_cf = j6.eAllContents.filter(ItemDefinition).head
	}

	@Test
	def void testGetConnectivityCallUniqueName()
	{
		Assert.assertEquals("cells", j1_j.container.uniqueName)

		Assert.assertEquals("cells", j2_j.container.uniqueName)
		Assert.assertEquals("nodesOfCellJ", j2_r.container.uniqueName)

		Assert.assertEquals("nodes", j3_r.container.uniqueName)
		Assert.assertEquals("cellsOfNodeR", j3_j.container.uniqueName)

		Assert.assertEquals("cells", j4_j.container.uniqueName)
		Assert.assertEquals("nodesOfCellJ", j4_r.container.uniqueName)

		Assert.assertEquals("cells", j5_j1.container.uniqueName)
		Assert.assertEquals("neighbourCellsJ1", j5_j2.container.uniqueName)
		Assert.assertEquals("commonFaceJ1J2", j5_cf.value.uniqueName)

		Assert.assertEquals("commonFaceJ1J2", j6_cf.value.uniqueName)
	}

	@Test
	def void testGetIndexName()
	{
		Assert.assertEquals("jCells", j1_j.toIrIndex.name)

		Assert.assertEquals("jCells", j2_j.toIrIndex.name)
		Assert.assertEquals("rNodesOfCellJ", j2_r.toIrIndex.name)

		Assert.assertEquals("rNodes", j3_r.toIrIndex.name)
		Assert.assertEquals("jCellsOfNodeR", j3_j.toIrIndex.name)

		Assert.assertEquals("jCells", j4_j.toIrIndex.name)
		Assert.assertEquals("rNodesOfCellJ", j4_r.toIrIndex.name)

		Assert.assertEquals("j1Cells", j5_j1.toIrIndex.name)
		Assert.assertEquals("j2NeighbourCellsJ1", j5_j2.toIrIndex.name)
	}

	@Test
	def void testGetNeededIdDefinitions()
	{
		Assert.assertArrayEquals(#[], j1_j.neededIdDefinitions.map[id.name])

		Assert.assertArrayEquals(#["jId"], j2_j.neededIdDefinitions.map[id.name])
		Assert.assertArrayEquals(#[], j2_r.neededIdDefinitions.map[id.name])

		Assert.assertArrayEquals(#["jId"], j3_j.neededIdDefinitions.map[id.name])
		Assert.assertArrayEquals(#["rId"], j3_r.neededIdDefinitions.map[id.name])

		Assert.assertArrayEquals(#["jId"], j4_j.neededIdDefinitions.map[id.name])
		Assert.assertArrayEquals(#["rId", "rPlus1Id"], j4_r.neededIdDefinitions.map[id.name])

		Assert.assertArrayEquals(#["j1Id"], j5_j1.neededIdDefinitions.map[id.name])
		Assert.assertArrayEquals(#["j2Id"], j5_j2.neededIdDefinitions.map[id.name])
		Assert.assertEquals("cfId", j5_cf.toIrIdDefinition.id.name)

		Assert.assertEquals("cfId", j6_cf.toIrIdDefinition.id.name)
	}

	@Test
	def void testGetNeededIndexDefinitions()
	{
		Assert.assertArrayEquals(#[], j1_j.neededIndexDefinitions.map[index.name])

		Assert.assertArrayEquals(#[], j2_j.neededIndexDefinitions.map[index.name])
		Assert.assertArrayEquals(#[], j2_r.neededIndexDefinitions.map[index.name])

		Assert.assertArrayEquals(#[], j3_r.neededIndexDefinitions.map[index.name])
		Assert.assertArrayEquals(#["jCells", "rNodesOfCellJ"], j3_j.neededIndexDefinitions.map[index.name])

		Assert.assertArrayEquals(#[], j4_j.neededIndexDefinitions.map[index.name])
		Assert.assertArrayEquals(#["rNodes", "rPlus1Nodes"], j4_r.neededIndexDefinitions.map[index.name])

		Assert.assertArrayEquals(#[], j5_j1.neededIndexDefinitions.map[index.name])
		Assert.assertArrayEquals(#["j2Cells"], j5_j2.neededIndexDefinitions.map[index.name])
		Assert.assertArrayEquals(#["cfFaces"], j5_cf.item.neededIndexDefinitions.map[index.name])
	}

	private def getIteratorByName(Job it, String name)
	{
		val iterator = eAllContents.filter(SpaceIterator).findFirst[x | x.item.name == name]
//		println("iterator " + name + " : " + iterator)
		return iterator
	}
}
