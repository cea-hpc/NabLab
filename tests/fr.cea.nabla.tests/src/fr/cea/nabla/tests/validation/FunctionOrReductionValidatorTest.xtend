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
import fr.cea.nabla.validation.FunctionOrReductionValidator
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
class FunctionOrReductionValidatorTest
{
	@Inject ParseHelper<NablaRoot> parseHelper
	@Inject Provider<ResourceSet> resourceSetProvider
	@Inject extension ValidationUtils
	@Inject extension TestUtils
	@Inject extension ValidationTestHelper

	@Test
	def void testCheckEmptyBody()
	{
		val moduleKo = parseHelper.parse(
		'''
		module Test;

		def real f(real a);
		''')
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.functionOrReduction,
			FunctionOrReductionValidator::EMPTY_BODY,
			FunctionOrReductionValidator::getEmptyBodyMsg())

		val moduleOk = parseHelper.parse(
		'''
		module Test;

		def real f(real a) { return 1.0; }
		''')
		Assert.assertNotNull(moduleOk)
	}

	@Test
	def void testCheckForbiddenReturn()
	{
		val rs = resourceSetProvider.get
		parseHelper.parse(readFileAsString(TestUtils.CartesianMesh2DPath), rs)
		val moduleKo = parseHelper.parse(
			'''
			«testModule»
			int U{cells};
			ComputeU: forall  j in cells(), {
					let int e = 1;
					U{j} = e * 4;
					return e;
			}
			''', rs)
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.^return,
			FunctionOrReductionValidator::FORBIDDEN_RETURN,
			FunctionOrReductionValidator::getForbiddenReturnMsg())

		val moduleOk = parseHelper.parse(
			'''
			«testModule»
			int U{cells};
			ComputeU: forall  j in cells(), {
					let int e = 1;
					U{j} = e * 4;
			}
			''', rs)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckMissingReturn()
	{
		val moduleKo = parseHelper.parse(
		'''
		module Test;

		def real f(real a) { let x = 1; }
		''')
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.functionOrReduction,
			FunctionOrReductionValidator::MISSING_RETURN,
			FunctionOrReductionValidator::getMissingReturnMsg())

		val moduleOk = parseHelper.parse(
		'''
		module Test;

		def real f(real a) { return 1.0; }
		''')
		Assert.assertNotNull(moduleOk)
	}

	@Test
	def void testCheckUnreachableCode()
	{
		val moduleKo = parseHelper.parse(
		'''
		module Test;

		def real f(real a)
		{
			return 1.0;
			let int x = 1;
		}
		''')
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.simpleVarDeclaration,
			FunctionOrReductionValidator::UNREACHABLE_CODE,
			FunctionOrReductionValidator::getUnreachableReturnMsg())

		val moduleOk = parseHelper.parse(
		'''
		module Test;

		def real f(real a)
		{ 
			return 1.0;
		}
		''')
		Assert.assertNotNull(moduleOk)
	}

	@Test
	def void testCheckOnlyIntAndVarInFunctionInTypes()
	{
		val modulekO = parseHelper.parse(
		'''
		extension Test;
		def <x> real[x] f(real[x+1] a);
		''')
		Assert.assertNotNull(modulekO)

		modulekO.assertError(NablaPackage.eINSTANCE.function,
			FunctionOrReductionValidator::ONLY_INT_AND_VAR_IN_FUNCTION_IN_TYPES,
			FunctionOrReductionValidator::getOnlyIntAndVarInFunctionInTypesMsg(#["x"]))

		val moduleOk = parseHelper.parse(
		'''
		extension Test;
		def <x> real[x+1] f(real[x] a);
		''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def testCheckOnlyIntAndVarInReductionType()
	{
		val modulekO = parseHelper.parse(
		'''
		extension Test;
		red <x,y> real[x+y] sum(0.0) (a,b) : return a + b;
		''')
		Assert.assertNotNull(modulekO)

		modulekO.assertError(NablaPackage.eINSTANCE.reduction,
			FunctionOrReductionValidator::ONLY_INT_AND_VAR_IN_REDUCTION_TYPE,
			FunctionOrReductionValidator::getOnlyIntAndVarInReductionTypeMsg(#["x, y"]))

		val moduleOk = parseHelper.parse(
		'''
		extension Test;
		red <x> real[x] sum(0.0) (a,b) : return a + b;
		''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckFunctionIncompatibleInTypes() 
	{
		val modulekO = parseHelper.parse(
			'''
			extension Test;
			def real g(real[2] a);
			def <x> real g(real[x] a);
			''')
		Assert.assertNotNull(modulekO)

		modulekO.assertError(NablaPackage.eINSTANCE.function,
			FunctionOrReductionValidator::FUNCTION_INCOMPATIBLE_IN_TYPES,
			FunctionOrReductionValidator::getFunctionIncompatibleInTypesMsg())

		val moduleOk = parseHelper.parse(
			'''
			extension Test;
			def real g(real a);
			def <x> real g(real[x] a);
			''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testFunctionReturnTypeDeclaration()
	{
		val model = '''
		extension Test;
		def real f(real a) { return 1; }
		def real g(real a) { return 1.0; }
		'''
		val module = parseHelper.parse(model)
		Assert.assertNotNull(module)
		Assert.assertEquals(1, module.validate.filter(i | i.severity == Severity.ERROR).size)
		module.assertError(NablaPackage.eINSTANCE.functionReturnTypeDeclaration, FunctionOrReductionValidator::FUNCTION_RETURN_TYPE, getTypeMsg("int", "real"))
	}

	@Test
	def void testCheckFunctionReturnTypeDeclarationVar() 
	{
		val modulekO = parseHelper.parse(
			'''
			extension Test;
			def <x> real[x] f(real a);
			''')
		Assert.assertNotNull(modulekO)
		modulekO.assertError(NablaPackage.eINSTANCE.functionReturnTypeDeclaration, 
			FunctionOrReductionValidator::FUNCTION_RETURN_TYPE_VAR, 
			FunctionOrReductionValidator::getFunctionReturnTypeDeclarationVarMsg("x"))

		val moduleOk = parseHelper.parse(
			'''
			extension Test;
			def <x> real[x] f(real[x] a);
			def <y> real[x, y] g(real[y] a);
			''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors(NablaPackage.eINSTANCE.functionReturnTypeDeclaration, FunctionOrReductionValidator::FUNCTION_RETURN_TYPE_VAR)
	}

	@Test
	def void testCheckReductionIncompatibleTypes() 
	{
		val modulekO = parseHelper.parse(
			'''
			extension Test;
			red real[2] g(0.0) (a, b) : return a;
			red <x> real[x] g(0.0) (a, b) : return a;
			''')
		Assert.assertNotNull(modulekO)
		modulekO.assertError(NablaPackage.eINSTANCE.reduction,
			FunctionOrReductionValidator::REDUCTION_INCOMPATIBLE_TYPES,
			FunctionOrReductionValidator::getReductionIncompatibleTypesMsg())

		val moduleOk = parseHelper.parse(
			'''
			extension Test;
			red real g(0.0) (a, b) : return a;
			red <x> real[x] g(0.0) (a, b) :  return a;
			''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckSeedAndTypes()
	{
		val moduleKo = parseHelper.parse(
			'''
			extension Test;
			red real[2] sum1([0.0, 0.0]) (a, b) : return a + b;
			red int sum1(0.0) (a, b) : return a + b;
			''')
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.reduction,
			FunctionOrReductionValidator::REDUCTION_SEED_TYPE,
			FunctionOrReductionValidator::getReductionSeedTypeMsg())

		moduleKo.assertError(NablaPackage.eINSTANCE.reduction,
			FunctionOrReductionValidator::REDUCTION_TYPES_COMPATIBILITY,
			FunctionOrReductionValidator::getReductionTypesCompatibilityMsg(PrimitiveType::REAL.literal, PrimitiveType::INT.literal))

		val moduleOk = parseHelper.parse(
			'''
			extension Test;
			red real[2] sum1(0.0) (a, b) : return a + b;
			red int sum1(0) (a, b) : return a + b;
			''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}
}
