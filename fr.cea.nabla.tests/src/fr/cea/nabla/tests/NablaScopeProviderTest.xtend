/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.tests

import com.google.inject.Inject
import fr.cea.nabla.JobExtensions
import fr.cea.nabla.NablaModuleExtensions
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NablaPackage
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.ScalarVarDefinition
import fr.cea.nabla.nabla.VarGroupDeclaration
import fr.cea.nabla.nabla.VarRef
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
	@Inject extension JobExtensions

	/*** Scope for iterators **********************************************************/

	@Test 
	def void testScopeProviderForSpaceIteratorRefInVarRef() 
	{
		val module = parseHelper.parse(TestUtils::testModule
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

		val j1 = module.getJobByName("j1")
		val j1_a = j1.getVarAffectationByName("a")
		j1_a.varRef.assertScope(eref, "j")

		val j2 = module.getJobByName("j2")
		val j2_c = j2.getVarAffectationByName("c")
		j2_c.varRef.assertScope(eref, "j")
		val sum = j2_c.expression.eContents.filter(ReductionCall).head
		val j2_d = sum.arg as VarRef
		j2_d.assertScope(eref, "r, j")
		
		val j3 = module.getJobByName("j3")
		val j3_b = j3.getVarAffectationByName("b")
		j3_b.varRef.assertScope(eref, "r, j")

		val j4 = module.getJobByName("j4")
		val j4_a = j4.getVarAffectationByName("a")
		j4_a.varRef.assertScope(eref, "j")
		val sum2 = j4_a.expression as ReductionCall
		val j4_b = sum2.arg as VarRef
		j4_b.assertScope(eref, "r, j")
	}

	
	@Test 
	def void testScopeProviderForSpaceIteratorRefInConnectivityCall() 
	{
		val module = parseHelper.parse(TestUtils::testModule
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
		println('elementNames : ' + elementNames)
		Assert.assertEquals(expected.toString, elementNames)
	}
	
	/*** Scope for variables ***********************************************************/

	@Test 
	def void testScopeProviderForVarRefInInstruction() 
	{
		val module = parseHelper.parse(TestUtils::testModule
		+
		'''
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
		''')
		Assert.assertNotNull(module)

		val eref = NablaPackage::eINSTANCE.varRef_Variable

		val aDeclaration = module.getVariableByName("a").eContainer as ScalarVarDefinition
		aDeclaration.assertScope(eref, defaultOptionsScope)		

		val b1Declaration = module.getVariableByName("b1").eContainer as VarGroupDeclaration
		b1Declaration.assertScope(eref, defaultOptionsScope + ", a")		

		val b2Declaration = module.getVariableByName("b2").eContainer as ScalarVarDefinition
		b2Declaration.assertScope(eref, defaultOptionsScope + ", a, b1")	// ????	
		
		val j1 = module.getJobByName("j1")
		val affectationc1 = j1.getVarAffectationByName("c1")
		affectationc1.assertScope(eref, defaultOptionsScope + ", a, b1, b2, c1, c2")

		val affectationc2 = j1.getVarAffectationByName("c2")
		affectationc2.assertScope(eref, "d, "+ defaultOptionsScope + ", a, b1, b2, c1, c2")

		val affectationf = j1.getVarAffectationByName("f")
		println("affectation f " + affectationf)
		affectationf.assertScope(eref, "e, f, d, "+ defaultOptionsScope + ", a, b1, b2, c1, c2")
	}
	
	@Test 
	def void testScopeProviderForVarRefInReduction() 
	{
		val module = parseHelper.parse(TestUtils::getTestModuleWithCustomFunctions(
			'''
			functions {
				reduceMin: (ℝ.MaxValue, ℝ)→ℝ;
			}
			''')
		)
		
		Assert.assertNotNull(module)

		val eref = NablaPackage::eINSTANCE.varRef_Variable

		val reduction = module.getReductionByName("reduceMin")
		Assert.assertNotNull(reduction)
		reduction.assertScope(eref, "")
	}

	@Test 
	def void testScopeProviderForVarRefInFunction() 
	{
		val module = parseHelper.parse(TestUtils::getTestModuleWithCustomFunctions(
			'''
			functions {
				inverse: ℝ[2,2] → ℝ[2,2];
			}
			''')
		)
		
		Assert.assertNotNull(module)

		val eref = NablaPackage::eINSTANCE.varRef_Variable

		val inverse = module.getFunctionByName("inverse")
		Assert.assertNotNull(inverse)
		inverse.assertScope(eref, "")
	}
		
	private def defaultOptionsScope()
	{
		return "X_EDGE_LENGTH, Y_EDGE_LENGTH, X_EDGE_ELEMS, Y_EDGE_ELEMS, Z_EDGE_ELEMS, option_stoptime, option_max_iterations"	
	}
}