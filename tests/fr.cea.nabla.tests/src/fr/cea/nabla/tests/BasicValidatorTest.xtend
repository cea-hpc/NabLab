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

import static fr.cea.nabla.tests.TestUtils.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(NablaInjectorProvider))
class BasicValidatorTest 
{
	@Inject ParseHelper<NablaModule> parseHelper
	@Inject extension ValidationTestHelper
	@Inject extension NablaModuleExtensions

	// ===== Unique Names ====

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
	def void checkDuplicateSpaceIterator()
	{
		val moduleKo = parseHelper.parse(getTestModule(nodesConnectivity, '') +
		'''
			ℝ X{nodes, nodes};
			j1: ∀r∈nodes(), ∀r∈nodes(), ℝ d = X{r, r} * 2.0;
		''')
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.spaceIterator,
			BasicValidator::DUPLICATE_NAME,
			BasicValidator::getDuplicateNameMsg(NablaPackage.Literals.SPACE_ITERATOR, "r"))

		val moduleOk = parseHelper.parse(getTestModule(nodesConnectivity, '') +
		'''
			ℝ X{nodes, nodes};
			j1: ∀r1∈nodes(), ∀r2∈nodes(), ℝ d = X{r1, r2} * 2.0;
		''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void checkDuplicateVarTypeSymbol()
	{
		val moduleKo = parseHelper.parse(getTestModule('', '''def j: a, a | ℝ[a, a] → ℝ;'''))
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.sizeTypeSymbol,
			BasicValidator::DUPLICATE_NAME,
			BasicValidator::getDuplicateNameMsg(NablaPackage.Literals.SIZE_TYPE_SYMBOL, "a"))

		val moduleOk = parseHelper.parse(getTestModule('', '''def j: a | ℝ[a, a] → ℝ;'''))
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors

		val moduleKo2 = parseHelper.parse(getTestModule('', '''
			def j: a | ℝ[a, a] → ℝ, (x) → {
				ℝ y;
				∀i∈[0;a[, ∀i∈[0;a[, y = y * x[i, i];
				return y;
			}'''))
		Assert.assertNotNull(moduleKo2)
		moduleKo2.assertError(NablaPackage.eINSTANCE.sizeTypeSymbol,
			BasicValidator::DUPLICATE_NAME,
			BasicValidator::getDuplicateNameMsg(NablaPackage.Literals.SIZE_TYPE_SYMBOL, "i"))

		val moduleOk2 = parseHelper.parse(getTestModule('', '''
			def j: a | ℝ[a, a] → ℝ, (x) → {
				ℝ y;
				∀i∈[0;a[, ∀j∈[0;a[, y = y * x[i, j];
				return y;
			}'''))
		Assert.assertNotNull(moduleOk2)
		moduleOk2.assertNoErrors
	}

	@Test
	def void checkDuplicateItemType()
	{
		val moduleKo = parseHelper.parse('''
			module Test;
			
			items { node, node }
			
			set	nodes: → {node};
			
			const ℝ X_EDGE_LENGTH = 0.01;
			const ℝ Y_EDGE_LENGTH = X_EDGE_LENGTH;
			const ℕ X_EDGE_ELEMS = 100;
			const ℕ Y_EDGE_ELEMS = 10;
		''')
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.itemType,
			BasicValidator::DUPLICATE_NAME,
			BasicValidator::getDuplicateNameMsg(NablaPackage.Literals.ITEM_TYPE, "node"))

		val moduleOk = parseHelper.parse('''
			module Test;
			
			items { node }
			
			set	nodes: → {node};
			
			const ℝ X_EDGE_LENGTH = 0.01;
			const ℝ Y_EDGE_LENGTH = X_EDGE_LENGTH;
			const ℕ X_EDGE_ELEMS = 100;
			const ℕ Y_EDGE_ELEMS = 10;
		''')
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void checkDuplicateConnectivity()
	{
		val moduleKo = parseHelper.parse('''
			module Test;
			
			items { node }
			
			set	nodes: → {node};
			set	nodes: → {node};
			
			const ℝ X_EDGE_LENGTH = 0.01;
			const ℝ Y_EDGE_LENGTH = X_EDGE_LENGTH;
			const ℕ X_EDGE_ELEMS = 100;
			const ℕ Y_EDGE_ELEMS = 10;
		''')
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.connectivity,
			BasicValidator::DUPLICATE_NAME,
			BasicValidator::getDuplicateNameMsg(NablaPackage.Literals.CONNECTIVITY, "nodes"))

		val moduleOk = parseHelper.parse('''
			module Test;
			
			items { node }
			
			set	nodes: → {node};
			
			const ℝ X_EDGE_LENGTH = 0.01;
			const ℝ Y_EDGE_LENGTH = X_EDGE_LENGTH;
			const ℕ X_EDGE_ELEMS = 100;
			const ℕ Y_EDGE_ELEMS = 10;
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
			ℕ in, ik;
			iterate n counter in while(true), n counter ik while(true);
		''')
		Assert.assertNotNull(moduleKo)
		moduleKo.assertError(NablaPackage.eINSTANCE.timeIterator,
			BasicValidator::DUPLICATE_NAME,
			BasicValidator::getDuplicateNameMsg(NablaPackage.Literals.TIME_ITERATOR, "n"))

		val moduleOk = parseHelper.parse(testModule +
		'''
			ℕ in, ik;
			iterate n counter in while(true), k counter ik while(true);
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
			items { node }
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
			ℕ ni;
			iterate n counter ni while(true);
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertWarning(NablaPackage.eINSTANCE.timeIterator,
			BasicValidator::UNUSED_TIME_ITERATOR,
			BasicValidator::getUnusedTimeIteratorMsg())

		val moduleOk = parseHelper.parse(testModule +
			'''
			ℝ u, v;
			ℕ ni;
			iterate n counter ni while(true);
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
			ℕ ni;
			iterate n counter ni while(true);
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
			ℕ ni;
			iterate n counter ni while(true);
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
			ℕ ni;
			iterate n counter ni while(true);
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
				ℕ in;
				iterate n counter in while(∑{x∈[0;3[}(x[i]]));
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.timeIterator,
			BasicValidator::NO_REDUCTION_IN_CONDITION,
			BasicValidator::getNoReductionInConditionMsg())

		val moduleOk = parseHelper.parse(testModule +
			'''
				ℝ[3] x;
				ℕ in;
				iterate n counter in while(x[0] > 0.0);
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

		val moduleOk =  parseHelper.parse(testModule +
			'''
			ℕ[2,2] a;
			ℕ b = a[0,0];
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
			ℕ ni;
			iterate n counter ni while(true);
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
			ℕ ni;
			iterate n counter ni while(true);
			ComputeU: u^{n+1} = u^{n} + 6.0;
			ComputeV: v = u^{n} + 4.0; // Wrong: must be u^{n}
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	// ===== Functions (Reductions, Dimension) =====

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
			ℝ[2] orig = [0.0 , 0.0];
			ComputeV:
			{ 
				ℝ v = f(orig);
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
		val moduleKo = parseHelper.parse(getTestModule('', '''def reduceMin: (ℝ.MaxValue, ℝ[2]) → ℝ[2];'''))
		Assert.assertNotNull(moduleKo)

		moduleKo.assertWarning(NablaPackage.eINSTANCE.reduction,
			BasicValidator::UNUSED_REDUCTION,
			BasicValidator::getUnusedReductionMsg())

		val moduleOk = parseHelper.parse(getTestModule(nodesConnectivity, '''def reduceMin: (ℝ.MaxValue, ℝ[2]) → ℝ[2];''') +
			'''
			ℝ[2] orig = [0.0 , 0.0];
			ℝ[2] X{nodes};
			ComputeU: orig = reduceMin{r∈nodes()}(X{r});
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoIssues
	}

	@Test
	def testCheckFunctionInTypes() 
	{
		var functions =
			'''
			def	g: ℝ[2] → ℝ;
			def g: x | ℝ[x] → ℝ;
			'''

		val modulekO = parseHelper.parse(getTestModule('', functions))
		Assert.assertNotNull(modulekO)

		modulekO.assertError(NablaPackage.eINSTANCE.function,
			BasicValidator::FUNCTION_INCOMPATIBLE_IN_TYPES,
			BasicValidator::getFunctionIncompatibleInTypesMsg())

		functions =
			'''
			def	g: ℝ → ℝ;
			def g: x | ℝ[x] → ℝ;
			'''

		val moduleOk = parseHelper.parse(getTestModule('', functions))
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def testCheckFunctionReturnType() 
	{
		var functions = '''def	f: x | ℝ → ℝ[x];'''

		val modulekO = parseHelper.parse(getTestModule('', functions))
		Assert.assertNotNull(modulekO)

		modulekO.assertError(NablaPackage.eINSTANCE.function, 
			BasicValidator::FUNCTION_RETURN_TYPE, 
			BasicValidator::getFunctionReturnTypeMsg("x"))

		functions =
			'''
			def	f: x | ℝ[x] → ℝ[x];
			def	g: y | ℝ[y] → ℝ[x, y];
			'''

		val moduleOk = parseHelper.parse(getTestModule('', functions))
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors(NablaPackage.eINSTANCE.function, BasicValidator::FUNCTION_RETURN_TYPE)
	}

	@Test
	def testCheckReductionCollectionType() 
	{
		var functions =
			'''
			def	reduce: (ℝ.MaxValue, ℝ[2]) → ℝ;
			def reduce: x | (ℝ.MaxValue , ℝ[x]) → ℝ;
			'''

		val modulekO = parseHelper.parse(getTestModule('',functions))
		Assert.assertNotNull(modulekO)

		modulekO.assertError(NablaPackage.eINSTANCE.reduction,
			BasicValidator::REDUCTION_INCOMPATIBLE_COLLECTION_TYPE,
			BasicValidator::getReductionIncompatibleCollectionTypeMsg)

		functions =
			'''
			def	reduce: (ℝ.MaxValue, ℝ) → ℝ;
			def reduce: x | (ℝ.MaxValue , ℝ[x]) → ℝ;
			'''

		val moduleOk = parseHelper.parse(getTestModule('', functions))
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def testCheckReductionReturnType() 
	{
		val modulekO = parseHelper.parse(getTestModule('', '''def	reduce: x,y | (ℝ.MaxValue , ℝ[x]) → ℝ[y];'''))
		Assert.assertNotNull(modulekO)

		modulekO.assertError(NablaPackage.eINSTANCE.reduction,
			BasicValidator::REDUCTION_RETURN_TYPE,
			BasicValidator::getReductionReturnTypeMsg("y"))

		val modulekO2 = parseHelper.parse(getTestModule('', '''def	reduce: x,y | (ℝ.MaxValue , ℝ[x]) → ℝ[x+y];'''))
		Assert.assertNotNull(modulekO2)

		modulekO2.assertError(NablaPackage.eINSTANCE.reduction,
			BasicValidator::REDUCTION_RETURN_TYPE,
			BasicValidator::getReductionReturnTypeMsg("y"))

		val moduleOk = parseHelper.parse(getTestModule('', '''def	reduce: x | (ℝ.MaxValue , ℝ[x]) → ℝ[x];'''))
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}


	// ===== Connectivities =====

	@Test
	def void testCheckUnusedConnectivity()
	{
		val connectivities =
			'''
			items { node }
			set	nodes: → {node};
			set	borderNodes: → {node};
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

		val moduleOk =  parseHelper.parse(getTestModule(defaultConnectivities, '') +
			'''
			ℝ[2] X{nodes};
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

	@Test
	def void testCheckDimensionMultipleAndArg()
	{
		val connectivities =
		'''
		items { node, cell }
		set	nodes: → {node};
		set	cells: → {cell};
		set	prevNode: node → node;
		set	neigboursCells: cell → {cell};
		'''
		val moduleKo = parseHelper.parse(getTestModule(connectivities, '')
			+
			'''
			ℝ[2] U{prevNode};
			ℝ[2] V{neigboursCells};
			''')
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.connectivityVar,
			BasicValidator::DIMENSION_MULTIPLE,
			BasicValidator::getDimensionMultipleMsg)

		moduleKo.assertError(NablaPackage.eINSTANCE.connectivityVar,
			BasicValidator::DIMENSION_ARG,
			BasicValidator::getDimensionArgMsg)

		val moduleOk =  parseHelper.parse(getTestModule(connectivities, '')
				+
				'''
				ℝ[2] U{nodes};
				ℝ[2] V{cells, neigboursCells};
				''')
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
			initXXX: { const ℝ xxx=0.0; xxx = 0.01; }
			'''
		)
		Assert.assertNotNull(moduleKo2)

		moduleKo2.assertError(NablaPackage.eINSTANCE.affectation,
			BasicValidator::AFFECTATION_CONST,
			BasicValidator::getAffectationConstMsg)

		val moduleOk =  parseHelper.parse(testModule +
			'''
			computeX1 : ℝ X1 = Y_EDGE_LENGTH;
			initYYY: { const ℝ xxx=0.0; ℝ yyy = xxx; }
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
			ℕ coef = 2;
			const ℝ DOUBLE_LENGTH = X_EDGE_LENGTH * coef;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.simpleVarDefinition,
			BasicValidator::SCALAR_VAR_DEFAULT_VALUE,
			BasicValidator::getScalarVarDefaultValueMsg)

		val moduleOk =  parseHelper.parse(testModule +
			'''
			const ℕ coef = 2;
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
		val moduleKo = parseHelper.parse(testModule +
			'''
			UpdateX: ∀r1∈nodes(), ∀r2∈nodes(), X{r1} = X{r1} + 1;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertWarning(NablaPackage.eINSTANCE.spaceIterator,
			BasicValidator::UNUSED_ITERATOR,
			BasicValidator::getUnusedIteratorMsg())

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
	def void testCheckRangeReturnType()
	{
		var connectivities =
			'''
			items { node }
			set nodes: → {node};
			set leftNode: node → node;
			'''
		val moduleKo = parseHelper.parse(getTestModule(connectivities, '')
			+
			'''
			ℝ[2] X{nodes};
			UpdateX: ∀r1∈nodes(), ∀r2∈leftNode(r1), X{r2} = X{r1} - 1;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.rangeSpaceIterator,
			BasicValidator::RANGE_RETURN_TYPE,
			BasicValidator::getRangeReturnTypeMsg)

		connectivities =
			'''
			items { node }
			set nodes: → {node};
			set leftNodes: node → {node};
			'''
		val moduleOk =  parseHelper.parse(getTestModule(connectivities, '')
			+
			'''
			ℝ[2] X{nodes};
			UpdateX: ∀r1∈nodes(), ∀r2∈leftNodes(r1), X{r2} = X{r1} - 1;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckSingletonReturnType() 
	{
		var connectivities =
			'''
			items { node }
			set	nodes: → {node};
			set	leftNode: node → {node};
			'''
		val moduleKo = parseHelper.parse(getTestModule(connectivities, '')
			+
			'''
			ℝ[2] X{nodes};
			UpdateX: ∀r1∈nodes(), r2 = leftNode(r1), X{r2} = X{r1} - 1;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.singletonSpaceIterator,
			BasicValidator::SINGLETON_RETURN_TYPE,
			BasicValidator::getSingletonReturnTypeMsg)

		connectivities =
			'''
			items { node }
			set	nodes: → {node};
			set	leftNode: node → node;
			'''
		val moduleOk =  parseHelper.parse(getTestModule(connectivities, '')
			+
			'''
			ℝ[2] X{nodes};
			UpdateX: ∀r1∈nodes(), r2 = leftNode(r1), X{r2} = X{r1} - 1;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckIncAndDecValidity() 
	{
		val connectivities =
			'''
			items { node }
			set	nodes: → {node};
			set	leftNode: node → node;
			'''

		val moduleKo = parseHelper.parse(getTestModule(connectivities, '')
			+
			'''
			ℝ[2] X{nodes};
			UpdateX: ∀r1∈nodes(), r2 = leftNode(r1), X{r2} = X{r2-1} - 1;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.spaceIteratorRef,
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

	// ===== SizeType =====

	@Test
	def void testCheckUnusedSizeTypeSymbol()
	{
		val moduleKo = parseHelper.parse(getTestModule('', '''def f: x,y | ℝ[x] → ℝ[2];''') +
			'''
			ℝ[2] orig = [0.0 , 0.0] ;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertWarning(NablaPackage.eINSTANCE.sizeTypeSymbol,
			BasicValidator::UNUSED_SIZE_TYPE_SYMBOL,
			BasicValidator::getUnusedSizeTypeSymbolMsg())

		val moduleOk = parseHelper.parse(getTestModule('', '''def f: x | ℝ[x] → ℝ[2];''') +
			'''
			ℝ[2] orig = [0.0 , 0.0];
			ComputeOrig: orig = f(orig);
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoIssues
	}

	@Test
	def testCheckNoOperationInFunctionInTypes()
	{
		val modulekO = parseHelper.parse(getTestModule('', '''def f: x | ℝ[x+1] → ℝ[x];'''))
		Assert.assertNotNull(modulekO)

		modulekO.assertError(NablaPackage.eINSTANCE.function,
			BasicValidator::NO_OPERATION_IN_FUNCTION_IN_TYPES,
			BasicValidator::getNoOperationInFunctionInTypesMsg())

		val moduleOk = parseHelper.parse(getTestModule('', '''def f: x | ℝ[x] → ℝ[x+1];'''))
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def testCheckNoOperationInReductionCollectionType()
	{
		val modulekO = parseHelper.parse(getTestModule('', '''def reduce: x,y | (ℝ.MaxValue , ℝ[x+y]) → ℝ[x+y];'''))
		Assert.assertNotNull(modulekO)

		modulekO.assertError(NablaPackage.eINSTANCE.reduction,
			BasicValidator::NO_OPERATION_IN_REDUCTION_COLLECTION_TYPE,
			BasicValidator::getNoOperationInReductionCollectionTypeMsg)

		val moduleOk = parseHelper.parse(getTestModule('', '''def	reduce: x | (ℝ.MaxValue , ℝ[x]) → ℝ[x];'''))
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}

	@Test
	def void testCheckNoOperationInVarRefIndices()
	{
		val moduleKo = parseHelper.parse(testModule +
			'''
			ℝ[2] orig = [0.0 , 0.0];
			ComputeOrig: orig[0+1] = 1.0;
			'''
		)
		Assert.assertNotNull(moduleKo)

		moduleKo.assertError(NablaPackage.eINSTANCE.argOrVarRef,
			BasicValidator::NO_OPERATION_IN_VAR_REF_INDICES,
			BasicValidator::getNoOperationInVarRefIndicesMsg())

		val moduleOk =  parseHelper.parse(testModule +
			'''
			ℝ[2] orig = [0.0 , 0.0];
			ComputeOrig: orig[0] = 1.0;
			'''
		)
		Assert.assertNotNull(moduleOk)
		moduleOk.assertNoErrors
	}
}
