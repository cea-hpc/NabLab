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
import com.google.inject.Provider
import fr.cea.nabla.NablaModuleExtensions
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.NablaExtension
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NablaPackage
import fr.cea.nabla.nabla.NablaRoot
import fr.cea.nabla.nabla.PrimitiveType
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.overloading.DeclarationProvider
import fr.cea.nabla.typing.NSTRealArray1D
import fr.cea.nabla.typing.NSTRealScalar
import fr.cea.nabla.typing.NablaConnectivityType
import fr.cea.nabla.validation.ExpressionValidator
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
class DeclarationProviderTest 
{
	@Inject Provider<ResourceSet> resourceSetProvider
	@Inject ParseHelper<NablaRoot> parserHelper
	@Inject extension DeclarationProvider
	@Inject extension ValidationTestHelper
	@Inject extension NablaModuleExtensions
	@Inject extension TestUtils

	@Test
	def void testFunctions() 
	{
		val nablaextModel =
		'''
		extension MyLibOfFunctions;

		def f: → ℕ;
		def f: ℕ → ℕ;
		def f: ℝ → ℝ;
		def f: ℝ[2] → ℝ[2];

		def g: a | ℝ[a] → ℝ[a];
		def g: a, b | ℝ[a, b] → ℝ[a*b];
		def g: a, b | ℝ[a] × ℝ[b] → ℝ[a+b];
		'''

		val nablaModel =
		'''
		module Test;

		with MyLibOfFunctions.*;

		itemtypes { cell, node }

		connectivity cells: → {cell};
		connectivity nodes: → {node};

		ℝ a{cells};
		ℝ x{cells};
		ℝ[2] x2{cells};

		// --- TEST DE F ---
		J0: { let ℕ y = f(); }
		J1: { let ℕ y = f(2); }
		J2: { let ℝ y = f(3.0); }
		J3: {
				let ℝ[2] b = [1.1, 2.2];
				let ℝ[2] y = f(b);
		}
		J4: { let ℝ y = f(3.0, true); } // Wrong arguments : ℝ, ℾ

		// --- TEST DE G ---
		J5: {
				let ℝ[2] b = [1.1, 2.2];
				let ℝ[2] y = g(b);
		}
		J6: {
				let ℝ[2,3] b = [[1.1, 2.2, 3.3], [4.4, 5.5, 6.6]];
				let ℝ[6] y = g(b);
		}
		J7: {
				let ℝ[2] b = [1.1, 2.2];
				let ℝ[3] c = [3.3, 4.4, 5.5];
				let ℝ[5] y = g(b, c);
		}
		J8: { a = g(x); }
		J9: { a = g(x, x); } // Wrong arguments : ℝ{cells}, ℝ{cells}
		J10: { a = g(x2); } // Wrong arguments : ℝ²{cells}
		'''

		val rs = resourceSetProvider.get
		val nablaExt = parserHelper.parse(nablaextModel, rs) as NablaExtension
		val module = parserHelper.parse(nablaModel, rs) as NablaModule
		Assert.assertNotNull(module)
		Assert.assertEquals(4, module.validate.filter(i | i.severity == Severity.ERROR).size)
		module.assertError(NablaPackage.eINSTANCE.functionCall,
		ExpressionValidator::FUNCTION_CALL_ARGS,
		ExpressionValidator::getFunctionCallArgsMsg(#[PrimitiveType::REAL.literal, PrimitiveType::BOOL.literal]))
		val cells = module.getConnectivityByName("cells")
		module.assertError(NablaPackage.eINSTANCE.functionCall,
		ExpressionValidator::FUNCTION_CALL_ARGS,
		ExpressionValidator::getFunctionCallArgsMsg(#[new NablaConnectivityType(#[cells], new NSTRealArray1D(createIntConstant(2))).label]))
		module.assertError(NablaPackage.eINSTANCE.functionCall,
		ExpressionValidator::FUNCTION_CALL_ARGS,
		ExpressionValidator::getFunctionCallArgsMsg(#[new NablaConnectivityType(#[cells], new NSTRealScalar).label, new NablaConnectivityType(#[cells], new NSTRealScalar).label]))

		val fFunctions = nablaExt.functions.filter[x | x.name == 'f']
		val j0Fdecl = getFunctionDeclarationOfJob(module, 0)
		Assert.assertEquals(fFunctions.get(0), j0Fdecl.model)
		val j1Fdecl = getFunctionDeclarationOfJob(module, 1)
		Assert.assertEquals(fFunctions.get(1), j1Fdecl.model)
		val j2Fdecl = getFunctionDeclarationOfJob(module, 2)
		Assert.assertEquals(fFunctions.get(2), j2Fdecl.model)
		val j3Fdecl = getFunctionDeclarationOfJob(module, 3)
		Assert.assertEquals(fFunctions.get(3), j3Fdecl.model)
		val j4Fdecl = getFunctionDeclarationOfJob(module, 4)
		Assert.assertNull(j4Fdecl)

		val gFunctions = nablaExt.functions.filter(Function).filter[x | x.name == 'g']
		val j5Gdecl = getFunctionDeclarationOfJob(module, 5)
		Assert.assertEquals(gFunctions.get(0), j5Gdecl.model)
		Assert.assertEquals(new NSTRealArray1D(createIntConstant(2)), j5Gdecl.returnType)
		val j6Gdecl = getFunctionDeclarationOfJob(module, 6)
		Assert.assertEquals(gFunctions.get(1), j6Gdecl.model)
		Assert.assertEquals(new NSTRealArray1D(createIntConstant(6)), j6Gdecl.returnType)
		val j7Gdecl = getFunctionDeclarationOfJob(module, 7)
		Assert.assertEquals(gFunctions.get(2), j7Gdecl.model)
		Assert.assertEquals(new NSTRealArray1D(createIntConstant(5)), j7Gdecl.returnType)
		val j8Gdecl = getFunctionDeclarationOfJob(module, 8)
		Assert.assertEquals(gFunctions.get(0), j8Gdecl.model)
		Assert.assertEquals(new NablaConnectivityType(#[cells], new NSTRealScalar), j8Gdecl.returnType)
		val j9Gdecl = getFunctionDeclarationOfJob(module, 9)
		Assert.assertEquals(gFunctions.get(2), j9Gdecl.model)
		Assert.assertNull(j9Gdecl.returnType)
		val j10Gdecl = getFunctionDeclarationOfJob(module, 10)
		Assert.assertNull(j10Gdecl)
	}

	@Test
	def void testFunctionsWithBody()
	{
		val model =
		'''
		extension Test;

		def f: ℝ → ℝ, (a) → return a;
		def f: ℝ[2] → ℝ[2], (a) → return a;
		def g: x | ℝ[x] → ℝ[x], (a) → return a;

		def h: ℝ[2] → ℝ[2], (a) → {
			return f(a) + g(a);
		}

		def i: a | ℝ[a] → ℝ[a], (x) → {
			return f(x); // Wrong f only on ℝ[2]
		}

		def j: a | ℝ[a] → ℝ[a], (x) → {
			let ℝ[a] y = g(x);
			∀i∈[0;a[, y[i] = f(x[i]);
			return y;
		}
		'''

		val ext = parserHelper.parse(model)
		Assert.assertNotNull(ext)
		Assert.assertEquals(1, ext.validate.filter(i | i.severity == Severity.ERROR).size)
		ext.assertError(NablaPackage.eINSTANCE.functionCall, ExpressionValidator::FUNCTION_CALL_ARGS, ExpressionValidator::getFunctionCallArgsMsg(#["ℝ[a]"]))

		val functions = ext.functions
		val h = functions.findFirst[name == 'h']
		val hfCall = h.body.eAllContents.filter(FunctionCall).toList.get(0)
		Assert.assertEquals(functions.get(1), hfCall.declaration.model)
		val hgCall = h.body.eAllContents.filter(FunctionCall).toList.get(1)
		Assert.assertEquals(functions.get(2), hgCall.declaration.model)

		val j = functions.findFirst[name == 'j']
		val jfCall = j.body.eAllContents.filter(FunctionCall).toList.get(0)
		Assert.assertEquals(functions.get(2), jfCall.declaration.model)
		val jgCall = j.body.eAllContents.filter(FunctionCall).toList.get(1)
		Assert.assertEquals(functions.get(0), jgCall.declaration.model)
	}

	@Test
	def void testReductions() 
	{
		val model =
		'''
		module Test;

		itemtypes { cell, node }

		connectivity cells: → {cell}; 
		connectivity nodes: → {node};

		def f, 0.0: ℝ, (a , b) → return a;
		def f, 0.0: x | ℝ[x], (a , b) → return a;

		ℝ u{cells};
		ℝ[2] u2{cells};
		ℕ bidon{cells};

		// --- TEST DE F ---
		J0: { let ℝ x = f{j ∈ cells()}(u{j}); }
		J1: { let ℝ[2] x = f{j ∈ cells()}(u2{j}); }
		J2: { let ℝ x = f{j ∈ cells()}(bidon{j}); } // Wrong arguments : ℕ
		'''

		val module = parserHelper.parse(model) as NablaModule
		Assert.assertNotNull(module)
		Assert.assertEquals(1, module.validate.filter(i | i.severity == Severity.ERROR).size)
		module.assertError(NablaPackage.eINSTANCE.reductionCall,
		ExpressionValidator::REDUCTION_CALL_ARGS,
		ExpressionValidator::getReductionCallArgsMsg(PrimitiveType::INT.literal))

		val fReductions = module.reductions.filter[x | x.name == 'f']
		val j0Fdecl = getReductionDeclarationOfJob(module, 0)
		Assert.assertEquals(fReductions.get(0), j0Fdecl.model)
		val j1Fdecl = getReductionDeclarationOfJob(module, 1)
		Assert.assertEquals(fReductions.get(1), j1Fdecl.model)
		Assert.assertEquals(new NSTRealArray1D(createIntConstant(2)), j1Fdecl.type)
		val j2Fdecl = getReductionDeclarationOfJob(module, 2)
		Assert.assertNull(j2Fdecl)
	}

	private def getFunctionDeclarationOfJob(NablaModule m, int jobIndex)
	{
		val fcall = m.jobs.get(jobIndex).eAllContents.filter(FunctionCall).head
		fcall.declaration
	}

	private def getReductionDeclarationOfJob(NablaModule m, int jobIndex)
	{
		val fcall = m.jobs.get(jobIndex).eAllContents.filter(ReductionCall).head
		fcall.declaration
	}
}