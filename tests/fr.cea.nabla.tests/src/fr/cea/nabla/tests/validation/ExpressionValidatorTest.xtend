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
import fr.cea.nabla.NablaModuleExtensions
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NablaPackage
import fr.cea.nabla.nabla.NablaRoot
import fr.cea.nabla.nabla.PrimitiveType
import fr.cea.nabla.tests.NablaInjectorProvider
import fr.cea.nabla.tests.TestUtils
import fr.cea.nabla.typing.ArgOrVarTypeProvider
import fr.cea.nabla.typing.NSTRealArray1D
import fr.cea.nabla.typing.NSTRealScalar
import fr.cea.nabla.validation.ExpressionValidator
import fr.cea.nabla.validation.ValidationUtils
import org.eclipse.emf.ecore.resource.ResourceSet
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
class ExpressionValidatorTest
{
	@Inject ParseHelper<NablaRoot> parseHelper
	@Inject Provider<ResourceSet> resourceSetProvider
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
			let real[2] one = [1.0, 1.0];
			let int int_ = int(1.2);
			let bool bool_ = bool(1);
			let real real_ = real(true);
			let real[2] realOne = real[2](one);
			''')
		Assert.assertNotNull(moduleKo)
		Assert.assertEquals(4, moduleKo.validate.filter(i | i.severity == Severity.ERROR).size)

		moduleKo.assertError(NablaPackage.eINSTANCE.baseTypeConstant,
			ExpressionValidator::BASE_TYPE_CONSTANT_VALUE,
			getTypeMsg(PrimitiveType::REAL.literal, PrimitiveType::INT.literal))

		moduleKo.assertError(NablaPackage.eINSTANCE.baseTypeConstant,
			ExpressionValidator::BASE_TYPE_CONSTANT_VALUE,
			getTypeMsg(PrimitiveType::INT.literal, PrimitiveType::BOOL.literal))


		moduleKo.assertError(NablaPackage.eINSTANCE.baseTypeConstant,
			ExpressionValidator::BASE_TYPE_CONSTANT_VALUE,
			getTypeMsg(PrimitiveType::BOOL.literal, PrimitiveType::REAL.literal))

		moduleKo.assertError(NablaPackage.eINSTANCE.baseTypeConstant,
			ExpressionValidator::BASE_TYPE_CONSTANT_VALUE,
			getTypeMsg("real²", PrimitiveType::REAL.literal))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			let int int_ = int(1);
			let bool bool_ = bool(true);
			let real real_ = real(1.2);
			let real[2] realOne = real[2](1.0);
			''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckFunctionCallArgs()
	{
		val rs = resourceSetProvider.get
		parseHelper.parse(readFileAsString(TestUtils.CartesianMesh2DPath), rs)
		val model =
			'''
			«emptyTestModule»
			with CartesianMesh2D.*;
			def real test(bool a, real b, real[2] c) return b;
			let real[2] opt = [0., 1.];
			let int count = 1;
			real alpha{cells};
			'''
		val moduleKo = parseHelper.parse(
			'''
			«model»
			J1: let real x = test(true, 0, opt);
			''', rs)
		Assert.assertNotNull(moduleKo)
		Assert.assertEquals(1, moduleKo.validate.filter(i | i.severity == Severity.ERROR).size)

		moduleKo.assertError(NablaPackage.eINSTANCE.functionCall,
			ExpressionValidator::FUNCTION_CALL_ARGS,
			ExpressionValidator::getFunctionCallArgsMsg(
				#[PrimitiveType::BOOL.literal,
				PrimitiveType::INT.literal,
				new NSTRealArray1D(createIntConstant(2), 2).label]
		))

		val moduleOk = parseHelper.parse(
			'''
			«model»
			J1: let real x = test(true, 0., opt);
			''', rs)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckReductionCallArgs()
	{
		val rs = resourceSetProvider.get
		parseHelper.parse(readFileAsString(TestUtils.CartesianMesh2DPath), rs)
		val moduleKo = parseHelper.parse(
			'''
			«emptyTestModule»
			with CartesianMesh2D.*;
			red real sum(0.0) (a, b) : return a + b;
			real D{cells}; 
			real[2] E{cells}; 
			ComputeU: let real u = sum{c in cells()}(D);
			ComputeV: let real[2] v = sum{c in cells()}(E{c});
			''', rs)
		Assert.assertNotNull(moduleKo)
		Assert.assertEquals(2, moduleKo.validate.filter(i | i.severity == Severity.ERROR).size)

		moduleKo.assertError(NablaPackage.eINSTANCE.reductionCall,
			ExpressionValidator::REDUCTION_CALL_ON_CONNECTIVITIES_VARIABLE,
			ExpressionValidator::getReductionCallOnConnectivitiesVariableMsg())

		moduleKo.assertError(NablaPackage.eINSTANCE.reductionCall,
			ExpressionValidator::REDUCTION_CALL_ARGS,
			ExpressionValidator::getReductionCallArgsMsg(new NSTRealScalar().label))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			with CartesianMesh2D.*;
			red real sum(0.0) (a,b) : return a + b;
			red <x> real[x] sum(0.0) (a,b) : return a + b;
			real D{cells};
			real[2] E{cells};
			ComputeU: let real u = sum{c in cells()}(D{c});
			ComputeV: let real[2] v = sum{c in cells()}(E{c});
			''', rs)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckContractedIfType() 
	{
		val moduleKo = parseHelper.parse(
			'''
			«emptyTestModule»
			let real cond = 0.0;
			let real U = 1.1;
			let int V = 2;
			let real W = (cond ? U : V);
			''') as NablaModule
		Assert.assertNotNull(moduleKo)
		Assert.assertEquals(2, moduleKo.validate.filter(i | i.severity == Severity.ERROR).size)

		val cond = moduleKo.getVarByName("cond")
		val u = moduleKo.getVarByName("U")
		val v = moduleKo.getVarByName("V")

		moduleKo.assertError(NablaPackage.eINSTANCE.contractedIf,
			ExpressionValidator::CONTRACTED_IF_CONDITION_TYPE,
			getTypeMsg(cond.typeFor.label, "bool"))

		moduleKo.assertError(NablaPackage.eINSTANCE.contractedIf,
			ExpressionValidator::CONTRACTED_IF_ELSE_TYPE,
			getTypeMsg(v.typeFor.label, u.typeFor.label))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			let bool cond = true;
			let real U = 0.0;
			let real V = 1.1;
			let real W = (cond ? U : V);
			''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckNotExpressionType()
	{
		val moduleKo = parseHelper.parse(
			'''
			«emptyTestModule»
			let real cond = 0.0;
			let bool ok = !cond; 
			''') as NablaModule
		Assert.assertNotNull(moduleKo)
		Assert.assertEquals(1, moduleKo.validate.filter(i | i.severity == Severity.ERROR).size)

		val cond = moduleKo.getVarByName("cond")

		moduleKo.assertError(NablaPackage.eINSTANCE.not,
			ExpressionValidator::NOT_EXPRESSION_TYPE,
			getTypeMsg(cond.typeFor.label, "bool"))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			let bool cond = true;
			let bool ok = !cond; 
			''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckMulType()
	{
		val moduleKo = parseHelper.parse(
			'''
			«emptyTestModule»
			let bool  a = true; 
			let real b = 0.0;
			let real c = a * b;
			''')
		Assert.assertNotNull(moduleKo)
		Assert.assertEquals(1, moduleKo.validate.filter(i | i.severity == Severity.ERROR).size)

		moduleKo.assertError(NablaPackage.eINSTANCE.mul,
			ExpressionValidator::MUL_TYPE,
			ExpressionValidator::getBinaryOpTypeMsg("*",
				PrimitiveType::BOOL.literal,
				PrimitiveType::REAL.literal
			))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			let real a = 1.1;
			let real b = 0.0;
			let real c = a * b;
			''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckDivType()
	{
		val moduleKo = parseHelper.parse(
			'''
			«emptyTestModule»
			let bool a = true; 
			let real b = 0.0;
			let real c = a / b;
			''')
		Assert.assertNotNull(moduleKo)
		Assert.assertEquals(1, moduleKo.validate.filter(i | i.severity == Severity.ERROR).size)

		moduleKo.assertError(NablaPackage.eINSTANCE.div,
			ExpressionValidator::DIV_TYPE,
			ExpressionValidator::getBinaryOpTypeMsg("/",
				PrimitiveType::BOOL.literal,
				PrimitiveType::REAL.literal
			))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			let real a = 1.1;
			let real b = 0.0;
			let real c = a / b;
			''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckPlusType() 
	{
		val moduleKo = parseHelper.parse(
			'''
			«emptyTestModule»
			let bool a = true; 
			let int b = 0;
			let real c = a + b;
			''')
		Assert.assertNotNull(moduleKo)
		Assert.assertEquals(1, moduleKo.validate.filter(i | i.severity == Severity.ERROR).size)

		moduleKo.assertError(NablaPackage.eINSTANCE.plus,
			ExpressionValidator::PLUS_TYPE,
			ExpressionValidator::getBinaryOpTypeMsg("+",
				PrimitiveType::BOOL.literal,
				PrimitiveType::INT.literal
			))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			let real a = 1.1;
			let int b = 0;
			let real c = a + b;
			''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckMinusType()
	{
		val moduleKo = parseHelper.parse(
			'''
			«emptyTestModule»
			let real[2] a = real[2](0.0);
			let real[3] b = real[3](0.0);
			let real[2] c = a - b;
			''')
		Assert.assertNotNull(moduleKo)
		Assert.assertEquals(1, moduleKo.validate.filter(i | i.severity == Severity.ERROR).size)

		moduleKo.assertError(NablaPackage.eINSTANCE.minus,
			ExpressionValidator::MINUS_TYPE,
			ExpressionValidator::getBinaryOpTypeMsg("-",
				new NSTRealArray1D(createIntConstant(2), 2).label,

				new NSTRealArray1D(createIntConstant(3), 3).label
			))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			let real[2] a = real[2](0.0);
			let real[2] b = real[2](1.1);
			let real[2] c = a - b;
			''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckComparisonType()
	{
		val moduleKo = parseHelper.parse(
			'''
			«emptyTestModule»
			let real a = 0.0;
			let real[2] b = real[2](1.1);
			let bool c = a > b;
			''')
		Assert.assertNotNull(moduleKo)
		Assert.assertEquals(1, moduleKo.validate.filter(i | i.severity == Severity.ERROR).size)

		moduleKo.assertError(NablaPackage.eINSTANCE.comparison,
			ExpressionValidator::COMPARISON_TYPE,
			ExpressionValidator::getBinaryOpTypeMsg(">",
				PrimitiveType::REAL.literal,
				new NSTRealArray1D(createIntConstant(2), 2).label
			))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			let real a = 0.0;
			let real b = 1.1;
			let bool c = a > b;
			''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckEqualityType()
	{
		val moduleKo = parseHelper.parse(
			'''
			«emptyTestModule»
			let real a = 0.0;
			let real[2] b = real[2](1.1);
			let bool c = a == b;
			''')
		Assert.assertNotNull(moduleKo)
		Assert.assertEquals(1, moduleKo.validate.filter(i | i.severity == Severity.ERROR).size)

		moduleKo.assertError(NablaPackage.eINSTANCE.equality,
			ExpressionValidator::EQUALITY_TYPE,
			ExpressionValidator::getBinaryOpTypeMsg("==",
				PrimitiveType::REAL.literal,
				new NSTRealArray1D(createIntConstant(2), 2).label
			))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			let real a = 0.0; 
			let real b = 1.1;
			let bool c = a == b;
			''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckModuloType()
	{
		val moduleKo = parseHelper.parse(
			'''
			«emptyTestModule»
			let real a = 0.0;
			let real[2] b = real[2](1.1);
			let int c = a % b;
			''')
		Assert.assertNotNull(moduleKo)
		Assert.assertEquals(2, moduleKo.validate.filter(i | i.severity == Severity.ERROR).size)

		moduleKo.assertError(NablaPackage.eINSTANCE.modulo,
			ExpressionValidator::MODULO_TYPE,
			getTypeMsg(PrimitiveType::REAL.literal, "int"))

		moduleKo.assertError(NablaPackage.eINSTANCE.modulo,
			ExpressionValidator::MODULO_TYPE,
			getTypeMsg(new NSTRealArray1D(createIntConstant(2), 2).label, "int"))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			let int a = 0;
			let int b = 1;
			let int c = a % b;
			''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckAndType() 
	{
		val moduleKo = parseHelper.parse(
			'''
			«emptyTestModule»
			let int a = 0;
			let real b = 1.1; 
			let bool c = a && b;
			''')
		Assert.assertNotNull(moduleKo)
		Assert.assertEquals(2, moduleKo.validate.filter(i | i.severity == Severity.ERROR).size)

		moduleKo.assertError(NablaPackage.eINSTANCE.and,
			ExpressionValidator::AND_TYPE,
			getTypeMsg(PrimitiveType::REAL.literal, "bool"))

		moduleKo.assertError(NablaPackage.eINSTANCE.and,
			ExpressionValidator::AND_TYPE,
			getTypeMsg(PrimitiveType::INT.literal, "bool"))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			let bool a = true;
			let bool b = false; 
			let bool c = a && b;
			''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckOrType()
	{
		val moduleKo = parseHelper.parse(
			'''
			«emptyTestModule»
			let int a = 0;
			let real b = 1.1;
			let bool c = a || b;
			''')
		Assert.assertNotNull(moduleKo)
		Assert.assertEquals(2, moduleKo.validate.filter(i | i.severity == Severity.ERROR).size)

		moduleKo.assertError(NablaPackage.eINSTANCE.or,
			ExpressionValidator::OR_TYPE,
			getTypeMsg(PrimitiveType::REAL.literal, "bool"))

		moduleKo.assertError(NablaPackage.eINSTANCE.or,
			ExpressionValidator::OR_TYPE,
			getTypeMsg(PrimitiveType::INT.literal, "bool"))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			let bool a = true;
			let bool b = false;
			let bool c = a || b;
			''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testVectorConstantSize()
	{
		val moduleKo = parseHelper.parse(
			'''
			«emptyTestModule»
			let int[1] V = [0];
			''')
		Assert.assertNotNull(moduleKo)
		Assert.assertEquals(1, moduleKo.validate.filter(i | i.severity == Severity.ERROR).size)

		moduleKo.assertError(NablaPackage.eINSTANCE.vectorConstant,
			ExpressionValidator::VECTOR_CONSTANT_SIZE,
			ExpressionValidator::getVectorConstantSizeMsg(1))

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			letint[2] V = [0, 1];
			''')
		Assert.assertNotNull(moduleOk)
	}

	@Test
	def void testVectorConstantType()
	{
		val moduleKo = parseHelper.parse(
			'''
			«emptyTestModule»
			let int[2] V = [0, 3.4];
			''')
		Assert.assertNotNull(moduleKo)
		Assert.assertEquals(1, moduleKo.validate.filter(i | i.severity == Severity.ERROR).size)

		moduleKo.assertError(NablaPackage.eINSTANCE.vectorConstant,
			ExpressionValidator::VECTOR_CONSTANT_INCONSISTENT_TYPE,
			ExpressionValidator::getVectorConstantInconsistentTypeMsg())

		val moduleOk = parseHelper.parse(
			'''
			«emptyTestModule»
			let int[2] V = [0, 3];
			''')
		Assert.assertNotNull(moduleOk)
	}

	@Test
	def void testCheckExternFunctionCallInFunctionBody()
	{
		val extensionKo = parseHelper.parse(
			'''
			extension Test;
			def real f();
			def real g() 
			{
				real[4] n;
				forall  i in [0;4[, n[i] = 0.0;
				return f();
			}
			''')
		Assert.assertNotNull(extensionKo)
		Assert.assertEquals(1, extensionKo.validate.filter(i | i.severity == Severity.ERROR).size)

		extensionKo.assertError(NablaPackage.eINSTANCE.functionCall,
			ExpressionValidator::EXTERN_FUNCTION_CALL_IN_FUNCTION_BODY,
			ExpressionValidator::getExternFunctionCallInFunctionBodyMsg())

		val extensionOk = parseHelper.parse(
			'''
			extension Test;
			def real f();
			def real g() 
			{
				real[4] n;
				forall  i in [0;4[, n[i] = 0.0;
				return 4.0;
			}
			''')
		Assert.assertNotNull(extensionOk)
		extensionOk.assertNoErrors
	}
}
