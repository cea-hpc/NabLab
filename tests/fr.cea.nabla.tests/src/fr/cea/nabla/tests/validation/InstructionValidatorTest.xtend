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
import fr.cea.nabla.nabla.PrimitiveType
import fr.cea.nabla.tests.NablaInjectorProvider
import fr.cea.nabla.tests.TestUtils
import fr.cea.nabla.validation.InstructionValidator
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
class InstructionValidatorTest 
{
	@Inject ParseHelper<NablaRoot> parseHelper
	@Inject Provider<ResourceSet> resourceSetProvider
	@Inject extension ValidationUtils
	@Inject extension ValidationTestHelper
	@Inject extension TestUtils

	@Test
	def void testDynamicGlobalVars()
	{
		val rs = resourceSetProvider.get
		parseHelper.parse(readFileAsString(TestUtils.CartesianMesh2DPath), rs)
		val moduleKo = parseHelper.parse(
			'''
			«testModule»
			int dim;
			real[dim] X{nodes};
			SetDim: dim = 2;
			''', rs)
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.varGroupDeclaration,
			InstructionValidator::DYNAMIC_GLOBAL_VAR,
			InstructionValidator::getDynamicGlobalVarMsg)

		val moduleKo2 = parseHelper.parse(
			'''
			«testModule»
			int dim;
			real[dim] tab;
			''', rs)
		Assert.assertNotNull(moduleKo2)
		moduleKo.assertError(NablaPackage.eINSTANCE.varGroupDeclaration,
			InstructionValidator::DYNAMIC_GLOBAL_VAR,
			InstructionValidator::getDynamicGlobalVarMsg)

		val moduleOk =  parseHelper.parse(
			'''
			«testModule»
			let int dim = 2;
			real[dim] X{nodes};
			real[dim] tab;
			''', rs)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckLocalConnectivityVars()
	{
		val rs = resourceSetProvider.get
		parseHelper.parse(readFileAsString(TestUtils.CartesianMesh2DPath), rs)
		val moduleKo = parseHelper.parse(
			'''
			«testModule»
			real[2] X{nodes};
			UpdateX: 
			{
				real[2] a{nodes};
				forall r in nodes(), X{r} = a{r};
			}
			''', rs)
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.varGroupDeclaration,
			InstructionValidator::LOCAL_CONNECTIVITY_VAR,
			InstructionValidator::getLocalConnectivityVarMsg)

		val moduleOk =  parseHelper.parse(
			'''
			«testModule»
			real[2] X{nodes};
			UpdateX: 
			{
				real[2] a;
				forall r in nodes(), X{r} = a;
			}
			''', rs)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckAffectationType()
	{
		val rs = resourceSetProvider.get
		parseHelper.parse(readFileAsString(TestUtils.CartesianMesh2DPath), rs)
		val moduleKo = parseHelper.parse(
			'''
			«testModule»
			int U{cells};
			int V{nodes};
			ComputeU: forall  j in cells(), {
				let real e = 1.0;
				U{j} = e * 4;
			}
			ComputeV: V = U;
			''', rs)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.affectation,
			InstructionValidator::AFFECTATION_TYPE,
			getTypeMsg(PrimitiveType::REAL.literal, PrimitiveType::INT.literal))
		moduleKo.assertError(NablaPackage.eINSTANCE.affectation,
			InstructionValidator::AFFECTATION_TYPE,
			getTypeMsg("int{cells}", "int{nodes}"))
		moduleKo.assertError(NablaPackage.eINSTANCE.affectation,
			InstructionValidator::AFFECTATION_ON_CONNECTIVITY_TYPE,
			InstructionValidator.getAffectationOnConnectivityTypeMsg)

		val moduleOk = parseHelper.parse(
			'''
			«testModule»
			int U{cells}; 
			int V{cells};
			ComputeU: forall  j in cells(), {
					let int e = 1;
					U{j} = e * 4;
			}
			ComputeV: forall  j in cells(), V{j} = U{j};
			''', rs)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckIfConditionBoolType()
	{
		val moduleKo = parseHelper.parse(
			'''
			«emptyTestModule»
			int cond;
			int a;
			job: if (cond) { a = a + 1 ; } else { a = a -1 ; }
			''')
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.^if,
			InstructionValidator::CONDITION_BOOL,
			getTypeMsg(PrimitiveType::INT.literal, "bool"))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			bool cond;
			int a;
			Job: if (cond) { a = a + 1 ; } else { a = a -1 ; }
			''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckWhileConditionBoolType()
	{
		val moduleKo = parseHelper.parse(
			'''
			«emptyTestModule»
			int cond;
			int a;
			Job: while (cond) { a = a + 1 ; }
			''')
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.^while,
			InstructionValidator::CONDITION_BOOL,
			getTypeMsg(PrimitiveType::INT.literal, "bool"))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			bool cond;
			int a;
			Job: while (cond) { a = a + 1 ; }
			''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckVarTypeForSimpleVarDeclaration()
	{
		val moduleKo1 = parseHelper.parse(
			'''
			«emptyTestModule»
			let int coef = 2.0;
			''')
		Assert.assertNotNull(moduleKo1)
		moduleKo1.assertError(NablaPackage.eINSTANCE.simpleVarDeclaration,
			InstructionValidator::SIMPLE_VAR_TYPE,
			getTypeMsg(PrimitiveType.REAL.literal, PrimitiveType.INT.literal))

		val moduleKo2 = parseHelper.parse(
			'''
			«emptyTestModule»
			red <int> mySum(0) (a, b) : return a + b;
			let int[3] coef = [2, 3, 4];
			let int c = mySum{k in [0;3[}(coef[k]);
			''')
		Assert.assertNotNull(moduleKo2)
		moduleKo2.assertError(NablaPackage.eINSTANCE.simpleVarDeclaration,
			InstructionValidator::GLOBAL_VAR_VALUE,
			InstructionValidator::getGlobalVarValueMsg)

		val moduleOk =  parseHelper.parse(
			'''
			«emptyTestModule»
			let int coef = 2;
			let real DOUBLE_LENGTH = 0.1 * coef;
			''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}
}
