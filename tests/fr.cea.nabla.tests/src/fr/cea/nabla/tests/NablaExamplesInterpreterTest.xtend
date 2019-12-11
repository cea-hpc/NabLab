package fr.cea.nabla.tests

import com.google.inject.Inject
import fr.cea.nabla.ir.interpreter.ModuleInterpreter
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

import static fr.cea.nabla.tests.TestUtils.*

@RunWith(XtextRunner)
@InjectWith(NablaInjectorProvider)
class NablaExamplesInterpreterTest 
{
	@Inject CompilationChainHelper compilationHelper
	
	@Test
	def void testInterpreteGlace2D()
	{
		val model = readFileAsString("src/glace2d/Glace2d.nabla")
		val genmodel = readFileAsString("src/glace2d/Glace2d.nablagen")
		
		val irModule = compilationHelper.getIrModule(model, genmodel)
		val moduleInterpreter = new ModuleInterpreter(irModule)
		moduleInterpreter.interprete
	}
	
	@Test
	def void testInterpreteHeatEquation()
	{
		val model = readFileAsString("src/heatequation/HeatEquation.nabla")
		val genmodel = readFileAsString("src/heatequation/HeatEquation.nablagen")
		
		val irModule = compilationHelper.getIrModule(model, genmodel)
		val moduleInterpreter = new ModuleInterpreter(irModule)
		moduleInterpreter.interprete
	}
	
}