/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.tests

import com.google.inject.Inject
import fr.cea.nabla.NablaModuleExtensions
import fr.cea.nabla.ir.MandatoryOptions
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
	@Inject extension TestUtils
	@Inject extension ValidationTestHelper
	@Inject extension NablaModuleExtensions

	// ===== Unique Names ====

	@Test
	def void checkDuplicateTimeIterator()
	{
		val moduleKo = parseHelper.parse(getTestModule('', '') + '''iterate n while (true), n while (true);''')
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.timeIterator,
			BasicValidator::DUPLICATE_NAME,
			BasicValidator::getDuplicateNameMsg(NablaPackage.Literals.TIME_ITERATOR, "n"))

		val moduleKo2 = parseHelper.parse(getTestModule('', '') + '''
			ℕ n;
			iterate n while (true), m while (true);
			''')
		Assert.assertNotNull(moduleKo2)
		moduleKo2.assertError(NablaPackage.eINSTANCE.argOrVar,
			BasicValidator::DUPLICATE_NAME,
			BasicValidator::getDuplicateNameMsg(NablaPackage.Literals.ARG_OR_VAR, "n (iterator)"))

		val moduleOk = parseHelper.parse(getTestModule('', '') + '''iterate n while (true), m while (true);''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void checkDuplicateArg()
	{
		val moduleKo = parseHelper.parse(getTestModule('', '''def f: ℕ × ℕ → ℕ, (a, a) → { return a; }'''))
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.arg,
			BasicValidator::DUPLICATE_NAME,
			BasicValidator::getDuplicateNameMsg(NablaPackage.Literals.ARG, "a"))

		val moduleOk = parseHelper.parse(getTestModule('', '''def f: ℕ × ℕ → ℕ, (a, b) → { return a; }'''))
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void checkDuplicateVar()
	{
		val moduleKo = parseHelper.parse(testModule +
		'''
			ℝ a, a;
		''')
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.^var,
			BasicValidator::DUPLICATE_NAME,
			BasicValidator::getDuplicateNameMsg(NablaPackage.Literals.VAR, "a"))

		val moduleOk = parseHelper.parse(testModule +
		'''
			ℝ a;
		''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void checkDuplicateArgOrVar()
	{
		val moduleKo = parseHelper.parse(testModule +
		'''
			ℝ a;
			ℝ a;
		''')
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.argOrVar,
			BasicValidator::DUPLICATE_NAME,
			BasicValidator::getDuplicateNameMsg(NablaPackage.Literals.ARG_OR_VAR, "a"))

		val moduleOk = parseHelper.parse(testModule +
		'''
			ℝ a;
		''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void checkDuplicateItem()
	{
		val moduleKo = parseHelper.parse(getTestModule(nodesConnectivity, '') +
		'''
			ℝ X{nodes, nodes};
			j1: ∀r∈nodes(), ∀r∈nodes(), let d = X{r, r} * 2.0;
		''')
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.item,
			BasicValidator::DUPLICATE_NAME,
			BasicValidator::getDuplicateNameMsg(NablaPackage.Literals.ITEM, "r"))

		val moduleOk = parseHelper.parse(getTestModule(nodesConnectivity, '') +
		'''
			ℝ X{nodes, nodes};
			j1: ∀r1∈nodes(), ∀r2∈nodes(), let d = X{r1, r2} * 2.0;
		''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void checkDuplicateItemType()
	{
		val moduleKo = parseHelper.parse('''
			module Test;
			
			itemtypes { node, node }
			
			set nodes: → {node};
			
			const X_EDGE_LENGTH = 0.01;
			const Y_EDGE_LENGTH = X_EDGE_LENGTH;
			const X_EDGE_ELEMS = 100;
			const Y_EDGE_ELEMS = 10;
		''')
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.itemType,
			BasicValidator::DUPLICATE_NAME,
			BasicValidator::getDuplicateNameMsg(NablaPackage.Literals.ITEM_TYPE, "node"))

		val moduleOk = parseHelper.parse('''
			module Test;
			
			itemtypes { node }
			
			set nodes: → {node};
			
			const X_EDGE_LENGTH = 0.01;
			const Y_EDGE_LENGTH = X_EDGE_LENGTH;
			const X_EDGE_ELEMS = 100;
			const Y_EDGE_ELEMS = 10;
		''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void checkDuplicateConnectivity()
	{
		val moduleKo = parseHelper.parse('''
			module Test;
			
			itemtypes { node }
			
			set nodes: → {node};
			set nodes: → {node};
			
			const X_EDGE_LENGTH = 0.01;
			const Y_EDGE_LENGTH = X_EDGE_LENGTH;
			const X_EDGE_ELEMS = 100;
			const Y_EDGE_ELEMS = 10;
		''')
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.connectivity,
			BasicValidator::DUPLICATE_NAME,
			BasicValidator::getDuplicateNameMsg(NablaPackage.Literals.MULTIPLE_CONNECTIVITY, "nodes"))

		val moduleOk = parseHelper.parse('''
			module Test;

			itemtypes { node }

			set nodes: → {node};

			const X_EDGE_LENGTH = 0.01;
			const Y_EDGE_LENGTH = X_EDGE_LENGTH;
			const X_EDGE_ELEMS = 100;
			const Y_EDGE_ELEMS = 10;
		''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void checkJob()
	{
		val moduleKo = parseHelper.parse(testModule +
		'''
			ℝ a;
			IncrA: a = a + 1;
			IncrA: a = a + 1;
		''')
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.job,
			BasicValidator::DUPLICATE_NAME,
			BasicValidator::getDuplicateNameMsg(NablaPackage.Literals.JOB, "IncrA"))

		val moduleOk = parseHelper.parse(testModule +
		'''
			ℝ a;
			IncrA: a = a + 1;
		''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void checkTimeIterator()
	{
		val moduleKo = parseHelper.parse(testModule +
		'''
			iterate n while(true), n while(true);
		''')
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.timeIterator,
			BasicValidator::DUPLICATE_NAME,
			BasicValidator::getDuplicateNameMsg(NablaPackage.Literals.TIME_ITERATOR, "n"))

		val moduleOk = parseHelper.parse(testModule +
		'''
			iterate n while(true), k while(true);
		''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	// ===== NablaModule =====

	@Test
	def void testCheckMandatoryOptions()
	{
		// no item => no mesh => no mandatory variables
		val moduleOk1 = parseHelper.parse('''module Test;''')
		Assert.assertNotNull(moduleOk1)
		moduleOk1.assertNoErrors

		// item => mesh => mandatory variables
		val moduleKo = parseHelper.parse(
		'''
			module Test;
			itemtypes { node }
		''')
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.nablaModule,
			BasicValidator::MANDATORY_OPTION,
			BasicValidator::getMandatoryOptionsMsg(MandatoryOptions::NAMES))

		val moduleOk2 = parseHelper.parse(getTestModule)
		Assert.assertNotNull(moduleOk2)
		moduleOk2.assertNoErrors
	}

	@Test
	def void testCheckName()
	{
		val moduleKo = parseHelper.parse('''module test;''')
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.nablaModule,
			BasicValidator::MODULE_NAME,
			BasicValidator::getModuleNameMsg())		

		val moduleOk = parseHelper.parse('''module Test;''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	// ===== TimeIterator =====

	@Test
	def testCheckUnusedTimeIterator()
	{
		val moduleKo = parseHelper.parse(testModule +
			'''
			iterate n while(true);
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertWarning(NablaPackage.eINSTANCE.timeIterator,
			BasicValidator::UNUSED_TIME_ITERATOR,
			BasicValidator::getUnusedTimeIteratorMsg())

		val moduleOk = parseHelper.parse(testModule +
			'''
			ℝ u, v;
			iterate n while(true);
			ComputeU: u^{n+1} = u^{n} + 6.0;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors		
	}

	@Test
	def testCheckInitValue()
	{
		val moduleKo = parseHelper.parse(testModule +
			'''
			ℝ u, v;
			iterate n while(true);
			ComputeUinit: u^{n=1} = 0.0;
			ComputeU: u^{n+1} = u^{n} + 6.0;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.initTimeIteratorRef,
			BasicValidator::INIT_VALUE,
			BasicValidator::getInitValueMsg(1))

		val moduleOk = parseHelper.parse(testModule +
			'''
			ℝ u, v;
			iterate n while(true);
			ComputeUinit: u^{n=0} = 0.0;
			ComputeU: u^{n+1} = u^{n} + 6.0;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors		
	}

	@Test
	def testCheckNextValue()
	{
		val moduleKo = parseHelper.parse(testModule +
			'''
			ℝ u, v;
			ℕ ni;
			iterate n counter ni while(true);
			ComputeU: u^{n+2} = u^{n} + 6.0;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.nextTimeIteratorRef,
			BasicValidator::NEXT_VALUE,
			BasicValidator::getNextValueMsg(2))

		val moduleOk = parseHelper.parse(testModule +
			'''
			ℝ u, v;
			iterate n while(true);
			ComputeU: u^{n+1} = u^{n} + 6.0;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors		
	}

	@Test
	def testCheckNoReductionInConsition()
	{
		val moduleKo = parseHelper.parse(testModule +
			'''
				ℝ[3] x;
				iterate n while(∑{x∈[0;3[}(x[i]]));
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.timeIterator,
			BasicValidator::NO_REDUCTION_IN_CONDITION,
			BasicValidator::getNoReductionInConditionMsg())

		val moduleOk = parseHelper.parse(testModule +
			'''
				ℝ[3] x;
				iterate n while(x[0] > 0.0);
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors		
	}

	// ===== BaseType =====	

	@Test
	def void testCheckArraySize()
	{
		val moduleKo = parseHelper.parse(testModule +
			'''
			ℝ[1] a;
			ℕ[1,3] b;
			ℕ[2,1] c;
			ℝ[2, 3, 4] d;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.baseType,
			BasicValidator::ARRAY_SIZES,
			BasicValidator::getArraySizesMsg())

		moduleKo.assertError(NablaPackage.eINSTANCE.baseType,
			BasicValidator::ARRAY_SIZES,
			BasicValidator::getArraySizesMsg())

		moduleKo.assertError(NablaPackage.eINSTANCE.baseType,
			BasicValidator::ARRAY_DIMENSION,
			BasicValidator::getArrayDimensionMsg())

		val moduleOk = parseHelper.parse(testModule +
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
			testModule +
			'''
			ℝ a;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertWarning(NablaPackage.eINSTANCE.^var, 
			BasicValidator::UNUSED_VARIABLE, 
			BasicValidator::getUnusedVariableMsg())

		val moduleOk = parseHelper.parse(
			testModule +
			'''
			ℝ a;
			ComputeA: a = 1.;
			'''
		)

		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoIssues
	}

	@Test
	def void testCheckIndicesNumber()
	{
		val moduleKo = parseHelper.parse(testModule +
			'''
			ℕ[2,2] a;
			let b = a[0];
			ℕ[2] c;
			let d = c[0,1];
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.argOrVarRef,
			BasicValidator::INDICES_NUMBER,
			BasicValidator::getIndicesNumberMsg(2,1))

		moduleKo.assertError(NablaPackage.eINSTANCE.argOrVarRef,
			BasicValidator::INDICES_NUMBER,
			BasicValidator::getIndicesNumberMsg(1,2))

		val moduleOk =  parseHelper.parse(testModule +
			'''
			ℕ[2,2] a;
			let b = a[0,0];
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckSpaceIteratorNumberAndType() 
	{
		val moduleKo = parseHelper.parse(getTestModule(defaultConnectivities, '') +
			'''
			ℝ u{cells}, v{cells, nodesOfCell}, w{nodes};
			ComputeU: ∀ j∈cells(), ∀r∈nodesOfCell(j), u{j,r} = 1.;
			ComputeV: ∀ j∈cells(), ∀r∈nodesOfCell(j), v{j} = 1.;
			ComputeW: ∀ j∈cells(), w{j} = 1.;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.argOrVarRef,
			BasicValidator::SPACE_ITERATOR_NUMBER,
			BasicValidator::getSpaceIteratorNumberMsg(1,2))

		moduleKo.assertError(NablaPackage.eINSTANCE.argOrVarRef,
			BasicValidator::SPACE_ITERATOR_NUMBER,
			BasicValidator::getSpaceIteratorNumberMsg(2,1))

		val node = moduleKo.getItemTypeByName("node").name
		val cell = moduleKo.getItemTypeByName("cell").name

		moduleKo.assertError(NablaPackage.eINSTANCE.argOrVarRef,
			BasicValidator::SPACE_ITERATOR_TYPE, 
			BasicValidator::getSpaceIteratorTypeMsg(node, cell))

		val moduleOk =  parseHelper.parse(getTestModule(defaultConnectivities, '') +
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

	@Test
	def void testCheckTimeIteratorUsage() 
	{
		val moduleKo = parseHelper.parse(getTestModule('', '') +
			'''
			ℝ u, v;
			iterate n while(true);
			ComputeU: u^{n+1} = u^{n} + 6.0;
			ComputeV: v = u + 4.0; // Wrong: must be u^{n}
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.argOrVarRef,
			BasicValidator::TIME_ITERATOR_USAGE,
			BasicValidator::getTimeIteratorUsageMsg())

		val moduleOk =  parseHelper.parse(getTestModule('', '') +
			'''
			ℝ u, v;
			iterate n while(true);
			ComputeU: u^{n+1} = u^{n} + 6.0;
			ComputeV: v = u^{n} + 4.0; // Wrong: must be u^{n}
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	// ===== Functions (Reductions, Dimension) =====

	@Test
	def testCheckOnlyIntAndVarInFunctionInTypes()
	{
		val modulekO = parseHelper.parse(getTestModule('', '''def f: x | ℝ[x+1] → ℝ[x];'''))
		Assert.assertNotNull(modulekO)

		modulekO.assertError(NablaPackage.eINSTANCE.function,
			BasicValidator::ONLY_INT_AND_VAR_IN_FUNCTION_IN_TYPES,
			BasicValidator::getOnlyIntAndVarInFunctionInTypesMsg())

		val moduleOk = parseHelper.parse(getTestModule('', '''def f: x | ℝ[x] → ℝ[x+1];'''))
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def testCheckOnlyIntAndVarInReductionCollectionType()
	{
		val modulekO = parseHelper.parse(getTestModule('', '''def sum, 0.0: x,y | ℝ[x+y], (a,b) → return a + b;'''))
		Assert.assertNotNull(modulekO)

		modulekO.assertError(NablaPackage.eINSTANCE.reduction,
			BasicValidator::ONLY_INT_AND_VAR_IN_REDUCTION_TYPE,
			BasicValidator::getOnlyIntAndVarInReductionTypeMsg)

		val moduleOk = parseHelper.parse(getTestModule('', '''def sum, 0.0: x | ℝ[x], (a,b) → return a + b;'''))
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckUnusedFunction() 
	{
		val modelKo = getTestModule('', '''def f: x | ℝ[x] → ℝ''')
		val moduleKo = parseHelper.parse(modelKo)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertWarning(NablaPackage.eINSTANCE.function,
			BasicValidator::UNUSED_FUNCTION,
			BasicValidator::getUnusedFunctionMsg())

		val modelOk = getTestModule('', '''def f: x | ℝ[x] → ℝ;''') +
			'''
			let orig = [0.0 , 0.0];
			ComputeV:
			{ 
				let v = f(orig);
				v = v + 1;
			}
			'''
		val moduleOk = parseHelper.parse(modelOk)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoIssues
	}

	@Test
	def void testCheckUnusedReduction()
	{
		val reduc = '''def sum, 0.0: ℝ[2], (a, b) → return a+b;'''
		val moduleKo = parseHelper.parse(getTestModule('', reduc))
		Assert.assertNotNull(moduleKo)

		moduleKo.assertWarning(NablaPackage.eINSTANCE.reduction,
			BasicValidator::UNUSED_REDUCTION,
			BasicValidator::getUnusedReductionMsg())

		val moduleOk = parseHelper.parse(getTestModule(nodesConnectivity, reduc) +
			'''
			let orig = [0.0 , 0.0];
			ℝ[2] X{nodes};
			ComputeU: orig = sum{r∈nodes()}(X{r});
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoIssues
	}

	@Test
	def testCheckFunctionIncompatibleInTypes() 
	{
		var functions =
			'''
			def g: ℝ[2] → ℝ;
			def g: x | ℝ[x] → ℝ;
			'''

		val modulekO = parseHelper.parse(getTestModule('', functions))
		Assert.assertNotNull(modulekO)

		modulekO.assertError(NablaPackage.eINSTANCE.function,
			BasicValidator::FUNCTION_INCOMPATIBLE_IN_TYPES,
			BasicValidator::getFunctionIncompatibleInTypesMsg())

		functions =
			'''
			def g: ℝ → ℝ;
			def g: x | ℝ[x] → ℝ;
			'''

		val moduleOk = parseHelper.parse(getTestModule('', functions))
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def testCheckFunctionReturnType() 
	{
		var functions = '''def f: x | ℝ → ℝ[x];'''

		val modulekO = parseHelper.parse(getTestModule('', functions))
		Assert.assertNotNull(modulekO)

		modulekO.assertError(NablaPackage.eINSTANCE.function, 
			BasicValidator::FUNCTION_RETURN_TYPE, 
			BasicValidator::getFunctionReturnTypeMsg("x"))

		functions =
			'''
			def f: x | ℝ[x] → ℝ[x];
			def g: y | ℝ[y] → ℝ[x, y];
			'''

		val moduleOk = parseHelper.parse(getTestModule('', functions))
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors(NablaPackage.eINSTANCE.function, BasicValidator::FUNCTION_RETURN_TYPE)
	}

	@Test
	def testCheckReductionIncompatibleTypes() 
	{
		var reductions =
			'''
			def g, 0.0: ℝ[2], (a, b) → return a;
			def g, 0.0: x | ℝ[x], (a, b) → return a;
			'''
		val modulekO = parseHelper.parse(getTestModule('', reductions))
		Assert.assertNotNull(modulekO)

		modulekO.assertError(NablaPackage.eINSTANCE.reduction,
			BasicValidator::REDUCTION_INCOMPATIBLE_TYPES,
			BasicValidator::getReductionIncompatibleTypesMsg())

		reductions =
			'''
			def g, 0.0: ℝ, (a, b) → return a;
			def g, 0.0: x | ℝ[x], (a, b) → return a;
			'''
		val moduleOk = parseHelper.parse(getTestModule('', reductions))
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}


	// ===== Connectivities =====

	@Test
	def void testCheckUnusedConnectivity()
	{
		val connectivities =
			'''
			itemtypes { node }
			set nodes: → {node};
			set borderNodes: → {node};
			'''
		val moduleKo = parseHelper.parse(getTestModule(connectivities, ''))
		Assert.assertNotNull(moduleKo)

		moduleKo.assertWarning(NablaPackage.eINSTANCE.connectivity,
			BasicValidator::UNUSED_CONNECTIVITY,
			BasicValidator::getUnusedConnectivityMsg())

		val moduleOk = parseHelper.parse(getTestModule(connectivities, '')
			+
			'''
			ℝ[2] X{nodes};
			IniXborder: ∀r∈borderNodes(), X{r} = X{r} - 1;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoIssues
	}

	@Test
	def void testCheckConnectivityCallIndexAndType()
	{
		val moduleKo = parseHelper.parse(getTestModule(defaultConnectivities, '') +
			'''
			let orig = [0.0 , 0.0] ;
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

		val moduleOk =  parseHelper.parse(getTestModule(defaultConnectivities, '') +
			'''
			ℝ[2] X{nodes};
			let orig = [0.0 , 0.0] ;
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
		val moduleKo = parseHelper.parse(getTestModule(defaultConnectivities, '') +
			'''
			ℝ[2] X{nodes};
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

		val moduleOk =  parseHelper.parse(getTestModule(defaultConnectivities, '') +
			'''
			ℝ[2] X{nodes};
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

	// ===== Instructions =====

	@Test
	def void testCheckAffectationVar() 
	{
		val moduleKo = parseHelper.parse(testModule +
			'''
			computeX : X_EDGE_LENGTH = Y_EDGE_LENGTH;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.affectation,
			BasicValidator::AFFECTATION_CONST,
			BasicValidator::getAffectationConstMsg)

		val moduleKo2 = parseHelper.parse(testModule +
			'''
			initXXX: { const xxx = 0.0; xxx = 0.01; }
			'''
		)
		Assert.assertNotNull(moduleKo2)

		moduleKo2.assertError(NablaPackage.eINSTANCE.affectation,
			BasicValidator::AFFECTATION_CONST,
			BasicValidator::getAffectationConstMsg)

		val moduleOk =  parseHelper.parse(testModule +
			'''
			computeX1 : let X1 = Y_EDGE_LENGTH;
			initYYY: { const xxx = 0.0; let yyy = xxx; }
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckScalarVarDefaultValue()
	{
		val moduleKo = parseHelper.parse(testModule +
			'''
			let coef = 2;
			const DOUBLE_LENGTH = X_EDGE_LENGTH * coef;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.simpleVarDefinition,
			BasicValidator::SCALAR_VAR_DEFAULT_VALUE,
			BasicValidator::getScalarVarDefaultValueMsg)

		val moduleOk =  parseHelper.parse(testModule +
			'''
			const coef = 2;
			const DOUBLE_LENGTH = X_EDGE_LENGTH * coef;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	// ===== Items =====

	@Test
	def void testCheckUnusedItem()
	{
		val moduleKo = parseHelper.parse(testModule +
			'''
			UpdateX: ∀r1∈nodes(), ∀r2∈nodes(), X{r1} = X{r1} + 1;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertWarning(NablaPackage.eINSTANCE.item,
			BasicValidator::UNUSED_ITEM,
			BasicValidator::getUnusedItemMsg())

		val moduleOk = parseHelper.parse(getTestModule(nodesConnectivity, '') +
			'''
			ℝ[2] X{nodes};
			UpdateX: ∀r1∈nodes(), X{r1} = X{r1} + 1;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoIssues
	}

	@Test
	def void testCheckShiftValidity()
	{
		val connectivities =
			'''
			itemtypes { node }
			set nodes: → {node};
			item leftNode: node → node;
			'''

		val moduleKo = parseHelper.parse(getTestModule(connectivities, '')
			+
			'''
			ℝ[2] X{nodes};
			UpdateX: ∀r1∈nodes(), r2 = leftNode(r1), X{r2} = X{r2-1} - 1;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.itemRef,
			BasicValidator::SHIFT_VALIDITY,
			BasicValidator::getShiftValidityMsg)

		val moduleOk =  parseHelper.parse(getTestModule(connectivities, '')
			+
			'''
			ℝ[2] X{nodes};
			UpdateX: ∀r1∈nodes(), r2 = leftNode(r1), X{r2} = X{r1-1} - 1;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}
}
