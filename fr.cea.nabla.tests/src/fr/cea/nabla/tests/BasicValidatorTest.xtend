package fr.cea.nabla.tests

import com.google.inject.Inject
import fr.cea.nabla.MandatoryOptions
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
import fr.cea.nabla.NablaModuleExtensions

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(NablaInjectorProvider))
class BasicValidatorTest 
{
	@Inject ParseHelper<NablaModule> parseHelper
	@Inject extension ValidationTestHelper
	@Inject extension NablaModuleExtensions

	private def String getEmptyTestModule()
	{
		'''
			module Test;
		'''
	}

	private def String getMandatoryOptions()
	{
		'''
		// Options obligatoires pour générer
		const ℝ X_EDGE_LENGTH = 0.01;
		const ℝ Y_EDGE_LENGTH = X_EDGE_LENGTH;
		const ℕ X_EDGE_ELEMS = 100;
		const ℕ Y_EDGE_ELEMS = 10;
		const ℕ Z_EDGE_ELEMS = 1;
		const ℝ option_stoptime = 0.2;
		const ℕ option_max_iterations = 20000;
		'''
	}
	
	private def String getConnectivities()
	{
		'''
		items { node, cell }
		
		connectivities {
			nodes: → {node};
			cells: → {cell};
			nodesOfCell: cell → {node};
		}
		'''
	}

	private def String getNodesConnectivity()
	{
		'''
		items { node }
		
		connectivities 
		{
			nodes: → {node};
		}
		'''
	}

	private def String getCoordVariable()
	{
		'''
		ℝ[2] X{nodes};
		ℝ[2] orig = [0.0 , 0.0] ;
		'''
	}
	
	private def String getIniX()
	{
		'''
		IniX: ∀r∈nodes(), X{r} = orig;
		'''
	}
	
	private def CharSequence getTestModule()
	{
		emptyTestModule + connectivities + mandatoryOptions
		//new SerializedModule(connectivities, null, mandatoryOptions, null)
	}
	
	private def getTestModuleWithCustomFunctions(CharSequence functions)
	{
		emptyTestModule + functions + mandatoryOptions
		//new SerializedModule(null, null, mandatoryOptions, null).addFunction()
	}

	private def getTestModuleWithCustomConnectivities(CharSequence connectivities)
	{
		emptyTestModule + connectivities + mandatoryOptions
		//new SerializedModule(null, null, mandatoryOptions, null).addFunction()
	}

	private def getTestModuleWithCoordVariable()
	{
		emptyTestModule + nodesConnectivity + coordVariable + mandatoryOptions + iniX
	}	

	private def getTestModuleWithCoordVariableWithCustomVars(CharSequence variables)
	{
		emptyTestModule + nodesConnectivity + coordVariable + mandatoryOptions + variables + iniX
	}

	private def getTestModuleWithCoordVariableWithCustomFunctions(CharSequence functions)
	{
		emptyTestModule + nodesConnectivity + functions + coordVariable + mandatoryOptions + iniX
	}

	private def getTestModuleWithCoordVariableWithCustomConnectivities(CharSequence connectivities)
	{
		emptyTestModule + connectivities + coordVariable + mandatoryOptions + iniX
	}

	// ===== NablaModule =====	
	
	@Test
	def void testCheckCoordVariable() 
	{
		val moduleKo = parseHelper.parse(testModule)
		Assert.assertNotNull(moduleKo)
		
		moduleKo.assertWarning(NablaPackage.eINSTANCE.nablaModule, 
			BasicValidator::COORD_VARIABLE, 
			BasicValidator::getCoordVariableMsg())		

		val moduleOk = parseHelper.parse(testModuleWithCoordVariable)
		// We have to put IniX job, to avoid Unused variable warning
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoIssues
	}

	@Test
	def void testCheckMandatoryOptions() 
	{
		val moduleKo = parseHelper.parse(emptyTestModule)
		Assert.assertNotNull(moduleKo)
		
		moduleKo.assertError(NablaPackage.eINSTANCE.nablaModule, 
			BasicValidator::MANDATORY_OPTION, 
			BasicValidator::getMandatoryOption(MandatoryOptions::OPTION_NAMES))		

		val moduleOk = parseHelper.parse(testModule)
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

		val moduleOk = parseHelper.parse(testModule)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors		
	}

	// ===== BaseType =====	

	@Test
	def void testCheckTypeDimension() 
	{
		val moduleKo = parseHelper.parse(testModule
			+
			'''
			ℝ[1] d;
			'''
		)
		Assert.assertNotNull(moduleKo)
		
		moduleKo.assertError(NablaPackage.eINSTANCE.baseType, 
			BasicValidator::TYPE_DIMENSION, 
			BasicValidator::getTypeDimensionMsg())		

		val moduleOk = parseHelper.parse(testModule
			+
			'''
			ℝ[2] d;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors		
	}
	
	// ===== Constant expressions =====	
	
	//TODO : CheckOnlyRealArrayConst ?
//	def void testCheckOnlyRealArrayConst() 
//	{	
//		val moduleKo = parseHelper.parse(testModule
//			+
//			'''
//			ℝ c = ℝ(0)
//			'''
//		)
//		Assert.assertNotNull(moduleKo)
//		
//		moduleKo.assertError(NablaPackage.eINSTANCE.baseTypeConstant, 
//			BasicValidator::ONLY_REAL_ARRAY_CONST, 
//			BasicValidator::getOnlyRealArrayConstMsg())		
//
//
//		val moduleOk = parseHelper.parse(testModule
//			+
//			'''
//			ℝ[2] c = ℝ[2](0);
//			'''
//		)
//		Assert.assertNotNull(moduleOk)
//		moduleOk.assertNoErrors		
//	}
	
	// ===== Variables : Var & VarRef =====	
	
	@Test
	def void testCheckUnusedVariable() 
	{
		val moduleKo = parseHelper.parse(
			getTestModuleWithCoordVariableWithCustomVars(
			'''
			ℝ a;
			''')
		)
		Assert.assertNotNull(moduleKo)
		
		moduleKo.assertWarning(NablaPackage.eINSTANCE.^var, 
			BasicValidator::UNUSED_VARIABLE, 
			BasicValidator::getUnusedVariableMsg())		

		val moduleOk = parseHelper.parse(
			getTestModuleWithCoordVariableWithCustomVars(
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
		val moduleKo = parseHelper.parse(testModule
			+
			'''
			ℕ[2,2] a;
			ℕ b = a[0];
			ℕ[2] c;
			ℕ d = c[0,1];
			'''
		)
		Assert.assertNotNull(moduleKo)
		
		moduleKo.assertError(NablaPackage.eINSTANCE.varRef, 
			BasicValidator::INDICES_NUMBER, 
			BasicValidator::getIndicesNumberMsg(2,1))		

		moduleKo.assertError(NablaPackage.eINSTANCE.varRef, 
			BasicValidator::INDICES_NUMBER, 
			BasicValidator::getIndicesNumberMsg(1,2))		

		val moduleOk =  parseHelper.parse(testModule
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
		val moduleKo = parseHelper.parse(testModule
			+
			'''
			ℝ u{cells}, v{cells, nodesOfCell}, w{nodes};
			ComputeU: ∀ j∈cells(), ∀r∈nodesOfCell(j), u{j,r} = 1.;
			ComputeV: ∀ j∈cells(), ∀r∈nodesOfCell(j), v{j} = 1.;
			ComputeW: ∀ j∈cells(), w{j} = 1.;
			'''
		)
		Assert.assertNotNull(moduleKo)
		
		moduleKo.assertError(NablaPackage.eINSTANCE.varRef, 
			BasicValidator::ITERATOR_NUMBER, 
			BasicValidator::getIteratorNumberMsg(1,2))		

		moduleKo.assertError(NablaPackage.eINSTANCE.varRef, 
			BasicValidator::ITERATOR_NUMBER, 
			BasicValidator::getIteratorNumberMsg(2,1))		

		val node = moduleKo.getItemTypeByName("node").name
		val cell = moduleKo.getItemTypeByName("cell").name
		
		moduleKo.assertError(NablaPackage.eINSTANCE.varRef, 
			BasicValidator::ITERATOR_TYPE, 
			BasicValidator::getIteratorTypeMsg(node, cell))		

		val moduleOk =  parseHelper.parse(testModule
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
		val moduleKo = parseHelper.parse(
			getTestModuleWithCoordVariableWithCustomFunctions(
			'''
			functions 
			{
				f:	x | ℝ[x] → ℝ;
			}
			''')
		)
		Assert.assertNotNull(moduleKo)
			
		moduleKo.assertWarning(NablaPackage.eINSTANCE.function, 
			BasicValidator::UNUSED_FUNCTION, 
			BasicValidator::getUnusedFunctionMsg())		
					
		val moduleOk = parseHelper.parse(
			getTestModuleWithCoordVariableWithCustomFunctions(
			'''
			functions 
			{
				f:	x | ℝ[x] → ℝ;
			}
			''')
			+
			'''
			ComputeT: 
			{ 
				ℝ t = f(orig);
				t = t + 1;	
			}
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoIssues
	}

	@Test
	def void testCheckUnusedReduction() 
	{
		val moduleKo = parseHelper.parse(
			getTestModuleWithCoordVariableWithCustomFunctions(
			'''
			functions 
			{
				reduceMin: (ℝ.MaxValue, ℝ[2])→ℝ[2];
			}
			''')
		)
		Assert.assertNotNull(moduleKo)
			
		moduleKo.assertWarning(NablaPackage.eINSTANCE.reduction, 
			BasicValidator::UNUSED_REDUCTION, 
			BasicValidator::getUnusedReductionMsg())		
									
		val moduleOk = parseHelper.parse(
			getTestModuleWithCoordVariableWithCustomFunctions(
			'''
			functions 
			{
				reduceMin: (ℝ.MaxValue, ℝ[2])→ℝ[2];
			}
			''')
			+
			'''
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
			getTestModuleWithCustomFunctions(
				'''
				functions 
				{
					f: x | ℝ[x+1] → ℝ[x];
					g: ℝ[2] → ℝ, x | ℝ[x] → ℝ;
				}
				'''
			)
		)
		Assert.assertNotNull(modulekO)
		
		modulekO.assertError(NablaPackage.eINSTANCE.functionArg, 
			BasicValidator::FUNCTION_IN_TYPES_OPERATION, 
			BasicValidator::getFunctionInTypesOperationMsg())

		modulekO.assertError(NablaPackage.eINSTANCE.functionArg, 
			BasicValidator::FUNCTION_INCOMPATIBLE_IN_TYPES, 
			BasicValidator::getFunctionIncompatibleInTypesMsg())

		//TODO : syntax error on 	f: x | ℝ[x] → ℝ[x-1];
		val moduleOk = parseHelper.parse(
			getTestModuleWithCustomFunctions(
				'''
				functions 
				{
					f: x | ℝ[x] → ℝ[x+1];
					g: ℝ → ℝ, x | ℝ[x] → ℝ;
				}
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
			getTestModuleWithCustomFunctions(
				'''
				functions 
				{
					f: x | ℝ → ℝ[x];
				}
				'''
			)
		)
		Assert.assertNotNull(modulekO)
		
		modulekO.assertError(NablaPackage.eINSTANCE.functionArg, 
			BasicValidator::FUNCTION_RETURN_TYPE, 
			BasicValidator::getFunctionReturnTypeMsg("x"))

		val moduleOk = parseHelper.parse(
			getTestModuleWithCustomFunctions(
				'''
				functions 
				{
					f: x | ℝ[x] → ℝ[x];
				}
				'''
			)
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}
	
	@Test
	def testCheckReductionCollectionType() 
	{
		val modulekO = parseHelper.parse(
			getTestModuleWithCustomFunctions(
				'''
				functions 
				{
					reduce1: x,y | (ℝ.MaxValue , ℝ[x+y])→ℝ[x+y];
					//reduce2: x,y | (ℝ.MaxValue , ℝ[x])→ℝ[y];
					reduce2: (ℝ.MaxValue, ℝ[2])→ℝ ,  x | (ℝ.MaxValue , ℝ[x])→ℝ;
				}
				'''
			)
		)
		Assert.assertNotNull(modulekO)
		
		modulekO.assertError(NablaPackage.eINSTANCE.reductionArg, 
			BasicValidator::REDUCTION_COLLECTION_TYPE_OPERATION, 
			BasicValidator::getReductionCollectionTypeOperationMsg)

		modulekO.assertError(NablaPackage.eINSTANCE.reductionArg, 
			BasicValidator::REDUCTION_INCOMPATIBLE_COLLECTION_TYPE, 
			BasicValidator::getReductionIncompatibleCollectionTypeMsg)

		val moduleOk = parseHelper.parse(
			getTestModuleWithCustomFunctions(
				'''
				functions 
				{
					reduce1: x,y | (ℝ.MaxValue , ℝ[x])→ℝ[x+y];
					//reduce2: x,y | (ℝ.MaxValue , ℝ[x])→ℝ[x,x+y];
					reduce2: (ℝ.MaxValue, ℝ)→ℝ ,  x | (ℝ.MaxValue , ℝ[x])→ℝ;
				}
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
			getTestModuleWithCustomFunctions(
				'''
				functions 
				{
					reduce: x,y | (ℝ.MaxValue , ℝ[x])→ℝ[y];
				}
				'''
			)
		)
		Assert.assertNotNull(modulekO)
		
		modulekO.assertError(NablaPackage.eINSTANCE.reductionArg, 
			BasicValidator::REDUCTION_RETURN_TYPE, 
			BasicValidator::getReductionReturnTypeMsg("y"))

		//TODO reduce: x,y | (ℝ.MaxValue , ℝ[x])→ℝ[x+y]; KO or OK ?
		val moduleOk = parseHelper.parse(
			getTestModuleWithCustomFunctions(
				'''
				functions 
				{
					reduce: x,y | (ℝ.MaxValue , ℝ[x])→ℝ[x+y];
				}
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
			getTestModuleWithCustomFunctions(
			'''
			functions 
			{
				f:	n | ℝ[n] → ℝ;
				g:	x | ℝ[x] → ℝ;
			}
			''')
		)
		Assert.assertNotNull(modulekO)
		
		modulekO.assertError(NablaPackage.eINSTANCE.dimensionVar, 
			BasicValidator::DIMENSION_VAR_NAME, 
			BasicValidator::getDimensionVarNameMsg())

		val moduleOk = parseHelper.parse(
			getTestModuleWithCustomFunctions(
			'''
			functions 
			{
				f:	x | ℝ[x] → ℝ;
			}
			''')
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}
	
	@Test
	def void testCheckUnusedDimensionVar() 
	{
		val moduleKo = parseHelper.parse(
			getTestModuleWithCoordVariableWithCustomFunctions(
			'''
			functions 
			{
				f: x,y | ℝ[x] → ℝ[2];
			}
			''')
		)
		Assert.assertNotNull(moduleKo)
			
		moduleKo.assertWarning(NablaPackage.eINSTANCE.dimensionVar, 
			BasicValidator::UNUSED_DIMENSION_VAR, 
			BasicValidator::getUnusedDimensionVar())		
									
		val moduleOk = parseHelper.parse(
			getTestModuleWithCoordVariableWithCustomFunctions(
			'''
			functions 
			{
				f: x | ℝ[x] → ℝ[2];
			}
			''')
			+
			'''
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
			getTestModuleWithCoordVariableWithCustomConnectivities(
			'''
			items { node }
			connectivities 
			{
				nodes: → {node};
				borderNodes: → {node};
			}
			''')
		)
		Assert.assertNotNull(moduleKo)
		
		moduleKo.assertWarning(NablaPackage.eINSTANCE.connectivity, 
			BasicValidator::UNUSED_CONNECTIVITY, 
			BasicValidator::getUnusedConnectivityMsg())		

		val moduleOk = parseHelper.parse(
			getTestModuleWithCoordVariableWithCustomConnectivities(
			'''
			items { node }
			connectivities 
			{
				nodes: → {node};
				borderNodes: → {node};
			}
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
		val moduleKo = parseHelper.parse(getTestModuleWithCoordVariableWithCustomConnectivities(connectivities)
			+
			'''
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

		val moduleOk =  parseHelper.parse(getTestModuleWithCoordVariableWithCustomConnectivities(connectivities)
			+
			'''
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
		val moduleKo = parseHelper.parse(testModuleWithCoordVariable
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

		val moduleOk =  parseHelper.parse(testModuleWithCoordVariable
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
			getTestModuleWithCustomConnectivities(
				'''
				items { node, cell }
				connectivities 
				{
					nodes: → {node};
					cells: → {cell};
					prevNode: node → node;
					neigboursCells: cell → {cell};
				}
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
			getTestModuleWithCustomConnectivities(
				'''
				items { node, cell }
				connectivities 
				{
					nodes: → {node};
					cells: → {cell};
					prevNode: node → node;
					neigboursCells: cell → {cell};
				}
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
	
	@Test
	def void testCheckOnlyRealArray() 
	{		
		val moduleKo = parseHelper.parse(testModule
			+
			'''
			ℕ[2] U{cells, cells};
			'''
		)
		Assert.assertNotNull(moduleKo)
		
		moduleKo.assertError(NablaPackage.eINSTANCE.connectivityVar, 
			BasicValidator::ONLY_REAL_ARRAY, 
			BasicValidator::getOnlyRealArrayMsg)		

		val moduleOk =  parseHelper.parse(testModule
			+
			'''
			ℝ[2] U{cells, cells};
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}
	
	// ===== Instructions =====

	@Test
	def void testCheckAffectationVar() 
	{		
		val moduleKo = parseHelper.parse(testModule
			+
			'''
			computeX : X_EDGE_LENGTH = Y_EDGE_LENGTH;
			'''
		)
		Assert.assertNotNull(moduleKo)
		
		moduleKo.assertError(NablaPackage.eINSTANCE.affectation, 
			BasicValidator::AFFECTATION_VAR, 
			BasicValidator::getAffectationVarMsg)		

		val moduleOk =  parseHelper.parse(testModule
			+
			'''
			computeX : ℝ X = Y_EDGE_LENGTH;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}
}
