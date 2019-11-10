package fr.cea.nabla.tests

import com.google.inject.Inject
import fr.cea.nabla.ir.interpreter.NV0Int
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

import static fr.cea.nabla.tests.TestUtils.*

import static extension fr.cea.nabla.ir.interpreter.ModuleInterpreter.*

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
		ℕ n1 = 1;
		'''

		val irModule = compilationHelper.getIrModule(model, TestUtils::testGenModel)
		val context = irModule.interprete

		assertVariableValueInContext(irModule, context, "n1", new NV0Int(1))
	}
}