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
import fr.cea.nabla.validation.ArgOrVarRefValidator
import fr.cea.nabla.validation.BasicValidator
import fr.cea.nabla.validation.ValidationUtils
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
class ArgOrVarRefValidatorTest
{
	@Inject ParseHelper<NablaModule> parseHelper
	@Inject Provider<ResourceSet> resourceSetProvider
	@Inject extension ValidationUtils
	@Inject extension TestUtils
	@Inject extension ValidationTestHelper

	@Test
	def void testCheckIndicesNumber()
	{
		val moduleKo = parseHelper.parse(
			'''
			«emptyTestModule»
			let int[2,2] a = int[2,2](0);
			let int[2] b = a[0]; // Wrong number of args
			let int[2] c = int[2](0);
			let int d = c[0,1]; // Wrong number of args
			''')
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.argOrVarRef,
			ArgOrVarRefValidator::INDICES_NUMBER,
			ArgOrVarRefValidator::getIndicesNumberMsg(2,1))

		moduleKo.assertError(NablaPackage.eINSTANCE.argOrVarRef,
			ArgOrVarRefValidator::INDICES_NUMBER,
			ArgOrVarRefValidator::getIndicesNumberMsg(1,2))

		val moduleOk =  parseHelper.parse(
			'''
			«emptyTestModule»
			let int[2,2] a = int[2,2](0);
			let int b = a[0,0];
			''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckSpaceIteratorNumberAndType()
	{
		val rs = resourceSetProvider.get
		parseHelper.parse(readFileAsString(TestUtils.CartesianMesh2DPath), rs)
		val moduleKo = parseHelper.parse(
			'''
			«testModule»
			real u{cells}, v{cells, nodesOfCell}, w{nodes};
			ComputeU: forall  j in cells(), forall r in nodesOfCell(j), u{j,r} = 1.;
			ComputeV: forall  j in cells(), forall r in nodesOfCell(j), v{j} = 1.;
			ComputeW: forall  j in cells(), w{j} = 1.;
			''', rs)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.argOrVarRef,
			ArgOrVarRefValidator::SPACE_ITERATOR_NUMBER,
			ArgOrVarRefValidator::getSpaceIteratorNumberMsg(1,2))

		moduleKo.assertError(NablaPackage.eINSTANCE.argOrVarRef,
			ArgOrVarRefValidator::SPACE_ITERATOR_NUMBER,
			ArgOrVarRefValidator::getSpaceIteratorNumberMsg(2,1))

		moduleKo.assertError(NablaPackage.eINSTANCE.argOrVarRef,
			ArgOrVarRefValidator::SPACE_ITERATOR_TYPE, 
			getTypeMsg("node", "cell"))

		val moduleOk =  parseHelper.parse(
			'''
			«testModule»
			real u{cells}, v{cells, nodesOfCell}, w{nodes};
			ComputeU: forall  j in cells(), forall r in nodesOfCell(j), u{j} = 1.;
			ComputeV: forall  j in cells(), forall r in nodesOfCell(j), v{j,r} = 1.;
			ComputeW: forall  j in nodes(), w{j} = 1.;
			''', rs)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckRequiredTimeIterator()
	{
		val rs = resourceSetProvider.get
		parseHelper.parse(readFileAsString(TestUtils.CartesianMesh2DPath), rs)
		val moduleKo = parseHelper.parse(
			'''
			«testModule»
			real u, v;
			iterate n while(true);
			ComputeU: u^{n+1} = u^{n} + 6.0;
			ComputeV: v = u + 4.0; // Wrong: must be u^{n}
			''', rs)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.argOrVarRef,
			ArgOrVarRefValidator::REQUIRED_TIME_ITERATOR,
			ArgOrVarRefValidator::getRequiredTimeIteratorMsg())

		val moduleOk =  parseHelper.parse(
			'''
			«testModule»
			real u, v;
			iterate n while(true);
			ComputeU: u^{n+1} = u^{n} + 6.0;
			ComputeV: v = u^{n} + 4.0; // Wrong: must be u^{n}
			''', rs)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckIllegalTimeIterator()
	{
		val rs = resourceSetProvider.get
		parseHelper.parse(readFileAsString(TestUtils.CartesianMesh2DPath), rs)
		val moduleKo1 = parseHelper.parse(
			'''
			«testModule»
			let real u=0;
			real v;
			iterate n while(true);
			ComputeU: u^{n+1} = u^{n} + 6.0;
			ComputeV: v = u + 4.0; // Wrong: must be u^{n}
			''', rs)
		Assert.assertNotNull(moduleKo1)
		moduleKo1.assertError(NablaPackage.eINSTANCE.argOrVarRef,
			ArgOrVarRefValidator::ILLEGAL_TIME_ITERATOR,
			ArgOrVarRefValidator::getIllegalTimeIteratorMsg())

		val moduleKo2 = parseHelper.parse(
			'''
			«testModule»
			let real u = 3.4;
			real v;
			iterate n while(true);
			ComputeU: u^{n+1} = u^{n} + 6.0;
			ComputeV: v = u + 4.0; // Wrong: must be u^{n}
			''', rs)
		Assert.assertNotNull(moduleKo2)
		moduleKo2.assertError(NablaPackage.eINSTANCE.argOrVarRef,
			ArgOrVarRefValidator::ILLEGAL_TIME_ITERATOR,
			ArgOrVarRefValidator::getIllegalTimeIteratorMsg())

		val moduleKo3 = parseHelper.parse(
			'''
			«testModule»
			real u, v;
			iterate n while(true);
			ComputeU: u^{n+1} = u^{n} + n^{n} + 6.0;
			ComputeV: v = u + 4.0; // Wrong: must be u^{n}
			''', rs)
		Assert.assertNotNull(moduleKo3)
		moduleKo3.assertError(NablaPackage.eINSTANCE.argOrVarRef,
			ArgOrVarRefValidator::ILLEGAL_TIME_ITERATOR,
			ArgOrVarRefValidator::getIllegalTimeIteratorMsg())

		val moduleOk =  parseHelper.parse(
			'''
			«testModule»
			real u, v;
			iterate n while(true);
			ComputeU: u^{n+1} = u^{n} + 6.0;
			ComputeV: v = u^{n} + 4.0; // Wrong: must be u^{n}
			''', rs)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckIndicesExpressionAndType()
	{
		val rs = resourceSetProvider.get
		parseHelper.parse(readFileAsString(TestUtils.CartesianMesh2DPath), rs)
		val moduleKo1 = parseHelper.parse(
			'''
			«testModule»
			let int[2] a = int[2](0);
			let int m = a[2.3];
			''', rs)
		Assert.assertNotNull(moduleKo1)
		moduleKo1.assertError(NablaPackage.eINSTANCE.argOrVarRef,
			BasicValidator::TYPE_EXPRESSION_TYPE,
			getTypeMsg("real", "int"))

		val moduleKo2 = parseHelper.parse(
			'''
			«testModule»
			let int[2] a = int[2](0);
			let real b = 1.2;
			let int o = a[b];
			''', rs)
		Assert.assertNotNull(moduleKo2)
		moduleKo2.assertError(NablaPackage.eINSTANCE.argOrVarRef,
			BasicValidator::TYPE_EXPRESSION_TYPE,
			getTypeMsg("real", "int"))

		val moduleOk =  parseHelper.parse(
			'''
			«testModule»
			let int[2] a = int[2](0);
			let int b = 1;

			let int m = a[2];
			let int o = a[b];
			let int p = a[b + 4];
			''', rs)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckNullType()
	{
		val rs = resourceSetProvider.get
		parseHelper.parse(readFileAsString(TestUtils.CartesianMesh2DPath), rs)
		val moduleKo = parseHelper.parse(
			'''
			«testModule»
			real[2] X{nodes};
			real x{nodes};
			InitY : y = X[1]; // wrong syntax. Precise space iterator before indice
			''', rs)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.argOrVarRef,
			ArgOrVarRefValidator::NULL_TYPE,
			ArgOrVarRefValidator::getNullTypeMsg())

		val moduleOk =  parseHelper.parse(
			'''
			«testModule»
			real[2] X{nodes};
			real y{nodes};
			InitY : forall r in nodes(), y{r} = X{r}[1];
			''', rs)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}
}
