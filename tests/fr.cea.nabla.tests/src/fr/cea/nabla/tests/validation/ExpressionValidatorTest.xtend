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
import fr.cea.nabla.nabla.PrimitiveType
import fr.cea.nabla.tests.NablaInjectorProvider
import fr.cea.nabla.tests.TestUtils
import fr.cea.nabla.typing.ArgOrVarTypeProvider
import fr.cea.nabla.typing.NSTRealArray1D
import fr.cea.nabla.typing.NSTRealScalar
import fr.cea.nabla.validation.ExpressionValidator
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
class ExpressionValidatorTest
{
	@Inject ParseHelper<NablaModule> parseHelper
	@Inject extension ValidationUtils
	@Inject extension ValidationTestHelper
	@Inject extension NablaModuleExtensions
	@Inject extension ArgOrVarTypeProvider
	@Inject extension TestUtils

	@Test
	def void testCheckBaseTypeConstantValue()
	{
		val moduleKo = parseHelper.parse(
			'''
			«emptyTestModule»
			let ℝ[2] one = [1.0, 1.0];
			let ℕ int = ℕ(1.2);
			let ℾ bool = ℾ(1);
			let ℝ real = ℝ(true);
			let ℝ[2] realOne = ℝ[2](one);
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.baseTypeConstant,
			ExpressionValidator::BASE_TYPE_CONSTANT_VALUE, 
			ExpressionValidator::getBaseTypeConstantValueMsg(PrimitiveType::REAL.literal))

		moduleKo.assertError(NablaPackage.eINSTANCE.baseTypeConstant,
			ExpressionValidator::BASE_TYPE_CONSTANT_VALUE, 
			ExpressionValidator::getBaseTypeConstantValueMsg(PrimitiveType::INT.literal))

		moduleKo.assertError(NablaPackage.eINSTANCE.baseTypeConstant,
			ExpressionValidator::BASE_TYPE_CONSTANT_VALUE,
			ExpressionValidator::getBaseTypeConstantValueMsg(PrimitiveType::BOOL.literal))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			let ℕ int = ℕ(1);
			let ℾ bool = ℾ(true);
			let ℝ real = ℝ(1.2);
			let ℝ[2] realOne = ℝ[2](1.0);
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckBaseTypeConstantType()
	{
		val moduleKo = parseHelper.parse(
			'''
			«emptyTestModule»
			let ℕ two = 2;
			let ℝ[2] realOne = ℝ[two](1.0);
			'''
		)
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.baseTypeConstant,
			ExpressionValidator::BASE_TYPE_CONSTANT_TYPE, 
			ExpressionValidator::getBaseTypeConstantTypeMsg())

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			let ℝ[2] realOne = ℝ[2](1.0);
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckFunctionCallArgs()
	{
		val model =
			'''
			«emptyTestModule»
			«defaultConnectivities»
			def test: ℾ × ℝ × ℝ[2] → ℝ, (a, b, c) → return b;
			let ℝ[2] opt = [0., 1.];
			let ℕ count = 1;
			ℝ alpha{cells};
			'''

		val moduleKo = parseHelper.parse(
			'''
			«model»
			J1: let ℝ x = test(true, 0, opt);
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.functionCall,
			ExpressionValidator::FUNCTION_CALL_ARGS,
			ExpressionValidator::getFunctionCallArgsMsg(
				#[PrimitiveType::BOOL.literal,
				PrimitiveType::INT.literal,
				new NSTRealArray1D(createIntConstant(2)).label]
		))

		val moduleOk = parseHelper.parse(
			'''
			«model»
			J1: let ℝ x = test(true, 0., opt);
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckReductionCallArgs()
	{
		val moduleKo = parseHelper.parse(
			'''
			«emptyTestModule»
			«defaultConnectivities»
			def sum, 0.0: ℝ, (a, b) → return a + b;
			ℝ D{cells}; 
			ℝ[2] E{cells}; 
			ComputeU: let ℝ u = sum{c∈cells()}(D);
			ComputeV: let ℝ[2] v = sum{c∈cells()}(E{c});
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.reductionCall,
			ExpressionValidator::REDUCTION_CALL_ON_CONNECTIVITIES_VARIABLE,
			ExpressionValidator::getReductionCallOnConnectivitiesVariableMsg())

		moduleKo.assertError(NablaPackage.eINSTANCE.reductionCall,
			ExpressionValidator::REDUCTION_CALL_ARGS,
			ExpressionValidator::getReductionCallArgsMsg(new NSTRealScalar().label))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			«defaultConnectivities»
			def sum, 0.0: ℝ, (a,b) → return a + b;
			def sum, 0.0: x | ℝ[x], (a,b) → return a + b;
			ℝ D{cells};
			ℝ[2] E{cells};
			ComputeU: let ℝ u = sum{c∈cells()}(D{c});
			ComputeV: let ℝ[2] v = sum{c∈cells()}(E{c});
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckContractedIfType() 
	{
		val moduleKo = parseHelper.parse(
			'''
			«emptyTestModule»
			let ℝ cond = 0.0;
			let ℝ U = 1.1;
			let ℕ V = 2;
			let ℝ W = (cond ? U : V);
			'''
		)
		Assert.assertNotNull(moduleKo)
		val cond = moduleKo.getVariableByName("cond")
		val u = moduleKo.getVariableByName("U")
		val v = moduleKo.getVariableByName("V")

		moduleKo.assertError(NablaPackage.eINSTANCE.contractedIf,
			ExpressionValidator::CONTRACTED_IF_CONDITION_TYPE,
			getTypeMsg(cond.typeFor.label, "ℾ"))

		moduleKo.assertError(NablaPackage.eINSTANCE.contractedIf,
			ExpressionValidator::CONTRACTED_IF_ELSE_TYPE,
			getTypeMsg(v.typeFor.label, u.typeFor.label))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			let ℾ cond = true;
			let ℝ U = 0.0;
			let ℝ V = 1.1;
			let ℝ W = (cond ? U : V);
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckNotExpressionType()
	{
		val moduleKo = parseHelper.parse(
			'''
			«emptyTestModule»
			let ℝ cond = 0.0;
			let ℾ ok = !cond; 
			'''
		)
		Assert.assertNotNull(moduleKo)
		val cond = moduleKo.getVariableByName("cond")

		moduleKo.assertError(NablaPackage.eINSTANCE.not,
			ExpressionValidator::NOT_EXPRESSION_TYPE,
			getTypeMsg(cond.typeFor.label, "ℾ"))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			let ℾ cond = true;
			let ℾ ok = !cond; 
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckMulType()
	{
		val moduleKo = parseHelper.parse(
			'''
			«emptyTestModule»
			let ℾ  a = true; 
			let ℝ b = 0.0;
			let ℝ c = a * b;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.mul,
			ExpressionValidator::MUL_TYPE,
			ExpressionValidator::getBinaryOpTypeMsg("*",
				PrimitiveType::BOOL.literal,
				PrimitiveType::REAL.literal
			))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			let ℝ a = 1.1;
			let ℝ b = 0.0;
			let ℝ c = a * b;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckDivType()
	{
		val moduleKo = parseHelper.parse(
			'''
			«emptyTestModule»
			let ℾ a = true; 
			let ℝ b = 0.0;
			let ℝ c = a / b;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.div,
			ExpressionValidator::DIV_TYPE,
			ExpressionValidator::getBinaryOpTypeMsg("/",
				PrimitiveType::BOOL.literal,
				PrimitiveType::REAL.literal
			))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			let ℝ a = 1.1;
			let ℝ b = 0.0;
			let ℝ c = a / b;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckPlusType() 
	{
		val moduleKo = parseHelper.parse(
			'''
			«emptyTestModule»
			let ℾ a = true; 
			let ℕ b = 0;
			let ℝ c = a + b;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.plus,
			ExpressionValidator::PLUS_TYPE,
			ExpressionValidator::getBinaryOpTypeMsg("+",
				PrimitiveType::BOOL.literal,
				PrimitiveType::INT.literal
			))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			let ℝ a = 1.1;
			let ℕ b = 0;
			let ℝ c = a + b;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckMinusType()
	{
		val moduleKo = parseHelper.parse(
			'''
			«emptyTestModule»
			let ℝ[2] a = ℝ[2](0.0);
			let ℝ[3] b = ℝ[3](0.0);
			let ℝ[2] c = a - b;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.minus,
			ExpressionValidator::MINUS_TYPE,
			ExpressionValidator::getBinaryOpTypeMsg("-",
				new NSTRealArray1D(createIntConstant(2)).label,

				new NSTRealArray1D(createIntConstant(3)).label
			))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			let ℝ[2] a = ℝ[2](0.0);
			let ℝ[2] b = ℝ[2](1.1);
			let ℝ[2] c = a - b;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckComparisonType()
	{
		val moduleKo = parseHelper.parse(
			'''
			«emptyTestModule»
			let ℝ a = 0.0;
			let ℝ[2] b = ℝ[2](1.1);
			let ℾ c = a > b;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.comparison,
			ExpressionValidator::COMPARISON_TYPE,
			ExpressionValidator::getBinaryOpTypeMsg(">",
				PrimitiveType::REAL.literal,
				new NSTRealArray1D(createIntConstant(2)).label
			))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			let ℝ a = 0.0;
			let ℝ b = 1.1;
			let ℾ c = a > b;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckEqualityType()
	{
		val moduleKo = parseHelper.parse(
			'''
			«emptyTestModule»
			let ℝ a = 0.0;
			let ℝ[2] b = ℝ[2](1.1);
			let ℾ c = a == b;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.equality,
			ExpressionValidator::EQUALITY_TYPE,
			ExpressionValidator::getBinaryOpTypeMsg("==",
				PrimitiveType::REAL.literal,
				new NSTRealArray1D(createIntConstant(2)).label
			))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			let ℝ a = 0.0; 
			let ℝ b = 1.1;
			let ℾ c = a == b;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckModuloType()
	{
		val moduleKo = parseHelper.parse(
			'''
			«emptyTestModule»
			let ℝ a = 0.0;
			let ℝ[2] b = ℝ[2](1.1);
			let ℕ c = a % b;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.modulo,
			ExpressionValidator::MODULO_TYPE,
			getTypeMsg(PrimitiveType::REAL.literal, "ℕ"))

		moduleKo.assertError(NablaPackage.eINSTANCE.modulo,
			ExpressionValidator::MODULO_TYPE,
			getTypeMsg(new NSTRealArray1D(createIntConstant(2)).label, "ℕ"))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			let ℕ a = 0;
			let ℕ b = 1;
			let ℕ c = a % b;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckAndType() 
	{
		val moduleKo = parseHelper.parse(
			'''
			«emptyTestModule»
			let ℕ a = 0;
			let ℝ b = 1.1; 
			let ℾ c = a && b;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.and,
			ExpressionValidator::AND_TYPE,
			getTypeMsg(PrimitiveType::REAL.literal, "ℾ"))

		moduleKo.assertError(NablaPackage.eINSTANCE.and,
			ExpressionValidator::AND_TYPE,
			getTypeMsg(PrimitiveType::INT.literal, "ℾ"))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			let ℾ a = true;
			let ℾ b = false; 
			let ℾ c = a && b;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckOrType()
	{
		val moduleKo = parseHelper.parse(
			'''
			«emptyTestModule»
			let ℕ a = 0;
			let ℝ b = 1.1;
			let ℾ c = a || b;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.or,
			ExpressionValidator::OR_TYPE,
			getTypeMsg(PrimitiveType::REAL.literal, "ℾ"))

		moduleKo.assertError(NablaPackage.eINSTANCE.or,
			ExpressionValidator::OR_TYPE,
			getTypeMsg(PrimitiveType::INT.literal, "ℾ"))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			let ℾ a = true;
			let ℾ b = false;
			let ℾ c = a || b;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testVectorConstantSize()
	{
		val moduleKo = parseHelper.parse(
			'''
			«emptyTestModule»
			let ℕ[1] V = [0];
			'''
		)
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.vectorConstant,
			ExpressionValidator::VECTOR_CONSTANT_SIZE,
			ExpressionValidator::getVectorConstantSizeMsg(1))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			letℕ[2] V = [0, 1];
			'''
		)
		Assert.assertNotNull(moduleOk)
	}

	@Test
	def void testVectorConstantType()
	{
		val moduleKo = parseHelper.parse(
			'''
			«emptyTestModule»
			let ℕ[2] V = [0, 3.4];
			'''
		)
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.vectorConstant,
			ExpressionValidator::VECTOR_CONSTANT_INCONSISTENT_TYPE,
			ExpressionValidator::getVectorConstantInconsistentTypeMsg())

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			let ℕ[2] V = [0, 3];
			'''
		)
		Assert.assertNotNull(moduleOk)
	}
}
