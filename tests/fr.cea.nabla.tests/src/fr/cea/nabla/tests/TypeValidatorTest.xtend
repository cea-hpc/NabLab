/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.tests

import com.google.inject.Inject
import fr.cea.nabla.NablaModuleExtensions
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NablaPackage
import fr.cea.nabla.nabla.PrimitiveType
import fr.cea.nabla.typing.ArgOrVarTypeProvider
import fr.cea.nabla.typing.NSTRealArray1D
import fr.cea.nabla.typing.NSTRealScalar
import fr.cea.nabla.validation.TypeValidator
import org.eclipse.xtext.diagnostics.Severity
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(NablaInjectorProvider))
class TypeValidatorTest 
{
	@Inject ParseHelper<NablaModule> parseHelper
	@Inject extension ValidationTestHelper
	@Inject extension NablaModuleExtensions
	@Inject extension ArgOrVarTypeProvider
	@Inject extension TestUtils

	// ===== Functions =====

	@Test
	def void testFunctionReturnType()
	{
		val module = parseHelper.parse(
		'''
		module Test;

		itemtypes { node }
		set nodes: → {node};

		def f: ℝ → ℝ, (a) → { return 1; }
		def g: ℝ → ℝ, (a) → { return 1.0; }
		'''
		+ mandatoryOptions)

		Assert.assertNotNull(module)
		Assert.assertEquals(1, module.validate.filter(i | i.severity == Severity.ERROR).size)
		module.assertError(NablaPackage.eINSTANCE.function, TypeValidator::FUNCTION_RETURN_TYPE, TypeValidator::getFunctionReturnTypeMsg("ℕ", "ℝ"))
	}

	// ===== Instructions =====	

	@Test
	def void testChecAffectationType() 
	{
		val moduleKo = parseHelper.parse(getTestModule(defaultConnectivities, '')
			+
			'''
			ℕ U{cells};
			ℕ V{nodes};
			ComputeU: ∀ j∈cells(), {
					let e = 1.0;
					U{j} = e * 4;
			}
			ComputeV: V = U;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.affectation,
			TypeValidator::AFFECTATION_TYPE,
			TypeValidator::getAffectationTypeMsg(PrimitiveType::REAL.literal,
				PrimitiveType::INT.literal
			))

		moduleKo.assertError(NablaPackage.eINSTANCE.affectation,
			TypeValidator::AFFECTATION_TYPE,
			TypeValidator::getAffectationTypeMsg("ℕ{cells}", "ℕ{nodes}"))

			val moduleOk = parseHelper.parse(getTestModule(defaultConnectivities, '')
			+
			'''
			ℕ U{cells}; 
			ℕ V{cells};
			ComputeU: ∀ j∈cells(), {
					let e = 1;
					U{j} = e * 4;
			}
			ComputeV: V = U;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testChecIfType() 
	{
		val moduleKo = parseHelper.parse(testModule
			+
			'''
			ℕ cond;
			ℕ a;
			jobIf: if (cond) { a = a + 1 ; } else { a = a -1 ; }
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.^if,
			TypeValidator::IF_CONDITION_BOOL,
			TypeValidator::getIfConditionBoolMsg(PrimitiveType::INT.literal))

		val moduleOk = parseHelper.parse(testModule
			+
			'''
			ℾ cond;
			ℕ a;
			jobIf: if (cond) { a = a + 1 ; } else { a = a -1 ; }
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	// ===== Expressions =====	

	@Test
	def void testCheckValueType()
	{
		val moduleKo = parseHelper.parse(testModule
			+
			'''
			const one = [1.0, 1.0];
			const int = ℕ(1.2);
			const bool = ℾ(1);
			const real = ℝ(true);
			const realOne = ℝ[2](one);
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.baseTypeConstant,
			TypeValidator::VALUE_TYPE, 
			TypeValidator::getValueTypeMsg(PrimitiveType::REAL.literal))

		moduleKo.assertError(NablaPackage.eINSTANCE.baseTypeConstant,
			TypeValidator::VALUE_TYPE, 
			TypeValidator::getValueTypeMsg(PrimitiveType::INT.literal))

		moduleKo.assertError(NablaPackage.eINSTANCE.baseTypeConstant,
			TypeValidator::VALUE_TYPE,
			TypeValidator::getValueTypeMsg(PrimitiveType::BOOL.literal))

		val moduleOk = parseHelper.parse(testModule
			+
			'''
			const int = ℕ(1);
			const bool = ℾ(true);
			const real = ℝ(1.2);
			const realOne = ℝ[2](1.0);
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckSeedAndTypes()
	{
		val moduleKo = parseHelper.parse(getTestModule ('',
				'''
				def sum1, [0.0, 0.0]: ℝ[2], (a, b) → return a + b;
				def sum1, 0.0: ℕ, (a, b) → return a + b;
				'''
			)
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.reduction,
			TypeValidator::REDUCTION_SEED_TYPE,
			TypeValidator::getReductionSeedTypeMsg())

		moduleKo.assertError(NablaPackage.eINSTANCE.reduction,
			TypeValidator::REDUCTION_TYPES_COMPATIBILITY,
			TypeValidator::getReductionTypesCompatibilityMsg(PrimitiveType::REAL.literal, PrimitiveType::INT.literal))

		val moduleOk = parseHelper.parse(getTestModule( '',
				'''
				def sum1, 0.0: ℝ[2], (a, b) → return a + b;
				def sum1, 0: ℕ, (a, b) → return a + b;
				'''
			)
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckFunctionCallArgs()
	{
		val functions =
			'''
			def	test: ℾ × ℝ × ℝ[2] → ℝ;
			'''

		val moduleKo = parseHelper.parse(getTestModule('', functions)
			+
			'''
			const option = [0., 1.];
			const x = test(true, 0, option);
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.functionCall,
			TypeValidator::FUNCTION_ARGS,
			TypeValidator::getFunctionArgsMsg(
				#[PrimitiveType::BOOL.literal,
				PrimitiveType::INT.literal,
				new NSTRealArray1D(createIntConstant(2)).label]
		))		

		val moduleOk = parseHelper.parse(getTestModule('', functions)
			+
			'''
			const option = [0., 1.];
			const x = test(true, 0., option);
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckReductionArgs()
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
			TypeValidator::REDUCTION_ON_CONNECTIVITIES_VARIABLE,
			TypeValidator::getReductionOnConnectivitiesVariableMsg())

		moduleKo.assertError(NablaPackage.eINSTANCE.reductionCall,
			TypeValidator::REDUCTION_ARGS,
			TypeValidator::getReductionArgsMsg(new NSTRealScalar().label))

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
			ℝ cond;
			ℝ U;
			ℕ V;
			let W = (cond ? U : V);
			'''
		)
		Assert.assertNotNull(moduleKo)
		val cond = moduleKo.getVariableByName("cond")
		val u = moduleKo.getVariableByName("U")
		val v = moduleKo.getVariableByName("V")

		moduleKo.assertError(NablaPackage.eINSTANCE.contractedIf,
			TypeValidator::CONTRACTED_IF_CONDITION_TYPE,
			TypeValidator::getContractedIfConditionTypeMsg(cond.typeFor.label))

		moduleKo.assertError(NablaPackage.eINSTANCE.contractedIf,
			TypeValidator::CONTRACTED_IF_ELSE_TYPE,
			TypeValidator::getContractedIfElseTypeMsg(v.typeFor.label, u.typeFor.label))

		val moduleOk = parseHelper.parse(testModule
			+
			'''
			ℾ cond;
			ℝ U;
			ℝ V;
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
			ℝ cond;
			let ok = !cond; 
			'''
		)
		Assert.assertNotNull(moduleKo)
		val cond = moduleKo.getVariableByName("cond")

		moduleKo.assertError(NablaPackage.eINSTANCE.not,
			TypeValidator::NOT_EXPRESSION_TYPE,
			TypeValidator::getNotExpressionTypeMsg(cond.typeFor.label))

		val moduleOk = parseHelper.parse(testModule
			+
			'''
			ℾ cond;
			let ok = !cond; 
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}		
	
	@Test
	def void testCheckMulOrDivType()
	{
		val moduleKo = parseHelper.parse(testModule
			+
			'''
			ℾ a; 
			ℝ b;
			let c = a * b;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.mul,
			TypeValidator::MUL_TYPE,
			TypeValidator::getBinaryOpTypeMsg("*",
				PrimitiveType::BOOL.literal,
				PrimitiveType::REAL.literal
			))

		val moduleOk = parseHelper.parse(testModule
			+
			'''
			ℝ a;
			ℝ b;
			let c = a * b;
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
			ℾ a; 
			ℕ b;
			let c = a + b;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.plus,
			TypeValidator::PLUS_TYPE,
			TypeValidator::getBinaryOpTypeMsg("+",
				PrimitiveType::BOOL.literal,
				PrimitiveType::INT.literal
			))

		val moduleOk = parseHelper.parse(testModule
			+
			'''
			ℝ a;
			ℕ b;
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
			ℝ[2] a;
			ℝ[3] b;
			let c = a - b;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.minus,
			TypeValidator::MINUS_TYPE,
			TypeValidator::getBinaryOpTypeMsg("-",
				new NSTRealArray1D(createIntConstant(2)).label,

				new NSTRealArray1D(createIntConstant(3)).label
			))

		val moduleOk = parseHelper.parse(testModule
			+
			'''
			ℝ[2] a;
			ℝ[2] b;
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
			ℝ a;
			ℝ[2] b;
			let c = a > b;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.comparison,
			TypeValidator::COMPARISON_TYPE,
			TypeValidator::getBinaryOpTypeMsg(">",
				PrimitiveType::REAL.literal,
				new NSTRealArray1D(createIntConstant(2)).label
			))

		val moduleOk = parseHelper.parse(testModule
			+
			'''
			ℝ a;
			ℝ b;
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
			ℝ a;
			ℝ[2] b;
			let c = a == b;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.equality,
			TypeValidator::EQUALITY_TYPE,
			TypeValidator::getBinaryOpTypeMsg("==",
				PrimitiveType::REAL.literal,
				new NSTRealArray1D(createIntConstant(2)).label
			))

		val moduleOk = parseHelper.parse(testModule
			+
			'''
			ℝ a; 
			ℝ b;
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
			ℝ a;
			ℝ[2] b;
			let c = a % b;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.modulo,
			TypeValidator::MODULO_TYPE,
			TypeValidator::getModuloTypeMsg(PrimitiveType::REAL.literal))

		moduleKo.assertError(NablaPackage.eINSTANCE.modulo,
			TypeValidator::MODULO_TYPE,
			TypeValidator::getModuloTypeMsg(new NSTRealArray1D(createIntConstant(2)).label))

		val moduleOk = parseHelper.parse(testModule
			+
			'''
			ℕ a;
			ℕ b;
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
			ℕ a;
			ℝ b; 
			let c = a && b;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.and,
			TypeValidator::AND_TYPE,
			TypeValidator::getAndTypeMsg(PrimitiveType::REAL.literal))

		moduleKo.assertError(NablaPackage.eINSTANCE.and,
			TypeValidator::AND_TYPE,
			TypeValidator::getAndTypeMsg(PrimitiveType::INT.literal))

		val moduleOk = parseHelper.parse(testModule
			+
			'''
			ℾ a;
			ℾ b; 
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
			ℕ a;
			ℝ b;
			let c = a || b;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.or,
			TypeValidator::OR_TYPE,
			TypeValidator::getOrTypeMsg(PrimitiveType::REAL.literal))

		moduleKo.assertError(NablaPackage.eINSTANCE.or,
			TypeValidator::OR_TYPE,
			TypeValidator::getOrTypeMsg(PrimitiveType::INT.literal))

		val moduleOk = parseHelper.parse(testModule
			+
			'''
			ℾ a;
			ℾ b;
			let c = a || b;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}
}
