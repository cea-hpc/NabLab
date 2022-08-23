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

			connectivity {node} nodes();
			''', rs)

		val moduleKo = parseHelper.parse(
			'''
			module Test;
			real a{CartesianMesh2D.nodes};
			real b{BidonMesh.nodes};
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
			real a{nodes};
			real b{nodes};
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
			def real g() 
			{
				real[4] n;
				forall  i in [1;3[, n[i] = 0.0;
				return 4.0;
			}
			''')
		moduleKo.assertError(NablaPackage.eINSTANCE.interval,
			BasicValidator::ZERO_FROM,
			BasicValidator::getZeroFromMsg())

		val moduleOk = parseHelper.parse(
			'''
			extension Test;
			def real g() 
			{
				real[4] n;
				forall  i in [0;3[, n[i] = 0.0;
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
			def real g() 
			{
				real[4] n;
				forall  i in [0;3.2[, n[i] = 0.0;
				return 4.0;
			}
			''')
		moduleKo1.assertError(NablaPackage.eINSTANCE.interval,
			BasicValidator::TYPE_EXPRESSION_TYPE,
			getTypeMsg("real", "int"))

		val moduleKo2 = parseHelper.parse(
			'''
			extension Test;
			def real g() 
			{
				let real x = 6.7;
				real[4] n;
				forall  i in [0;x[, n[i] = 0.0;
				return 4.0;
			}
			''')

		moduleKo2.assertError(NablaPackage.eINSTANCE.interval,
			BasicValidator::TYPE_EXPRESSION_TYPE,
			getTypeMsg("real", "int"))

		val moduleOk = parseHelper.parse(
			'''
			extension Test;
			def real g() 
			{
				real[4] n;
				forall  i in [0;4[, n[i] = 0.0;
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
			real u;
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
			real u;
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
			real u;
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
			real u;
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
			red real sum(0.0) (a, b) : return a + b;
			def real G() 
			{
				real[4] n;
				forall  i in [0;3[, n[i] = 0.0;
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
			red real sum(0.0) (a, b) : return a + b;
			def real g() 
			{
				real[4] n;
				forall  i in [0;3[, n[i] = 0.0;
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
			real u, v;
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
			real u, v;
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
			real u, v;
			int ni;
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
			real u, v;
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
			real[3] x;
			iterate n while(sum{x in [0;3[}(x[i]]));
			''')
		Assert.assertNotNull(moduleKo1)
		moduleKo1.assertError(NablaPackage.eINSTANCE.timeIterator,
			BasicValidator::CONDITION_CONSTRAINTS,
			BasicValidator::getConditionConstraintsMsg())

		val moduleKo2 = parseHelper.parse(
			'''
			«emptyTestModule»
			real[3] x;
			iterate n while(x[0]);
			''')
		Assert.assertNotNull(moduleKo2)
		moduleKo2.assertError(NablaPackage.eINSTANCE.timeIterator,
			BasicValidator::CONDITION_BOOL,
			getTypeMsg("real", "bool"))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			real[3] x;
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
			real u;
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
			real u;
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
			real u;
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
			real u;
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
			real[1, 2, 3] a;
			''')

		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.baseType,
			BasicValidator::UNEXPECTED_DIMENSION,
			BasicValidator::getUnexpectedDimensionMsg(3))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			real[1, 2] a;
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
			let real x = 2.2;
			real[1.1] a;
			int[x] b;
			''')
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.baseType,
			BasicValidator::TYPE_EXPRESSION_TYPE,
			getTypeMsg("real", "int"))

		moduleKo.assertError(NablaPackage.eINSTANCE.baseType,
			BasicValidator::TYPE_EXPRESSION_TYPE,
			getTypeMsg("real", "int"))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			let int x = 2;
			real[2] a;
			int[x] b;
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
			real[2] X{nodes};
			IniX1: forall j in cells(), forall r in nodes(j), X{r} = orig;
			IniX2: forall r in nodes(), forall j in nodesOfCell(r), X{r} = orig;
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
			let real[2] orig = [0.0 , 0.0];
			real[2] X{nodes};
			IniX1: forall j in cells(), forall r in nodes(), X{r} = orig; 
			IniX2: forall j in cells(), forall r in nodesOfCell(j), X{r} = orig; 
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
			real[2] X{nodesOfCell};
			''', rs)
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.connectivityVar,
			BasicValidator::DIMENSION_ARG,
			BasicValidator::getDimensionArgMsg())

		val moduleOk =  parseHelper.parse(
			'''
			«testModule»
			real[2] X{nodes};
			''', rs)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def testCheckDimensionsArgOrder()
	{
		val rs = resourceSetProvider.get
		parseHelper.parse(readFileAsString(TestUtils.CartesianMesh2DPath), rs)
		val moduleKo =  parseHelper.parse(
			'''
			«testModule»
			real[2] X{nodesOfCell};
			int toto{cells, nodesOfCell, nodes};
			''', rs)
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.connectivityVar,
			BasicValidator::DIMENSIONS_ARG_ORDER,
			BasicValidator::getDimensionsArgOrderMsg())

		val moduleOk =  parseHelper.parse(
			'''
			«testModule»
			real[2] X{nodes};
			int toto{cells, nodes, nodesOfCell};
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
			real[2] X{cells};
			UpdateX: forall j1 in cells(), forall j2 in leftCell(j1), X{j2} = X{j2-1} - 1;
			''', rs)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.spaceIteratorRef,
			BasicValidator::SHIFT_VALIDITY,
			BasicValidator::getShiftValidityMsg)

		val moduleOk =  parseHelper.parse(
			'''
			«testModule»
			real[2] X{cells};
			UpdateX: forall j1 in cells(), forall j2 in leftCell(j1), X{j2} = X{j1-1} - 1;
			''', rs)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}
}
