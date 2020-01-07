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
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NablaPackage
import fr.cea.nabla.nabla.PrimitiveType
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.typing.DeclarationProvider
import fr.cea.nabla.typing.NSTRealArray1D
import fr.cea.nabla.typing.NSTRealScalar
import fr.cea.nabla.typing.NSTSizeType
import fr.cea.nabla.typing.NablaConnectivityType
import fr.cea.nabla.validation.BasicValidator
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
class DeclarationProviderTest 
{
	@Inject extension ParseHelper<NablaModule>
	@Inject extension DeclarationProvider
	@Inject extension ValidationTestHelper
	@Inject extension NablaModuleExtensions

	@Test
	def void testFunctions() 
	{
		val model =
		'''
		module Test;

		items { cell, node }

		set	cells: → {cell};
		set	nodes: → {node};

		def	f: → ℕ;
		def f: ℕ → ℕ;
		def f: ℝ → ℝ;
		def f: ℝ[2] → ℝ[2];

		def	g: a | ℝ[a] → ℝ[a];
		def g: a, b | ℝ[a, b] → ℝ[a*b];
		def g: a, b | ℝ[a] × ℝ[b] → ℝ[a+b];
		'''
		+ TestUtils::mandatoryOptions +
		'''
			
		ℝ a{cells};
		ℝ x{cells};
		ℝ[2] x2{cells};

		// --- TEST DE F ---
		J0: { ℕ y = f(); }
		J1: { ℕ y = f(2); }
		J2: { ℝ y = f(3.0); }
		J3: {
				ℝ[2] b = [1.1, 2.2];
				ℝ[2] y = f(b);
		}
		J4: { ℝ y = f(3.0, true); } // Wrong arguments : ℝ, ℾ

		// --- TEST DE G ---
		J5: {
				ℝ[2] b = [1.1, 2.2];
				ℝ[2] y = g(b);
		}
		J6: {
				ℝ[2, 3] b = [[1.1, 2.2, 3.3], [4.4, 5.5, 6.6]];
				ℝ[6] y = g(b);
		}
		J7: {
				ℝ[2] b = [1.1, 2.2];
				ℝ[3] c = [3.3, 4.4, 5.5];
				ℝ[5] y = g(b, c);
		}
		J8: { a = g(x); }
		J9: { a = g(x, x); } // Wrong arguments : ℝ{cells}, ℝ{cells}
		J10: { a = g(x2); } // Wrong arguments : ℝ²{cells}
		'''

		val module = model.parse
		Assert.assertNotNull(module)
		Assert.assertEquals(3, module.validate.filter(i | i.severity == Severity.ERROR).size)
		module.assertError(NablaPackage.eINSTANCE.functionCall,
		TypeValidator::FUNCTION_ARGS,
		TypeValidator::getFunctionArgsMsg(#[PrimitiveType::REAL.literal, PrimitiveType::BOOL.literal]))
		val cells = module.getConnectivityByName("cells")
		module.assertError(NablaPackage.eINSTANCE.functionCall,
		TypeValidator::FUNCTION_ARGS,
		TypeValidator::getFunctionArgsMsg(#[new NablaConnectivityType(#[cells], new NSTRealArray1D(NSTSizeType.create(2))).label]))
		module.assertError(NablaPackage.eINSTANCE.functionCall,
		TypeValidator::FUNCTION_ARGS,
		TypeValidator::getFunctionArgsMsg(#[new NablaConnectivityType(#[cells], new NSTRealScalar).label, new NablaConnectivityType(#[cells], new NSTRealScalar).label]))

		val fFunctions = module.functions.filter[x | x.name == 'f']
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

		val gFunctions = module.functions.filter(Function).filter[x | x.name == 'g']
		val j5Gdecl = getFunctionDeclarationOfJob(module, 5)
		Assert.assertEquals(gFunctions.get(0), j5Gdecl.model)
		Assert.assertEquals(new NSTRealArray1D(NSTSizeType.create(2)), j5Gdecl.returnType)
		val j6Gdecl = getFunctionDeclarationOfJob(module, 6)
		Assert.assertEquals(gFunctions.get(1), j6Gdecl.model)
		Assert.assertEquals(new NSTRealArray1D(NSTSizeType.create(6)), j6Gdecl.returnType)
		val j7Gdecl = getFunctionDeclarationOfJob(module, 7)
		Assert.assertEquals(gFunctions.get(2), j7Gdecl.model)
		Assert.assertEquals(new NSTRealArray1D(NSTSizeType.create(5)), j7Gdecl.returnType)
		val j8Gdecl = getFunctionDeclarationOfJob(module, 8)
		Assert.assertEquals(gFunctions.get(0), j8Gdecl.model)
		Assert.assertEquals(new NablaConnectivityType(#[cells], new NSTRealScalar), j8Gdecl.returnType)
		val j9Gdecl = getFunctionDeclarationOfJob(module, 9)
		Assert.assertEquals(gFunctions.get(2), j9Gdecl.model)
		Assert.assertNull(j9Gdecl.returnType)
		val j10Gdecl = getFunctionDeclarationOfJob(module, 10)
		Assert.assertEquals(gFunctions.get(1), j10Gdecl.model)
		Assert.assertNull(j10Gdecl.returnType)
	}

	@Test
	def void testFunctionsWithBody()
	{
		val model =
		'''
		module Test;

		items { node }
		set	nodes: → {node};

		def f: ℝ → ℝ;
		def f: ℝ[2] → ℝ[2];
		def g: x | ℝ[x] → ℝ[x];

		def h: ℝ[2] → ℝ[2], (a) → {
			return f(a) + g(a);
		}

		def i: a | ℝ[a] → ℝ[a], (x) → {
			return f(x); // Wrong f only on ℝ[2]
		}

		def	j: a | ℝ[a] → ℝ[a], (x) → {
			ℝ[a] y = g(x);
			∀i∈[0;a[, y[i] = f(x[i]);
			return y;
		}
		'''
		+ TestUtils::mandatoryOptions

		val module = model.parse
		Assert.assertNotNull(module)
		Assert.assertEquals(1, module.validate.filter(i | i.severity == Severity.ERROR).size)
		module.assertError(NablaPackage.eINSTANCE.functionCall, TypeValidator::FUNCTION_ARGS, TypeValidator::getReductionArgsMsg("ℝ[a]"))

		Assert.assertEquals(4, module.validate.filter(i | i.severity == Severity.WARNING).size)
		module.assertWarning(NablaPackage.eINSTANCE.function, BasicValidator::UNUSED_FUNCTION, 114, 1, BasicValidator::getUnusedFunctionMsg)
		module.assertWarning(NablaPackage.eINSTANCE.function, BasicValidator::UNUSED_FUNCTION, 166, 1, BasicValidator::getUnusedFunctionMsg)
		module.assertWarning(NablaPackage.eINSTANCE.function, BasicValidator::UNUSED_FUNCTION, 239, 1, BasicValidator::getUnusedFunctionMsg)

		val functions = module.functions
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

		items { cell, node }

		set cells: → {cell}; 
		set nodes: → {node};
			
		def	f: (0.0, ℝ) → ℝ;
		def f: x | (0.0, ℝ[x]) → ℝ[x];
		'''
		+ TestUtils::mandatoryOptions +
		'''
		ℝ u{cells};
		ℝ[2] u2{cells};
		ℕ bidon{cells};

		// --- TEST DE F ---
		J0: { ℝ x = f{j ∈ cells()}(u{j}); }
		J1: { ℝ[2] x = f{j ∈ cells()}(u2{j}); }
		J2: { ℝ x = f{j ∈ cells()}(bidon{j}); } // Wrong arguments : ℕ
		'''

		val module = model.parse
		Assert.assertNotNull(module)
		Assert.assertEquals(1, module.validate.filter(i | i.severity == Severity.ERROR).size)
		module.assertError(NablaPackage.eINSTANCE.reductionCall,
		TypeValidator::REDUCTION_ARGS,
		TypeValidator::getReductionArgsMsg(PrimitiveType::INT.literal))
		
		val fReductions = module.reductions.filter[x | x.name == 'f']
		val j0Fdecl = getReductionDeclarationOfJob(module, 0)
		Assert.assertEquals(fReductions.get(0), j0Fdecl.model)
		val j1Fdecl = getReductionDeclarationOfJob(module, 1)
		Assert.assertEquals(fReductions.get(1), j1Fdecl.model)
		Assert.assertEquals(new NSTRealArray1D(NSTSizeType.create(2)), j1Fdecl.returnType)
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