package fr.cea.nabla.tests

import com.google.inject.Inject
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NablaPackage
import fr.cea.nabla.validation.BasicValidator
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(NablaInjectorProvider))
class BasicValidatorTest 
{
	@Inject ParseHelper<NablaModule> parseHelper
	@Inject extension ValidationTestHelper

	private def getEmptyTestModule()
	{
		'''
			module Test;
		'''
	}

	private def getMandatoryOptions()
	{
		'''
		// Options obligatoires pour générer
		const ℝ X_EDGE_LENGTH = 0.01;
		const ℝ Y_EDGE_LENGTH = X_EDGE_LENGTH;
		const ℕ X_EDGE_ELEMS = 100;
		const ℕ Y_EDGE_ELEMS = 10;
		const ℕ Z_EDGE_ELEMS = 1;
		const ℝ option_stoptime = 0.2;
		const ℕ option_max_iterations = 20000;
		'''
	}
	
	private def getConnectivities()
	{
		'''
		items { node}
		
		connectivities {
			nodes: → {node};
		}
		'''
	}

	private def getCoordVariable()
	{
		'''
		ℝ[2] X{nodes};
		ℝ[2] orig = [0.0 , 0.0] ;
		'''
	}
	
	private def getIniX()
	{
		'''
		IniX: ∀r∈nodes(), 
		{ 
			X{r} = orig;
		}
		'''
	}
	
	private def getTestModule()
	{
		emptyTestModule + mandatoryOptions.toString
	}	
	
	private def getTestModule(CharSequence functions)
	{
		emptyTestModule + functions.toString + mandatoryOptions.toString
	}	

	private def getTestModuleWithCoordVariable()
	{
		emptyTestModule + connectivities.toString + coordVariable.toString + mandatoryOptions.toString + iniX
	}	

	// ===== NablaModule =====	
	
	@Test
	def void testCheckCoordVariable() 
	{
		val module = parseHelper.parse(testModule)
		Assert.assertNotNull(module)
		
		module.assertWarning(NablaPackage.eINSTANCE.nablaModule, 
			BasicValidator::COORD_VARIABLE, 
			BasicValidator::getCoordVariableMsg())		
	}
	
	@Test
	def void testValidCheckCoordVariable() 
	{
		val module = parseHelper.parse(
		testModuleWithCoordVariable)
		// We have to put IniX job, to avoid Unused variable warning
		Assert.assertNotNull(module)
		module.assertNoIssues		
	}
	
	// ===== Functions (Reductions, Dimension) =====	
	
	@Test
	def testCheckDimensionVarName() 
	{
		val module = parseHelper.parse(
		'''
			functions 
			{
				f:	n | ℝ[n] → ℝ;
				g:	x | ℝ[x] → ℝ;
			}
		'''.testModule)
		Assert.assertNotNull(module)
		
		module.assertError(NablaPackage.eINSTANCE.dimensionVar, 
			BasicValidator::DIMENSION_VAR_NAME, 
			BasicValidator::getDimensionVarNameMsg())
	}
	
	@Test
	def testValidCheckDimensionVarName() 
	{
		val module = parseHelper.parse(
		'''
			functions 
			{
				f:	x | ℝ[x] → ℝ;
			}
		'''.testModule)
		Assert.assertNotNull(module)
		module.assertNoErrors
	}
}
