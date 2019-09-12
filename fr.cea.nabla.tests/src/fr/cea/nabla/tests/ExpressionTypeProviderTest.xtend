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
import fr.cea.nabla.nabla.Job
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.Var
import fr.cea.nabla.typing.ExpressionTypeProvider
import fr.cea.nabla.typing.NTBoolScalar
import fr.cea.nabla.typing.NTConnectivityType
import fr.cea.nabla.typing.NTIntArray1D
import fr.cea.nabla.typing.NTIntArray2D
import fr.cea.nabla.typing.NTIntScalar
import fr.cea.nabla.typing.NTRealArray1D
import fr.cea.nabla.typing.NTRealArray2D
import fr.cea.nabla.typing.NTRealScalar
import fr.cea.nabla.typing.NablaType
import fr.cea.nabla.typing.VarTypeProvider
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(XtextRunner)
@InjectWith(NablaInjectorProvider)
class ExpressionTypeProviderTest 
{
	@Inject extension ParseHelper<NablaModule>
	@Inject extension ValidationTestHelper
	@Inject extension ExpressionTypeProvider
	@Inject extension VarTypeProvider
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
		solveLinearSystem: x | ℝ[x, x] × ℝ[x] → ℝ[x];
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
	ℕ[2] a5;
	ℕ[2] a6 = [1,1];
	ℕ[2] a7 = ℕ[2](1);
	ℕ[2,2] a8;
	ℕ a9 = a8[0,2];
	
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
	const ℝ c7 = 1.0e-10;
	
	ℝ[2] d1 = [1.0, 2.0];
	ℝ[2] d2 = perp(d1);
	ℝ[2] d3 = ℝ[2](0.);
	
	ℝ[3] e = [1.0, 2.0, 3.0];
	
	
	ℝ[2,2] g = [ [1.0, 0.0], [0.0, 1.0] ];
	ℝ h = (a1 == 1 ? 0.0 : 1.0);
	
	ℕ t{cells};
	ℝ u{cells}, v{cells};
	ℝ[2] w{cells, nodesOfCell};
	ℝ x{cells, nodesOfCell};
	ℝ α{cells, cells}; 
	
	UpdateU: u^{n+1} = solveLinearSystem(α, u);
	
	ComputeV: ∀j∈cells(), v{j} = reduceMin{r∈nodesOfCell(j)}(x{j,r} + t{j});

	ComputeX: ∀ j∈cells(), {
		ℝ e = 1.0;
		u{j} = e * 4; 
		∀r∈nodesOfCell(j), x{j,r} = norm(w{j,r});
	}
	'''

	@Test 
	def testCorrectParsing()
	{
		model.parse.assertNoErrors
	}
		
	//TODO : Ajouter un BinaryOperationsTypeProviderTest pour tester tous les cas
	@Test 
	def void testGetTypeFor() 
	{
 		val module = model.parse
 		val cells = module.getConnectivityByName("cells")
 		val nodesOfCell = module.getConnectivityByName("nodesOfCell")
		val updateU = module.getJobByName("UpdateU")
		val computeV = module.getJobByName("ComputeV")
		val computeX = module.getJobByName("ComputeX")

		assertTypesFor(new NTIntScalar, module, "a1")
		assertTypesFor(new NTIntScalar, module, "a2")
		assertTypesFor(new NTIntScalar, module, "a3")
		assertTypesFor(new NTIntScalar, module, "a4")
		assertTypesFor(new NTIntArray1D(2), module, "a5")
		assertTypesFor(new NTIntArray1D(2), module, "a6")
		assertTypesFor(new NTIntArray1D(2), module, "a7")
		assertTypesFor(new NTIntArray2D(2,2), module, "a8")
		assertTypesFor(new NTIntScalar, module, "a9")

		assertTypesFor(new NTBoolScalar, module, "b1")
		assertTypesFor(new NTBoolScalar, module, "b2")
		assertTypesFor(new NTBoolScalar, module, "b3")
		assertTypesFor(new NTBoolScalar, module, "b4")
		assertTypesFor(new NTBoolScalar, module, "b5")
		assertTypesFor(new NTBoolScalar, module, "b6")
		assertTypesFor(new NTBoolScalar, module, "b7")
		assertTypesFor(new NTBoolScalar, module, "b8")
		assertTypesFor(new NTBoolScalar, module, "b9")
		assertTypesFor(new NTBoolScalar, module, "b10")		

		assertTypesFor(new NTRealScalar, module, "c1")
		assertTypesFor(new NTRealScalar, module, "c2")
		assertTypesFor(new NTRealScalar, module, "c3")
		assertTypesFor(new NTRealScalar, module, "c4")
		assertTypesFor(new NTRealScalar, module, "c5")
		assertTypesFor(new NTRealScalar, module, "c6")
		assertTypesFor(new NTRealScalar, module, "c7")		

		assertTypesFor(new NTRealArray1D(2), module, "d1")
		assertTypesFor(new NTRealArray1D(2), module, "d2")
		assertTypesFor(new NTRealArray1D(2), module, "d3")

		assertTypesFor(new NTRealArray1D(3), module, "e")

		assertTypesFor(new NTRealArray2D(2,2), module, "g")
		assertTypesFor(new NTRealScalar, module, "h")
				
		assertTypesFor(new NTConnectivityType(#[cells], new NTIntScalar), module, "t")
		assertTypesFor(new NTConnectivityType(#[cells], new NTRealScalar), module, "u")
		assertTypesFor(new NTConnectivityType(#[cells], new NTRealScalar), module, "v")
		assertTypesFor(new NTConnectivityType(#[cells, nodesOfCell], new NTRealArray1D(2)), module, "w")
		assertTypesFor(new NTConnectivityType(#[cells, nodesOfCell], new NTRealScalar), module, "x")
		assertTypesFor(new NTConnectivityType(#[cells, cells], new NTRealScalar), module, "α")

		assertTypesFor(new NTConnectivityType(#[cells], new NTRealScalar), updateU, "u")

		assertTypesFor(new NTRealScalar, computeV, "v")
				
		assertTypesFor(new NTRealScalar, computeX, "e")
		assertTypesFor(new NTRealScalar, computeX, "u")
		assertTypesFor(new NTRealScalar, computeX, "x")
	}
					
	private def assertTypesFor(NablaType expectedType, NablaModule module, String varName)	
	{
		val variable = module.getVariableByName(varName)
		Assert.assertNotNull(variable)
		assertTypesFor(expectedType, variable)
	}

	private def assertTypesFor(NablaType expectedType, Job job, String varName, boolean affectationRHSDefined)	
	{
		val variable = job.getVariableByName(varName)
		val affectation = job.getVarAffectationByName(varName) 
		Assert.assertTrue(variable !== null || affectation !== null)
		if (variable !== null)
			assertTypesFor(expectedType, variable)
		if (affectation !== null)
		{
			if (affectationRHSDefined)
				assertTypesFor(expectedType, affectation)						
			else
				Assert.assertNull(affectation.expression.typeFor)
		}	
	}

	private def assertTypesFor(NablaType expectedType, Job job, String varName)
	{
		assertTypesFor(expectedType, job, varName, true)
	}	

	private def assertTypesFor(NablaType expectedType, Var variable)	
	{
		// We test both variable type and default value type
		Assert.assertEquals(expectedType, variable.typeFor)
		if (variable.defaultValue !== null)
			Assert.assertEquals(expectedType, variable.defaultValue.typeFor)
	}

	private def assertTypesFor(NablaType expectedType, Affectation affectation)	
	{
		// We test both variable type and expression type
		Assert.assertEquals(expectedType, affectation.varRef.typeFor)
		Assert.assertEquals(expectedType, affectation.expression.typeFor)
	}
}