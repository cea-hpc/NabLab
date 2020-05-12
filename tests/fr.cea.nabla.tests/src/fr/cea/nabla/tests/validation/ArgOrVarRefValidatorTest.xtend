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
	@Inject extension TestUtils
	@Inject extension ValidationTestHelper
	@Inject extension NablaModuleExtensions

	@Test
	def void testCheckIndicesNumber()
	{
		val moduleKo = parseHelper.parse(testModule +
			'''
			let a = ℕ[2,2](0);
			let b = a[0];
			let c = ℕ[2](0);
			let d = c[0,1];
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.argOrVarRef,
			ArgOrVarRefValidator::INDICES_NUMBER,
			ArgOrVarRefValidator::getIndicesNumberMsg(2,1))

		moduleKo.assertError(NablaPackage.eINSTANCE.argOrVarRef,
			ArgOrVarRefValidator::INDICES_NUMBER,
			ArgOrVarRefValidator::getIndicesNumberMsg(1,2))

		val moduleOk =  parseHelper.parse(testModule +
			'''
			let a = ℕ[2,2](0);
			let b = a[0,0];
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckSpaceIteratorNumberAndType() 
	{
		val moduleKo = parseHelper.parse(getTestModule(defaultConnectivities, '') +
			'''
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
			ArgOrVarRefValidator::getSpaceIteratorTypeMsg(node, cell))

		val moduleOk =  parseHelper.parse(getTestModule(defaultConnectivities, '') +
			'''
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
	def void testCheckTimeIteratorUsage() 
	{
		val moduleKo = parseHelper.parse(getTestModule('', '') +
			'''
			ℝ u, v;
			iterate n while(true);
			ComputeU: u^{n+1} = u^{n} + 6.0;
			ComputeV: v = u + 4.0; // Wrong: must be u^{n}
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.argOrVarRef,
			ArgOrVarRefValidator::TIME_ITERATOR_USAGE,
			ArgOrVarRefValidator::getTimeIteratorUsageMsg())

		val moduleOk =  parseHelper.parse(getTestModule('', '') +
			'''
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
		val moduleKo1 = parseHelper.parse(getTestModule('', '') +
			'''
			let a = ℕ[2](0);
			let m = a[2.3];
			'''
		)
		Assert.assertNotNull(moduleKo1)
		moduleKo1.assertError(NablaPackage.eINSTANCE.argOrVarRef,
			BasicValidator::TYPE_EXPRESSION_TYPE,
			BasicValidator::getTypeExpressionMsg("ℝ"))

		val moduleKo2 = parseHelper.parse(getTestModule('', '') +
			'''
			let a = ℕ[2](0);
			let b = 1.2;
			let o = a[b];
			'''
		)
		Assert.assertNotNull(moduleKo2)
		moduleKo2.assertError(NablaPackage.eINSTANCE.argOrVarRef,
			BasicValidator::TYPE_EXPRESSION_TYPE,
			BasicValidator::getTypeExpressionMsg("ℝ"))

		val moduleOk =  parseHelper.parse(getTestModule('', '') +
			'''
			let a = ℕ[2](0);
			let b = 1;

			let m = a[2];
			let o = a[b];
			let p = a[b + 4];
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}
}
