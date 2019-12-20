package fr.cea.nabla.tests

import com.google.inject.Inject
import fr.cea.nabla.ir.interpreter.ModuleInterpreter
import fr.cea.nabla.ir.interpreter.NV0Real
import fr.cea.nabla.ir.interpreter.NV1Real
import java.util.logging.ConsoleHandler
import java.util.logging.Level
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

import static fr.cea.nabla.tests.TestUtils.*

@RunWith(XtextRunner)
@InjectWith(NablaInjectorProvider)
class InstructionInterpreterTest 
{
	@Inject CompilationChainHelper compilationHelper

	@Test
	def void testInterpreteVarDefinition()
	{
		val model = TestUtils::testModule
		+
		'''
		Job1: { ℝ r = 1.0; t = r; }
		'''

		val irModule = compilationHelper.getIrModule(model, TestUtils::testGenModel)
		val handler = new ConsoleHandler
		handler.level = Level::OFF
		val moduleInterpreter = new ModuleInterpreter(irModule, handler)
		val context = moduleInterpreter.interprete

		assertVariableValueInContext(irModule, context, "t", new NV0Real(1.0))
	}

	@Test
	def void testInterpreteInstructionBlock()
	{
		val model = TestUtils::testModule
		+
		'''
		Job1: { ℝ r = 1.0; t = r; }
		'''

		val irModule = compilationHelper.getIrModule(model, TestUtils::testGenModel)
		val handler = new ConsoleHandler
		handler.level = Level::OFF
		val moduleInterpreter = new ModuleInterpreter(irModule, handler)
		val context = moduleInterpreter.interprete

		assertVariableValueInContext(irModule, context, "t", new NV0Real(1.0))
	}

	@Test
	def void testInterpreteAffectation()
	{
		val model = TestUtils::testModule
		+
		'''
		Job1: { ℝ r = 1.0; t = r; }
		'''

		val irModule = compilationHelper.getIrModule(model, TestUtils::testGenModel)
		val handler = new ConsoleHandler
		handler.level = Level::OFF
		val moduleInterpreter = new ModuleInterpreter(irModule, handler)
		val context = moduleInterpreter.interprete

		assertVariableValueInContext(irModule, context, "t", new NV0Real(1.0))
	}

	@Test
	def void testInterpreteLoop()
	{
		val xQuads = 100
		val yQuads = 100
		val model = TestUtils::getTestModule(xQuads, yQuads, 0.2, 1)
		+
		'''
		ℝ U{cells};
		ℝ[2] C{cells, nodesOfCell};
		InitU : ∀r∈cells(), U{r} = 1.0;
		ComputeCjr: ∀j∈cells(), ∀r∈nodesOfCell(j), C{j,r} = 0.5 * (X{r+1} - X{r-1});
		'''

		val irModule = compilationHelper.getIrModule(model, TestUtils::testGenModel)
		val handler = new ConsoleHandler
		handler.level = Level::OFF
		val moduleInterpreter = new ModuleInterpreter(irModule, handler)
		val context = moduleInterpreter.interprete

		val double[] res = newDoubleArrayOfSize(xQuads * yQuads)
		for (var i = 0 ; i < res.length ; i++)
			res.set(i, 1.0)

		assertVariableValueInContext(irModule, context, "U", new NV1Real(res))
	}
}