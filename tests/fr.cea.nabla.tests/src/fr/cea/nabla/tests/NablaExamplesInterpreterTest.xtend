package fr.cea.nabla.tests

import com.google.inject.Inject
import fr.cea.nabla.ir.interpreter.ModuleInterpreter
import java.util.logging.FileHandler
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
		val moduleInterpreter = new ModuleInterpreter(irModule, handler)
		//moduleInterpreter.warn("Execution 1")
		moduleInterpreter.interprete
		// To test cache influence
//		moduleInterpreter.warn("Execution 2")
//		moduleInterpreter.interprete
//		moduleInterpreter.warn("Execution 3")
//		moduleInterpreter.interprete
//		moduleInterpreter.warn("Execution 4")
//		moduleInterpreter.interprete
//		moduleInterpreter.warn("Execution 5")
//		moduleInterpreter.interprete
//		moduleInterpreter.warn("Execution 6")
//		moduleInterpreter.interprete
//		moduleInterpreter.warn("Execution 7")
//		moduleInterpreter.interprete
//		moduleInterpreter.warn("Execution 8")
//		moduleInterpreter.interprete
//		moduleInterpreter.warn("Execution 9")
//		moduleInterpreter.interprete
//		moduleInterpreter.warn("Execution 10")
//		moduleInterpreter.interprete
	}
}