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
		val moduleKo = parseHelper.parse(testModule +
			'''
			iterate n while(true);
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertWarning(NablaPackage.eINSTANCE.timeIterator,
			UnusedValidator::UNUSED,
			UnusedValidator::getUnusedMsg(NablaPackage.Literals.TIME_ITERATOR, 'n'))

		val moduleOk = parseHelper.parse(testModule +
			'''
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
			testModule +
			'''
			ℝ a;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertWarning(NablaPackage.eINSTANCE.^var, 
			UnusedValidator::UNUSED, 
			UnusedValidator::getUnusedMsg(NablaPackage.Literals.VAR, 'a'))

		val moduleOk = parseHelper.parse(
			testModule +
			'''
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
		val connectivities =
			'''
			itemtypes { node }
			set nodes: → {node};
			set borderNodes: → {node};
			'''
		val moduleKo = parseHelper.parse(getTestModule(connectivities, ''))
		Assert.assertNotNull(moduleKo)

		moduleKo.assertWarning(NablaPackage.eINSTANCE.connectivity,
			UnusedValidator::UNUSED,
			UnusedValidator::getUnusedMsg(NablaPackage.Literals.CONNECTIVITY, 'nodes'))

		moduleKo.assertWarning(NablaPackage.eINSTANCE.connectivity,
			UnusedValidator::UNUSED,
			UnusedValidator::getUnusedMsg(NablaPackage.Literals.CONNECTIVITY, 'borderNodes'))

		val moduleOk = parseHelper.parse(getTestModule(connectivities, '')
			+
			'''
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
		val moduleKo = parseHelper.parse(getTestModule(
			'''
			itemtypes { node }
			''', ''))
		Assert.assertNotNull(moduleKo)
		moduleKo.assertWarning(NablaPackage.eINSTANCE.itemType,
			UnusedValidator::UNUSED,
			UnusedValidator::getUnusedMsg(NablaPackage.Literals.ITEM_TYPE, 'node'))

		val moduleOk = parseHelper.parse(getTestModule(
			'''
			itemtypes { node }
			set nodes: → {node};
			''', '') + 
			'''
			ℝ[2] X{nodes};
			UpdateX: ∀r1∈nodes(), X{r1} = X{r1} + 1;
			'''
			)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoIssues
	}

	@Test
	def void testCheckUnusedItem()
	{
		val moduleKo = parseHelper.parse(getTestModule(nodesConnectivity, '') +
			'''
			UpdateX: ∀r1∈nodes(), ∀r2∈nodes(), X{r1} = X{r1} + 1;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertWarning(NablaPackage.eINSTANCE.item,
			UnusedValidator::UNUSED,
			UnusedValidator::getUnusedMsg(NablaPackage.Literals.ITEM, 'r2'))

		val moduleOk = parseHelper.parse(getTestModule(nodesConnectivity, '') +
			'''
			ℝ[2] X{nodes};
			UpdateX: ∀r1∈nodes(), X{r1} = X{r1} + 1;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoIssues
	}

	@Test
	def void testCheckUnusedFunction() 
	{
		val modelKo = getTestModule('', '''def f: x | ℝ[x] → ℝ''')
		val moduleKo = parseHelper.parse(modelKo)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertWarning(NablaPackage.eINSTANCE.function,
			UnusedValidator::UNUSED,
			UnusedValidator::getUnusedMsg(NablaPackage.Literals.FUNCTION, 'f'))

		val modelOk = getTestModule('', '''def f: x | ℝ[x] → ℝ;''') +
			'''
			let orig = [0.0 , 0.0];
			ComputeV:
			{ 
				let v = f(orig);
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
		val reduc = '''def sum, 0.0: ℝ[2], (a, b) → return a+b;'''
		val moduleKo = parseHelper.parse(getTestModule('', reduc))
		Assert.assertNotNull(moduleKo)

		moduleKo.assertWarning(NablaPackage.eINSTANCE.reduction,
			UnusedValidator::UNUSED,
			UnusedValidator::getUnusedMsg(NablaPackage.Literals.REDUCTION, 'sum'))

		val moduleOk = parseHelper.parse(getTestModule(nodesConnectivity, reduc) +
			'''
			let orig = [0.0 , 0.0];
			ℝ[2] X{nodes};
			ComputeU: orig = sum{r∈nodes()}(X{r});
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoIssues
	}
}
