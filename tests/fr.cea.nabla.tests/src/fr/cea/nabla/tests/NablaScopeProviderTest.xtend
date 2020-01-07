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
import fr.cea.nabla.nabla.VarGroupDeclaration
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.scoping.IScopeProvider
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith

import static extension fr.cea.nabla.tests.TestUtils.*

@RunWith(XtextRunner)
@InjectWith(NablaInjectorProvider)
class NablaScopeProviderTest 
{
	@Inject ParseHelper<NablaModule> parseHelper;
	@Inject extension IScopeProvider
	@Inject extension NablaModuleExtensions

	/*** Scope for iterators **********************************************************/

	@Test
	def void testScopeProviderForSpaceIteratorRefInVarRef()
	{
		val module = parseHelper.parse(getTestModule(defaultConnectivities, '')
			+
			'''
			ℝ a{cells}, b{cells, nodesOfCell}, c{cells};
			ℝ d{nodes};
			
			j1 : ∀j ∈ cells(), a{j} = 0.0;
			j2 : ∀j ∈ cells(), c{j} = 0.25 * ∑{r ∈ nodes()}(d{r});
			j3 : ∀j ∈ cells(), ∀r ∈ nodesOfCell(j), b{j,r} = 0.;
			j4 : ∀j ∈ cells(), a{j} = ∑{r∈nodesOfCell(j)}(b{j, r});
			j5 : ℝ[2] z = ∑{j∈cells()}(∑{r∈nodesOfCell(j)}(X{r}));
			'''
		)
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
	}

	@Test
	def void testScopeProviderForSpaceIteratorRefInConnectivityCall()
	{
		val module = parseHelper.parse(getTestModule(defaultConnectivities, '')
			+
			'''
			ℝ a{cells}, b{cells, nodesOfCell}, c{cells};
			ℝ d{nodes};
			
			j1 : ∀j ∈ cells(), a{j} = 0.0;
			j2 : ∀j ∈ cells(), c{j} = 0.25 * ∑{r ∈ nodes()}(d{r});
			j3 : ∀j ∈ cells(), ∀r ∈ nodesOfCell(j), b{j,r} = 0.;
			j4 : ∀j ∈ cells(), a{j} = ∑{r∈nodesOfCell(j)}(b{j, r});
			'''
		)
		Assert.assertNotNull(module)

		val eref = NablaPackage::eINSTANCE.spaceIteratorRef_Target
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
	}

	def private assertScope(EObject context, EReference reference, CharSequence expected)
	{
		val elementNames = context.getScope(reference).allElements.map[name].join(", ")
		Assert.assertEquals(expected.toString, elementNames)
	}

	/*** Scope for variables ***********************************************************/

	@Test
	def void testScopeProviderForArgOrVarRefInInstruction()
	{
		val module = parseHelper.parse(getTestModule(defaultConnectivities, '')
		+
		'''
		ℝ[2] X{nodes};
		ℝ a = 4.0;
		ℝ b1;
		ℝ b2 = b1;		
		ℝ c1 {cells}, c2 {cells};
		
		j1: ∀ j∈cells(), {
			c1{j} = a * 2;
			ℝ d = 6.0;
			c2{j} = 2 * d;
			∀ r∈nodesOfCells(j), {
				ℝ e = 3.3;
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
			ℝ z = ∑{j∈cells()}(∑{r∈nodesOfCell(j)}(∑{k∈[0;1]}(X{r}[k])));
			z = z + 1;
		}
		''')

		Assert.assertNotNull(module)
		val eref = NablaPackage::eINSTANCE.argOrVarRef_Target

		val aDeclaration = module.getVariableByName("a").eContainer as SimpleVarDefinition
		aDeclaration.assertScope(eref, defaultOptionsScope + ", X")

		val b1Declaration = module.getVariableByName("b1").eContainer as VarGroupDeclaration
		b1Declaration.assertScope(eref, defaultOptionsScope + ", X, a")

		val b2Declaration = module.getVariableByName("b2").eContainer as SimpleVarDefinition
		b2Declaration.assertScope(eref, defaultOptionsScope + ", X, a, b1")
		
		val j1 = module.getJobByName("j1")
		val affectationc1 = j1.getVarAffectationByName("c1")
		affectationc1.assertScope(eref, defaultOptionsScope + ", X, a, b1, b2, c1, c2")

		val affectationc2 = j1.getVarAffectationByName("c2")
		affectationc2.assertScope(eref, "d, " + defaultOptionsScope + ", X, a, b1, b2, c1, c2")

		val affectationf = j1.getVarAffectationByName("f")
		affectationf.assertScope(eref, "e, f, d, " + defaultOptionsScope + ", X, a, b1, b2, c1, c2")

		val j2 = module.getJobByName("j2")
		val affectationn = j2.getVarAffectationByName("n")
		affectationn.assertScope(eref, "n, m, " + defaultOptionsScope + ", X, a, b1, b2, c1, c2")

		val affectationm = j2.getVarAffectationByName("m")
		affectationm.assertScope(eref, "n, m, " + defaultOptionsScope + ", X, a, b1, b2, c1, c2")

		val j3 = module.getJobByName("j3")
		val j3_xvarref = j3.instruction.eAllContents.filter(ArgOrVarRef).findFirst[x | x.target.name == 'X']
		j3_xvarref.assertScope(eref, defaultOptionsScope + ", X, a, b1, b2, c1, c2")
	}

	@Test
	def void testScopeProviderForArgOrVarRefInReduction() 
	{
		val module = parseHelper.parse(TestUtils::getTestModule('',
			'''
			def reduceMin: (ℝ.MaxValue, ℝ) → ℝ;
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
		val model = TestUtils::getTestModule( '',
			'''
			def	inverse: ℝ[2,2] → ℝ[2,2];
			def f: x,y | ℝ[x] × ℝ[y] → ℝ[x+y], (a, b) →
			{
				ℝ c = 2.0;
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
		fReturnInstruction.assertScope(eref, "c, a, b")

		val g = module.getFunctionByName("g")
		Assert.assertNotNull(g)
		val affectationn = g.getVarAffectationByName("n")
		affectationn.assertScope(eref, "n, m")

		val affectationm = g.getVarAffectationByName("m")
		affectationm.assertScope(eref, "n, m")
	}

	private def defaultOptionsScope()
	{
		return "X_EDGE_LENGTH, Y_EDGE_LENGTH, X_EDGE_ELEMS, Y_EDGE_ELEMS"
	}

	/*** Scope for dimension symbols **********************************/

	@Test
	def void testScopeProviderForDimensionSymbolInInstruction()
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
			ℝ z = ∑{j∈cells()}(∑{r∈nodesOfCell(j)}(∑{k∈[0;1]}(X{r}[k+1])));
			z = z + 1;
		}
		''')
		Assert.assertNotNull(module)
		val eref = NablaPackage::eINSTANCE.sizeTypeSymbolRef_Target

		val c1Decl = module.instructions.get(0)		
		c1Decl.assertScope(eref, "")

		val j1 = module.getJobByName("j1")
		val affectationc1 = j1.getVarAffectationByName("c1")
		affectationc1.assertScope(eref, "")

		val j2 = module.getJobByName("j2")
		val affectationn = j2.getVarAffectationByName("n")
		affectationn.left.assertScope(eref, "i")

		val affectationm = j2.getVarAffectationByName("m")
		affectationm.left.assertScope(eref, "j, i")

		val j3 = module.getJobByName("j3")
		val j3_xvarref = j3.instruction.eAllContents.filter(ArgOrVarRef).findFirst[x | x.target.name == 'X']
		j3_xvarref.assertScope(eref, "k")
	}

	@Test
	def void testScopeProviderForDimensionSymbolInFunction()
	{
		val model = TestUtils::getTestModule( '',
			'''
			def	inverse: ℝ[2,2] → ℝ[2,2];
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
		val eref = NablaPackage::eINSTANCE.sizeTypeSymbolRef_Target

		val inverse = module.getFunctionByName("inverse")
		Assert.assertNotNull(inverse)
		inverse.assertScope(eref, "")

		val f = module.getFunctionByName("f")
		Assert.assertNotNull(f)
		val fReturnInstruction = f.body.eAllContents.filter(Return).head
		Assert.assertNotNull(fReturnInstruction)
		fReturnInstruction.expression.assertScope(eref, "x, y")

		val g = module.getFunctionByName("g")
		Assert.assertNotNull(g)
		val affectationn = g.getVarAffectationByName("n")
		affectationn.left.assertScope(eref, "i")

		val affectationm = g.getVarAffectationByName("m")
		affectationm.left.assertScope(eref, "j, i")
	}
}