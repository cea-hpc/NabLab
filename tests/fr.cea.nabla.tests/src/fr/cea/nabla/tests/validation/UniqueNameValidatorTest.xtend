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
import fr.cea.nabla.validation.UniqueNameValidator
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(NablaInjectorProvider))
class UniqueNameValidatorTest
{
	@Inject ParseHelper<NablaModule> parseHelper
	@Inject extension TestUtils
	@Inject extension ValidationTestHelper

	@Test
	def void checkDuplicateArg()
	{
		val moduleKo = parseHelper.parse(getTestModule('', '''def f: ℕ × ℕ → ℕ, (a, a) → { return a; }'''))
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.arg,
			UniqueNameValidator::DUPLICATE_NAME,
			UniqueNameValidator::getDuplicateNameMsg(NablaPackage.Literals.ARG, "a"))

		val moduleOk = parseHelper.parse(getTestModule('', '''def f: ℕ × ℕ → ℕ, (a, b) → { return a; }'''))
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void checkDuplicateVar()
	{
		val moduleKo = parseHelper.parse(testModule +
		'''
			ℝ a, a;
		''')
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.^var,
			UniqueNameValidator::DUPLICATE_NAME,
			UniqueNameValidator::getDuplicateNameMsg(NablaPackage.Literals.VAR, "a"))

		val moduleOk = parseHelper.parse(testModule +
		'''
			ℝ a;
		''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void checkDuplicateArgOrVar()
	{
		val moduleKo = parseHelper.parse(testModule +
		'''
			ℝ a;
			ℝ a;
		''')
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.argOrVar,
			UniqueNameValidator::DUPLICATE_NAME,
			UniqueNameValidator::getDuplicateNameMsg(NablaPackage.Literals.ARG_OR_VAR, "a"))

		val moduleOk = parseHelper.parse(testModule +
		'''
			ℝ a;
		''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void checkDuplicateItem()
	{
		val moduleKo1 = parseHelper.parse(getTestModule(
		'''
		itemtypes { node }
		set nodes: → {node};
		''', '') +
		'''
			ℝ X{nodes, nodes};
			j1: ∀r∈nodes(), ∀r∈nodes(), let d = X{r, r} * 2.0;
		''')
		Assert.assertNotNull(moduleKo1)
		moduleKo1.assertError(NablaPackage.eINSTANCE.item,
			UniqueNameValidator::DUPLICATE_NAME,
			UniqueNameValidator::getDuplicateNameMsg(NablaPackage.Literals.ITEM, "r"))

		val moduleKo2 = parseHelper.parse(getTestModule(
		'''
		itemtypes { node }
		set nodes: → {node};
		item topLeftNode: → node;
		''', '') +
		'''
			ℝ X{nodes, nodes};
			j1: {
				item r1 = topLeftNode();
				∀r1∈nodes(), ∀r2∈nodes(), let d = X{r1, r2} * 2.0;
			}
		''')
		Assert.assertNotNull(moduleKo2)
		moduleKo2.assertError(NablaPackage.eINSTANCE.item,
			UniqueNameValidator::DUPLICATE_NAME,
			UniqueNameValidator::getDuplicateNameMsg(NablaPackage.Literals.ITEM, "r1"))

		val moduleOk = parseHelper.parse(getTestModule(nodesConnectivity, '') +
		'''
			ℝ X{nodes, nodes};
			j1: ∀r1∈nodes(), ∀r2∈nodes(), let d = X{r1, r2} * 2.0;
		''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void checkDuplicateSet()
	{
		val moduleKo = parseHelper.parse(getTestModule(nodesConnectivity, '') +
		'''
			j1: {
				set myNodes = nodes();
				set myNodes = nodes();
			}
		''')
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.setDefinition,
			UniqueNameValidator::DUPLICATE_NAME,
			UniqueNameValidator::getDuplicateNameMsg(NablaPackage.Literals.SET_DEFINITION, "myNodes"))

		val moduleOk = parseHelper.parse(getTestModule(nodesConnectivity, '') +
		'''
			ℝ X{nodes, nodes};
			j1: {
				set myNodes = nodes();
				∀r1∈myNodes, ∀r2∈myNodes, let d = X{r1, r2} * 2.0;
			}
		''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void checkDuplicateItemType()
	{
		val moduleKo = parseHelper.parse('''
			module Test;

			itemtypes { node, node }

			set nodes: → {node};

			option X_EDGE_LENGTH = 0.01;
			option Y_EDGE_LENGTH = X_EDGE_LENGTH;
			option X_EDGE_ELEMS = 100;
			option Y_EDGE_ELEMS = 10;
		''')
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.itemType,
			UniqueNameValidator::DUPLICATE_NAME,
			UniqueNameValidator::getDuplicateNameMsg(NablaPackage.Literals.ITEM_TYPE, "node"))

		val moduleOk = parseHelper.parse('''
			module Test;

			itemtypes { node }

			set nodes: → {node};

			option X_EDGE_LENGTH = 0.01;
			option Y_EDGE_LENGTH = X_EDGE_LENGTH;
			option X_EDGE_ELEMS = 100;
			option Y_EDGE_ELEMS = 10;
		''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void checkDuplicateConnectivity()
	{
		val moduleKo = parseHelper.parse('''
			module Test;

			itemtypes { node }

			set nodes: → {node};
			set nodes: → {node};

			option X_EDGE_LENGTH = 0.01;
			option Y_EDGE_LENGTH = X_EDGE_LENGTH;
			option X_EDGE_ELEMS = 100;
			option Y_EDGE_ELEMS = 10;
		''')
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.connectivity,
			UniqueNameValidator::DUPLICATE_NAME,
			UniqueNameValidator::getDuplicateNameMsg(NablaPackage.Literals.MULTIPLE_CONNECTIVITY, "nodes"))

		val moduleOk = parseHelper.parse('''
			module Test;

			itemtypes { node }

			set nodes: → {node};

			option X_EDGE_LENGTH = 0.01;
			option Y_EDGE_LENGTH = X_EDGE_LENGTH;
			option X_EDGE_ELEMS = 100;
			option Y_EDGE_ELEMS = 10;
		''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void checkDuplicateJob()
	{
		val moduleKo = parseHelper.parse(testModule +
		'''
			ℝ a;
			IncrA: a = a + 1;
			IncrA: a = a + 1;
		''')
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.job,
			UniqueNameValidator::DUPLICATE_NAME,
			UniqueNameValidator::getDuplicateNameMsg(NablaPackage.Literals.JOB, "IncrA"))

		val moduleOk = parseHelper.parse(testModule +
		'''
			ℝ a;
			IncrA: a = a + 1;
		''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}


	@Test
	def void checkDuplicateTimeIterator()
	{
		val moduleKo = parseHelper.parse(getTestModule('', '') + '''iterate n while (true), n while (true);''')
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.timeIterator,
			UniqueNameValidator::DUPLICATE_NAME,
			UniqueNameValidator::getDuplicateNameMsg(NablaPackage.Literals.TIME_ITERATOR, "n"))

		val moduleKo2 = parseHelper.parse(getTestModule('', '') + '''
			ℕ n;
			iterate n while (true), m while (true);
			''')
		Assert.assertNotNull(moduleKo2)
		moduleKo2.assertError(NablaPackage.eINSTANCE.argOrVar,
			UniqueNameValidator::DUPLICATE_NAME,
			UniqueNameValidator::getDuplicateNameMsg(NablaPackage.Literals.ARG_OR_VAR, "n (iterator)"))

		val moduleOk = parseHelper.parse(getTestModule('', '') + '''iterate n while (true), m while (true);''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}
}
