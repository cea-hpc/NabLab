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
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NablaPackage
import fr.cea.nabla.nabla.PrimitiveType
import fr.cea.nabla.tests.NablaInjectorProvider
import fr.cea.nabla.tests.TestUtils
import fr.cea.nabla.validation.InstructionValidator
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
	@Inject ParseHelper<NablaModule> parseHelper
	@Inject extension ValidationTestHelper
	@Inject extension TestUtils

	@Test
	def void testCheckLocalConnectivityVars() 
	{
		val moduleKo = parseHelper.parse(getTestModule(defaultConnectivities, '') +
			'''
			ℝ[2] X{nodes};
			UpdateX: 
			{
				ℝ[2] a{nodes};
				∀r∈nodes(), X{r} = a{r};
			}
			'''
		)
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.varGroupDeclaration,
			InstructionValidator::LOCAL_CONNECTIVITY_VAR,
			InstructionValidator::getLocalConnectivityVarMsg)

		val moduleOk =  parseHelper.parse(getTestModule(defaultConnectivities, '') +
			'''
			ℝ[2] X{nodes};
			UpdateX: 
			{
				ℝ[2] a;
				∀r∈nodes(), X{r} = a;
			}
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckAffectationType()
	{
		val moduleKo = parseHelper.parse(getTestModule(defaultConnectivities, '')
			+
			'''
			ℕ U{cells};
			ℕ V{nodes};
			ComputeU: ∀ j∈cells(), {
					let ℝ e = 1.0;
					U{j} = e * 4;
			}
			ComputeV: V = U;
			''')
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.affectation,
			InstructionValidator::AFFECTATION_TYPE,
			InstructionValidator::getAffectationTypeMsg(PrimitiveType::REAL.literal,
				PrimitiveType::INT.literal
			))
		moduleKo.assertError(NablaPackage.eINSTANCE.affectation,
			InstructionValidator::AFFECTATION_TYPE,
			InstructionValidator::getAffectationTypeMsg("ℕ{cells}", "ℕ{nodes}"))

		val moduleOk = parseHelper.parse(getTestModule(defaultConnectivities, '')
			+
			'''
			ℕ U{cells}; 
			ℕ V{cells};
			ComputeU: ∀ j∈cells(), {
					let ℕ e = 1;
					U{j} = e * 4;
			}
			ComputeV: V = U;
			''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckIfConditionBoolType() 
	{
		val moduleKo = parseHelper.parse(testModule
			+
			'''
			ℕ cond;
			ℕ a;
			jobIf: if (cond) { a = a + 1 ; } else { a = a -1 ; }
			''')
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.^if,
			InstructionValidator::IF_CONDITION_BOOL,
			InstructionValidator::getIfConditionBoolMsg(PrimitiveType::INT.literal))

		val moduleOk = parseHelper.parse(testModule
			+
			'''
			ℾ cond;
			ℕ a;
			jobIf: if (cond) { a = a + 1 ; } else { a = a -1 ; }
			''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckGlobalVarValue()
	{
		val moduleKo1 = parseHelper.parse(getTestModule('', '''def mySum, 0.0: ℕ, (a, b) → return a + b;''') +
			'''
			let ℕ[3] coef = [2, 3, 4];
			let ℝ DOUBLE_LENGTH = mySum{k∈[0;3[}(X_EDGE_LENGTH, coef[k]);
			''')
		Assert.assertNotNull(moduleKo1)
		moduleKo1.assertError(NablaPackage.eINSTANCE.simpleVarDefinition,
			InstructionValidator::GLOBAL_VAR_VALUE,
			InstructionValidator::getGlobalVarValueMsg)

		val moduleKo2 = parseHelper.parse(getTestModule(nodesConnectivity, '') +
			'''
			let ℕ c = card(nodes());
			option ℕ d = c;
			''')
		Assert.assertNotNull(moduleKo2)
		moduleKo2.assertError(NablaPackage.eINSTANCE.simpleVarDefinition,
			InstructionValidator::GLOBAL_VAR_VALUE,
			InstructionValidator::getGlobalVarValueMsg)

		val moduleOk =  parseHelper.parse(testModule +
			'''
			let ℕ coef = 2;
			let ℝ DOUBLE_LENGTH = X_EDGE_LENGTH * coef;
			''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testLocalOption()
	{
		val moduleKo = parseHelper.parse(getTestModule(defaultConnectivities, '')
			+
			'''
			option ℕ alpha = 1;
			ℕ U{cells}; 
			ℕ V{cells};
			ComputeU: ∀ j∈cells(), {
					option ℕ e = 1;
					U{j} = e * alpha * 4;
			}
			ComputeV: V = U;
			''')
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.simpleVarDefinition,
			InstructionValidator::LOCAL_OPTION,
			InstructionValidator::getLocalOptionMsg())

		val moduleOk = parseHelper.parse(getTestModule(defaultConnectivities, '')
			+
			'''
			option ℕ alpha = 1;
			ℕ U{cells}; 
			ℕ V{cells};
			ComputeU: ∀ j∈cells(), {
					let ℕ e = 1;
					U{j} = e * alpha * 4;
			}
			ComputeV: V = U;
			''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}
}
