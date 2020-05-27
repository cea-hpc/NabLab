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
import fr.cea.nabla.ir.MandatoryVariables
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NablaPackage
import fr.cea.nabla.tests.NablaInjectorProvider
import fr.cea.nabla.tests.TestUtils
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
class BasicValidatorTest
{
	@Inject ParseHelper<NablaModule> parseHelper
	@Inject extension TestUtils
	@Inject extension ValidationTestHelper
	@Inject extension NablaModuleExtensions

	// ===== Interval =====

	@Test
	def void testCheckFrom()
	{
		val moduleKo = parseHelper.parse(getTestModule( '',
			'''
			def g: → ℝ, () →
			{
				ℝ[4] n;
				∀ i∈[1;3[, n[i] = 0.0;
				return 4.0;
			}
			'''))
		moduleKo.assertError(NablaPackage.eINSTANCE.interval,
			BasicValidator::ZERO_FROM,
			BasicValidator::getZeroFromMsg())

		val moduleOk = parseHelper.parse(getTestModule( '',
			'''
			def g: → ℝ, () →
			{
				ℝ[4] n;
				∀ i∈[0;3[, n[i] = 0.0;
				return 4.0;
			}
			'''))
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckNbElems()
	{
		val moduleKo1 = parseHelper.parse(getTestModule('',
			'''
			def g: → ℝ, () →
			{
				ℝ[4] n;
				∀ i∈[0;3.2[, n[i] = 0.0;
				return 4.0;
			}
			'''))
		moduleKo1.assertError(NablaPackage.eINSTANCE.interval,
			BasicValidator::TYPE_EXPRESSION_TYPE,
			BasicValidator::getTypeExpressionMsg("ℝ"))

		val moduleKo2 = parseHelper.parse(getTestModule('',
			'''
			def g: → ℝ, () →
			{
				let ℝ x = 6.7;
				ℝ[4] n;
				∀ i∈[0;x[, n[i] = 0.0;
				return 4.0;
			}
			'''))

		moduleKo2.assertError(NablaPackage.eINSTANCE.interval,
			BasicValidator::TYPE_EXPRESSION_TYPE,
			BasicValidator::getTypeExpressionMsg("ℝ"))

		val moduleOk = parseHelper.parse(getTestModule( '',
			'''
			def g: → ℝ, () →
			{
				ℝ[4] n;
				∀ i∈[0;4[, n[i] = 0.0;
				return 4.0;
			}
			'''))
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	// ===== NablaModule =====

	@Test
	def void testCheckMandatoryOptions()
	{
		// no item => no mesh => no mandatory variables
		val moduleOk1 = parseHelper.parse('''module Test;''')
		Assert.assertNotNull(moduleOk1)
		moduleOk1.assertNoErrors

		// item => mesh => mandatory variables
		val moduleKo = parseHelper.parse(
		'''
			module Test;
			itemtypes { node }
		''')
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.nablaModule,
			BasicValidator::MANDATORY_VARS,
			BasicValidator::getMandatoryVarsMsg(MandatoryVariables::NAMES))

		val moduleOk2 = parseHelper.parse(getTestModule)
		Assert.assertNotNull(moduleOk2)
		moduleOk2.assertNoErrors
	}

	@Test
	def void testCheckName()
	{
		val moduleKo = parseHelper.parse('''module test;''')
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.nablaModule,
			BasicValidator::MODULE_NAME,
			BasicValidator::getModuleNameMsg())		

		val moduleOk = parseHelper.parse('''module Test;''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	// ===== TimeIterator =====

	@Test
	def testCheckInitValue()
	{
		val moduleKo = parseHelper.parse(testModule +
			'''
			ℝ u, v;
			iterate n while(true);
			ComputeUinit: u^{n=1} = 0.0;
			ComputeU: u^{n+1} = u^{n} + 6.0;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.initTimeIteratorRef,
			BasicValidator::INIT_VALUE,
			BasicValidator::getInitValueMsg(1))

		val moduleOk = parseHelper.parse(testModule +
			'''
			ℝ u, v;
			iterate n while(true);
			ComputeUinit: u^{n=0} = 0.0;
			ComputeU: u^{n+1} = u^{n} + 6.0;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors		
	}

	@Test
	def testCheckNextValue()
	{
		val moduleKo = parseHelper.parse(testModule +
			'''
			ℝ u, v;
			ℕ ni;
			iterate n counter ni while(true);
			ComputeU: u^{n+2} = u^{n} + 6.0;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.nextTimeIteratorRef,
			BasicValidator::NEXT_VALUE,
			BasicValidator::getNextValueMsg(2))

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
	def testCheckConditionConstraints()
	{
		val moduleKo = parseHelper.parse(testModule +
			'''
				ℝ[3] x;
				iterate n while(∑{x∈[0;3[}(x[i]]));
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.timeIterator,
			BasicValidator::CONDITION_CONSTRAINTS,
			BasicValidator::getConditionConstraintsMsg())

		val moduleOk = parseHelper.parse(testModule +
			'''
				ℝ[3] x;
				iterate n while(x[0] > 0.0);
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}


	// ===== BaseType =====	

	@Test
	def void testCheckUnsupportedDimension()
	{
		val moduleKo = parseHelper.parse(testModule +
			'''
			ℝ[1, 2, 3] a;
			''')

		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.baseType,
			BasicValidator::UNSUPPORTED_DIMENSION,
			BasicValidator::getUnsupportedDimensionMsg(3))

		val moduleOk = parseHelper.parse(testModule +
			'''
			ℝ[1, 2] a;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckSizeExpression()
	{
		val moduleKo = parseHelper.parse(testModule +
			'''
			let ℝ x = 2.2;
			ℝ[1.1] a;
			ℕ[x] b;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.baseType,
			BasicValidator::TYPE_EXPRESSION_TYPE,
			BasicValidator::getTypeExpressionMsg("ℝ"))

		moduleKo.assertError(NablaPackage.eINSTANCE.baseType,
			BasicValidator::TYPE_EXPRESSION_TYPE,
			BasicValidator::getTypeExpressionMsg("ℝ"))

		val moduleOk = parseHelper.parse(testModule +
			'''
			let ℕ x = 2;
			ℝ[2] a;
			ℕ[x] b;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors		
	}


	// ===== Connectivities =====

	@Test
	def void testCheckConnectivityCallIndexAndType()
	{
		val moduleKo = parseHelper.parse(getTestModule(defaultConnectivities, '') +
			'''
			let orig = [0.0 , 0.0] ;
			IniX1: ∀j∈cells(), ∀r∈nodes(j), X{r} = orig; 
			IniX2: ∀r∈nodes(), ∀j∈nodesOfCell(r), X{r} = orig; 
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.connectivityCall,
			BasicValidator::CONNECTIVITY_CALL_INDEX,
			BasicValidator::getConnectivityCallIndexMsg(0,1))

		val node = moduleKo.getItemTypeByName("node").name
		val cell = moduleKo.getItemTypeByName("cell").name

		moduleKo.assertError(NablaPackage.eINSTANCE.connectivityCall,
			BasicValidator::CONNECTIVITY_CALL_TYPE,
			BasicValidator::getConnectivityCallTypeMsg(cell,node))

		val moduleOk =  parseHelper.parse(getTestModule(defaultConnectivities, '') +
			'''
			let ℝ[2] orig = [0.0 , 0.0] ;
			ℝ[2] X{nodes};
			IniX1: ∀j∈cells(), ∀r∈nodes(), X{r} = orig; 
			IniX2: ∀j∈cells(), ∀r∈nodesOfCell(j), X{r} = orig; 
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def testCheckDimensionArg()
	{
		val moduleKo =  parseHelper.parse(getTestModule(defaultConnectivities, '') +
			'''
			ℝ[2] X{nodesOfCell};
			'''
		)
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.connectivityVar,
			BasicValidator::DIMENSION_ARG,
			BasicValidator::getDimensionArgMsg())

		val moduleOk =  parseHelper.parse(getTestModule(defaultConnectivities, '') +
			'''
			ℝ[2] X{nodes};
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	// ===== Items =====

	@Test
	def void testCheckShiftValidity()
	{
		val connectivities =
			'''
			itemtypes { node }
			set nodes: → {node};
			item leftNode: node → node;
			'''

		val moduleKo = parseHelper.parse(getTestModule(connectivities, '')
			+
			'''
			ℝ[2] X{nodes};
			UpdateX: ∀r1∈nodes(), r2 = leftNode(r1), X{r2} = X{r2-1} - 1;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.itemRef,
			BasicValidator::SHIFT_VALIDITY,
			BasicValidator::getShiftValidityMsg)

		val moduleOk =  parseHelper.parse(getTestModule(connectivities, '')
			+
			'''
			ℝ[2] X{nodes};
			UpdateX: ∀r1∈nodes(), r2 = leftNode(r1), X{r2} = X{r1-1} - 1;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}
}
