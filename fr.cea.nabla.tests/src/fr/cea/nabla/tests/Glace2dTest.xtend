package fr.cea.nabla.tests

import com.google.inject.Inject
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

import static fr.cea.nabla.tests.TestUtils.*

import static extension fr.cea.nabla.ir.interpreter.ModuleInterpreter.*

@RunWith(XtextRunner)
@InjectWith(NablaInjectorProvider)
class Glace2dTest 
{
	@Inject CompilationChainHelper compilationHelper
	
	@Test
	def void testInterpreteGlace2D()
	{
		val model = readFileAsString("../NablaExamples/src/glace2d/Glace2d.nabla")
		val genmodel = readFileAsString("../NablaExamples/src/glace2d/Glace2d.nablagen")
		
		val irModule = compilationHelper.getIrModule(model, genmodel)
		irModule.interprete
	}
}