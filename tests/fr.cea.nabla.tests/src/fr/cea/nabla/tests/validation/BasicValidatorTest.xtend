/*******************************************************************************
 * Copyright (c) 2021 CEA
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
import fr.cea.nabla.nabla.NablaRoot
import fr.cea.nabla.tests.NablaInjectorProvider
import fr.cea.nabla.tests.TestUtils
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
class BasicValidatorTest
{
	@Inject ParseHelper<NablaRoot> parseHelper
	@Inject Provider<ResourceSet> resourceSetProvider
	@Inject extension ValidationUtils
	@Inject extension TestUtils
	@Inject extension ValidationTestHelper

	// ===== Module ====

	@Test
	def void testCheckModuleUniqueMeshExtension()
	{
		var rs = resourceSetProvider.get
		parseHelper.parse(readFileAsString(TestUtils.CartesianMesh2DPath), rs)
		parseHelper.parse(
			'''
			mesh extension BidonMesh;

			itemtypes { node }

			connectivity nodes: → {node};
			''', rs)

		val moduleKo = parseHelper.parse(
			'''
			module Test;
			ℝ a{CartesianMesh2D.nodes};
			ℝ b{BidonMesh.nodes};
			''', rs)

		moduleKo.assertError(NablaPackage.eINSTANCE.nablaRoot,
			BasicValidator::MODULE_UNIQUE_MESH_EXTENSION,
			BasicValidator::getModuleUniqueMeshExtensionMsg(#["CartesianMesh2D", "BidonMesh"]))

		rs = resourceSetProvider.get
		parseHelper.parse(readFileAsString(TestUtils.CartesianMesh2DPath), rs)
		val moduleOk = parseHelper.parse(
			'''
			module Test;
			with CartesianMesh2D.*;
			ℝ a{nodes};
			ℝ b{nodes};
			''', rs)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	// ===== Interval =====

	@Test
	def void testCheckFrom()
	{
		val moduleKo = parseHelper.parse(
			'''
			extension Test;
			def g: → ℝ, () →
			{
				ℝ[4] n;
				∀ i∈[1;3[, n[i] = 0.0;
				return 4.0;
			}
			''')
		moduleKo.assertError(NablaPackage.eINSTANCE.interval,
			BasicValidator::ZERO_FROM,
			BasicValidator::getZeroFromMsg())

		val moduleOk = parseHelper.parse(
			'''
			extension Test;
			def g: → ℝ, () →
			{
				ℝ[4] n;
				∀ i∈[0;3[, n[i] = 0.0;
				return 4.0;
			}
			''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckNbElems()
	{
		val moduleKo1 = parseHelper.parse(
			'''
			extension Test;
			def g: → ℝ, () →
			{
				ℝ[4] n;
				∀ i∈[0;3.2[, n[i] = 0.0;
				return 4.0;
			}
			''')
		moduleKo1.assertError(NablaPackage.eINSTANCE.interval,
			BasicValidator::TYPE_EXPRESSION_TYPE,
			getTypeMsg("ℝ", "ℕ"))

		val moduleKo2 = parseHelper.parse(
			'''
			extension Test;
			def g: → ℝ, () →
			{
				let ℝ x = 6.7;
				ℝ[4] n;
				∀ i∈[0;x[, n[i] = 0.0;
				return 4.0;
			}
			''')

		moduleKo2.assertError(NablaPackage.eINSTANCE.interval,
			BasicValidator::TYPE_EXPRESSION_TYPE,
			getTypeMsg("ℝ", "ℕ"))

		val moduleOk = parseHelper.parse(
			'''
			extension Test;
			def g: → ℝ, () →
			{
				ℝ[4] n;
				∀ i∈[0;4[, n[i] = 0.0;
				return 4.0;
			}
			''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	// ===== Names format =====

	@Test
	def void testCheckUpperCaseRoot()
	{
		val moduleKo = parseHelper.parse(
			'''
			module test;
			ℝ u;
			iterate n while(true);
			ComputeUinit: u^{n=0} = 0.0;
			''')
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.nablaRoot,
			BasicValidator::UPPER_CASE_START_NAME,
			BasicValidator::getUpperCaseNameMsg())
		val moduleOk = parseHelper.parse(
			'''
			module Test;
			ℝ u;
			iterate n while(true);
			ComputeUinit: u^{n=0} = 0.0;
			''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors

		val extensionKo = parseHelper.parse('''extension test;''')
		Assert.assertNotNull(extensionKo)
		extensionKo.assertError(NablaPackage.eINSTANCE.nablaRoot,
			BasicValidator::UPPER_CASE_START_NAME,
			BasicValidator::getUpperCaseNameMsg())
		val extensionOk = parseHelper.parse('''extension Test;''')
		Assert.assertNotNull(extensionOk)
		extensionOk.assertNoErrors
	}

	@Test
	def void testCheckUpperCaseJob()
	{
		val moduleKo = parseHelper.parse(
			'''
			module Test;
			ℝ u;
			iterate n while(true);
			computeUinit: u^{n=0} = 0.0;
			''')
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.job,
			BasicValidator::UPPER_CASE_START_NAME,
			BasicValidator::getUpperCaseNameMsg())

		val moduleOk = parseHelper.parse(
			'''
			module Test;
			ℝ u;
			iterate n while(true);
			ComputeUinit: u^{n=0} = 0.0;
			''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckLowerCaseFunction()
	{
		val moduleKo = parseHelper.parse(
			'''
			extension Test;
			def ∑, 0.0: ℝ, (a, b) → return a + b;
			def G: → ℝ, () →
			{
				ℝ[4] n;
				∀ i∈[0;3[, n[i] = 0.0;
				return 4.0;
			}
			''')
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.functionOrReduction,
			BasicValidator::LOWER_CASE_START_NAME,
			BasicValidator::getLowerCaseNameMsg())

		val moduleOk = parseHelper.parse(
			'''
			extension Test;
			def ∑, 0.0: ℝ, (a, b) → return a + b;
			def g: → ℝ, () →
			{
				ℝ[4] n;
				∀ i∈[0;3[, n[i] = 0.0;
				return 4.0;
			}
			''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	// ===== TimeIterator =====

	@Test
	def testCheckInitValue()
	{
		val moduleKo = parseHelper.parse(
			'''
			«emptyTestModule»
			ℝ u, v;
			iterate n while(true);
			ComputeUinit: u^{n=1} = 0.0;
			ComputeU: u^{n+1} = u^{n} + 6.0;
			''')
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.initTimeIteratorRef,
			BasicValidator::INIT_VALUE,
			BasicValidator::getInitValueMsg(1))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			ℝ u, v;
			iterate n while(true);
			ComputeUinit: u^{n=0} = 0.0;
			ComputeU: u^{n+1} = u^{n} + 6.0;
			''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def testCheckNextValue()
	{
		val moduleKo = parseHelper.parse(
			'''
			«emptyTestModule»
			ℝ u, v;
			ℕ ni;
			iterate n counter ni while(true);
			ComputeU: u^{n+2} = u^{n} + 6.0;
			''')
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.nextTimeIteratorRef,
			BasicValidator::NEXT_VALUE,
			BasicValidator::getNextValueMsg(2))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			ℝ u, v;
			iterate n while(true);
			ComputeU: u^{n+1} = u^{n} + 6.0;
			''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def testCheckConditionConstraints()
	{
		val moduleKo1 = parseHelper.parse(
			'''
			«emptyTestModule»
			ℝ[3] x;
			iterate n while(∑{x∈[0;3[}(x[i]]));
			''')
		Assert.assertNotNull(moduleKo1)
		moduleKo1.assertError(NablaPackage.eINSTANCE.timeIterator,
			BasicValidator::CONDITION_CONSTRAINTS,
			BasicValidator::getConditionConstraintsMsg())

		val moduleKo2 = parseHelper.parse(
			'''
			«emptyTestModule»
			ℝ[3] x;
			iterate n while(x[0]);
			''')
		Assert.assertNotNull(moduleKo2)
		moduleKo2.assertError(NablaPackage.eINSTANCE.timeIterator,
			BasicValidator::CONDITION_BOOL,
			getTypeMsg("ℝ", "ℾ"))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			ℝ[3] x;
			iterate n while(x[0] > 0.0);
			''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckRefValidity()
	{
		val moduleKo1 = parseHelper.parse(
			'''
			«emptyTestModule»
			ℝ u;
			iterate n while(true),
			{
				k while (true);
				l while (true), m while (true);
			}
			ComputeU: u^{k} = 6.0;
			''')
		Assert.assertNotNull(moduleKo1)
		moduleKo1.assertError(NablaPackage.eINSTANCE.timeIteratorRef,
			BasicValidator::REF_VALIDITY,
			BasicValidator::getRefValidityMsg(#["n"], "k"))

		val moduleKo2 = parseHelper.parse(
			'''
			«emptyTestModule»
			ℝ u;
			iterate n while(true),
			{
				k while (true);
				l while (true), m while (true);
			}
			ComputeU: u^{n+1, m} = 6.0;
			''')
		Assert.assertNotNull(moduleKo2)
		moduleKo2.assertError(NablaPackage.eINSTANCE.timeIteratorRef,
			BasicValidator::REF_VALIDITY,
			BasicValidator::getRefValidityMsg(#["k or l"], "m"))

		val moduleKo3 = parseHelper.parse(
			'''
			«emptyTestModule»
			ℝ u;
			iterate n while(true),
			{
				k while (true);
				l while (true), m while (true);
			}
			ComputeU: u^{n+1, k+1, m} = 6.0;
			''')
		Assert.assertNotNull(moduleKo3)
		moduleKo3.assertError(NablaPackage.eINSTANCE.timeIteratorRef,
			BasicValidator::REF_VALIDITY,
			BasicValidator::getRefValidityMsg(#[], "m"))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			ℝ u;
			iterate n while(true),
			{
				k while (true);
				l while (true), m while (true);
			}
			ComputeU: u^{n+1, l+1, m} = 6.0;
			''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	// ===== BaseType =====	

	@Test
	def void testCheckUnexpectedDimension()
	{
		val moduleKo = parseHelper.parse(
			'''
			«emptyTestModule»
			ℝ[1, 2, 3] a;
			''')

		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.baseType,
			BasicValidator::UNEXPECTED_DIMENSION,
			BasicValidator::getUnexpectedDimensionMsg(3))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			ℝ[1, 2] a;
			''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckSizeExpression()
	{
		val moduleKo = parseHelper.parse(
			'''
			«emptyTestModule»
			let ℝ x = 2.2;
			ℝ[1.1] a;
			ℕ[x] b;
			''')
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.baseType,
			BasicValidator::TYPE_EXPRESSION_TYPE,
			getTypeMsg("ℝ", "ℕ"))

		moduleKo.assertError(NablaPackage.eINSTANCE.baseType,
			BasicValidator::TYPE_EXPRESSION_TYPE,
			getTypeMsg("ℝ", "ℕ"))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			let ℕ x = 2;
			ℝ[2] a;
			ℕ[x] b;
			''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}


	// ===== Connectivities =====

	@Test
	def void testCheckConnectivityCallIndexAndType()
	{
		val rs = resourceSetProvider.get
		parseHelper.parse(readFileAsString(TestUtils.CartesianMesh2DPath), rs)
		val moduleKo = parseHelper.parse(
			'''
			«testModule»
			let orig = [0.0 , 0.0] ;
			ℝ[2] X{nodes};
			IniX1: ∀j∈cells(), ∀r∈nodes(j), X{r} = orig;
			IniX2: ∀r∈nodes(), ∀j∈nodesOfCell(r), X{r} = orig;
			''', rs) as NablaModule
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.connectivityCall,
			BasicValidator::CONNECTIVITY_CALL_INDEX,
			BasicValidator::getConnectivityCallIndexMsg(0,1))

		moduleKo.assertError(NablaPackage.eINSTANCE.connectivityCall,
			BasicValidator::CONNECTIVITY_CALL_TYPE,
			getTypeMsg("cell", "node"))

		val moduleOk =  parseHelper.parse(
			'''
			«testModule»
			let ℝ[2] orig = [0.0 , 0.0];
			ℝ[2] X{nodes};
			IniX1: ∀j∈cells(), ∀r∈nodes(), X{r} = orig; 
			IniX2: ∀j∈cells(), ∀r∈nodesOfCell(j), X{r} = orig; 
			''', rs)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def testCheckDimensionArg()
	{
		val rs = resourceSetProvider.get
		parseHelper.parse(readFileAsString(TestUtils.CartesianMesh2DPath), rs)
		val moduleKo =  parseHelper.parse(
			'''
			«testModule»
			ℝ[2] X{nodesOfCell};
			''', rs)
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.connectivityVar,
			BasicValidator::DIMENSION_ARG,
			BasicValidator::getDimensionArgMsg())

		val moduleOk =  parseHelper.parse(
			'''
			«testModule»
			ℝ[2] X{nodes};
			''', rs)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	// ===== Items =====

	@Test
	def void testCheckShiftValidity()
	{
		val rs = resourceSetProvider.get
		parseHelper.parse(readFileAsString(TestUtils.CartesianMesh2DPath), rs)
		val moduleKo = parseHelper.parse(
			'''
			«testModule»
			ℝ[2] X{cells};
			UpdateX: ∀j1∈cells(), ∀j2∈leftCell(j1), X{j2} = X{j2-1} - 1;
			''', rs)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.spaceIteratorRef,
			BasicValidator::SHIFT_VALIDITY,
			BasicValidator::getShiftValidityMsg)

		val moduleOk =  parseHelper.parse(
			'''
			«testModule»
			ℝ[2] X{cells};
			UpdateX: ∀j1∈cells(), ∀j2∈leftCell(j1), X{j2} = X{j1-1} - 1;
			''', rs)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}
}
