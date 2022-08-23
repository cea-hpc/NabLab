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
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NablaPackage
import fr.cea.nabla.tests.NablaInjectorProvider
import fr.cea.nabla.tests.TestUtils
import fr.cea.nabla.validation.UnusedValidator
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
class UnusedValidatorTest
{
	@Inject ParseHelper<NablaModule> parseHelper
	@Inject Provider<ResourceSet> resourceSetProvider
	@Inject extension TestUtils
	@Inject extension ValidationTestHelper

	@Test
	def testCheckUnusedTimeIterator()
	{
		val moduleKo = parseHelper.parse(
			'''
			«emptyTestModule»
			iterate n while(true);
			''')
		Assert.assertNotNull(moduleKo)

		moduleKo.assertWarning(NablaPackage.eINSTANCE.timeIterator,
			UnusedValidator::UNUSED,
			UnusedValidator::getUnusedMsg(NablaPackage.Literals.TIME_ITERATOR, 'n'))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			real u, v;
			iterate n while(true);
			ComputeU: u^{n+1} = u^{n} + 6.0;
			''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckUnusedVariable()
	{
		val moduleKo = parseHelper.parse(
			'''
			«emptyTestModule»
			real a;
			''')
		Assert.assertNotNull(moduleKo)

		moduleKo.assertWarning(NablaPackage.eINSTANCE.^var, 
			UnusedValidator::UNUSED, 
			UnusedValidator::getUnusedMsg(NablaPackage.Literals.VAR, 'a'))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			real a;
			ComputeA: a = 1.;
			''')

		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoIssues
	}

	@Test
	def void testCheckUnusedSpaceIterator()
	{
		val rs = resourceSetProvider.get
		parseHelper.parse(readFileAsString(TestUtils.CartesianMesh2DPath), rs)
		val moduleKo1 = parseHelper.parse(
			'''
			«emptyTestModule»
			with CartesianMesh2D.*;
			UpdateX: forall r1 in nodes(), forall r2 in nodes(), X{r1} = X{r1} + 1;
			''', rs)
		Assert.assertNotNull(moduleKo1)
		moduleKo1.assertWarning(NablaPackage.eINSTANCE.spaceIterator,
			UnusedValidator::UNUSED,
			UnusedValidator::getUnusedMsg(NablaPackage.Literals.SPACE_ITERATOR, 'r2'))

		val moduleKo2 = parseHelper.parse(
			'''
			«emptyTestModule»
			with CartesianMesh2D.*;
			real[2] X{nodes};
			UpdateX: forall r1 in nodes(), forall r2 in topLeftNode(), X{r1} = X{r1} + 1;
			''', rs)
		Assert.assertNotNull(moduleKo1)
		moduleKo2.assertWarning(NablaPackage.eINSTANCE.spaceIterator,
			UnusedValidator::UNUSED,
			UnusedValidator::getUnusedMsg(NablaPackage.Literals.SPACE_ITERATOR, 'r2'))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			with CartesianMesh2D.*;
			real[2] X{nodes};
			UpdateX: forall r1 in nodes(), X{r1} = X{r1} + 1;
			''', rs)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoIssues
	}

	@Test
	def void testCheckUnusedItemSet()
	{
		val model = 
			'''
			«emptyTestModule»
			with CartesianMesh2D.*;
			real[2] X{nodes};
			'''
		val rs = resourceSetProvider.get
		parseHelper.parse(readFileAsString(TestUtils.CartesianMesh2DPath), rs)
		val moduleKo = parseHelper.parse(
			'''
			«model»
			UpdateX: {
				set myNodes = nodes();
				forall r1 in nodes(), X{r1} = X{r1} + 1;
			}
			''', rs)
		Assert.assertNotNull(moduleKo)
		moduleKo.assertWarning(NablaPackage.eINSTANCE.itemSet,
			UnusedValidator::UNUSED,
			UnusedValidator::getUnusedMsg(NablaPackage.Literals.ITEM_SET, 'myNodes'))

		val moduleOk = parseHelper.parse(
			'''
			«model»
			UpdateX: {
				set myNodes = nodes();
				forall r1 in myNodes, X{r1} = X{r1} + 1;
			}
			''', rs)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoIssues
	}

	@Test
	def void testCheckUnusedFunction() 
	{
		val modelKo = 
			'''
			«emptyTestModule»
			def <x> real f(real[x] a) return 1.0;
			let real[2] orig = [0.0 , 0.0];
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
				let real v = f(orig);
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
			with CartesianMesh2D.*;
			red real[2] sum(0.0) (a, b) : return a+b;
			let real[2] orig = [0.0 , 0.0];
			real[2] X{nodes};
			'''
		val rs = resourceSetProvider.get
		parseHelper.parse(readFileAsString(TestUtils.CartesianMesh2DPath), rs)
		val moduleKo = parseHelper.parse(modelKo, rs)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertWarning(NablaPackage.eINSTANCE.reduction,
			UnusedValidator::UNUSED,
			UnusedValidator::getUnusedMsg(NablaPackage.Literals.REDUCTION, 'sum'))

		val moduleOk = parseHelper.parse(
			'''
			«modelKo»
			ComputeU: orig = sum{r in nodes()}(X{r});
			''', rs)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoIssues
	}
}
