package fr.cea.nabla.tests

import com.google.inject.Inject
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NablaPackage
import fr.cea.nabla.nabla.PrimitiveType
import fr.cea.nabla.typing.RealArrayType
import fr.cea.nabla.validation.TypeValidator
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith
import fr.cea.nabla.NablaModuleExtensions
import fr.cea.nabla.typing.ExpressionTypeProvider

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(NablaInjectorProvider))
class TypeValidatorTest 
{
	@Inject ParseHelper<NablaModule> parseHelper
	@Inject extension ValidationTestHelper
	@Inject extension NablaModuleExtensions
	@Inject extension ExpressionTypeProvider

	// ===== Expressions =====	
	
	@Test
	def void testCheckValueType() 
	{
		val moduleKo = parseHelper.parse(TestUtils::testModule
			+
			'''
			const ℕ int = ℕ(1.2);
			const ℾ bool = ℾ(1);
			const ℝ real = ℝ(true);
			'''
		)
		Assert.assertNotNull(moduleKo)
		
		moduleKo.assertError(NablaPackage.eINSTANCE.baseTypeConstant, 
			TypeValidator::VALUE_TYPE, 
			TypeValidator::getValueTypeMsg(PrimitiveType::REAL.literal))		

		moduleKo.assertError(NablaPackage.eINSTANCE.baseTypeConstant, 
			TypeValidator::VALUE_TYPE, 
			TypeValidator::getValueTypeMsg(PrimitiveType::INT.literal))		

		moduleKo.assertError(NablaPackage.eINSTANCE.baseTypeConstant, 
			TypeValidator::VALUE_TYPE, 
			TypeValidator::getValueTypeMsg(PrimitiveType::BOOL.literal))		

		val moduleOk = parseHelper.parse(TestUtils::testModule
			+
			'''
			const ℕ int = ℕ(1);
			const ℾ bool = ℾ(true);
			const ℝ real = ℝ(1.2);
			'''		
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckSeedAndReturnTypes() 
	{
		val moduleKo = parseHelper.parse(TestUtils::getTestModuleWithCustomFunctions
			(
				'''
				functions {
					reduce1: (orig, ℝ)→ℝ;
					reduce2: (ℝ.MinValue, ℝ)→ℕ;	
				}
				'''
			)
			+
			'''
			const ℝ[2] orig = [0.0 , 0.0];
			'''
		)
		Assert.assertNotNull(moduleKo)
		
		moduleKo.assertError(NablaPackage.eINSTANCE.reductionArg, 
			TypeValidator::SEED_TYPE, 
			TypeValidator::getSeedTypeMsg())		

		moduleKo.assertError(NablaPackage.eINSTANCE.reductionArg, 
			TypeValidator::SEED_AND_RETURN_TYPES, 
			TypeValidator::getSeedAndReturnTypesMsg(PrimitiveType::REAL.literal, PrimitiveType::INT.literal))		

		val moduleOk = parseHelper.parse(TestUtils::getTestModuleWithCustomFunctions
			(
				'''
				functions {
					reduce1: (orig, ℝ)→ℝ;
					reduce2: (ℝ.MinValue, ℝ)→ℝ;	
				}
				'''
			)
			+
			'''
			const ℝ orig = 0.0;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckFunctionCallArgs() 
	{
		val moduleKo = parseHelper.parse(TestUtils::getTestModuleWithCustomFunctions
			(
				'''
				functions {
					test: ℾ × ℝ × ℝ[2] → ℝ;
				}
				'''
			)
			+
			'''
			const ℝ[2] option = [0., 1.];
			const ℝ x = test(true, 0, option);
			'''
		)
		Assert.assertNotNull(moduleKo)
		
		moduleKo.assertError(NablaPackage.eINSTANCE.functionCall, 
			TypeValidator::FUNCTION_ARGS, 
			TypeValidator::getFunctionArgsMsg(
				#[PrimitiveType::BOOL.literal,
				PrimitiveType::INT.literal,
				new RealArrayType(#[],#[2]).label]
		))		

		val moduleOk = parseHelper.parse(TestUtils::getTestModuleWithCustomFunctions
			(
				'''
				functions {
					test: ℾ × ℝ × ℝ[2] → ℝ;
				}
				'''
			)
			+
			'''
			const ℝ[2] option = [0., 1.];
			const ℝ x = test(true, 0., option);
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckReductionArgs() 
	{
		Assert.fail("Not yet Correctly Implemented")
		val moduleKo = parseHelper.parse(TestUtils::getTestModuleWithCustomFunctions
			(
				'''
				functions {
					reduceMin: (ℝ.MaxValue, ℝ)→ℝ;
				}
				'''
			)
			+
			'''
			ℝ D{cells}; 
			computeT: ℝ t = reduceMin{c∈cells()}(X_EDGE_LENGTH*Y_EDGE_LENGTH/D{c}) * 0.24;
			'''
		)
		Assert.assertNotNull(moduleKo)
		
		moduleKo.assertError(NablaPackage.eINSTANCE.reductionCall, 
			TypeValidator::REDUCTION_ON_CONNECTIVITIES_VARIABLE, 
			TypeValidator::getReductionOnConnectivitiesVariableMsg())		

		moduleKo.assertError(NablaPackage.eINSTANCE.reductionCall, 
			TypeValidator::REDUCTION_ARGS, 
			TypeValidator::getReductionArgsMsg(""))		

		val moduleOk = parseHelper.parse(TestUtils::getTestModuleWithCoordVariableWithCustomFunctions
			(
				'''
				functions {
					reduceMin: (ℝ.MaxValue, ℝ)→ℝ;
				}
				'''
			)
			+
			'''
			ℝ D{cells}; 
			computeT: ℝ t = reduceMin{c∈cells()}(X_EDGE_LENGTH*Y_EDGE_LENGTH/D{c}) * 0.24;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}	
	
	@Test
	def void testCheckVarRefType() 
	{
		Assert.fail("Not yet Correctly Implemented")

		val moduleKo = parseHelper.parse(TestUtils::testModule
		)
		Assert.assertNotNull(moduleKo)
		
		moduleKo.assertError(NablaPackage.eINSTANCE.varRef, 
			TypeValidator::VAR_REF_TYPE, 
			TypeValidator::getVarRefTypeMsg())		

		val moduleOk = parseHelper.parse(TestUtils::testModule
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}	

	@Test
	def void testCheckContractedIfType() 
	{
		val moduleKo = parseHelper.parse(TestUtils::testModule
			+
			'''
			ℝ cond;
			ℝ U;
			ℕ V;
			ℝ W = (cond ? U : V);
			'''
		)
		Assert.assertNotNull(moduleKo)
		val cond = moduleKo.getVariableByName("cond")
		val u = moduleKo.getVariableByName("U")
		val v = moduleKo.getVariableByName("V")
				
		moduleKo.assertError(NablaPackage.eINSTANCE.contractedIf, 
			TypeValidator::CONTRACTED_IF_CONDITION_TYPE, 
			TypeValidator::getContractedIfConditionTypeMsg(cond.typeFor.label))		

		moduleKo.assertError(NablaPackage.eINSTANCE.contractedIf, 
			TypeValidator::CONTRACTED_IF_ELSE_TYPE, 
			TypeValidator::getContractedIfElseTypeMsg(v.typeFor.label, u.typeFor.label))		

		val moduleOk = parseHelper.parse(TestUtils::testModule
			+
			'''
			ℾ cond;
			ℝ U;
			ℝ V;
			ℝ W = (cond ? U : V);
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}		

	@Test
	def void testCheckNotExpressionType() 
	{
		val moduleKo = parseHelper.parse(TestUtils::testModule
			+
			'''
			ℝ cond;
			ℾ ok = !cond; 
			'''
		)
		Assert.assertNotNull(moduleKo)
		val cond = moduleKo.getVariableByName("cond")
				
		moduleKo.assertError(NablaPackage.eINSTANCE.not, 
			TypeValidator::NOT_EXPRESSION_TYPE, 
			TypeValidator::getNotExpressionTypeMsg(cond.typeFor.label))		

		val moduleOk = parseHelper.parse(TestUtils::testModule
			+
			'''
			ℾ cond;
			ℾ ok = !cond; 
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}		
	
	@Test
	def void testCheckMulOrDivType() 
	{
		val moduleKo = parseHelper.parse(TestUtils::testModule
			+
			'''
			ℾ a; 
			ℝ b;
			ℝ c = a * b;
			'''
		)
		Assert.assertNotNull(moduleKo)
				
		moduleKo.assertError(NablaPackage.eINSTANCE.mulOrDiv, 
			TypeValidator::MUL_OR_DIV_TYPE, 
			TypeValidator::getMulOrDivTypeMsg("*", 
				PrimitiveType::BOOL.literal, 
				PrimitiveType::REAL.literal
			))		

		val moduleOk = parseHelper.parse(TestUtils::testModule
			+
			'''
			ℝ a; 
			ℝ b;
			ℝ c = a * b;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}			

	@Test
	def void testCheckPlusType() 
	{
		val moduleKo = parseHelper.parse(TestUtils::testModule			+
			'''		
			ℾ a; 
			ℕ b;
			ℝ c = a + b;
			'''
		
		)
		Assert.assertNotNull(moduleKo)
				
		moduleKo.assertError(NablaPackage.eINSTANCE.plus, 
			TypeValidator::PLUS_TYPE, 
			TypeValidator::getPlusTypeMsg("+", 
				PrimitiveType::BOOL.literal, 
				PrimitiveType::INT.literal
			))		

		val moduleOk = parseHelper.parse(TestUtils::testModule
			+
			'''
			ℝ a; 
			ℕ b;
			ℝ c = a + b;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}			
	
	@Test
	def void testCheckMinusType() 
	{
		val moduleKo = parseHelper.parse(TestUtils::testModule
			+
			'''
			ℝ[2] a; 
			ℝ[3] b;
			ℝ[2] c = a - b;
			'''
		)
		Assert.assertNotNull(moduleKo)
				
		moduleKo.assertError(NablaPackage.eINSTANCE.minus, 
			TypeValidator::MINUS_TYPE, 
			TypeValidator::getMinusTypeMsg("-", 
				new RealArrayType(#[],#[2]).label, 
				new RealArrayType(#[],#[3]).label
			))		

		val moduleOk = parseHelper.parse(TestUtils::testModule
			+
			'''
			ℝ[2] a; 
			ℝ[2] b;
			ℝ[2] c = a - b;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}			
	
	@Test
	def void testCheckComparisonType() 
	{
		val moduleKo = parseHelper.parse(TestUtils::testModule
			+
			'''
			ℝ a; 
			ℝ[2] b;
			ℾ c = a > b;
			'''
		)
		Assert.assertNotNull(moduleKo)
				
		moduleKo.assertError(NablaPackage.eINSTANCE.comparison, 
			TypeValidator::COMPARISON_TYPE, 
			TypeValidator::getComparisonTypeMsg(">", 
				PrimitiveType::REAL.literal, 
				new RealArrayType(#[],#[2]).label
			))		

		val moduleOk = parseHelper.parse(TestUtils::testModule
			+
			'''
			ℝ a; 
			ℝ b;
			ℾ c = a > b;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}			
}
