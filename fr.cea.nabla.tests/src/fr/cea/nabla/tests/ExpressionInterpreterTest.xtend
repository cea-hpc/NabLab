package fr.cea.nabla.tests

import com.google.inject.Inject
import fr.cea.nabla.ir.IrModuleExtensions
import fr.cea.nabla.ir.interpreter.Context
import fr.cea.nabla.ir.interpreter.NV0Int
import fr.cea.nabla.ir.interpreter.NV0Real
import fr.cea.nabla.ir.interpreter.NV1Int
import fr.cea.nabla.ir.interpreter.NV1Real
import fr.cea.nabla.ir.interpreter.NablaValue
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.SimpleVariable
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith

import static extension fr.cea.nabla.ir.interpreter.ExpressionInterpreter.*
import static extension fr.cea.nabla.ir.interpreter.NablaValueExtensions.*
import fr.cea.nabla.ir.interpreter.NV0Bool

@RunWith(XtextRunner)
@InjectWith(NablaInjectorProvider)
class ExpressionInterpreterTest
{
	@Inject CompilationChainHelper compilationHelper
	@Inject extension IrModuleExtensions
		
	@Test
	def void testInterpreteContractedIf() 
	{
		val model = TestUtils::testModule 
		+
		'''	
		ℝ r1 = true ? 1.0 : 2.0; // -> 1.0
		ℝ r2 = false ? 1.0 : 2.0; // -> 1.0
		
		JO: t = 0.; // No generation if no job ?
		'''
		val irModule = compilationHelper.getIrModule(model, TestUtils::testGenModel)
		val context = new Context

		assertInterpreteValue(irModule, context, "r1", new NV0Real(1.0))
		assertInterpreteValue(irModule, context, "r2", new NV0Real(2.0))
	}
		
	@Test
	def void testInterpreteBinaryExpression_getValueOfNV0Bool_NV0Bool() 
	{
		val model = TestUtils::testModule 
		+
		'''	
		ℾ b1 = true || false; // -> true
		ℾ b2 = true || true; // -> true
		ℾ b3 = false || false; // -> false

		ℾ b4 = true && false; // -> false
		ℾ b5 = true && true; // -> true
		ℾ b6 = false && false; // -> false

		ℾ b7 = true == false; // -> false
		ℾ b8 = true != false; // -> true
		ℾ b9 = true >= false; // -> true
		ℾ b10 = true <= false; // -> false
		ℾ b11 = true > false; // -> true
		ℾ b12 = true < false; // -> false
		
		JO: t = 0.; // No generation if no job ?
		'''
		val irModule = compilationHelper.getIrModule(model, TestUtils::testGenModel)
		val context = new Context
		
		assertInterpreteValue(irModule, context, "b1", new NV0Bool(true))
		assertInterpreteValue(irModule, context, "b2", new NV0Bool(true))
		assertInterpreteValue(irModule, context, "b3", new NV0Bool(false))

		assertInterpreteValue(irModule, context, "b4", new NV0Bool(false))
		assertInterpreteValue(irModule, context, "b5", new NV0Bool(true))
		assertInterpreteValue(irModule, context, "b6", new NV0Bool(false))

		assertInterpreteValue(irModule, context, "b7", new NV0Bool(false))
		assertInterpreteValue(irModule, context, "b8", new NV0Bool(true))	
		assertInterpreteValue(irModule, context, "b9", new NV0Bool(true))
		assertInterpreteValue(irModule, context, "b10", new NV0Bool(false))
		assertInterpreteValue(irModule, context, "b11", new NV0Bool(true))
		assertInterpreteValue(irModule, context, "b12", new NV0Bool(false))
	}
	
	@Test
	def void testInterpreteBinaryExpression_getValueOfNV0Int_NV0Int() 
	{
		val model = TestUtils::testModule 
		+
		'''	
		ℾ b1 = 1 == 2; // -> false
		ℾ b2 = 1 == 1; // -> true

		ℾ b3 = 1 != 2; // -> true
		ℾ b4 = 2 != 2; // -> false

		ℾ b5 = 1 >= 2; // -> false
		ℾ b6 = 2 >= 2; // -> true

		ℾ b7 = 1 <= 2; // -> true
		ℾ b8 = 2 <= 2; // -> true

		ℾ b9 = 1 > 2; // -> false
		ℾ b10 = 2 > 1; // -> true

		ℾ b11 = 1 < 2; // -> true
		ℾ b12 = 2 < 1; // -> false

		ℕ n1 = 1 + 2; // -> 3
		ℕ n2 = 2 - 1; // -> 1
		ℕ n3 = 2 * 3; // -> 6
		ℕ n4 = 6 / 3; // -> 2
		ℕ n5 = 7 / 3; // -> 2
		ℕ n6 = 7 % 3; // -> 1
		
		JO: t = 0.; // No generation if no job ?
		'''
		
		println(model)
		val irModule = compilationHelper.getIrModule(model, TestUtils::testGenModel)
		val context = new Context
		
		assertInterpreteValue(irModule, context, "b1", new NV0Bool(false))
		assertInterpreteValue(irModule, context, "b2", new NV0Bool(true))
		assertInterpreteValue(irModule, context, "b3", new NV0Bool(true))
		assertInterpreteValue(irModule, context, "b4", new NV0Bool(false))
		assertInterpreteValue(irModule, context, "b5", new NV0Bool(false))
		assertInterpreteValue(irModule, context, "b6", new NV0Bool(true))
		assertInterpreteValue(irModule, context, "b7", new NV0Bool(true))
		assertInterpreteValue(irModule, context, "b8", new NV0Bool(true))	
		assertInterpreteValue(irModule, context, "b9", new NV0Bool(false))
		assertInterpreteValue(irModule, context, "b10", new NV0Bool(true))
		assertInterpreteValue(irModule, context, "b11", new NV0Bool(true))
		assertInterpreteValue(irModule, context, "b12", new NV0Bool(false))
		
		assertInterpreteValue(irModule, context, "n1", new NV0Int(3))
		assertInterpreteValue(irModule, context, "n2", new NV0Int(1))
		assertInterpreteValue(irModule, context, "n3", new NV0Int(6))
		assertInterpreteValue(irModule, context, "n4", new NV0Int(2))
		assertInterpreteValue(irModule, context, "n5", new NV0Int(2))
		assertInterpreteValue(irModule, context, "n6", new NV0Int(1))
	}
			
	@Test
	def void testInterpreteConstant() 
	{
		val model = TestUtils::testModule 
		+
		'''
		ℕ a1 = 1;
		ℕ[2] a2 = [1,1];
		
		ℝ b1 = 2.0;
		ℝ[2] b2 = [1.0, 2.0];
		
		ℾ c1 = true;
		ℾ c2 = false;
		//ℾ [2] c3 = [true, false];

		JO: t = 0.; // No generation if no job ?
		'''
		val irModule = compilationHelper.getIrModule(model, TestUtils::testGenModel)
		val context = new Context

		assertInterpreteValue(irModule, context, "a1", new NV0Int(1))
		assertInterpreteValue(irModule, context, "a2", new NV1Int(#[1,1]))

		assertInterpreteValue(irModule, context, "b1", new NV0Real(2.0))
		assertInterpreteValue(irModule, context, "b2", new NV1Real(#[1.0,2.0]))
		
		assertInterpreteValue(irModule, context, "c1", new NV0Bool(true))
		assertInterpreteValue(irModule, context, "c2", new NV0Bool(false))
	}

	private def assertInterpreteValue(IrModule irModule, Context context, String variableName, NablaValue value)
	{
		Assert.assertTrue((irModule.getVariableByName(variableName) as SimpleVariable).defaultValue.interprete(context).isEqualsTo(value))
	}
}