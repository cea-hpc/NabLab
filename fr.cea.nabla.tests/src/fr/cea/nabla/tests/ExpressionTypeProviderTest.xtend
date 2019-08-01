/*******************************************************************************
 * Copyright (c) 2018 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.tests

import com.google.inject.Inject
import fr.cea.nabla.JobExtensions
import fr.cea.nabla.NablaModuleExtensions
import fr.cea.nabla.VarExtensions
import fr.cea.nabla.nabla.Affectation
import fr.cea.nabla.nabla.Connectivity
import fr.cea.nabla.nabla.Job
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.PrimitiveType
import fr.cea.nabla.nabla.Var
import fr.cea.nabla.typing.ExpressionTypeProvider
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(XtextRunner)
@InjectWith(NablaInjectorProvider)
class ExpressionTypeProviderTest 
{
	@Inject extension ParseHelper<NablaModule>
	@Inject extension ValidationTestHelper
	@Inject extension ExpressionTypeProvider
	@Inject extension VarExtensions
	@Inject extension NablaModuleExtensions
	@Inject extension JobExtensions
	
	val model = 
	'''
	module Test;
	
	items { node, cell }
	
	connectivities 
	{
		cells: → {cell};
		nodesOfCell: cell → {node};
	}
	
	functions 
	{
		perp: ℝ[2] → ℝ[2];
		norm: x | ℝ[x] → ℝ;
		reduceMin: (ℝ.MaxValue, ℝ)→ℝ;
	}
	
	const ℝ X_EDGE_LENGTH = 1.;
	const ℝ Y_EDGE_LENGTH = X_EDGE_LENGTH;
	const ℕ X_EDGE_ELEMS = 2;
	const ℕ Y_EDGE_ELEMS = 2;
	const ℕ Z_EDGE_ELEMS = 1;
	const ℝ option_stoptime = 0.1;
	const ℕ option_max_iterations = 500;
	
	ℕ a1 = 1;
	ℕ a2 = 9 % 4;
	ℕ a3 = ℕ.MinValue;
	ℕ a4;
	ℾ b1 = true;
	ℾ b2 = false || true;
	ℾ b3 = false && true;
	ℾ b4 = (a1 == 2);
	ℾ b5 = (a1 != 2);
	ℾ b6 = (a1 > 2);
	ℾ b7 = (a1 >= 2);
	ℾ b8 = (a1 <= 2);
	ℾ b9 = (a1 < 2);
	ℾ b10 = !(a1 < 2);	
	ℝ c1 = 2.0 + 1.0;
	ℝ c2 = 2.0 - 1.0;
	ℝ c3 = 2.0 * 1.0;
	ℝ c4 = 2.0 / 1.0;		
	ℝ c5 = -c1;		
	ℝ c6 = ℝ.MaxValue;		
	ℝ[2] d1 = [1.0, 2.0];
	ℝ[2] d2 = perp(d1);
	ℝ[3] e = [1.0, 2.0, 3.0];
	const ℝ f = 1.0e-10;
	ℝ[2,2] g = [ [1.0, 0.0], [0.0, 1.0] ];
	//ℝ h = (a1 == 1 ? 0.0 : 1.0);
	
	ℝ u{cells}, v{cells};
	ℝ[2] w{cells, nodesOfCell};
	ℝ x{cells, nodesOfCell};
	
		
	j1: ∀ j∈cells(), {
		ℝ e = 1.0;
		u{j} = e * 4; 
		∀r∈nodesOfCell(j), x{j,r} = norm(w{j,r});
	}
	
	ComputeX: ∀j∈cells(), v{j} = reduceMin{r∈nodesOfCell(j)}(x{j,r});
	'''
	
	@Test 
	def testCorrectParsing()
	{
		model.parse.assertNoErrors
	}
	
	@Test 
	def void testGetTypeForExpression() 
	{
 		val module = model.parse
 		val cells = module.getConnectivityByName("cells")
 		val nodesOfCell = module.getConnectivityByName("nodesOfCell")
		val j1Loop = module.getJobByName("j1")

		assertTypesFor(PrimitiveType::INT, #[], #[], module, "a1")
		assertTypesFor(PrimitiveType::INT, #[], #[], module, "a2")
		assertTypesFor(PrimitiveType::INT, #[], #[], module, "a3")
		assertTypesFor(PrimitiveType::INT, #[], #[], module, "a4")
		assertTypesFor(PrimitiveType::BOOL, #[], #[], module, "b1")
		assertTypesFor(PrimitiveType::BOOL, #[], #[], module, "b2")
		assertTypesFor(PrimitiveType::BOOL, #[], #[], module, "b3")
		assertTypesFor(PrimitiveType::BOOL, #[], #[], module, "b4")
		assertTypesFor(PrimitiveType::BOOL, #[], #[], module, "b5")
		assertTypesFor(PrimitiveType::BOOL, #[], #[], module, "b6")
		assertTypesFor(PrimitiveType::BOOL, #[], #[], module, "b7")
		assertTypesFor(PrimitiveType::BOOL, #[], #[], module, "b8")
		assertTypesFor(PrimitiveType::BOOL, #[], #[], module, "b9")
		assertTypesFor(PrimitiveType::BOOL, #[], #[], module, "b10")		
		assertTypesFor(PrimitiveType::REAL, #[], #[], module, "c1")
		assertTypesFor(PrimitiveType::REAL, #[], #[], module, "c2")
		assertTypesFor(PrimitiveType::REAL, #[], #[], module, "c3")
		assertTypesFor(PrimitiveType::REAL, #[], #[], module, "c4")
		assertTypesFor(PrimitiveType::REAL, #[], #[], module, "c5")
		assertTypesFor(PrimitiveType::REAL, #[], #[], module, "c6")
		assertTypesFor(PrimitiveType::REAL, #[2], #[], module, "d1")
		assertTypesFor(PrimitiveType::REAL, #[2], #[], module, "d2")
		assertTypesFor(PrimitiveType::REAL, #[3], #[], module, "e")
		assertTypesFor(PrimitiveType::REAL, #[], #[], module, "f")		
		assertTypesFor(PrimitiveType::REAL, #[2,2], #[], module, "g")
		//TODO Bug à corriger
		//assertTypesFor(PrimitiveType::REAL, #[], #[], module, "h")
		//TODO Pourquoi ne type ne renvoit-il pas les connectivités
		//assertTypesFor(PrimitiveType::REAL, #[], #[cells], module, "u")
		//assertTypesFor(PrimitiveType::REAL, #[], #[cells], module, "v")
		//assertTypesFor(PrimitiveType::REAL, #[2], #[cells, nodesOfCell], module, "w")
		//assertTypesFor(PrimitiveType::REAL, #[], #[cells, nodesOfCell], module, "x")
				
		assertTypesFor(PrimitiveType::REAL, #[], #[], j1Loop, "e")
		//TODO Est-ce normal ?
		assertTypesFor(PrimitiveType::REAL, #[], #[], j1Loop, "u")
		assertTypesFor(PrimitiveType::REAL, #[], #[], j1Loop, "v")
		assertTypesFor(PrimitiveType::REAL, #[2], #[], j1Loop, "w")
		assertTypesFor(PrimitiveType::REAL, #[], #[], j1Loop, "x")
	}
					
	private def assertTypesFor(PrimitiveType expectedRoot, int[] expectedSizes, Connectivity[] expectedConnectivities, NablaModule it, String varName)	
	{
		val variable = allVars.findFirst[v | v.name == varName]
		if (variable !== null)
			assertTypesFor(expectedRoot, expectedSizes, expectedConnectivities, variable)
	}

	private def assertTypesFor(PrimitiveType expectedRoot, int[] expectedSizes, Connectivity[] expectedConnectivities, Job it, String varName)	
	{
		val variable = allVars.findFirst[v | v.name == varName]
		if (variable !== null)
			assertTypesFor(expectedRoot, expectedSizes, expectedConnectivities, variable)
		val affectation =  allAffectations.findFirst[a | a.varRef.variable.name == varName]
		if (affectation !== null)
			assertTypesFor(expectedRoot, expectedSizes, expectedConnectivities, affectation)			
	}

	private def assertTypesFor(PrimitiveType expectedRoot, int[] expectedSizes, Connectivity[] expectedConnectivities, Var variable)	
	{
		// We test both variable type and default value type
		println("Var " + variable.name + " - baseType = " + variable.baseType.root + variable.baseType.sizes.toString + " -> " + variable.baseType.typeFor.label)
		TestUtils.assertEquals(expectedRoot, expectedSizes, expectedConnectivities, variable.baseType.typeFor)
		if (variable.defaultValue !== null)
			TestUtils.assertEquals(expectedRoot, expectedSizes, expectedConnectivities, variable.defaultValue.typeFor)
	}

	private def assertTypesFor(PrimitiveType expectedRoot, int[] expectedSizes, Connectivity[] expectedConnectivities, Affectation affectation)	
	{
		// We test both variable type and expression type
		TestUtils.assertEquals(expectedRoot, expectedSizes, expectedConnectivities, affectation.varRef.typeFor)
		TestUtils.assertEquals(expectedRoot, expectedSizes, expectedConnectivities, affectation.expression.typeFor)
	}

	private def getJobByName(NablaModule it, String jobName)
	{
		jobs.findFirst[j | j.name == jobName]
	}
	
	private def getConnectivityByName(NablaModule it, String connectivityName)
	{
		connectivities.findFirst[c | c.name == connectivityName]
	}
}