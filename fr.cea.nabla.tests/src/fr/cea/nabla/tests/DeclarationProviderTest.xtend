package fr.cea.nabla.tests

import com.google.inject.Inject
import fr.cea.nabla.NablaModuleExtensions
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NablaPackage
import fr.cea.nabla.nabla.PrimitiveType
import fr.cea.nabla.nabla.Reduction
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.typing.DeclarationProvider
import fr.cea.nabla.validation.TypeValidator
import org.eclipse.xtext.diagnostics.Severity
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith
import fr.cea.nabla.typing.NablaConnectivityType
import fr.cea.nabla.typing.NSTRealScalar
import fr.cea.nabla.typing.NSTRealArray1D

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

		connectivities {
			cells: → {cell};
			nodes: → {node};
		}

		functions
		{
			f:	→ ℕ, ℕ → ℕ, ℝ → ℝ, ℝ[2] → ℝ[2];
			g:	a | ℝ[a] → ℝ[a], a, b | ℝ[a, b] → ℝ[a*b], a, b | ℝ[a] × ℝ[b] → ℝ[a+b];
		}
		'''
		+ TestUtils::mandatoryOptions + TestUtils::mandatoryVariables +
		'''
			
		ℝ a{cells};
		ℝ x{cells};
		ℝ[2] x2{cells};

		// --- TEST DE F ---
		J0: { ℕ x = f(); }
		J1: { ℕ x = f(2); }
		J2: { ℝ x = f(3.0); }
		J3: {
				ℝ[2] a = [1.1, 2.2];
				ℝ[2] x = f(a);
		}
		J4: { ℝ x = f(3.0, true); } // Wrong arguments : ℝ, ℾ

		// --- TEST DE G ---
		J5: {
				ℝ[2] a = [1.1, 2.2];
				ℝ[2] x = g(a);
		}
		J6: {
				ℝ[2, 3] a = [[1.1, 2.2, 3.3], [4.4, 5.5, 6.6]];
				ℝ[6] x = g(a);
		}
		J7: {
				ℝ[2] a = [1.1, 2.2];
				ℝ[3] b = [3.3, 4.4, 5.5];
				ℝ[5] x = g(a, b);
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
		TypeValidator::getFunctionArgsMsg(#[new NablaConnectivityType(#[cells], new NSTRealArray1D(2)).label]))
		module.assertError(NablaPackage.eINSTANCE.functionCall,
		TypeValidator::FUNCTION_ARGS,
		TypeValidator::getFunctionArgsMsg(#[new NablaConnectivityType(#[cells], new NSTRealScalar).label, new NablaConnectivityType(#[cells], new NSTRealScalar).label]))
		
		val f = module.functions.filter(Function).get(0)
		val j0Fdecl = getFunctionDeclarationOfJob(module, 0)
		Assert.assertEquals(f.argGroups.get(0), j0Fdecl.model)
		val j1Fdecl = getFunctionDeclarationOfJob(module, 1)
		Assert.assertEquals(f.argGroups.get(1), j1Fdecl.model)
		val j2Fdecl = getFunctionDeclarationOfJob(module, 2)
		Assert.assertEquals(f.argGroups.get(2), j2Fdecl.model)
		val j3Fdecl = getFunctionDeclarationOfJob(module, 3)
		Assert.assertEquals(f.argGroups.get(3), j3Fdecl.model)
		val j4Fdecl = getFunctionDeclarationOfJob(module, 4)
		Assert.assertNull(j4Fdecl)
		
		val g = module.functions.filter(Function).get(1)
		val j5Gdecl = getFunctionDeclarationOfJob(module, 5)
		Assert.assertEquals(g.argGroups.get(0), j5Gdecl.model)
		Assert.assertEquals(new NSTRealArray1D(2), j5Gdecl.returnType)	
		
		val j6Gdecl = getFunctionDeclarationOfJob(module, 6)
		Assert.assertEquals(g.argGroups.get(1), j6Gdecl.model)
		Assert.assertEquals(new NSTRealArray1D(6), j6Gdecl.returnType)
		val j7Gdecl = getFunctionDeclarationOfJob(module, 7)
		Assert.assertEquals(g.argGroups.get(2), j7Gdecl.model)
		Assert.assertEquals(new NSTRealArray1D(5), j7Gdecl.returnType)
		val j8Gdecl = getFunctionDeclarationOfJob(module, 8)
		Assert.assertEquals(g.argGroups.get(0), j8Gdecl.model)
		Assert.assertEquals(new NablaConnectivityType(#[cells], new NSTRealScalar), j8Gdecl.returnType)
		val j9Gdecl = getFunctionDeclarationOfJob(module, 9)
		Assert.assertEquals(g.argGroups.get(2), j9Gdecl.model)
		Assert.assertNull(j9Gdecl.returnType)
		val j10Gdecl = getFunctionDeclarationOfJob(module, 10)
		Assert.assertEquals(g.argGroups.get(1), j10Gdecl.model)
		Assert.assertNull(j10Gdecl.returnType)
	}
	
	@Test
	def void testReductions() 
	{
		val model =
		'''
		module Test;

		items { cell, node }

		connectivities { cells: → {cell}; nodes: → {node};}
			
		functions
		{
			f: (0.0, ℝ) → ℝ, x | (0.0, ℝ[x]) → ℝ[x];
		}
		'''
		+ TestUtils::mandatoryOptions + TestUtils::mandatoryVariables +
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
		
		val f = module.functions.filter(Reduction).get(0)
		val j0Fdecl = getReductionDeclarationOfJob(module, 0)
		Assert.assertEquals(f.argGroups.get(0), j0Fdecl.model)
		val j1Fdecl = getReductionDeclarationOfJob(module, 1)
		Assert.assertEquals(f.argGroups.get(1), j1Fdecl.model)
		Assert.assertEquals(new NSTRealArray1D(2), j1Fdecl.returnType)
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