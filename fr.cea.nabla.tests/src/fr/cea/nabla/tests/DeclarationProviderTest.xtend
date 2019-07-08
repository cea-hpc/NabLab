package fr.cea.nabla.tests

import com.google.inject.Inject
import fr.cea.nabla.DeclarationProvider
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.NablaModule
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.nabla.PrimitiveType

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(NablaInjectorProvider))
class DeclarationProviderTest 
{
	@Inject ParseHelper<NablaModule> parseHelper
	@Inject extension DeclarationProvider
	
	@Test
	def void loadModel() 
	{
		val module = parseHelper.parse(
		'''
			module Test;
			
			functions 
			{
				f:	→ ℕ,
					ℕ → ℕ,
					ℝ → ℝ,
					ℝ[2] → ℝ[2];
					
				g:	a | ℝ[a] → ℝ[a],
					a, b | ℝ[a, b] → ℝ[a*b],
					a, b | ℝ[a] × ℝ[b] → ℝ[a+b];
			}
			
			// --- TEST DE F ---
			J0: { ℕ x = f(); }
			J1: { ℕ x = f(2); }
			J2: { ℝ x = f(3.0); } 
			J3: { 
					ℝ[2] a = [1.1, 2.2];
					ℝ[2] x = f(a);
			} 
			J4: { ℝ x = f(3.0, true); } 

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
		''')
		
		Assert.assertNotNull(module)
		val errors = module.eResource.errors
		for (e : errors)
			println(e.message)
		Assert.assertTrue(errors.isEmpty)
		
		val f = module.functions.filter(Function).get(0)		
		val j0Fdecl = getDeclarationOfJob(module, 0)
		Assert.assertEquals(f.argGroups.get(0), j0Fdecl.model)
		val j1Fdecl = getDeclarationOfJob(module, 1)
		Assert.assertEquals(f.argGroups.get(1), j1Fdecl.model)
		val j2Fdecl = getDeclarationOfJob(module, 2)
		Assert.assertEquals(f.argGroups.get(2), j2Fdecl.model)
		val j3Fdecl = getDeclarationOfJob(module, 3)
		Assert.assertEquals(f.argGroups.get(3), j3Fdecl.model)
		val j4Fdecl = getDeclarationOfJob(module, 4)
		Assert.assertNull(j4Fdecl)
		
		val g = module.functions.filter(Function).get(1)		
		val j5Gdecl = getDeclarationOfJob(module, 5)
		Assert.assertEquals(g.argGroups.get(0), j5Gdecl.model)
		Assert.assertEquals(PrimitiveType::REAL, j5Gdecl.returnType.root)
		Assert.assertEquals(#[2], j5Gdecl.returnType.sizes)
		val j6Gdecl = getDeclarationOfJob(module, 6)
		Assert.assertEquals(g.argGroups.get(1), j6Gdecl.model)
		TestUtils.assertEquals(PrimitiveType::REAL, #[6], j6Gdecl.returnType)
		val j7Gdecl = getDeclarationOfJob(module, 7)
		Assert.assertEquals(g.argGroups.get(2), j7Gdecl.model)
		TestUtils.assertEquals(PrimitiveType::REAL, #[5], j7Gdecl.returnType)
	}
	
	private def getDeclarationOfJob(NablaModule m, int jobIndex)
	{
		val fcall = m.jobs.get(jobIndex).eAllContents.filter(FunctionCall).head
		fcall.declaration
	}
}