/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.tests.validation

import com.google.inject.Inject
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NablaPackage
import fr.cea.nabla.tests.NablaInjectorProvider
import fr.cea.nabla.tests.TestUtils
import fr.cea.nabla.validation.UnusedValidator
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(NablaInjectorProvider))
class UnusedValidatorTest
{
	@Inject ParseHelper<NablaModule> parseHelper
	@Inject extension TestUtils
	@Inject extension ValidationTestHelper

	@Test
	def testCheckUnusedTimeIterator()
	{
		val moduleKo = parseHelper.parse(
			'''
			«emptyTestModule»
			iterate n while(true);
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertWarning(NablaPackage.eINSTANCE.timeIterator,
			UnusedValidator::UNUSED,
			UnusedValidator::getUnusedMsg(NablaPackage.Literals.TIME_ITERATOR, 'n'))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			ℝ u, v;
			iterate n while(true);
			ComputeU: u^{n+1} = u^{n} + 6.0;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckUnusedVariable()
	{
		val moduleKo = parseHelper.parse(
			'''
			«emptyTestModule»
			ℝ a;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertWarning(NablaPackage.eINSTANCE.^var, 
			UnusedValidator::UNUSED, 
			UnusedValidator::getUnusedMsg(NablaPackage.Literals.VAR, 'a'))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			ℝ a;
			ComputeA: a = 1.;
			'''
		)

		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoIssues
	}

	@Test
	def void testCheckUnusedConnectivity()
	{
		val model =
			'''
			«emptyTestModule»
			itemtypes { node }
			connectivity nodes: → {node};
			connectivity borderNodes: → {node};
			'''
		val moduleKo = parseHelper.parse(model)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertWarning(NablaPackage.eINSTANCE.connectivity,
			UnusedValidator::UNUSED,
			UnusedValidator::getUnusedMsg(NablaPackage.Literals.CONNECTIVITY, 'nodes'))

		moduleKo.assertWarning(NablaPackage.eINSTANCE.connectivity,
			UnusedValidator::UNUSED,
			UnusedValidator::getUnusedMsg(NablaPackage.Literals.CONNECTIVITY, 'borderNodes'))

		val moduleOk = parseHelper.parse(
			'''
			«model»
			ℝ[2] X{nodes};
			IniXborder: ∀r∈borderNodes(), X{r} = X{r} - 1;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoIssues
	}

	@Test
	def void testCheckUnusedItemType()
	{
		val moduleKo = parseHelper.parse(
			'''
			«emptyTestModule»
			itemtypes { node }
			''')
		Assert.assertNotNull(moduleKo)
		moduleKo.assertWarning(NablaPackage.eINSTANCE.itemType,
			UnusedValidator::UNUSED,
			UnusedValidator::getUnusedMsg(NablaPackage.Literals.ITEM_TYPE, 'node'))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			itemtypes { node }
			connectivity nodes: → {node};
			ℝ[2] X{nodes};
			UpdateX: ∀r1∈nodes(), X{r1} = X{r1} + 1;
			'''
			)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoIssues
	}

	@Test
	def void testCheckUnusedSpaceIterator()
	{
		val moduleKo1 = parseHelper.parse(
			'''
			«testModuleForSimulation»
			UpdateX: ∀r1∈nodes(), ∀r2∈nodes(), X{r1} = X{r1} + 1;
			'''
		)
		Assert.assertNotNull(moduleKo1)
		moduleKo1.assertWarning(NablaPackage.eINSTANCE.spaceIterator,
			UnusedValidator::UNUSED,
			UnusedValidator::getUnusedMsg(NablaPackage.Literals.SPACE_ITERATOR, 'r2'))

		val moduleKo2 = parseHelper.parse(
			'''
			«emptyTestModule»
			itemtypes { node }
			connectivity nodes: → {node};
			connectivity topLeftNode: → node;
			ℝ[2] X{nodes};
			UpdateX: ∀r1∈nodes(), ∀r2∈topLeftNode(), X{r1} = X{r1} + 1;
			'''
		)
		Assert.assertNotNull(moduleKo1)
		moduleKo2.assertWarning(NablaPackage.eINSTANCE.spaceIterator,
			UnusedValidator::UNUSED,
			UnusedValidator::getUnusedMsg(NablaPackage.Literals.SPACE_ITERATOR, 'r2'))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			itemtypes { node }
			connectivity nodes: → {node};
			ℝ[2] X{nodes};
			UpdateX: ∀r1∈nodes(), X{r1} = X{r1} + 1;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoIssues
	}

	@Test
	def void testCheckUnusedItemSet()
	{
		val model = 
			'''
			«emptyTestModule»
			itemtypes { node }
			connectivity nodes: → {node};
			ℝ[2] X{nodes};
			'''
		val moduleKo = parseHelper.parse(
			'''
			«model»
			UpdateX: {
				set myNodes = nodes();
				∀r1∈nodes(), X{r1} = X{r1} + 1;
			}
			'''
		)
		Assert.assertNotNull(moduleKo)
		moduleKo.assertWarning(NablaPackage.eINSTANCE.itemSet,
			UnusedValidator::UNUSED,
			UnusedValidator::getUnusedMsg(NablaPackage.Literals.ITEM_SET, 'myNodes'))

		val moduleOk = parseHelper.parse(
			'''
			«model»
			UpdateX: {
				set myNodes = nodes();
				∀r1∈myNodes, X{r1} = X{r1} + 1;
			}
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoIssues
	}

	@Test
	def void testCheckUnusedFunction() 
	{
		val modelKo = 
			'''
			«emptyTestModule»
			def f: x | ℝ[x] → ℝ, (a) → return 1.0;
			let ℝ[2] orig = [0.0 , 0.0];
		'''
		val moduleKo = parseHelper.parse(modelKo)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertWarning(NablaPackage.eINSTANCE.function,
			UnusedValidator::UNUSED,
			UnusedValidator::getUnusedMsg(NablaPackage.Literals.FUNCTION, 'f'))

		val modelOk =
			'''
			«modelKo»
			ComputeV:
			{ 
				let ℝ v = f(orig);
				v = v + 1;
			}
			'''
		val moduleOk = parseHelper.parse(modelOk)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoIssues
	}

	@Test
	def void testCheckUnusedReduction()
	{
		val modelKo = 
			'''
			«emptyTestModule»
			itemtypes { node }
			connectivity nodes: → {node};
			def sum, 0.0: ℝ[2], (a, b) → return a+b;
			let ℝ[2] orig = [0.0 , 0.0];
			ℝ[2] X{nodes};
			'''
		val moduleKo = parseHelper.parse(modelKo)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertWarning(NablaPackage.eINSTANCE.reduction,
			UnusedValidator::UNUSED,
			UnusedValidator::getUnusedMsg(NablaPackage.Literals.REDUCTION, 'sum'))

		val moduleOk = parseHelper.parse(
			'''
			«modelKo»
			ComputeU: orig = sum{r∈nodes()}(X{r});
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoIssues
	}
}
