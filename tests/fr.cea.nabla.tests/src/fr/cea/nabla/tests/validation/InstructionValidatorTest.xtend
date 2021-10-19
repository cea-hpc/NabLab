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
			ℕ dim;
			ℝ[dim] X{nodes};
			''', rs)
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.varGroupDeclaration,
			InstructionValidator::DYNAMIC_GLOBAL_VAR,
			InstructionValidator::getDynamicGlobalVarMsg)

		val moduleKo2 = parseHelper.parse(
			'''
			«testModule»
			ℕ dim;
			ℝ[dim] tab;
			''', rs)
		Assert.assertNotNull(moduleKo2)
		moduleKo.assertError(NablaPackage.eINSTANCE.varGroupDeclaration,
			InstructionValidator::DYNAMIC_GLOBAL_VAR,
			InstructionValidator::getDynamicGlobalVarMsg)

		val moduleOk =  parseHelper.parse(
			'''
			«testModule»
			let ℕ dim = 2;
			ℝ[dim] X{nodes};
			ℝ[dim] tab;
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
			ℝ[2] X{nodes};
			UpdateX: 
			{
				ℝ[2] a{nodes};
				∀r∈nodes(), X{r} = a{r};
			}
			''', rs)
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.varGroupDeclaration,
			InstructionValidator::LOCAL_CONNECTIVITY_VAR,
			InstructionValidator::getLocalConnectivityVarMsg)

		val moduleOk =  parseHelper.parse(
			'''
			«testModule»
			ℝ[2] X{nodes};
			UpdateX: 
			{
				ℝ[2] a;
				∀r∈nodes(), X{r} = a;
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
			option ℕ dim = 2;
			ℕ U{cells};
			ℕ V{nodes};
			ComputeU: ∀ j∈cells(), {
				let ℝ e = 1.0;
				U{j} = e * 4;
			}
			ComputeV: V = U;
			SetDim: dim = 3;
			''', rs)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.affectation,
			InstructionValidator::AFFECTATION_TYPE,
			getTypeMsg(PrimitiveType::REAL.literal, PrimitiveType::INT.literal))
		moduleKo.assertError(NablaPackage.eINSTANCE.affectation,
			InstructionValidator::AFFECTATION_TYPE,
			getTypeMsg("ℕ{cells}", "ℕ{nodes}"))
		moduleKo.assertError(NablaPackage.eINSTANCE.affectation,
			InstructionValidator::AFFECTATION_ON_CONNECTIVITY_TYPE,
			InstructionValidator.getAffectationOnConnectivityTypeMsg)
		moduleKo.assertError(NablaPackage.eINSTANCE.affectation,
			InstructionValidator::AFFECTATION_ON_OPTION,
			InstructionValidator.getAffectationOnOptionMsg)

		val moduleOk = parseHelper.parse(
			'''
			«testModule»
			option ℕ dim = 2;
			ℕ U{cells}; 
			ℕ V{cells};
			ComputeU: ∀ j∈cells(), {
					let ℕ e = 1;
					U{j} = e * 4;
			}
			ComputeV: ∀ j∈cells(), V{j} = U{j};
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
			ℕ cond;
			ℕ a;
			job: if (cond) { a = a + 1 ; } else { a = a -1 ; }
			''')
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.^if,
			InstructionValidator::CONDITION_BOOL,
			getTypeMsg(PrimitiveType::INT.literal, "ℾ"))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			ℾ cond;
			ℕ a;
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
			ℕ cond;
			ℕ a;
			Job: while (cond) { a = a + 1 ; }
			''')
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.^while,
			InstructionValidator::CONDITION_BOOL,
			getTypeMsg(PrimitiveType::INT.literal, "ℾ"))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			ℾ cond;
			ℕ a;
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
			let ℕ coef = 2.0;
			''')
		Assert.assertNotNull(moduleKo1)
		moduleKo1.assertError(NablaPackage.eINSTANCE.simpleVarDeclaration,
			InstructionValidator::SIMPLE_VAR_TYPE,
			getTypeMsg(PrimitiveType.REAL.literal, PrimitiveType.INT.literal))

		val moduleKo2 = parseHelper.parse(
			'''
			«emptyTestModule»
			def mySum, 0: ℕ, (a, b) → return a + b;
			let ℕ[3] coef = [2, 3, 4];
			let ℕ c = mySum{k∈[0;3[}(coef[k]);
			''')
		Assert.assertNotNull(moduleKo2)
		moduleKo2.assertError(NablaPackage.eINSTANCE.simpleVarDeclaration,
			InstructionValidator::GLOBAL_VAR_VALUE,
			InstructionValidator::getGlobalVarValueMsg)

		val moduleOk =  parseHelper.parse(
			'''
			«emptyTestModule»
			let ℕ coef = 2;
			let ℝ DOUBLE_LENGTH = 0.1 * coef;
			''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckVarTypeForOption()
	{
		val moduleKo1 = parseHelper.parse(
			'''
			«emptyTestModule»
			option ℕ coef = 2.0;
			''')
		Assert.assertNotNull(moduleKo1)
		moduleKo1.assertError(NablaPackage.eINSTANCE.optionDeclaration,
			InstructionValidator::SIMPLE_VAR_TYPE,
			getTypeMsg(PrimitiveType.REAL.literal, PrimitiveType.INT.literal))

		val moduleKo2 = parseHelper.parse(
			'''
			«emptyTestModule»
			def mySum, 0: ℕ, (a, b) → return a + b;
			option ℕ[3] coef = [2, 3, 4];
			option ℕ c = mySum{k∈[0;3[}(coef[k]);
			''')
		Assert.assertNotNull(moduleKo2)
		moduleKo2.assertError(NablaPackage.eINSTANCE.optionDeclaration,
			InstructionValidator::GLOBAL_VAR_VALUE,
			InstructionValidator::getGlobalVarValueMsg)
	}
}
