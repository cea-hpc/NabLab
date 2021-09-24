/*******************************************************************************
 * Copyright (c) 2021 CEA
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
import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NablaPackage
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.Return
import fr.cea.nabla.nabla.SimpleVarDeclaration
import fr.cea.nabla.nabla.TimeIterator
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.xtext.scoping.IScopeProvider
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(XtextRunner)
@InjectWith(NablaInjectorProvider)
class NablaScopeProviderTest
{
	@Inject extension IScopeProvider
	@Inject extension NablaModuleExtensions
	@Inject extension TestUtils
	@Inject ParseHelper<NablaModule> parseHelper
	@Inject Provider<ResourceSet> resourceSetProvider

	/*** Scope for items *****************************************************/

	@Test
	def void testScopeProviderForSpaceIteratorRefInVarRef()
	{
		val model = 
		'''
		«testModule»

		ℝ a{cells}, b{cells, nodesOfCell}, c{cells};
		ℝ d{nodes};

		j1 : ∀j ∈ cells(), a{j} = 0.0;
		j2 : ∀j ∈ cells(), c{j} = 0.25 * ∑{r ∈ nodes()}(d{r});
		j3 : ∀j ∈ cells(), ∀r ∈ nodesOfCell(j), b{j,r} = 0.;
		j4 : ∀j ∈ cells(), a{j} = ∑{r∈nodesOfCell(j)}(b{j, r});
		j5 : let ℝ z = ∑{j∈cells()}(∑{r∈nodesOfCell(j)}(X{r}));
		j6 : ∀j ∈ cells(), ∀ rj ∈ rightCell(j), ∀ lj ∈ leftCell(j), c{j} = a{rj};
		j7 : ∀j ∈ cells(), {
				set rjset = rightCell(j);
				∀ rj ∈ rjset, c{j} = a{rj};
			}
		'''
		val rs = resourceSetProvider.get
		parseHelper.parse(readFileAsString(TestUtils.CartesianMesh2DPath), rs)
		val module = parseHelper.parse(model, rs)
		Assert.assertNotNull(module)

		val eref = NablaPackage::eINSTANCE.spaceIteratorRef_Target
		val j1 = module.getJobByName("j1")
		val j1_a = j1.getVarAffectationByName("a")
		j1_a.left.assertScope(eref, "j")

		val j2 = module.getJobByName("j2")
		val j2_c = j2.getVarAffectationByName("c")
		j2_c.left.assertScope(eref, "j")
		val sum = j2_c.right.eContents.filter(ReductionCall).head
		val j2_d = sum.arg as ArgOrVarRef
		j2_d.assertScope(eref, "r, j")

		val j3 = module.getJobByName("j3")
		val j3_b = j3.getVarAffectationByName("b")
		j3_b.left.assertScope(eref, "r, j")

		val j4 = module.getJobByName("j4")
		val j4_a = j4.getVarAffectationByName("a")
		j4_a.left.assertScope(eref, "j")
		val sum2 = j4_a.right as ReductionCall
		val j4_b = sum2.arg as ArgOrVarRef
		j4_b.assertScope(eref, "r, j")

		val j5 = module.getJobByName("j5")
		val j5_x = j5.eAllContents.filter(ArgOrVarRef).head
		j5_x.assertScope(eref, "r, j")

		val j6 = module.getJobByName("j6")
		val j6_a = j6.eAllContents.filter(ArgOrVarRef).head
		j6_a.assertScope(eref, "lj, rj, j")

		val j7 = module.getJobByName("j7")
		val j7_a = j7.eAllContents.filter(ArgOrVarRef).head
		j7_a.assertScope(eref, "rj, j")
	}

	@Test
	def void testScopeProviderForSpaceIteratorRefInConnectivityCall()
	{
		val model = 
		'''
		«testModule»
		ℝ a{cells}, b{cells, nodesOfCell}, c{cells};
		ℝ d{nodes};

		j1 : ∀j ∈ cells(), a{j} = 0.0;
		j2 : ∀j ∈ cells(), c{j} = 0.25 * ∑{r ∈ nodes()}(d{r});
		j3 : ∀j ∈ cells(), ∀r ∈ nodesOfCell(j), b{j,r} = 0.;
		j4 : ∀j ∈ cells(), a{j} = ∑{r∈nodesOfCell(j)}(b{j, r});
		j5 : ∀j ∈ cells(), ∀ rj ∈ rightCell(j), ∀ lj ∈ leftCell(j), c{j} = a{rj} + a{lj};
		j6 : ∀j ∈ cells(), {
				set rjset = rightCell(j);
				∀ rj ∈ rjset, c{j} = a{rj};
			}
		'''

		val rs = resourceSetProvider.get
		parseHelper.parse(readFileAsString(TestUtils.CartesianMesh2DPath), rs)
		val module = parseHelper.parse(model, rs)
		Assert.assertNotNull(module)

		val eref = NablaPackage::eINSTANCE.spaceIteratorRef_Target

		val j1 = module.getJobByName("j1")
		val j1_cells = j1.getAllConnectivityCalls().get(0)
		j1_cells.assertScope(eref, "")

		val j2 = module.getJobByName("j2")
		val j2_ccalls = j2.getAllConnectivityCalls()
		val j2_cells = j2_ccalls.get(0)
		Assert.assertNotNull(j2_cells)
		j2_cells.assertScope(eref, "")
		val j2_nodes = j2_ccalls.get(1)
		Assert.assertNotNull(j2_nodes)
		j2_nodes.assertScope(eref, "j")

		val j3 = module.getJobByName("j3")
		val j3_ccalls = j3.getAllConnectivityCalls()
		val j3_cells = j3_ccalls.get(0)
		Assert.assertNotNull(j3_cells)
		j3_cells.assertScope(eref, "")
		val j3_nodesOfCell = j3_ccalls.get(1)
		Assert.assertNotNull(j3_nodesOfCell)
		j3_nodesOfCell.assertScope(eref, "j")

		val j4 = module.getJobByName("j4")
		val j4_ccalls = j4.getAllConnectivityCalls()
		val j4_cells = j4_ccalls.get(0)
		Assert.assertNotNull(j4_cells)
		j4_cells.assertScope(eref, "")
		val j4_nodesOfCell = j4_ccalls.get(1)
		Assert.assertNotNull(j4_nodesOfCell)
		j4_nodesOfCell.assertScope(eref, "j")

		val j5 = module.getJobByName("j5")
		val j5_ccalls = j5.getAllConnectivityCalls()
		val j5_cells = j5_ccalls.get(0)
		Assert.assertNotNull(j5_cells)
		j5_cells.assertScope(eref, "")
		val j5_rightCell = j5_ccalls.get(1)
		Assert.assertNotNull(j5_rightCell)
		j5_rightCell.assertScope(eref, "j")
		val j5_leftCell = j5_ccalls.get(2)
		Assert.assertNotNull(j5_leftCell)
		j5_leftCell.assertScope(eref, "rj, j")

		val j6 = module.getJobByName("j6")
		val j6_ccalls = j6.getAllConnectivityCalls()
		val j6_cells = j6_ccalls.get(0)
		Assert.assertNotNull(j6_cells)
		j6_cells.assertScope(eref, "")
		val j6_rightCell = j6_ccalls.get(1)
		Assert.assertNotNull(j6_rightCell)
		j6_rightCell.assertScope(eref, "j")
	}

	def private assertScope(EObject context, EReference reference, CharSequence expected)
	{
		val elementNames = context.getScope(reference).allElements.map[name].join(", ")
		Assert.assertEquals(expected.toString, elementNames)
	}

	/*** Scope for sets ******************************************************/

	@Test
	def void testScopeProviderForSet()
	{
		val model =
		'''
		«testModule»
		ℝ a{cells}, b{cells, nodesOfCell};

		j1 : ∀j ∈ cells(), a{j} = 0.0;
		j2 : {
			set myCells = cells();
			∀j ∈ myCells, a{j} = 0.0;
		}
		j3 : ∀j ∈ cells(), {
			set nOfCells = nodesOfCell(j);
			a{j} = ∑{r∈nOfCells}(b{j, r});
		}
		'''
		val rs = resourceSetProvider.get
		parseHelper.parse(readFileAsString(TestUtils.CartesianMesh2DPath), rs)
		val module = parseHelper.parse(model, rs)
		Assert.assertNotNull(module)

		val eref = NablaPackage::eINSTANCE.itemSetRef_Target
		val j1 = module.getJobByName("j1")
		val j1_a = j1.getVarAffectationByName("a")
		j1_a.assertScope(eref, "")
		val j2 = module.getJobByName("j2")
		val j2_a = j2.getVarAffectationByName("a")
		j2_a.assertScope(eref, "myCells")
		val j3 = module.getJobByName("j3")
		val j3_a = j3.getVarAffectationByName("a")
		j3_a.assertScope(eref, "nOfCells")
	}

	/*** Scope for variables *************************************************/

	@Test
	def void testScopeProviderForArgOrVarRefInInstruction()
	{
		val model =
		'''
		«testModule»
		let ℝ a = 4.0;
		let ℝ b1 = 0.0;
		let ℝ b2 = b1;
		ℝ[2] X{nodes};
		ℝ c1 {cells}, c2 {cells};

		iterate n while (n > 4), k while (n > 4 && k < 2);

		j1: ∀ j∈cells(), {
			c1{j} = a * 2;
			let ℝ d = 6.0;
			c2{j} = 2 * d;
			∀ r, countr ∈ nodesOfCell(j), {
				let ℝ e = 3.3;
				ℝ f;
				f = e + 1.0;
			}
		}

		j2: {
			ℝ[4] o;
			ℝ[4, 2] p;
			∀ i∈[0;4[, 
			{
				o[i] = 4.0;
				∀ j∈[0;2[, p[i,j] = 3.0;
			}
		}

		j3: {
			let ℝ z = ∑{j∈cells()}(∑{r∈nodesOfCell(j)}(∑{i∈[0;2[}(X{r}[i])));
			z = z + 1;
		}
		'''

		val rs = resourceSetProvider.get
		parseHelper.parse(readFileAsString(TestUtils.CartesianMesh2DPath), rs)
		val module = parseHelper.parse(model, rs)
		Assert.assertNotNull(module)
		val eref = NablaPackage::eINSTANCE.argOrVarRef_Target

		val iterators = module.iteration.eAllContents.filter(TimeIterator)
		val nRefInCondOfN = iterators.head.condition.eAllContents.filter(ArgOrVarRef).head
		Assert.assertNotNull(nRefInCondOfN)
		nRefInCondOfN.assertScope(eref, "δt, t, a, b1, b2, X, c1, c2, n")
		val nRefInCondOfK = iterators.last.condition.eAllContents.filter(ArgOrVarRef).head
		Assert.assertNotNull(nRefInCondOfK)
		nRefInCondOfK.assertScope(eref, "δt, t, a, b1, b2, X, c1, c2, n, k")

		val aDeclaration = module.getVarByName("a").eContainer as SimpleVarDeclaration
		aDeclaration.assertScope(eref, "δt, t")

		val b1Declaration = module.getVarByName("b1").eContainer as SimpleVarDeclaration
		b1Declaration.assertScope(eref, "δt, t, a")

		val b2Declaration = module.getVarByName("b2").eContainer as SimpleVarDeclaration
		b2Declaration.assertScope(eref, "δt, t, a, b1")
		
		val j1 = module.getJobByName("j1")
		val affectationc1 = j1.getVarAffectationByName("c1")
		affectationc1.assertScope(eref, "δt, t, a, b1, b2, X, c1, c2, n, k")

		val affectationc2 = j1.getVarAffectationByName("c2")
		affectationc2.assertScope(eref, "d, " + "δt, t, a, b1, b2, X, c1, c2, n, k")

		val affectationf = j1.getVarAffectationByName("f")
		affectationf.assertScope(eref, "e, f, countr, d, " + "δt, t, a, b1, b2, X, c1, c2, n, k")

		val j2 = module.getJobByName("j2")
		val affectationn = j2.getVarAffectationByName("o")
		affectationn.assertScope(eref, "i, o, p, " + "δt, t, a, b1, b2, X, c1, c2, n, k")

		val affectationm = j2.getVarAffectationByName("p")
		affectationm.assertScope(eref, "j, i, o, p, " + "δt, t, a, b1, b2, X, c1, c2, n, k")

		val j3 = module.getJobByName("j3")
		val j3_xvarref = j3.instruction.eAllContents.filter(ArgOrVarRef).findFirst[x | x.target.name == 'X']
		j3_xvarref.assertScope(eref, "i, " + "δt, t, a, b1, b2, X, c1, c2, n, k")
	}

	@Test
	def void testScopeProviderForArgOrVarRefInReduction()
	{
		val model =
		'''
		«emptyTestModule»
		def reduceMin, ℝ.MaxValue: ℝ, (a, b) → return min(a, b);
		'''
		val module = parseHelper.parse(model)
		Assert.assertNotNull(module)

		val eref = NablaPackage::eINSTANCE.argOrVarRef_Target

		val reduction = module.getReductionByName("reduceMin")
		Assert.assertNotNull(reduction)
		reduction.assertScope(eref, "")
	}

	@Test
	def void testScopeProviderForArgOrVarRefInFunction()
	{
		val model =
		'''
		«emptyTestModule»
		def f: x,y | ℝ[x] × ℝ[y] → ℝ[x+y], (a, b) →
		{
			let ℝ c = 2.0;
			c = a * 2.0;
			return c + 4.0;
		}
		def g: → ℝ, () →
		{
			ℝ[4] n;
			ℝ[4, 2] m;
			∀ i∈[0;4[, 
			{
				n[i] = 4.0;
				∀ j∈[0;2[, m[i,j] = 3.0;
			}
			return 4.0;
		}
		'''

		val module = parseHelper.parse(model)
		Assert.assertNotNull(module)
		val eref = NablaPackage::eINSTANCE.argOrVarRef_Target

		val f = module.getFunctionByName("f")
		Assert.assertNotNull(f)
		val fReturnInstruction = f.body.eAllContents.filter(Return).head
		Assert.assertNotNull(fReturnInstruction)
		fReturnInstruction.assertScope(eref, "c, x, y, a, b")

		val g = module.getFunctionByName("g")
		Assert.assertNotNull(g)
		val affectationn = g.getVarAffectationByName("n")
		affectationn.assertScope(eref, "i, n, m")

		val affectationm = g.getVarAffectationByName("m")
		affectationm.assertScope(eref, "j, i, n, m")

		val gReturnInstruction = g.body.eAllContents.filter(Return).head
		Assert.assertNotNull(gReturnInstruction)
		gReturnInstruction.assertScope(eref, "n, m")
	}

	/*** Scope for dimension symbols **********************************/

	@Test
	def void testScopeProviderForSizeVarInInstruction()
	{
		val model =
		'''
		«testModule»
		ℝ[2] X{nodes};
		ℝ c1 {cells};

		j1: ∀ j∈cells(), {
			c1{j} = 2.0;
		}

		j2: {
			ℝ[4] n;
			ℝ[4, 2] m;
			∀ i∈[0;4[, 
			{
				n[i] = 4.0;
				∀ j∈[0;2[, m[i,j] = 3.0;
			}
		}

		j3: {
			let ℝ z = ∑{j∈cells()}(∑{r∈nodesOfCell(j)}(∑{k∈[0;1[}(X{r}[k+1])));
			z = z + 1;
		}
		'''
		val rs = resourceSetProvider.get
		parseHelper.parse(readFileAsString(TestUtils.CartesianMesh2DPath), rs)
		val module = parseHelper.parse(model, rs)
		Assert.assertNotNull(module)
		val eref = NablaPackage::eINSTANCE.argOrVarRef_Target

		val d1Decl = module.declarations.get(1)
		d1Decl.assertScope(eref, "δt")

		val d2Decl = module.declarations.get(2)
		d2Decl.assertScope(eref, "δt, t")

		val d3Decl = module.declarations.get(3)
		d3Decl.assertScope(eref, "δt, t, X")

		val j1 = module.getJobByName("j1")
		val affectationc1 = j1.getVarAffectationByName("c1")
		affectationc1.assertScope(eref, "δt, t, X, c1")

		val j2 = module.getJobByName("j2")
		val affectationn = j2.getVarAffectationByName("n")
		affectationn.left.assertScope(eref, "i, n, m, " + "δt, t, X, c1")

		val affectationm = j2.getVarAffectationByName("m")
		affectationm.left.assertScope(eref, "j, i, n, m, " + "δt, t, X, c1")

		val j3 = module.getJobByName("j3")
		val j3_xvarref = j3.instruction.eAllContents.filter(ArgOrVarRef).findFirst[x | x.target.name == 'X']
		j3_xvarref.assertScope(eref, "k, " + "δt, t, X, c1")
	}

	@Test
	def void testScopeProviderForSizeVarInFunction()
	{
		val model =
		'''
		«emptyTestModule»
		def f: x,y | ℝ[x] × ℝ[y] → ℝ[x+y], (a, b) →
		{
			ℝ[x,y] c;
			return c;
		}
		def g: → ℝ, () →
		{
			ℝ[4] n;
			ℝ[4, 2] m;
			∀ i∈[0;4[, 
			{
				n[i] = 4.0;
				∀ j∈[0;2[, m[i,j] = 3.0;
			}
			return 4.0;
		}
		'''

		val module = parseHelper.parse(model)
		Assert.assertNotNull(module)
		val eref = NablaPackage::eINSTANCE.argOrVarRef_Target

		val f = module.getFunctionByName("f")
		Assert.assertNotNull(f)
		val fReturnInstruction = f.body.eAllContents.filter(Return).head
		Assert.assertNotNull(fReturnInstruction)
		fReturnInstruction.expression.assertScope(eref, "c, x, y, a, b")

		val g = module.getFunctionByName("g")
		Assert.assertNotNull(g)
		val affectation = g.getVarAffectationByName("n")
		affectation.left.assertScope(eref, "i, n, m")

		val affectationm = g.getVarAffectationByName("m")
		affectationm.left.assertScope(eref, "j, i, n, m")
	}
}