package fr.cea.nabla.tests.interpreter

import com.google.inject.Inject
import fr.cea.nabla.ir.interpreter.Context
import fr.cea.nabla.ir.interpreter.ModuleInterpreter
import fr.cea.nabla.ir.interpreter.NV0Bool
import fr.cea.nabla.ir.interpreter.NV0Int
import fr.cea.nabla.ir.interpreter.NV0Real
import fr.cea.nabla.ir.interpreter.NV1Bool
import fr.cea.nabla.ir.interpreter.NV1Int
import fr.cea.nabla.ir.interpreter.NV1Real
import fr.cea.nabla.ir.interpreter.NV2Bool
import fr.cea.nabla.ir.interpreter.NV2Int
import fr.cea.nabla.ir.interpreter.NV2Real
import fr.cea.nabla.tests.CompilationChainHelper
import fr.cea.nabla.tests.TestUtils
import java.util.logging.ConsoleHandler
import java.util.logging.Level
import java.util.logging.Logger
import org.junit.Assert

import static extension fr.cea.nabla.ir.IrModuleExtensions.*

class ExpressionInterpreterTest extends AbstractExpressionInterpreterTest {
	
	@Inject CompilationChainHelper compilationHelper
	@Inject extension TestUtils
	
	override assertInterpreteContractedIf(String model) {
		val irModule = compilationHelper.getIrModule(model, testGenModel)
		val context = new Context(irModule, Logger.getLogger(AbstractExpressionInterpreterTest.name))

		assertVariableDefaultValue(irModule, context, "r1", new NV0Real(1.0))
		assertVariableDefaultValue(irModule, context, "r2", new NV0Real(2.0))
	}

	override assertInterpreteUnaryExpression(String model)
	{
		val irModule = compilationHelper.getIrModule(model, testGenModel)
		val handler = new ConsoleHandler
		handler.level = Level::OFF
		val moduleInterpreter = new ModuleInterpreter(irModule, handler)
		val context = moduleInterpreter.interpreteWithOptionDefaultValues

		assertVariableValueInContext(irModule, context, "b0", new NV0Bool(true))
		assertVariableValueInContext(irModule, context, "n0", new NV0Int(-1))
		assertVariableValueInContext(irModule, context, "r0", new NV0Real(-1))
		assertVariableValueInContext(irModule, context, "n1", new NV1Int(#[1, 2]))
		assertVariableValueInContext(irModule, context, "n2", new NV1Int(#[-1, -2]))
		assertVariableValueInContext(irModule, context, "r1", new NV1Real(#[1.0, 2.0]))
		assertVariableValueInContext(irModule, context, "r2", new NV1Real(#[-1.0, -2.0]))
		assertVariableValueInContext(irModule, context, "n3", new NV2Int(#[#[0, 1],#[1, 2]]))
		assertVariableValueInContext(irModule, context, "n4", new NV2Int(#[#[0, -1],#[-1, -2]]))
		assertVariableValueInContext(irModule, context, "r3", new NV2Real(#[#[0.0, 1.0],#[1.0, 2.0]]))
		// Warning : -0.0 != 0.0
		assertVariableValueInContext(irModule, context, "r4", new NV2Real(#[#[-0.0, -1.0],#[-1.0, -2.0]]))
	}

	override assertInterpreteParenthesis(String model)
	{
		val irModule = compilationHelper.getIrModule(model, testGenModel)
		val context = new Context(irModule, Logger.getLogger(AbstractExpressionInterpreterTest.name))

		assertVariableDefaultValue(irModule, context, "b", new NV0Bool(true))
	}

	override assertInterpreteConstant(String model)
	{
		val irModule = compilationHelper.getIrModule(model, testGenModel)
		val context = new Context(irModule, Logger.getLogger(AbstractExpressionInterpreterTest.name))

		assertVariableDefaultValue(irModule, context, "n1", new NV0Int(1))
		assertVariableDefaultValue(irModule, context, "r1", new NV0Real(2.0))
		assertVariableDefaultValue(irModule, context, "b1", new NV0Bool(true))
		assertVariableDefaultValue(irModule, context, "b2", new NV0Bool(false))
	}

	override assertInterpreteMinConstant(String model)
	{
		val irModule = compilationHelper.getIrModule(model, testGenModel)
		val context = new Context(irModule, Logger.getLogger(AbstractExpressionInterpreterTest.name))

		assertVariableDefaultValue(irModule, context, "nMin", new NV0Int(Integer.MIN_VALUE))
		assertVariableDefaultValue(irModule, context, "rMin", new NV0Real(Double.MIN_VALUE))
	}

	override assertInterpreteMaxConstant(String model)
	{
		val irModule = compilationHelper.getIrModule(model, testGenModel)
		val context = new Context(irModule, Logger.getLogger(AbstractExpressionInterpreterTest.name))

		assertVariableDefaultValue(irModule, context, "nMax", new NV0Int(Integer.MAX_VALUE))
		assertVariableDefaultValue(irModule, context, "rMax", new NV0Real(Double.MAX_VALUE))
	}

	override assertInterpreteBaseTypeConstant(String model)
	{
		val irModule = compilationHelper.getIrModule(model, testGenModel)
		val context = new Context(irModule, Logger.getLogger(AbstractExpressionInterpreterTest.name))

		assertVariableDefaultValue(irModule, context, "n1", new NV0Int(1))
		assertVariableDefaultValue(irModule, context, "n2", new NV1Int(#[1,1]))
		assertVariableDefaultValue(irModule, context, "n3", new NV2Int(#[#[1, 1, 1],#[1, 1, 1]]))

		assertVariableDefaultValue(irModule, context, "r1", new NV0Real(1.0))
		assertVariableDefaultValue(irModule, context, "r2", new NV1Real(#[1.0,1.0]))
		assertVariableDefaultValue(irModule, context, "r3", new NV2Real(#[#[1.0, 1.0, 1.0],#[1.0, 1.0, 1.0]]))

		assertVariableDefaultValue(irModule, context, "b1", new NV0Bool(true))
		assertVariableDefaultValue(irModule, context, "b2", new NV1Bool(#[true, true]))
		assertVariableDefaultValue(irModule, context, "b3", new NV2Bool(#[#[true, true, true],#[true, true, true]]))
	}
	
	override assertInterpreteIntVectorConstant(String model)
	{
		val irModule = compilationHelper.getIrModule(model, testGenModel)
		val context = new Context(irModule, Logger.getLogger(AbstractExpressionInterpreterTest.name))

		assertVariableDefaultValue(irModule, context, "n", new NV1Int(#[1,2]))
	}

	override assertInterpreteIntMatrixConstant(String model)
	{
		val irModule = compilationHelper.getIrModule(model, testGenModel)
		val context = new Context(irModule, Logger.getLogger(AbstractExpressionInterpreterTest.name))

		assertVariableDefaultValue(irModule, context, "n", new NV2Int(#[#[0, 1, 2],#[1, 2, 3]]))
	}

	override assertInterpreteRealVectorConstant(String model)
	{
		val irModule = compilationHelper.getIrModule(model, testGenModel)
		val context = new Context(irModule, Logger.getLogger(AbstractExpressionInterpreterTest.name))

		assertVariableDefaultValue(irModule, context, "r", new NV1Real(#[1.0, 2.0]))
	}

	override assertInterpreteRealMatrixConstant(String model)
	{
		val irModule = compilationHelper.getIrModule(model, testGenModel)
		val context = new Context(irModule, Logger.getLogger(AbstractExpressionInterpreterTest.name))

		assertVariableDefaultValue(irModule, context, "r", new NV2Real(#[#[0.0, 1.0, 2.0],#[1.0, 2.0, 3.0]]))
	}

	override assertInterpreteCardinality(String model)
	{
		val irModule = compilationHelper.getIrModule(model, testGenModel)
		val handler = new ConsoleHandler
		handler.level = Level::OFF
		val moduleInterpreter = new ModuleInterpreter(irModule, handler)
		val context = moduleInterpreter.interpreteWithOptionDefaultValues
		val variableValue = context.getVariableValue(irModule.getVariableByName("c"))
		Assert.assertNotNull(variableValue)
		Assert.assertTrue(variableValue instanceof NV0Int)
		Assert.assertEquals(121, (variableValue as NV0Int).data)
	}

	override assertInterpreteFunctionCall(String model)
	{
		val irModule = compilationHelper.getIrModule(model, testGenModel)
		val handler = new ConsoleHandler
		handler.level = Level::OFF
		val moduleInterpreter = new ModuleInterpreter(irModule, handler)
		val context = moduleInterpreter.interpreteWithOptionDefaultValues

		assertVariableValueInContext(irModule, context, "n0", new NV0Int(0))
		assertVariableValueInContext(irModule, context, "n1", new NV0Int(1))
		assertVariableValueInContext(irModule, context, "n2", new NV0Int(2))
		assertVariableValueInContext(irModule, context, "n3", new NV0Int(3))

		assertVariableValueInContext(irModule, context, "r1", new NV0Real(1.0))
		assertVariableValueInContext(irModule, context, "r2", new NV0Real(2.0))
		assertVariableValueInContext(irModule, context, "r3", new NV0Real(3.0))

		assertVariableValueInContext(irModule, context, "w", new NV1Real(#[3.0, 3.0]))
		assertVariableValueInContext(irModule, context, "res1", new NV1Real(#[3.0, 3.0, 3.0]))
		assertVariableValueInContext(irModule, context, "res2", new NV2Real(#[#[3.0, 3.0],#[3.0, 3.0]]))
	}

	override assertInterpreteFunctionCallWithBody(String model)
	{
		val irModule = compilationHelper.getIrModule(model, testGenModel)
		val handler = new ConsoleHandler
		handler.level = Level::OFF
		val moduleInterpreter = new ModuleInterpreter(irModule, handler)
		val context = moduleInterpreter.interpreteWithOptionDefaultValues

		assertVariableValueInContext(irModule, context, "w1", new NV1Real(#[0.0, 0.2]))
		assertVariableValueInContext(irModule, context, "w2", new NV1Real(#[0.0, 0.2]))
		assertVariableValueInContext(irModule, context, "w3", new NV1Real(#[0.0, 0.2, 0.4]))
		assertVariableValueInContext(irModule, context, "w4", new NV1Real(#[0.0, 0.2]))
		assertVariableValueInContext(irModule, context, "w5", new NV1Real(#[0.0, 0.2, 0.4]))
		assertVariableValueInContext(irModule, context, "w6", new NV1Real(#[0.0, 0.2]))
	}

	override assertInterpreteVarRef(String model)
	{
		val irModule = compilationHelper.getIrModule(model, testGenModel)
		val handler = new ConsoleHandler
		handler.level = Level::OFF
		val moduleInterpreter = new ModuleInterpreter(irModule, handler)
		val context = moduleInterpreter.interpreteWithOptionDefaultValues

		assertVariableValueInContext(irModule, context, "b2", new NV0Bool(true))

		assertVariableValueInContext(irModule, context, "n2", new NV0Int(1))
		assertVariableValueInContext(irModule, context, "n4", new NV1Int(#[2,3]))
		assertVariableValueInContext(irModule, context, "n7", new NV2Int(#[#[2,3],#[4,5],#[6,7]]))
		assertVariableValueInContext(irModule, context, "n8", new NV0Int(5))

		assertVariableValueInContext(irModule, context, "r2", new NV0Real(1.0))
		assertVariableValueInContext(irModule, context, "r4", new NV1Real(#[2.0,3.0]))
		assertVariableValueInContext(irModule, context, "r7", new NV2Real(#[#[2.0,3.0],#[4.0,5.0],#[6.0,7.0]]))
		assertVariableValueInContext(irModule, context, "r8", new NV0Real(5.0))
	}
}