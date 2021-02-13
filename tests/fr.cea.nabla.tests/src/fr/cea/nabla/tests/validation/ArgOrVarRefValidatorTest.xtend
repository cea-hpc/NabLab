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
import fr.cea.nabla.NablaModuleExtensions
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NablaPackage
import fr.cea.nabla.tests.NablaInjectorProvider
import fr.cea.nabla.tests.TestUtils
import fr.cea.nabla.validation.ArgOrVarRefValidator
import fr.cea.nabla.validation.BasicValidator
import fr.cea.nabla.validation.ValidationUtils
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
	@Inject extension ValidationUtils
	@Inject extension TestUtils
	@Inject extension ValidationTestHelper
	@Inject extension NablaModuleExtensions

	@Test
	def void testCheckIndicesNumber()
	{
		val moduleKo = parseHelper.parse(
			'''
			«emptyTestModule»
			let ℕ[2,2] a = ℕ[2,2](0);
			let ℕ[2] b = a[0]; // Wrong number of args
			let ℕ[2] c = ℕ[2](0);
			let ℕ d = c[0,1]; // Wrong number of args
			'''
		)
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
			let ℕ[2,2] a = ℕ[2,2](0);
			let ℕ b = a[0,0];
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckSpaceIteratorNumberAndType()
	{
		val moduleKo = parseHelper.parse(
			'''
			«testModuleForSimulation»
			ℝ u{cells}, v{cells, nodesOfCell}, w{nodes};
			ComputeU: ∀ j∈cells(), ∀r∈nodesOfCell(j), u{j,r} = 1.;
			ComputeV: ∀ j∈cells(), ∀r∈nodesOfCell(j), v{j} = 1.;
			ComputeW: ∀ j∈cells(), w{j} = 1.;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.argOrVarRef,
			ArgOrVarRefValidator::SPACE_ITERATOR_NUMBER,
			ArgOrVarRefValidator::getSpaceIteratorNumberMsg(1,2))

		moduleKo.assertError(NablaPackage.eINSTANCE.argOrVarRef,
			ArgOrVarRefValidator::SPACE_ITERATOR_NUMBER,
			ArgOrVarRefValidator::getSpaceIteratorNumberMsg(2,1))

		val node = moduleKo.getItemTypeByName("node").name
		val cell = moduleKo.getItemTypeByName("cell").name

		moduleKo.assertError(NablaPackage.eINSTANCE.argOrVarRef,
			ArgOrVarRefValidator::SPACE_ITERATOR_TYPE, 
			getTypeMsg(node, cell))

		val moduleOk =  parseHelper.parse(
			'''
			«testModuleForSimulation»
			ℝ u{cells}, v{cells, nodesOfCell}, w{nodes};
			ComputeU: ∀ j∈cells(), ∀r∈nodesOfCell(j), u{j} = 1.;
			ComputeV: ∀ j∈cells(), ∀r∈nodesOfCell(j), v{j,r} = 1.;
			ComputeW: ∀ j∈nodes(), w{j} = 1.;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckRequiredTimeIterator()
	{
		val moduleKo = parseHelper.parse(
			'''
			«testModuleForSimulation»
			ℝ u, v;
			iterate n while(true);
			ComputeU: u^{n+1} = u^{n} + 6.0;
			ComputeV: v = u + 4.0; // Wrong: must be u^{n}
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.argOrVarRef,
			ArgOrVarRefValidator::REQUIRED_TIME_ITERATOR,
			ArgOrVarRefValidator::getRequiredTimeIteratorMsg())

		val moduleOk =  parseHelper.parse(
			'''
			«testModuleForSimulation»
			ℝ u, v;
			iterate n while(true);
			ComputeU: u^{n+1} = u^{n} + 6.0;
			ComputeV: v = u^{n} + 4.0; // Wrong: must be u^{n}
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckIllegalTimeIterator()
	{
		val moduleKo1 = parseHelper.parse(
			'''
			«testModuleForSimulation»
			let ℝ u=0;
			ℝ v;
			iterate n while(true);
			ComputeU: u^{n+1} = u^{n} + 6.0;
			ComputeV: v = u + 4.0; // Wrong: must be u^{n}
			'''
		)
		Assert.assertNotNull(moduleKo1)
		moduleKo1.assertError(NablaPackage.eINSTANCE.argOrVarRef,
			ArgOrVarRefValidator::ILLEGAL_TIME_ITERATOR,
			ArgOrVarRefValidator::getIllegalTimeIteratorMsg())

		val moduleKo2 = parseHelper.parse(
			'''
			«testModuleForSimulation»
			option ℝ u;
			ℝ v;
			iterate n while(true);
			ComputeU: u^{n+1} = u^{n} + 6.0;
			ComputeV: v = u + 4.0; // Wrong: must be u^{n}
			'''
		)
		Assert.assertNotNull(moduleKo2)
		moduleKo2.assertError(NablaPackage.eINSTANCE.argOrVarRef,
			ArgOrVarRefValidator::ILLEGAL_TIME_ITERATOR,
			ArgOrVarRefValidator::getIllegalTimeIteratorMsg())

		val moduleKo3 = parseHelper.parse(
			'''
			«testModuleForSimulation»
			ℝ u, v;
			iterate n while(true);
			ComputeU: u^{n+1} = u^{n} + n^{n} + 6.0;
			ComputeV: v = u + 4.0; // Wrong: must be u^{n}
			'''
		)
		Assert.assertNotNull(moduleKo3)
		moduleKo3.assertError(NablaPackage.eINSTANCE.argOrVarRef,
			ArgOrVarRefValidator::ILLEGAL_TIME_ITERATOR,
			ArgOrVarRefValidator::getIllegalTimeIteratorMsg())

		val moduleOk =  parseHelper.parse(
			'''
			«testModuleForSimulation»
			ℝ u, v;
			iterate n while(true);
			ComputeU: u^{n+1} = u^{n} + 6.0;
			ComputeV: v = u^{n} + 4.0; // Wrong: must be u^{n}
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckIndicesExpressionAndType()
	{
		val moduleKo1 = parseHelper.parse(
			'''
			«testModuleForSimulation»
			let ℕ[2] a = ℕ[2](0);
			let ℕ m = a[2.3];
			'''
		)
		Assert.assertNotNull(moduleKo1)
		moduleKo1.assertError(NablaPackage.eINSTANCE.argOrVarRef,
			BasicValidator::TYPE_EXPRESSION_TYPE,
			getTypeMsg("ℝ", "ℕ"))

		val moduleKo2 = parseHelper.parse(
			'''
			«testModuleForSimulation»
			let ℕ[2] a = ℕ[2](0);
			let ℝ b = 1.2;
			let ℕ o = a[b];
			'''
		)
		Assert.assertNotNull(moduleKo2)
		moduleKo2.assertError(NablaPackage.eINSTANCE.argOrVarRef,
			BasicValidator::TYPE_EXPRESSION_TYPE,
			getTypeMsg("ℝ", "ℕ"))

		val moduleOk =  parseHelper.parse(
			'''
			«testModuleForSimulation»
			let ℕ[2] a = ℕ[2](0);
			let ℕ b = 1;

			let ℕ m = a[2];
			let ℕ o = a[b];
			let ℕ p = a[b + 4];
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckNullType()
	{
		val moduleKo = parseHelper.parse(
			'''
			«testModuleForSimulation»
			ℝ[2] X{nodes};
			ℝ x{nodes};
			InitY : y = X[1]; // wrong syntax. Precise space iterator before indice
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.argOrVarRef,
			ArgOrVarRefValidator::NULL_TYPE,
			ArgOrVarRefValidator::getNullTypeMsg())

		val moduleOk =  parseHelper.parse(
			'''
			«testModuleForSimulation»
			ℝ[2] X{nodes};
			ℝ y{nodes};
			InitY : ∀r ∈nodes(), y{r} = X{r}[1];
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}
}
