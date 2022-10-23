/*******************************************************************************
 * Copyright (c) 2022 CEA
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
import fr.cea.nabla.nabla.ConnectivityVar
import fr.cea.nabla.nabla.DefaultExtension
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.FunctionCall
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
	@Inject ParseHelper<NablaRoot> parseHelper
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

		def int f();
		def int f(int a);
		def real f(real a);
		def real[2] f(real[2] a);

		def <a> real[a] g(real[a] x);
		def <a, b> real[a*b] g(real[a, b] x);
		def <a, b> real[a+b] g(real[a] x, real[b] y);

		def <a> real[a] h(real[a] x, real[a] y);
		'''

		val nablaModel =
		'''
		module Test;

		with MyLibOfFunctions.*;
		with CartesianMesh2D.*;

		real[card(cells())] a;
		real x{cells};
		real[2] x2{cells};
		real[3] t;

		let int constexprDim = 2;
		let real[constexprDim] constexprVec = [1.1, 1.1];

		// --- TEST DE F ---
		J0: { let int y = f(); }
		J1: { let int y = f(2); }
		J2: { let real y = f(3.0); }
		J3: {
				let real[2] b = [1.1, 2.2];
				let real[2] y = f(b);
				y = f(constexprVec);
		}
		J4: { let real y = f(3.0, true); } // Wrong arguments : real, bool

		// --- TEST DE G ---
		J5: {
				let real[2] b = [1.1, 2.2];
				let real[2] y = g(b);
		}
		J6: {
				let real[2,3] b = [[1.1, 2.2, 3.3], [4.4, 5.5, 6.6]];
				let real[6] y = g(b);
		}
		J7: {
				let real[2] b = [1.1, 2.2];
				let real[3] c = [3.3, 4.4, 5.5];
				let real[5] y = g(b, c);
		}
		J8: { let real[3] gt = g(t); }
		J9: { a = g(x, x); } // Wrong arguments : real{cells}, real{cells}
		J10: { a = g(x2); } // Wrong arguments : real²{cells}

		// --- TEST DE H ---
		J11: {
			let real[2] b = [1.1, 2.2];
			let real[2] y = h(b, constexprVec);
		}
		'''

		val rs = resourceSetProvider.get
		parseHelper.parse(readFileAsString(TestUtils.CartesianMesh2DPath), rs)
		val nablaExt = parseHelper.parse(nablaextModel, rs) as DefaultExtension
		val module = parseHelper.parse(nablaModel, rs) as NablaModule
		Assert.assertNotNull(module)
		Assert.assertEquals(3, module.validate.filter(i | i.severity == Severity.ERROR).size)
		module.assertError(NablaPackage.eINSTANCE.functionCall,
		ExpressionValidator::FUNCTION_CALL_ARGS,
		ExpressionValidator::getFunctionCallArgsMsg(#[PrimitiveType::REAL.literal, PrimitiveType::BOOL.literal]))
		val xVar = module.getVarByName("x") as ConnectivityVar
		val cells = xVar.supports.head
		module.assertError(NablaPackage.eINSTANCE.functionCall,
		ExpressionValidator::FUNCTION_CALL_ARGS,
		ExpressionValidator::getFunctionCallArgsMsg(#[new NablaConnectivityType(#[cells], new NSTRealArray1D(createIntConstant(2), 2)).label]))
		module.assertError(NablaPackage.eINSTANCE.functionCall,
		ExpressionValidator::FUNCTION_CALL_ARGS,
		ExpressionValidator::getFunctionCallArgsMsg(#[new NablaConnectivityType(#[cells], new NSTRealScalar).label, new NablaConnectivityType(#[cells], new NSTRealScalar).label]))

		val fFunctions = nablaExt.functions.filter[x | x.name == 'f']
		val j0Fdecl = getFunctionCallOfJob(module, 0)
		Assert.assertEquals(fFunctions.get(0), j0Fdecl.model)
		val j1Fdecl = getFunctionCallOfJob(module, 1)
		Assert.assertEquals(fFunctions.get(1), j1Fdecl.model)
		val j2Fdecl = getFunctionCallOfJob(module, 2)
		Assert.assertEquals(fFunctions.get(2), j2Fdecl.model)
		val j3Fdecl = getFunctionCallOfJob(module, 3)
		Assert.assertEquals(fFunctions.get(3), j3Fdecl.model)
		val j4Fdecl = getFunctionCallOfJob(module, 4)
		Assert.assertNull(j4Fdecl)

		val gFunctions = nablaExt.functions.filter(Function).filter[x | x.name == 'g']
		val j5Gdecl = getFunctionCallOfJob(module, 5)
		Assert.assertEquals(gFunctions.get(0), j5Gdecl.model)
		Assert.assertEquals(new NSTRealArray1D(createIntConstant(2), 2), j5Gdecl.returnType)
		val j6Gdecl = getFunctionCallOfJob(module, 6)
		Assert.assertEquals(gFunctions.get(1), j6Gdecl.model)
		Assert.assertEquals(new NSTRealArray1D(createIntConstant(6), 6), j6Gdecl.returnType)
		val j7Gdecl = getFunctionCallOfJob(module, 7)
		Assert.assertEquals(gFunctions.get(2), j7Gdecl.model)
		Assert.assertEquals(new NSTRealArray1D(createIntConstant(5), 5), j7Gdecl.returnType)
		val j8Gdecl = getFunctionCallOfJob(module, 8)
		Assert.assertEquals(gFunctions.get(0), j8Gdecl.model)
		Assert.assertEquals(new NSTRealArray1D(createIntConstant(3), 3), j8Gdecl.returnType)
		val j9Gdecl = getFunctionCallOfJob(module, 9)
		Assert.assertNull(j9Gdecl)
		val j10Gdecl = getFunctionCallOfJob(module, 10)
		Assert.assertNull(j10Gdecl)

		val hFunctions = nablaExt.functions.filter(Function).filter[x | x.name == 'h']
		val j11Hdecl = getFunctionCallOfJob(module, 11)
		Assert.assertEquals(hFunctions.get(0), j11Hdecl.model)
	}

	@Test
	def void testFunctionsWithBody()
	{
		val model =
		'''
		extension Test;

		def real f(real a) return a;
		def real[2] f(real[2] a) return a;
		def <x> real[x] g(real[x] a) return a;

		def real[2] h(real[2] a) {
			return f(a) + g(a);
		}

		def <a> real[a] i(real[a] x) {
			return f(x); // Wrong f only on real[2]
		}

		def <a> real[a] j(real[a] x) {
			let real[a] y = g(x);
			forall i in [0;a[, y[i] = f(x[i]);
			return y;
		}
		'''

		val ext = parseHelper.parse(model) as DefaultExtension
		Assert.assertNotNull(ext)
		Assert.assertEquals(1, ext.validate.filter(i | i.severity == Severity.ERROR).size)
		ext.assertError(NablaPackage.eINSTANCE.functionCall, ExpressionValidator::FUNCTION_CALL_ARGS, ExpressionValidator::getFunctionCallArgsMsg(#["real[a]"]))

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

		with CartesianMesh2D.*;

		red real f(0.0) (a , b) : return a;
		red <x> real[x] f(0.0) (a , b) : return a;

		real u{cells};
		real[2] u2{cells};
		int bidon{cells};

		// --- TEST DE F ---
		J0: { let real x = f{j in cells()}(u{j}); }
		J1: { let real[2] x = f{j in cells()}(u2{j}); }
		J2: { let real x = f{j in cells()}(bidon{j}); } // Wrong arguments : int
		'''

		val rs = resourceSetProvider.get
		parseHelper.parse(readFileAsString(TestUtils.CartesianMesh2DPath), rs)
		val module = parseHelper.parse(model, rs) as NablaModule
		Assert.assertNotNull(module)
		Assert.assertEquals(1, module.validate.filter(i | i.severity == Severity.ERROR).size)
		module.assertError(NablaPackage.eINSTANCE.reductionCall,
		ExpressionValidator::REDUCTION_CALL_ARGS,
		ExpressionValidator::getReductionCallArgsMsg(PrimitiveType::INT.literal))

		val fReductions = module.reductions.filter[x | x.name == 'f']
		val j0Fdecl = getReductionCallOfJob(module, 0)
		Assert.assertEquals(fReductions.get(0), j0Fdecl.model)
		val j1Fdecl = getReductionCallOfJob(module, 1)
		Assert.assertEquals(fReductions.get(1), j1Fdecl.model)
		Assert.assertEquals(new NSTRealArray1D(createIntConstant(2), 2), j1Fdecl.type)
		val j2Fdecl = getReductionCallOfJob(module, 2)
		Assert.assertNull(j2Fdecl)
	}

	private def getFunctionCallOfJob(NablaModule m, int jobIndex)
	{
		val fcall = m.jobs.get(jobIndex).eAllContents.filter(FunctionCall).head
		fcall.declaration
	}

	private def getReductionCallOfJob(NablaModule m, int jobIndex)
	{
		val fcall = m.jobs.get(jobIndex).eAllContents.filter(ReductionCall).head
		fcall.declaration
	}
}