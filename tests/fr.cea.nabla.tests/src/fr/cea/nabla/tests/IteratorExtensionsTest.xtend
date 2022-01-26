/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.tests

import com.google.inject.Inject
import com.google.inject.Provider
import fr.cea.nabla.NablaModuleExtensions
import fr.cea.nabla.generator.ir.IrItemIdDefinitionFactory
import fr.cea.nabla.generator.ir.IrItemIndexDefinitionFactory
import fr.cea.nabla.generator.ir.IrItemIndexFactory
import fr.cea.nabla.nabla.Job
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.SpaceIterator
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith

import static extension fr.cea.nabla.UniqueNameHelper.*

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
	@Inject Provider<ResourceSet> resourceSetProvider

	Job j1; Job j2; Job j3; Job j4;
	SpaceIterator j1_j; SpaceIterator j2_j; SpaceIterator j2_r; SpaceIterator j3_j; SpaceIterator j3_r;
	SpaceIterator j4_j; SpaceIterator j4_r;

	@Before
	def void setUpBefore() throws Exception
	{
		val model =
		'''
		module Test;

		with CartesianMesh2D.*;

		def ∑, 0.0: ℝ, (a, b) → return a + b;
		def ∑, 0.0: x | ℝ[x], (a, b) → return a + b;
		def ∑, 0.0: x | ℝ[x, x], (a, b) → return a + b;

		«simulationVariables»

		ℝ x{cells}, f{cells}, Cjr{cells,nodesOfCell};
		ℝ[2] X{nodes}, u{cells};
		ℝ surface{faces};
		ℝ a;

		J1: ∀j∈cells(), x{j} = 2.0;
		J2: ∀j∈cells(), ∀r∈nodesOfCell(j), Cjr{j,r} = 3.0;
		J3: ∀r∈nodes(), ∀j∈cellsOfNode(r), Cjr{j,r} = 1.0;
		J4: ∀j∈cells(), u{j} = 0.5 * ∑{r∈nodesOfCell(j)}(X{r} - X{r+1});
		'''

		val rs = resourceSetProvider.get
		parseHelper.parse(readFileAsString(TestUtils.CartesianMesh2DPath), rs)
		val nablaModule = parseHelper.parse(model, rs)

		j1 = nablaModule.getJobByName("J1")
		j2 = nablaModule.getJobByName("J2")
		j3 = nablaModule.getJobByName("J3")
		j4 = nablaModule.getJobByName("J4")

		j1_j = j1.getIteratorByName("j")
		j2_j = j2.getIteratorByName("j")
		j2_r = j2.getIteratorByName("r")
		j3_j = j3.getIteratorByName("j")
		j3_r = j3.getIteratorByName("r")
		j4_j = j4.getIteratorByName("j")
		j4_r = j4.getIteratorByName("r")
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
	}

	private def getIteratorByName(Job it, String name)
	{
		val iterator = eAllContents.filter(SpaceIterator).findFirst[x | x.name == name]
//		println("iterator " + name + " : " + iterator)
		return iterator
	}
}
