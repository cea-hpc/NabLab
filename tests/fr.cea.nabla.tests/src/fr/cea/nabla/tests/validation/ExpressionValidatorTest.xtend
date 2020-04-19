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
	@Inject extension ValidationTestHelper
	@Inject extension NablaModuleExtensions
	@Inject extension ArgOrVarTypeProvider
	@Inject extension TestUtils

	@Test
	def void testCheckBaseTypeConstantValueType()
	{
		val moduleKo = parseHelper.parse(testModule
			+
			'''
			let one = [1.0, 1.0];
			let int = ℕ(1.2);
			let bool = ℾ(1);
			let real = ℝ(true);
			let realOne = ℝ[2](one);
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.baseTypeConstant,
			ExpressionValidator::BASE_TYPE_CONSTANT_VALUE_TYPE, 
			ExpressionValidator::getBaseTypeConstantValueTypeMsg(PrimitiveType::REAL.literal))

		moduleKo.assertError(NablaPackage.eINSTANCE.baseTypeConstant,
			ExpressionValidator::BASE_TYPE_CONSTANT_VALUE_TYPE, 
			ExpressionValidator::getBaseTypeConstantValueTypeMsg(PrimitiveType::INT.literal))

		moduleKo.assertError(NablaPackage.eINSTANCE.baseTypeConstant,
			ExpressionValidator::BASE_TYPE_CONSTANT_VALUE_TYPE,
			ExpressionValidator::getBaseTypeConstantValueTypeMsg(PrimitiveType::BOOL.literal))

		val moduleOk = parseHelper.parse(testModule
			+
			'''
			let int = ℕ(1);
			let bool = ℾ(true);
			let real = ℝ(1.2);
			let realOne = ℝ[2](1.0);
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}


	@Test
	def void testCheckFunctionCallArgs()
	{
		val functions =
			'''
			def test: ℾ × ℝ × ℝ[2] → ℝ;
			'''

		val moduleKo = parseHelper.parse(getTestModule('', functions)
			+
			'''
			let opt = [0., 1.];
			j1: let x = test(true, 0, opt);
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

		val moduleOk = parseHelper.parse(getTestModule('', functions)
			+
			'''
			let opt = [0., 1.];
			j1: let x = test(true, 0., opt);
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckReductionCallArgs()
	{
		var functions =
			'''
			def sum, 0.0: ℝ, (a, b) → return a + b;
			'''

		val moduleKo = parseHelper.parse(getTestModule(defaultConnectivities, functions)
			+
			'''
			ℝ D{cells}; 
			ℝ[2] E{cells}; 
			computeU: let u = sum{c∈cells()}(D);
			computeV: let v = sum{c∈cells()}(E{c});
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.reductionCall,
			ExpressionValidator::REDUCTION_CALL_ON_CONNECTIVITIES_VARIABLE,
			ExpressionValidator::getReductionCallOnConnectivitiesVariableMsg())

		moduleKo.assertError(NablaPackage.eINSTANCE.reductionCall,
			ExpressionValidator::REDUCTION_CALL_ARGS,
			ExpressionValidator::getReductionCallArgsMsg(new NSTRealScalar().label))

		functions =
			'''
			def sum, 0.0: ℝ, (a,b) → return a + b;
			def sum, 0.0: x | ℝ[x], (a,b) → return a + b;
			'''

		val moduleOk = parseHelper.parse(getTestModule(defaultConnectivities, functions)
			+
			'''
			ℝ D{cells};
			ℝ[2] E{cells};
			computeT: let u = sum{c∈cells()}(D{c});
			computeV: let v = sum{c∈cells()}(E{c});
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckContractedIfType() 
	{
		val moduleKo = parseHelper.parse(testModule
			+
			'''
			let cond = 0.0;
			let U = 1.1;
			let V = 2;
			let W = (cond ? U : V);
			'''
		)
		Assert.assertNotNull(moduleKo)
		val cond = moduleKo.getVariableByName("cond")
		val u = moduleKo.getVariableByName("U")
		val v = moduleKo.getVariableByName("V")

		moduleKo.assertError(NablaPackage.eINSTANCE.contractedIf,
			ExpressionValidator::CONTRACTED_IF_CONDITION_TYPE,
			ExpressionValidator::getContractedIfConditionTypeMsg(cond.typeFor.label))

		moduleKo.assertError(NablaPackage.eINSTANCE.contractedIf,
			ExpressionValidator::CONTRACTED_IF_ELSE_TYPE,
			ExpressionValidator::getContractedIfElseTypeMsg(v.typeFor.label, u.typeFor.label))

		val moduleOk = parseHelper.parse(testModule
			+
			'''
			let cond = true;
			let U = 0.0;
			let V = 1.1;
			let W = (cond ? U : V);
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckNotExpressionType()
	{
		val moduleKo = parseHelper.parse(testModule
			+
			'''
			let cond = 0.0;
			let ok = !cond; 
			'''
		)
		Assert.assertNotNull(moduleKo)
		val cond = moduleKo.getVariableByName("cond")

		moduleKo.assertError(NablaPackage.eINSTANCE.not,
			ExpressionValidator::NOT_EXPRESSION_TYPE,
			ExpressionValidator::getNotExpressionTypeMsg(cond.typeFor.label))

		val moduleOk = parseHelper.parse(testModule
			+
			'''
			let cond = true;
			let ok = !cond; 
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckMulType()
	{
		val moduleKo = parseHelper.parse(testModule
			+
			'''
			let a = true; 
			let b = 0.0;
			let c = a * b;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.mul,
			ExpressionValidator::MUL_TYPE,
			ExpressionValidator::getBinaryOpTypeMsg("*",
				PrimitiveType::BOOL.literal,
				PrimitiveType::REAL.literal
			))

		val moduleOk = parseHelper.parse(testModule
			+
			'''
			let a = 1.1;
			let b = 0.0;
			let c = a * b;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}


	@Test
	def void testCheckDivType()
	{
		val moduleKo = parseHelper.parse(testModule
			+
			'''
			let a = true; 
			let b = 0.0;
			let c = a / b;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.div,
			ExpressionValidator::DIV_TYPE,
			ExpressionValidator::getBinaryOpTypeMsg("/",
				PrimitiveType::BOOL.literal,
				PrimitiveType::REAL.literal
			))

		val moduleOk = parseHelper.parse(testModule
			+
			'''
			let a = 1.1;
			let b = 0.0;
			let c = a / b;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckPlusType() 
	{
		val moduleKo = parseHelper.parse(testModule +
			'''
			let a = true; 
			let b = 0;
			let c = a + b;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.plus,
			ExpressionValidator::PLUS_TYPE,
			ExpressionValidator::getBinaryOpTypeMsg("+",
				PrimitiveType::BOOL.literal,
				PrimitiveType::INT.literal
			))

		val moduleOk = parseHelper.parse(testModule
			+
			'''
			let a = 1.1;
			let b = 0;
			let c = a + b;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckMinusType()
	{
		val moduleKo = parseHelper.parse(testModule
			+
			'''
			let a = ℝ[2](0.0);
			let b = ℝ[3](0.0);
			let c = a - b;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.minus,
			ExpressionValidator::MINUS_TYPE,
			ExpressionValidator::getBinaryOpTypeMsg("-",
				new NSTRealArray1D(createIntConstant(2)).label,

				new NSTRealArray1D(createIntConstant(3)).label
			))

		val moduleOk = parseHelper.parse(testModule
			+
			'''
			let a = ℝ[2](0.0);
			let b = ℝ[2](1.1);
			let c = a - b;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckComparisonType()
	{
		val moduleKo = parseHelper.parse(testModule
			+
			'''
			let a = 0.0;
			let b = ℝ[2](1.1);
			let c = a > b;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.comparison,
			ExpressionValidator::COMPARISON_TYPE,
			ExpressionValidator::getBinaryOpTypeMsg(">",
				PrimitiveType::REAL.literal,
				new NSTRealArray1D(createIntConstant(2)).label
			))

		val moduleOk = parseHelper.parse(testModule
			+
			'''
			let a = 0.0;
			let b = 1.1;
			let c = a > b;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckEqualityType()
	{
		val moduleKo = parseHelper.parse(testModule
			+
			'''
			let a = 0.0;
			let b = ℝ[2](1.1);
			let c = a == b;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.equality,
			ExpressionValidator::EQUALITY_TYPE,
			ExpressionValidator::getBinaryOpTypeMsg("==",
				PrimitiveType::REAL.literal,
				new NSTRealArray1D(createIntConstant(2)).label
			))

		val moduleOk = parseHelper.parse(testModule
			+
			'''
			let a = 0.0; 
			let b = 1.1;
			let c = a == b;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckModuloType()
	{
		val moduleKo = parseHelper.parse(testModule
			+
			'''
			let a = 0.0;
			let b = ℝ[2](1.1);
			let c = a % b;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.modulo,
			ExpressionValidator::MODULO_TYPE,
			ExpressionValidator::getModuloTypeMsg(PrimitiveType::REAL.literal))

		moduleKo.assertError(NablaPackage.eINSTANCE.modulo,
			ExpressionValidator::MODULO_TYPE,
			ExpressionValidator::getModuloTypeMsg(new NSTRealArray1D(createIntConstant(2)).label))

		val moduleOk = parseHelper.parse(testModule
			+
			'''
			let a = 0;
			let b = 1;
			let c = a % b;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckAndType() 
	{
		val moduleKo = parseHelper.parse(testModule
			+
			'''
			let a = 0;
			let b = 1.1; 
			let c = a && b;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.and,
			ExpressionValidator::AND_TYPE,
			ExpressionValidator::getAndTypeMsg(PrimitiveType::REAL.literal))

		moduleKo.assertError(NablaPackage.eINSTANCE.and,
			ExpressionValidator::AND_TYPE,
			ExpressionValidator::getAndTypeMsg(PrimitiveType::INT.literal))

		val moduleOk = parseHelper.parse(testModule
			+
			'''
			let a = true;
			let b = false; 
			let c = a && b;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckOrType()
	{
		val moduleKo = parseHelper.parse(testModule
			+
			'''
			let a = 0;
			let b = 1.1;
			let c = a || b;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.or,
			ExpressionValidator::OR_TYPE,
			ExpressionValidator::getOrTypeMsg(PrimitiveType::REAL.literal))

		moduleKo.assertError(NablaPackage.eINSTANCE.or,
			ExpressionValidator::OR_TYPE,
			ExpressionValidator::getOrTypeMsg(PrimitiveType::INT.literal))

		val moduleOk = parseHelper.parse(testModule
			+
			'''
			let a = true;
			let b = false;
			let c = a || b;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testVectorConstantSize()
	{
		val moduleKo = parseHelper.parse(testModule
			+
			'''
			let V = [0];
			'''
		)
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.vectorConstant,
			ExpressionValidator::VECTOR_CONSTANT_SIZE,
			ExpressionValidator::getVectorConstantSizeMsg(1))

		val moduleOk = parseHelper.parse(testModule
			+
			'''
			let V = [0, 1];
			'''
		)
		Assert.assertNotNull(moduleOk)
	}

	@Test
	def void testVectorConstantType()
	{
		val moduleKo = parseHelper.parse(testModule
			+
			'''
			let V = [0, 3.4];
			'''
		)
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.vectorConstant,
			ExpressionValidator::VECTOR_CONSTANT_INCONSISTENT_TYPE,
			ExpressionValidator::getVectorConstantInconsistentTypeMsg())

		val moduleOk = parseHelper.parse(testModule
			+
			'''
			let V = [0, 3];
			'''
		)
		Assert.assertNotNull(moduleOk)
	}
}
