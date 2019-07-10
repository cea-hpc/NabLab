package fr.cea.nabla.tests

import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.runner.RunWith
import com.google.inject.Inject
import fr.cea.nabla.nabla.NablaModule
import org.eclipse.xtext.testing.util.ParseHelper
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import org.junit.Test
import org.junit.Assert
import fr.cea.nabla.nabla.NablaPackage
import fr.cea.nabla.nabla.Function
import fr.cea.nabla.validation.BasicValidator

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(NablaInjectorProvider))
class BasicValidatorTest 
{
	@Inject ParseHelper<NablaModule> parseHelper
	@Inject extension ValidationTestHelper
	
	@Test
	def void test() 
	{
		val module = parseHelper.parse(
		'''
			module Test;
			
			functions 
			{
				f:	n | → ℝ[n];
			}
		''')
		
		Assert.assertNotNull(module)
		val errors = module.eResource.errors
		errors.forEach[x | println(x.message)]
		//Assert.assertTrue(errors.isEmpty)
		
		val f = module.functions.filter(Function).get(0).argGroups.get(0)
		f.assertError(NablaPackage.Literals::DIMENSION_VAR, BasicValidator::DIMENSION_VAR_NAME, 'Invalid name (reserved for time step)')
	}
}
