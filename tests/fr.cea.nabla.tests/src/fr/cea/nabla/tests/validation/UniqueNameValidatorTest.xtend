/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.tests.validation

import com.google.inject.Inject
import com.google.inject.Provider
import fr.cea.nabla.nabla.NablaPackage
import fr.cea.nabla.nabla.NablaRoot
import fr.cea.nabla.tests.NablaInjectorProvider
import fr.cea.nabla.tests.TestUtils
import fr.cea.nabla.validation.UniqueNameValidator
import org.eclipse.emf.ecore.resource.ResourceSet
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
	@Inject ParseHelper<NablaRoot> parseHelper
	@Inject Provider<ResourceSet> resourceSetProvider
	@Inject extension TestUtils
	@Inject extension ValidationTestHelper

	@Test
	def void checkDuplicateArg()
	{
		val rootKo = parseHelper.parse(
			'''
			extension Test;
			def f: int × int → int, (a, a) → { return a; }
			''')
		Assert.assertNotNull(rootKo)
		rootKo.assertError(NablaPackage.eINSTANCE.arg,
			UniqueNameValidator::DUPLICATE_NAME,
			UniqueNameValidator::getDuplicateNameMsg(NablaPackage.Literals.ARG, "a"))

		val rootOk = parseHelper.parse(
			'''
			extension Test;
			def f: int × int → int, (a, b) → { return a; }
			''')
		Assert.assertNotNull(rootOk)
		rootOk.assertNoErrors
	}

	@Test
	def void checkDuplicateVar()
	{
		val rootKo = parseHelper.parse(
			'''
			«emptyTestModule»
			real a, a;
			''')
		Assert.assertNotNull(rootKo)
		rootKo.assertError(NablaPackage.eINSTANCE.^var,
			UniqueNameValidator::DUPLICATE_NAME,
			UniqueNameValidator::getDuplicateNameMsg(NablaPackage.Literals.VAR, "a"))

		val rootOk = parseHelper.parse(
			'''
			«emptyTestModule»
			real a;
			''')
		Assert.assertNotNull(rootOk)
		rootOk.assertNoErrors
	}

	@Test
	def void checkDuplicateArgOrVar()
	{
		val rootKo = parseHelper.parse(
			'''
			«emptyTestModule»
			real a;
			real a;
			''')
		Assert.assertNotNull(rootKo)
		rootKo.assertError(NablaPackage.eINSTANCE.argOrVar,
			UniqueNameValidator::DUPLICATE_NAME,
			UniqueNameValidator::getDuplicateNameMsg(NablaPackage.Literals.ARG_OR_VAR, "a"))

		val rootOk = parseHelper.parse(
			'''
			«emptyTestModule»
			real a;
			''')
		Assert.assertNotNull(rootOk)
		rootOk.assertNoErrors
	}

	@Test
	def void checkDuplicateSpaceIterator()
	{
		val model = 
			'''
			«testModule»
			real XXX{nodes, nodes};
			'''
		val rs = resourceSetProvider.get
		parseHelper.parse(readFileAsString(TestUtils.CartesianMesh2DPath), rs)
		val rootKo1 = parseHelper.parse(
			'''
			«model»
			J1: ∀r∈nodes(), ∀r∈nodes(), let d = XXX{r, r} * 2.0;
			''', rs)
		Assert.assertNotNull(rootKo1)
		rootKo1.assertError(NablaPackage.eINSTANCE.spaceIterator,
			UniqueNameValidator::DUPLICATE_NAME,
			UniqueNameValidator::getDuplicateNameMsg(NablaPackage.Literals.SPACE_ITERATOR, "r"))

		val rootOk = parseHelper.parse(
			'''
			«model»
			J1: ∀r1∈nodes(), ∀r2∈nodes(), let real d = XXX{r1, r2} * 2.0;
			''', rs)
		Assert.assertNotNull(rootOk)
		rootOk.assertNoErrors
	}

	@Test
	def void checkDuplicateSet()
	{
		val rs = resourceSetProvider.get
		parseHelper.parse(readFileAsString(TestUtils.CartesianMesh2DPath), rs)
		val rootKo = parseHelper.parse(
			'''
			«testModule»
			J1: {
				set myNodes = nodes();
				set myNodes = nodes();
			}
			''', rs)
		Assert.assertNotNull(rootKo)
		rootKo.assertError(NablaPackage.eINSTANCE.itemSet,
			UniqueNameValidator::DUPLICATE_NAME,
			UniqueNameValidator::getDuplicateNameMsg(NablaPackage.Literals.ITEM_SET, "myNodes"))

		val rootOk = parseHelper.parse(
			'''
			«testModule»
			real X{nodes, nodes};
			J1: {
				set myNodes = nodes();
				∀r1∈myNodes, ∀r2∈myNodes, let real d = X{r1, r2} * 2.0;
			}
			''', rs)
		Assert.assertNotNull(rootOk)
		rootOk.assertNoErrors
	}

	@Test
	def void checkDuplicateItemType()
	{
		val rootKo = parseHelper.parse(
			'''
			mesh extension Test;
			itemtypes { node, node }
			connectivity nodes: → {node};
			''')
		Assert.assertNotNull(rootKo)
		rootKo.assertError(NablaPackage.eINSTANCE.itemType,
			UniqueNameValidator::DUPLICATE_NAME,
			UniqueNameValidator::getDuplicateNameMsg(NablaPackage.Literals.ITEM_TYPE, "node"))

		val rootOk = parseHelper.parse(
			'''
			mesh extension Test;
			itemtypes { node }
			connectivity nodes: → {node};
			''')
		Assert.assertNotNull(rootOk)
		rootOk.assertNoErrors
	}

	@Test
	def void checkDuplicateConnectivity()
	{
		val rootKo = parseHelper.parse(
			'''
			mesh extension Test;
			itemtypes { node }
			connectivity nodes: → {node};
			connectivity nodes: → {node};
			''')
		Assert.assertNotNull(rootKo)
		rootKo.assertError(NablaPackage.eINSTANCE.connectivity,
			UniqueNameValidator::DUPLICATE_NAME,
			UniqueNameValidator::getDuplicateNameMsg(NablaPackage.Literals.CONNECTIVITY, "nodes"))

		val rootOk = parseHelper.parse(
			'''
			mesh extension Test;
			itemtypes { node }
			connectivity nodes: → {node};
			''')
		Assert.assertNotNull(rootOk)
		rootOk.assertNoErrors
	}

	@Test
	def void checkDuplicateJob()
	{
		val rootKo = parseHelper.parse(
			'''
			«emptyTestModule»
			real a;
			IncrA: a = a + 1;
			IncrA: a = a + 1;
			''')
		Assert.assertNotNull(rootKo)
		rootKo.assertError(NablaPackage.eINSTANCE.job,
			UniqueNameValidator::DUPLICATE_NAME,
			UniqueNameValidator::getDuplicateNameMsg(NablaPackage.Literals.JOB, "IncrA"))

		val rootOk = parseHelper.parse(
			'''
			«emptyTestModule»
			real a;
			IncrA: a = a + 1;
			''')
		Assert.assertNotNull(rootOk)
		rootOk.assertNoErrors
	}


	@Test
	def void checkDuplicateTimeIterator()
	{
		val rootKo = parseHelper.parse(
			'''
			«emptyTestModule»
			iterate n while (true), n while (true);
			''')
		Assert.assertNotNull(rootKo)
		rootKo.assertError(NablaPackage.eINSTANCE.timeIterator,
			UniqueNameValidator::DUPLICATE_NAME,
			UniqueNameValidator::getDuplicateNameMsg(NablaPackage.Literals.TIME_ITERATOR, "n"))

		val rootKo2 = parseHelper.parse(
			'''
			«emptyTestModule»
			int n;
			iterate n while (true), m while (true);
			''')
		Assert.assertNotNull(rootKo2)
		rootKo2.assertError(NablaPackage.eINSTANCE.argOrVar,
			UniqueNameValidator::DUPLICATE_NAME,
			UniqueNameValidator::getDuplicateNameMsg(NablaPackage.Literals.ARG_OR_VAR, "n (iterator)"))

		val rootOk = parseHelper.parse(
			'''
			«emptyTestModule»
			iterate n while (true), m while (true);
			''')
		Assert.assertNotNull(rootOk)
		rootOk.assertNoErrors
	}
}
