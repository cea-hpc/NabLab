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
import fr.cea.nabla.nabla.ArgOrVarRef
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NablaPackage
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.Return
import fr.cea.nabla.nabla.SimpleVarDefinition
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
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
	@Inject ParseHelper<NablaModule> parseHelper;
	@Inject extension IScopeProvider
	@Inject extension NablaModuleExtensions
	@Inject extension TestUtils

	/*** Scope for items *****************************************************/

	@Test
	def void testScopeProviderForItemRefInVarRef()
	{
		val module = parseHelper.parse(getTestModule(defaultConnectivities + '''
			item leftCell: cell → cell;
			item rightCell: cell → cell;
			''', '')
			+
			'''
			ℝ a{cells}, b{cells, nodesOfCell}, c{cells};
			ℝ d{nodes};

			j1 : ∀j ∈ cells(), a{j} = 0.0;
			j2 : ∀j ∈ cells(), c{j} = 0.25 * ∑{r ∈ nodes()}(d{r});
			j3 : ∀j ∈ cells(), ∀r ∈ nodesOfCell(j), b{j,r} = 0.;
			j4 : ∀j ∈ cells(), a{j} = ∑{r∈nodesOfCell(j)}(b{j, r});
			j5 : let z = ∑{j∈cells()}(∑{r∈nodesOfCell(j)}(X{r}));
			j6 : ∀j ∈ cells(), rj = rightCell(j), lj = leftCell(j), c{j} = a{rj};
			j7 : ∀j ∈ cells(), {
					item lj = leftCell(j);
					c{j} = a{lj};
				}
			'''
		)
		Assert.assertNotNull(module)

		val eref = NablaPackage::eINSTANCE.itemRef_Target
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
		j6_a.assertScope(eref, "j, rj, lj")

		val j7 = module.getJobByName("j7")
		val j7_a = j7.eAllContents.filter(ArgOrVarRef).head
		j7_a.assertScope(eref, "lj, j")
	}

	@Test
	def void testScopeProviderForItemRefInConnectivityCall()
	{
		val module = parseHelper.parse(getTestModule(defaultConnectivities + '''
			item leftCell: cell → cell;
			item rightCell: cell → cell;
			''', '')
			+
			'''
			ℝ a{cells}, b{cells, nodesOfCell}, c{cells};
			ℝ d{nodes};

			j1 : ∀j ∈ cells(), a{j} = 0.0;
			j2 : ∀j ∈ cells(), c{j} = 0.25 * ∑{r ∈ nodes()}(d{r});
			j3 : ∀j ∈ cells(), ∀r ∈ nodesOfCell(j), b{j,r} = 0.;
			j4 : ∀j ∈ cells(), a{j} = ∑{r∈nodesOfCell(j)}(b{j, r});
			j5 : ∀j ∈ cells(), rj = rightCell(j), lj = leftCell(j), c{j} = a{rj} + a{lj};
			j6 : ∀j ∈ cells(), {
					item rj = rightCell(j);
					item lj = leftCell(rj)
					c{j} = a{rj} + a{lj};
				}
			'''
		)
		Assert.assertNotNull(module)

		val eref = NablaPackage::eINSTANCE.itemRef_Target
		val cells = module.getConnectivityByName("cells")
		val nodes = module.getConnectivityByName("nodes")
		val nodesOfCell = module.getConnectivityByName("nodesOfCell")

		val j1 = module.getJobByName("j1")
		val j1_cells = j1.getConnectivityCallFor(cells)
		j1_cells.assertScope(eref, "")

		val j2 = module.getJobByName("j2")
		val j2_cells = j2.getConnectivityCallFor(cells)
		Assert.assertNotNull(j2_cells)
		j2_cells.assertScope(eref, "")
		val j2_nodes = j2.getConnectivityCallFor(nodes)
		Assert.assertNotNull(j2_nodes)
		j2_nodes.assertScope(eref, "j")

		val j3 = module.getJobByName("j3")
		val j3_cells = j3.getConnectivityCallFor(cells)
		Assert.assertNotNull(j3_cells)
		j3_cells.assertScope(eref, "")
		val j3_nodesOfCell = j3.getConnectivityCallFor(nodesOfCell)
		Assert.assertNotNull(j3_nodesOfCell)
		j3_nodesOfCell.assertScope(eref, "j")

		val j4 = module.getJobByName("j4")
		val j4_cells = j4.getConnectivityCallFor(cells)
		Assert.assertNotNull(j4_cells)
		j4_cells.assertScope(eref, "")
		val j4_nodesOfCell = j4.getConnectivityCallFor(nodesOfCell)
		Assert.assertNotNull(j4_nodesOfCell)
		j4_nodesOfCell.assertScope(eref, "j")

		val j5 = module.getJobByName("j5")
		val j5_cells = j5.getConnectivityCallFor(cells)
		Assert.assertNotNull(j5_cells)
		j5_cells.assertScope(eref, "")
		val rightCell = module.getConnectivityByName("rightCell")
		val j5_rightCell = j5.getConnectivityCallFor(rightCell)
		Assert.assertNotNull(j5_rightCell)
		j5_rightCell.assertScope(eref, "j")
		val leftCell = module.getConnectivityByName("leftCell")
		val j5_leftCell = j5.getConnectivityCallFor(leftCell)
		Assert.assertNotNull(j5_leftCell)
		j5_leftCell.assertScope(eref, "rj, j")

		val j6 = module.getJobByName("j6")
		val j6_cells = j6.getConnectivityCallFor(cells)
		Assert.assertNotNull(j6_cells)
		j6_cells.assertScope(eref, "")
		val j6_rightCell = j6.getConnectivityCallFor(rightCell)
		Assert.assertNotNull(j6_rightCell)
		j6_rightCell.assertScope(eref, "j")
		val j6_leftCell = j6.getConnectivityCallFor(leftCell)
		Assert.assertNotNull(j6_leftCell)
		j6_leftCell.assertScope(eref, "rj, j")
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
		val module = parseHelper.parse(getTestModule(defaultConnectivities, '')
			+
			'''
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
		)
		Assert.assertNotNull(module)

		val eref = NablaPackage::eINSTANCE.setRef_Target
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
		val module = parseHelper.parse(getTestModule(defaultConnectivities, '')
		+
		'''
		let a = 4.0;
		let b1 = 0.0;
		let b2 = b1;
		ℝ[2] X{nodes};
		ℝ c1 {cells}, c2 {cells};

		iterate n while (n > 4), k while (n > 4 && k < 2);

		j1: ∀ j∈cells(), {
			c1{j} = a * 2;
			let d = 6.0;
			c2{j} = 2 * d;
			∀ r, countr ∈ nodesOfCell(j) {
				let e = 3.3;
				ℝ f;
				f = e + 1.0;
			}
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
			let z = ∑{j∈cells()}(∑{r∈nodesOfCell(j)}(∑{k∈[0;1]}(X{r}[k])));
			z = z + 1;
		}
		''')

		Assert.assertNotNull(module)
		val eref = NablaPackage::eINSTANCE.argOrVarRef_Target

		val iterate = module.iteration
		val nRefInCondOfN = iterate.iterators.head.cond.eAllContents.filter(ArgOrVarRef).head
		Assert.assertNotNull(nRefInCondOfN)
		nRefInCondOfN.assertScope(eref, defaultOptionsScope + ", a, b1, b2, X, c1, c2, n")
		val nRefInCondOfK = iterate.iterators.last.cond.eAllContents.filter(ArgOrVarRef).head
		Assert.assertNotNull(nRefInCondOfK)
		nRefInCondOfK.assertScope(eref, defaultOptionsScope + ", a, b1, b2, X, c1, c2, n, k")

		val aDeclaration = module.getVariableByName("a").eContainer as SimpleVarDefinition
		aDeclaration.assertScope(eref, defaultOptionsScope)

		val b1Declaration = module.getVariableByName("b1").eContainer as SimpleVarDefinition
		b1Declaration.assertScope(eref, defaultOptionsScope + ", a")

		val b2Declaration = module.getVariableByName("b2").eContainer as SimpleVarDefinition
		b2Declaration.assertScope(eref, defaultOptionsScope + ", a, b1")
		
		val j1 = module.getJobByName("j1")
		val affectationc1 = j1.getVarAffectationByName("c1")
		affectationc1.assertScope(eref, defaultOptionsScope + ", a, b1, b2, X, c1, c2")

		val affectationc2 = j1.getVarAffectationByName("c2")
		affectationc2.assertScope(eref, "d, " + defaultOptionsScope + ", a, b1, b2, X, c1, c2")

		val affectationf = j1.getVarAffectationByName("f")
		affectationf.assertScope(eref, "e, f, countr, d, " + defaultOptionsScope + ", a, b1, b2, X, c1, c2")

		val j2 = module.getJobByName("j2")
		val affectationn = j2.getVarAffectationByName("n")
		affectationn.assertScope(eref, "i, n, m, " + defaultOptionsScope + ", a, b1, b2, X, c1, c2")

		val affectationm = j2.getVarAffectationByName("m")
		affectationm.assertScope(eref, "j, i, n, m, " + defaultOptionsScope + ", a, b1, b2, X, c1, c2")

		val j3 = module.getJobByName("j3")
		val j3_xvarref = j3.instruction.eAllContents.filter(ArgOrVarRef).findFirst[x | x.target.name == 'X']
		j3_xvarref.assertScope(eref, "k, " + defaultOptionsScope + ", a, b1, b2, X, c1, c2")
	}

	@Test
	def void testScopeProviderForArgOrVarRefInReduction()
	{
		val module = parseHelper.parse(getTestModule('',
			'''
			def reduceMin, ℝ.MaxValue: ℝ, (a, b) → return min(a, b);
			''')
		)
		Assert.assertNotNull(module)

		val eref = NablaPackage::eINSTANCE.argOrVarRef_Target

		val reduction = module.getReductionByName("reduceMin")
		Assert.assertNotNull(reduction)
		reduction.assertScope(eref, "")
	}

	@Test
	def void testScopeProviderForArgOrVarRefInFunction()
	{
		val model = getTestModule( '',
			'''
			def inverse: ℝ[2,2] → ℝ[2,2];
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
			''')

		val module = parseHelper.parse(model)
		Assert.assertNotNull(module)
		val eref = NablaPackage::eINSTANCE.argOrVarRef_Target

		val inverse = module.getFunctionByName("inverse")
		Assert.assertNotNull(inverse)
		inverse.assertScope(eref, "")

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

	private def defaultOptionsScope()
	{
		return "X_EDGE_LENGTH, Y_EDGE_LENGTH, X_EDGE_ELEMS, Y_EDGE_ELEMS"
	}

	/*** Scope for dimension symbols **********************************/

	@Test
	def void testScopeProviderForSizeVarInInstruction()
	{
		val module = parseHelper.parse(getTestModule(defaultConnectivities, '')
		+
		'''
		ℝ[2] X{nodes}
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
			let z = ∑{j∈cells()}(∑{r∈nodesOfCell(j)}(∑{k∈[0;1]}(X{r}[k+1])));
			z = z + 1;
		}
		''')
		Assert.assertNotNull(module)
		val eref = NablaPackage::eINSTANCE.argOrVarRef_Target

		val c1Decl = module.declarations.get(1)
		c1Decl.assertScope(eref, defaultOptionsScope + ", X")

		val j1 = module.getJobByName("j1")
		val affectationc1 = j1.getVarAffectationByName("c1")
		affectationc1.assertScope(eref, defaultOptionsScope + ", X, c1")

		val j2 = module.getJobByName("j2")
		val affectationn = j2.getVarAffectationByName("n")
		affectationn.left.assertScope(eref, "i, n, m, " + defaultOptionsScope + ", X, c1")

		val affectationm = j2.getVarAffectationByName("m")
		affectationm.left.assertScope(eref, "j, i, n, m, " + defaultOptionsScope + ", X, c1")

		val j3 = module.getJobByName("j3")
		val j3_xvarref = j3.instruction.eAllContents.filter(ArgOrVarRef).findFirst[x | x.target.name == 'X']
		j3_xvarref.assertScope(eref, "k, " + defaultOptionsScope + ", X, c1")
	}

	@Test
	def void testScopeProviderForSizeVarInFunction()
	{
		val model = getTestModule( '',
			'''
			def inverse: ℝ[2,2] → ℝ[2,2];
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
			''')

		val module = parseHelper.parse(model)
		Assert.assertNotNull(module)
		val eref = NablaPackage::eINSTANCE.argOrVarRef_Target

		val inverse = module.getFunctionByName("inverse")
		Assert.assertNotNull(inverse)
		inverse.assertScope(eref, "")

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