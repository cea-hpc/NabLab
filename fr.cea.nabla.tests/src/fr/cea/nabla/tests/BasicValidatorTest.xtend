package fr.cea.nabla.tests

import com.google.inject.Inject
import fr.cea.nabla.NablaModuleExtensions
import fr.cea.nabla.ir.MandatoryOptions
import fr.cea.nabla.ir.MandatoryVariables
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NablaPackage
import fr.cea.nabla.validation.BasicValidator
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(NablaInjectorProvider))
class BasicValidatorTest 
{
	@Inject ParseHelper<NablaModule> parseHelper
	@Inject extension ValidationTestHelper
	@Inject extension NablaModuleExtensions

	// ===== NablaModule =====	

	@Test
	def void testCheckMandatoryVariables()
	{
		val moduleKo = parseHelper.parse(TestUtils::emptyTestModule + TestUtils::mandatoryOptions)
		Assert.assertNotNull(moduleKo)
		
		moduleKo.assertError(NablaPackage.eINSTANCE.nablaModule,
			BasicValidator::MANDATORY_VARIABLE,
			BasicValidator::getMandatoryVariablesMsg(MandatoryVariables::NAMES))

		val moduleOk = parseHelper.parse(TestUtils::emptyTestModule + TestUtils::connectivities + TestUtils::mandatoryOptions + TestUtils::mandatoryVariables)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckMandatoryOptions()
	{
		val moduleKo = parseHelper.parse(TestUtils::emptyTestModule + TestUtils::mandatoryVariables)
		Assert.assertNotNull(moduleKo)
		
		moduleKo.assertError(NablaPackage.eINSTANCE.nablaModule,
			BasicValidator::MANDATORY_OPTION,
			BasicValidator::getMandatoryOptionsMsg(MandatoryOptions::NAMES))

		val moduleOk = parseHelper.parse(TestUtils::emptyTestModule + TestUtils::getConnectivities + TestUtils::mandatoryOptions +  TestUtils::mandatoryVariables)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckName() 
	{
		val moduleKo = parseHelper.parse(''' module test''')
		Assert.assertNotNull(moduleKo)
		
		moduleKo.assertError(NablaPackage.eINSTANCE.nablaModule, 
			BasicValidator::MODULE_NAME, 
			BasicValidator::getModuleNameMsg())		

		val moduleOk = parseHelper.parse(TestUtils::testModule)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	// ===== BaseType =====	

	@Test
	def void testCheckArraySize() 
	{
		val moduleKo = parseHelper.parse(TestUtils::testModule
			+
			'''
			ℝ[1] a;
			ℕ[1,3] b;
			ℕ[2,1] c;
			'''
		)
		Assert.assertNotNull(moduleKo)
		
		moduleKo.assertError(NablaPackage.eINSTANCE.array1D, 
			BasicValidator::ARRAY_SIZE, 
			BasicValidator::getArraySizeMsg())

		moduleKo.assertError(NablaPackage.eINSTANCE.array2D, 
			BasicValidator::ARRAY_SIZE, 
			BasicValidator::getArraySizeMsg())

		val moduleOk = parseHelper.parse(TestUtils::testModule
			+
			'''
			ℝ[2] a;
			ℕ[3,3] b;
			ℕ[2,3] c;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors		
	}
		
	// ===== Variables : Var & VarRef =====	
	
	@Test
	def void testCheckUnusedVariable() 
	{
		val moduleKo = parseHelper.parse(
			TestUtils::getTestModuleWithCoordVariableWithCustomVars(
			'''
			ℝ a;
			''')
		)
		Assert.assertNotNull(moduleKo)
		
		moduleKo.assertWarning(NablaPackage.eINSTANCE.^var, 
			BasicValidator::UNUSED_VARIABLE, 
			BasicValidator::getUnusedVariableMsg())		

		val moduleOk = parseHelper.parse(
			TestUtils::getTestModuleWithCoordVariableWithCustomVars(
			'''
			ℝ a;
			ComputeA: a = 1.;
			''')
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoIssues
	}

	@Test
	def void testCheckIndicesNumber() 
	{		
		val moduleKo = parseHelper.parse(TestUtils::testModule
			+
			'''
			ℕ[2,2] a;
			ℕ b = a[0];
			ℕ[2] c;
			ℕ d = c[0,1];
			'''
		)
		Assert.assertNotNull(moduleKo)
		
		moduleKo.assertError(NablaPackage.eINSTANCE.argOrVarRef, 
			BasicValidator::INDICES_NUMBER, 
			BasicValidator::getIndicesNumberMsg(2,1))		

		moduleKo.assertError(NablaPackage.eINSTANCE.argOrVarRef, 
			BasicValidator::INDICES_NUMBER, 
			BasicValidator::getIndicesNumberMsg(1,2))		

		val moduleOk =  parseHelper.parse(TestUtils::testModule
			+
			'''
			ℕ[2,2] a;
			ℕ b = a[0,0];
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}
	
	@Test
	def void testCheckIteratorNumberAndType() 
	{		
		val moduleKo = parseHelper.parse(TestUtils::testModule
			+
			'''
			ℝ u{cells}, v{cells, nodesOfCell}, w{nodes};
			ComputeU: ∀ j∈cells(), ∀r∈nodesOfCell(j), u{j,r} = 1.;
			ComputeV: ∀ j∈cells(), ∀r∈nodesOfCell(j), v{j} = 1.;
			ComputeW: ∀ j∈cells(), w{j} = 1.;
			'''
		)
		Assert.assertNotNull(moduleKo)
		
		moduleKo.assertError(NablaPackage.eINSTANCE.argOrVarRef, 
			BasicValidator::ITERATOR_NUMBER, 
			BasicValidator::getIteratorNumberMsg(1,2))		

		moduleKo.assertError(NablaPackage.eINSTANCE.argOrVarRef, 
			BasicValidator::ITERATOR_NUMBER, 
			BasicValidator::getIteratorNumberMsg(2,1))		

		val node = moduleKo.getItemTypeByName("node").name
		val cell = moduleKo.getItemTypeByName("cell").name
		
		moduleKo.assertError(NablaPackage.eINSTANCE.argOrVarRef, 
			BasicValidator::ITERATOR_TYPE, 
			BasicValidator::getIteratorTypeMsg(node, cell))		

		val moduleOk =  parseHelper.parse(TestUtils::testModule
			+
			'''
			ℝ u{cells}, v{cells, nodesOfCell}, w{nodes};
			ComputeU: ∀ j∈cells(), ∀r∈nodesOfCell(j), u{j} = 1.;
			ComputeV: ∀ j∈cells(), ∀r∈nodesOfCell(j), v{j,r} = 1.;
			ComputeW: ∀ j∈nodes(), w{j} = 1.;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}
		
	// ===== Functions (Reductions, Dimension) =====	
	
	@Test
	def void testCheckUnusedFunction() 
	{
		val modelKo = TestUtils::getTestModuleWithCoordVariableWithCustomFunctions('''def	f:	x | ℝ[x] → ℝ''')
		val moduleKo = parseHelper.parse(modelKo)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertWarning(NablaPackage.eINSTANCE.function, 
			BasicValidator::UNUSED_FUNCTION, 
			BasicValidator::getUnusedFunctionMsg())

		val modelOk = TestUtils::getTestModuleWithCoordVariableWithCustomFunctions(
			'''
			def	f:	x | ℝ[x] → ℝ;
			''')
			+
			'''
			ℝ[2] orig = [0.0 , 0.0] ;
			ComputeT: 
			{ 
				ℝ t = f(orig);
				t = t + 1;	
			}
			'''		
		val moduleOk = parseHelper.parse(modelOk)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoIssues
	}

	@Test
	def void testCheckUnusedReduction() 
	{
		val moduleKo = parseHelper.parse(
			TestUtils::getTestModuleWithCoordVariableWithCustomFunctions(
			'''
			def reduceMin: (ℝ.MaxValue, ℝ[2]) → ℝ[2];
			''')
			+
			'''
			ℝ[2] orig = [0.0 , 0.0] ;
			'''
		)
		Assert.assertNotNull(moduleKo)
			
		moduleKo.assertWarning(NablaPackage.eINSTANCE.reduction, 
			BasicValidator::UNUSED_REDUCTION, 
			BasicValidator::getUnusedReductionMsg())		
									
		val moduleOk = parseHelper.parse(
			TestUtils::getTestModuleWithCoordVariableWithCustomFunctions(
			'''
			def	reduceMin: (ℝ.MaxValue, ℝ[2]) → ℝ[2];
			''')
			+
			'''
			ℝ[2] orig = [0.0 , 0.0] ;
			ComputeU: orig = reduceMin{r∈nodes()}(X{r});
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoIssues
	}

	@Test
	def testCheckFunctionInTypes() 
	{
		val modulekO = parseHelper.parse(
			TestUtils::getTestModuleWithCustomFunctions(
				'''
				def	f: x | ℝ[x+1] → ℝ[x];
				def	g: ℝ[2] → ℝ;
				def g: x | ℝ[x] → ℝ;
				'''
			)
		)
		Assert.assertNotNull(modulekO)
		
		modulekO.assertError(NablaPackage.eINSTANCE.function, 
			BasicValidator::FUNCTION_IN_TYPES_OPERATION, 
			BasicValidator::getFunctionInTypesOperationMsg())

		modulekO.assertError(NablaPackage.eINSTANCE.function, 
			BasicValidator::FUNCTION_INCOMPATIBLE_IN_TYPES, 
			BasicValidator::getFunctionIncompatibleInTypesMsg())

		val moduleOk = parseHelper.parse(
			TestUtils::getTestModuleWithCustomFunctions(
				'''
				def	f: x | ℝ[x] → ℝ[x+1];
				def	g: ℝ → ℝ;
				def g: x | ℝ[x] → ℝ;
				'''
			)
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def testCheckFunctionReturnType() 
	{
		val modulekO = parseHelper.parse(
			TestUtils::getTestModuleWithCustomFunctions(
				'''
				def	f: x | ℝ → ℝ[x];
				'''
			)
		)
		Assert.assertNotNull(modulekO)
		
		modulekO.assertError(NablaPackage.eINSTANCE.function, 
			BasicValidator::FUNCTION_RETURN_TYPE, 
			BasicValidator::getFunctionReturnTypeMsg("x"))

		val moduleOk = parseHelper.parse(
			TestUtils::getTestModuleWithCustomFunctions(
				'''
				def	f: x | ℝ[x] → ℝ[x];
				def	g: y | ℝ[y] → ℝ[x, y];
				'''
			)
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors(NablaPackage.eINSTANCE.function, 
			BasicValidator::FUNCTION_RETURN_TYPE)
	}
	
	@Test
	def testCheckReductionCollectionType() 
	{
		val modulekO = parseHelper.parse(
			TestUtils::getTestModuleWithCustomFunctions(
				'''
				def	reduce1: x,y | (ℝ.MaxValue , ℝ[x+y]) → ℝ[x+y];
				def	reduce2: (ℝ.MaxValue, ℝ[2]) → ℝ;
				def reduce2: x | (ℝ.MaxValue , ℝ[x]) → ℝ;
				'''
			)
		)
		Assert.assertNotNull(modulekO)
		
		modulekO.assertError(NablaPackage.eINSTANCE.reduction, 
			BasicValidator::REDUCTION_COLLECTION_TYPE_OPERATION, 
			BasicValidator::getReductionCollectionTypeOperationMsg)

		modulekO.assertError(NablaPackage.eINSTANCE.reduction, 
			BasicValidator::REDUCTION_INCOMPATIBLE_COLLECTION_TYPE, 
			BasicValidator::getReductionIncompatibleCollectionTypeMsg)

		val moduleOk = parseHelper.parse(
			TestUtils::getTestModuleWithCustomFunctions(
				'''
				def	reduce1: x | (ℝ.MaxValue , ℝ[x]) → ℝ[x];
				def	reduce2: (ℝ.MaxValue, ℝ) → ℝ;
				def reduce2: x | (ℝ.MaxValue , ℝ[x]) → ℝ;
				'''
			)
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def testCheckReductionReturnType() 
	{
		val modulekO = parseHelper.parse(
			TestUtils::getTestModuleWithCustomFunctions(
				'''
				def	reduce: x,y | (ℝ.MaxValue , ℝ[x]) → ℝ[y];
				'''
			)
		)
		Assert.assertNotNull(modulekO)
		
		modulekO.assertError(NablaPackage.eINSTANCE.reduction, 
			BasicValidator::REDUCTION_RETURN_TYPE, 
			BasicValidator::getReductionReturnTypeMsg("y"))

		val modulekO2 = parseHelper.parse(
			TestUtils::getTestModuleWithCustomFunctions(
				'''
				def	reduce: x,y | (ℝ.MaxValue , ℝ[x]) → ℝ[x+y];
				'''
			)
		)
		Assert.assertNotNull(modulekO2)
		
		modulekO2.assertError(NablaPackage.eINSTANCE.reduction, 
			BasicValidator::REDUCTION_RETURN_TYPE, 
			BasicValidator::getReductionReturnTypeMsg("y"))

		val moduleOk = parseHelper.parse(
			TestUtils::getTestModuleWithCustomFunctions(
				'''
				def	reduce: x | (ℝ.MaxValue , ℝ[x]) → ℝ[x];
				'''
			)
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}
	
	@Test
	def testCheckDimensionVarName() 
	{
		val modulekO = parseHelper.parse(
			TestUtils::getTestModuleWithCustomFunctions(
			'''
			def f:	n | ℝ[n] → ℝ;
			def g:	x | ℝ[x] → ℝ;
			''')
		)
		Assert.assertNotNull(modulekO)
		
		modulekO.assertError(NablaPackage.eINSTANCE.dimensionVar, 
			BasicValidator::DIMENSION_VAR_NAME, 
			BasicValidator::getDimensionVarNameMsg())

		val moduleOk = parseHelper.parse(
			TestUtils::getTestModuleWithCustomFunctions(
			'''
			def	f:	x | ℝ[x] → ℝ;
			''')
		)
		println(TestUtils::getTestModuleWithCustomFunctions(
			'''
			def	f:	x | ℝ[x] → ℝ;
			'''))
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}
	
	@Test
	def void testCheckUnusedDimensionVar() 
	{
		val moduleKo = parseHelper.parse(
			TestUtils::getTestModuleWithCoordVariableWithCustomFunctions(
			'''
			def f: x,y | ℝ[x] → ℝ[2];
			'''
			+
			'''
			ℝ[2] orig = [0.0 , 0.0] ;
			'''
			)
		)
		Assert.assertNotNull(moduleKo)
			
		moduleKo.assertWarning(NablaPackage.eINSTANCE.dimensionVar, 
			BasicValidator::UNUSED_DIMENSION_VAR, 
			BasicValidator::getUnusedDimensionVar())		
									
		val moduleOk = parseHelper.parse(
			TestUtils::getTestModuleWithCoordVariableWithCustomFunctions(
			'''
			def	f: x | ℝ[x] → ℝ[2];
			''')
			+
			'''
			ℝ[2] orig = [0.0 , 0.0];
			ComputeOrig: orig = f(orig);
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoIssues
	}
	
	// ===== Connectivities =====	
	
	@Test
	def void testCheckUnusedConnectivity() 
	{
		val moduleKo = parseHelper.parse(
			TestUtils::getTestModuleWithCoordVariableWithCustomConnectivities(
			'''
			items { node }
			set	nodes: → {node};
			set	borderNodes: → {node};
			''')
		)
		Assert.assertNotNull(moduleKo)
		
		moduleKo.assertWarning(NablaPackage.eINSTANCE.connectivity, 
			BasicValidator::UNUSED_CONNECTIVITY, 
			BasicValidator::getUnusedConnectivityMsg())		

		val moduleOk = parseHelper.parse(
			TestUtils::getTestModuleWithCoordVariableWithCustomConnectivities(
			'''
			items { node }
			set	nodes: → {node};
			set	borderNodes: → {node};
			''')
			+
			'''
			IniXborder: ∀r∈borderNodes(), X{r} = X{r} - 1;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoIssues
	}
	
	@Test
	def void testCheckConnectivityCallIndexAndType() 
	{		
		val moduleKo = parseHelper.parse(TestUtils::getTestModuleWithCoordVariableWithCustomConnectivities(TestUtils::connectivities)
			+
			'''
			ℝ[2] orig = [0.0 , 0.0] ;
			IniX1: ∀j∈cells(), ∀r∈nodes(j), X{r} = orig; 
			IniX2: ∀r∈nodes(), ∀j∈nodesOfCell(r), X{r} = orig; 
			'''
		)
		Assert.assertNotNull(moduleKo)
		
		moduleKo.assertError(NablaPackage.eINSTANCE.connectivityCall, 
			BasicValidator::CONNECTIVITY_CALL_INDEX, 
			BasicValidator::getConnectivityCallIndexMsg(0,1))		

		val node = moduleKo.getItemTypeByName("node").name
		val cell = moduleKo.getItemTypeByName("cell").name

		moduleKo.assertError(NablaPackage.eINSTANCE.connectivityCall, 
			BasicValidator::CONNECTIVITY_CALL_TYPE, 
			BasicValidator::getConnectivityCallTypeMsg(cell,node))		

		val moduleOk =  parseHelper.parse(TestUtils::getTestModuleWithCoordVariableWithCustomConnectivities(TestUtils::connectivities)
			+
			'''
			ℝ[2] orig = [0.0 , 0.0] ;
			IniX1: ∀j∈cells(), ∀r∈nodes(), X{r} = orig; 
			IniX2: ∀j∈cells(), ∀r∈nodesOfCell(j), X{r} = orig; 
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}
	
	@Test
	def void testCheckNotInInstructions() 
	{		
		val moduleKo = parseHelper.parse(TestUtils::testModuleWithCoordVariable
			+
			'''
			UpdateX: 
			{
				ℝ[2] a{nodes};
				∀r∈nodes(), X{r} = a{r};
			}
			'''
		)
		Assert.assertNotNull(moduleKo)
		
		moduleKo.assertError(NablaPackage.eINSTANCE.connectivityVar, 
			BasicValidator::NOT_IN_INSTRUCTIONS, 
			BasicValidator::getNotInInstructionsMsg)		

		val moduleOk =  parseHelper.parse(TestUtils::testModuleWithCoordVariable
			+
			'''
			UpdateX: 
			{
				ℝ[2] a;
				∀r∈nodes(), X{r} = a;
			}
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}
	
	@Test
	def void testCheckDimensionMultipleAndArg() 
	{		
		val moduleKo = parseHelper.parse(
			TestUtils::getTestModuleWithCustomConnectivities(
				'''
				items { node, cell }
				set	nodes: → {node};
				set	cells: → {cell};
				set	prevNode: node → node;
				set	neigboursCells: cell → {cell};
				''')
				+
				'''
				ℝ[2] U{prevNode};
				ℝ[2] V{neigboursCells};
				'''
		)
		Assert.assertNotNull(moduleKo)
		
		moduleKo.assertError(NablaPackage.eINSTANCE.connectivityVar, 
			BasicValidator::DIMENSION_MULTIPLE, 
			BasicValidator::getDimensionMultipleMsg)		

		moduleKo.assertError(NablaPackage.eINSTANCE.connectivityVar, 
			BasicValidator::DIMENSION_ARG, 
			BasicValidator::getDimensionArgMsg)		

		val moduleOk =  parseHelper.parse(
			TestUtils::getTestModuleWithCustomConnectivities(
				'''
				items { node, cell }
				set	nodes: → {node};
				set	cells: → {cell};
				set	prevNode: node → node;
				set	neigboursCells: cell → {cell};
				''')
				+
				'''
				ℝ[2] U{nodes};
				ℝ[2] V{cells, neigboursCells};
				'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}
	
	// ===== Instructions =====

	@Test
	def void testCheckAffectationVar() 
	{		
		val moduleKo = parseHelper.parse(TestUtils::testModule
			+
			'''
			computeX : X_EDGE_LENGTH = Y_EDGE_LENGTH;
			'''
		)
		Assert.assertNotNull(moduleKo)
		
		moduleKo.assertError(NablaPackage.eINSTANCE.affectation, 
			BasicValidator::AFFECTATION_CONST, 
			BasicValidator::getAffectationConstMsg)		

		val moduleKo2 = parseHelper.parse(TestUtils::testModule
			+
			'''
			initXXX: { const ℝ xxx=0.0; xxx = 0.01; }
			'''
		)
		Assert.assertNotNull(moduleKo2)
		
		moduleKo2.assertError(NablaPackage.eINSTANCE.affectation, 
			BasicValidator::AFFECTATION_CONST, 
			BasicValidator::getAffectationConstMsg)		

		val moduleOk =  parseHelper.parse(TestUtils::testModule
			+
			'''
			computeX : ℝ X = Y_EDGE_LENGTH;
			initYYY: { const ℝ xxx=0.0; ℝ yyy = xxx; }
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}
	
	@Test
	def void testCheckScalarVarDefaultValue() 
	{		
		val moduleKo = parseHelper.parse(TestUtils::testModule
			+
			'''
			ℕ coef = 2;
			const ℝ DOUBLE_LENGTH = X_EDGE_LENGTH * coef;
			'''
		)
		Assert.assertNotNull(moduleKo)
		
		moduleKo.assertError(NablaPackage.eINSTANCE.simpleVarDefinition, 
			BasicValidator::SCALAR_VAR_DEFAULT_VALUE, 
			BasicValidator::getScalarVarDefaultValueMsg)		

		val moduleOk =  parseHelper.parse(TestUtils::testModule
			+
			'''
			constℕ coef = 2;
			const ℝ DOUBLE_LENGTH = X_EDGE_LENGTH * coef;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}
	
	// ===== Iterators =====
	
	
		@Test
	def void testCheckUnusedIterator() 
	{
		val moduleKo = parseHelper.parse(TestUtils::getTestModuleWithCoordVariable
			+
			'''
			UpdateX: ∀r1∈nodes(), ∀r2∈nodes(), X{r1} = X{r1} + 1;
			'''
		)
		Assert.assertNotNull(moduleKo)
		
		moduleKo.assertWarning(NablaPackage.eINSTANCE.spaceIterator, 
			BasicValidator::UNUSED_ITERATOR, 
			BasicValidator::getUnusedIteratorMsg())		

		val moduleOk = parseHelper.parse(TestUtils::getTestModuleWithCoordVariable
			+
			'''
			UpdateX: ∀r1∈nodes(), X{r1} = X{r1} + 1;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoIssues
	}
	
	@Test
	def void testCheckRangeReturnType() 
	{		
		val moduleKo = parseHelper.parse(TestUtils::getTestModuleWithCoordVariableWithCustomConnectivities(
			'''
			items { node }
			set	nodes: → {node};
			set	leftNode: node → node;
			''')
			+
			'''
			UpdateX: ∀r1∈nodes(), ∀r2∈leftNode(r1), X{r2} = X{r1} - 1;
			'''
		)
		Assert.assertNotNull(moduleKo)
		
		moduleKo.assertError(NablaPackage.eINSTANCE.rangeSpaceIterator, 
			BasicValidator::RANGE_RETURN_TYPE, 
			BasicValidator::getRangeReturnTypeMsg)		

		val moduleOk =  parseHelper.parse(TestUtils::getTestModuleWithCoordVariableWithCustomConnectivities(
			'''
			items { node }
			set	nodes: → {node};
			set	leftNodes: node → {node};
			''')
			+
			'''
			UpdateX: ∀r1∈nodes(), ∀r2∈leftNodes(r1), X{r2} = X{r1} - 1;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckSingletonReturnType() 
	{		
		val moduleKo = parseHelper.parse(TestUtils::getTestModuleWithCoordVariableWithCustomConnectivities(
			'''
			items { node }
			set	nodes: → {node};
			set	leftNode: node → {node};
			''')
			+
			'''
			UpdateX: ∀r1∈nodes(), r2 = leftNode(r1), X{r2} = X{r1} - 1;
			'''
		)
		Assert.assertNotNull(moduleKo)
		
		moduleKo.assertError(NablaPackage.eINSTANCE.singletonSpaceIterator, 
			BasicValidator::SINGLETON_RETURN_TYPE, 
			BasicValidator::getSingletonReturnTypeMsg)		

		val moduleOk =  parseHelper.parse(TestUtils::getTestModuleWithCoordVariableWithCustomConnectivities(
			'''
			items { node }
			set	nodes: → {node};
			set	leftNode: node → node;
			''')
			+
			'''
			UpdateX: ∀r1∈nodes(), r2 = leftNode(r1), X{r2} = X{r1} - 1;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}
	
	@Test
	def void testCheckIncAndDecValidity() 
	{		
		val moduleKo = parseHelper.parse(TestUtils::getTestModuleWithCoordVariableWithCustomConnectivities(
			'''
			items { node }
			set	nodes: → {node};
			set	leftNode: node → node;
			''')
			+
			'''
			UpdateX: ∀r1∈nodes(), r2 = leftNode(r1), X{r2} = X{r2-1} - 1;
			'''
		)
		Assert.assertNotNull(moduleKo)
		
		moduleKo.assertError(NablaPackage.eINSTANCE.spaceIteratorRef, 
			BasicValidator::SHIFT_VALIDITY, 
			BasicValidator::getShiftValidityMsg)		

		val moduleOk =  parseHelper.parse(TestUtils::getTestModuleWithCoordVariableWithCustomConnectivities(
			'''
			items { node }
			set	nodes: → {node};
			set	leftNode: node → node;
			''')
			+
			'''
			UpdateX: ∀r1∈nodes(), r2 = leftNode(r1), X{r2} = X{r1-1} - 1;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}
}
