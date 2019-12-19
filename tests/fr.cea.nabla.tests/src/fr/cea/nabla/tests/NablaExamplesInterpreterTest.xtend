package fr.cea.nabla.tests

import com.google.inject.Inject
import fr.cea.nabla.ir.interpreter.ModuleInterpreter
import java.util.logging.FileHandler
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

import static fr.cea.nabla.tests.TestUtils.*
import java.util.logging.Level

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
		val handler = new FileHandler("src/glace2d/InterpreteGlace2d.log")
		val moduleInterpreter = new ModuleInterpreter(irModule, handler)
		moduleInterpreter.interprete
	}
	
	@Test
	def void testInterpreteHeatEquation()
	{
		val model = readFileAsString("src/heatequation/HeatEquation.nabla")
		val genmodel = readFileAsString("src/heatequation/HeatEquation.nablagen")
		
		val irModule = compilationHelper.getIrModule(model, genmodel)
		val handler = new FileHandler("src/heatequation/InterpreteHeatEquation.log")
		handler.level = Level::WARNING
		val moduleInterpreter = new ModuleInterpreter(irModule, handler)
		for (var i = 0 ; i < 10 ; i++) 
		{
 			moduleInterpreter.warn("Execution " + i)
			moduleInterpreter.interprete
		}
	}
}