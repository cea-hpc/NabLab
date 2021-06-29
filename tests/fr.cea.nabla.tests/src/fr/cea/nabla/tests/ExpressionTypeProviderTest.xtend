/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.tests

import com.google.inject.Inject
import com.google.inject.Provider
import fr.cea.nabla.ArgOrVarExtensions
import fr.cea.nabla.NablaModuleExtensions
import fr.cea.nabla.nabla.Affectation
import fr.cea.nabla.nabla.ConnectivityVar
import fr.cea.nabla.nabla.DefaultExtension
import fr.cea.nabla.nabla.Job
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NablaRoot
import fr.cea.nabla.nabla.Var
import fr.cea.nabla.typing.ArgOrVarTypeProvider
import fr.cea.nabla.typing.ExpressionTypeProvider
import fr.cea.nabla.typing.NLATMatrix
import fr.cea.nabla.typing.NLATVector
import fr.cea.nabla.typing.NSTBoolScalar
import fr.cea.nabla.typing.NSTIntArray1D
import fr.cea.nabla.typing.NSTIntArray2D
import fr.cea.nabla.typing.NSTIntScalar
import fr.cea.nabla.typing.NSTRealArray1D
import fr.cea.nabla.typing.NSTRealArray2D
import fr.cea.nabla.typing.NSTRealScalar
import fr.cea.nabla.typing.NablaConnectivityType
import fr.cea.nabla.typing.NablaType
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.xtext.diagnostics.Severity
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
	@Inject Provider<ResourceSet> resourceSetProvider
	@Inject ParseHelper<NablaRoot> parseHelper
	@Inject extension ValidationTestHelper
	@Inject extension ExpressionTypeProvider
	@Inject extension ArgOrVarTypeProvider
	@Inject extension ArgOrVarExtensions
	@Inject extension NablaModuleExtensions
	@Inject extension TestUtils

	val lightLinearAlgebraModel =
	'''
	linearalgebra extension LinearAlgebra;

	def solveLinearSystem: x | ℝ[x, x] × ℝ[x] → ℝ[x], (a, b) → return b;
	'''

	val nablaModel =
	'''
	module Test;

	with LinearAlgebra.*;
	with CartesianMesh2D.*;

	def reduceMin, ℝ.MaxValue: ℝ, (a, b) → return a;

	def perp: ℝ[2] → ℝ[2], (a) → return a;
	def norm: x | ℝ[x] → ℝ, (a) → return 1.0;

	option ℝ X_EDGE_LENGTH = 1.;
	option ℝ Y_EDGE_LENGTH = X_EDGE_LENGTH;
	option ℕ X_EDGE_ELEMS = 2;
	option ℕ Y_EDGE_ELEMS = 2;
	option ℝ option_stoptime = 0.1;
	option ℕ option_max_iterations = 500;

	let ℕ a1 = 1;
	let ℕ a2 = 9 % 4;
	let ℕ a3 = ℕ.MinValue;
	let ℕ[2] a4 = [1,1];
	let ℕ[2] a5 = ℕ[2](1);
	let ℕ[2,2] a6 = ℕ[2,2](1);
	let ℕ a7 = a6[0,2];

	let ℾ b1 = true;
	let ℾ b2 = false || true;
	let ℾ b3 = false && true;
	let ℾ b4 = (a1 == 2);
	let ℾ b5 = (a1 != 2);
	let ℾ b6 = (a1 > 2);
	let ℾ b7 = (a1 >= 2);
	let ℾ b8 = (a1 <= 2);
	let ℾ b9 = (a1 < 2);
	let ℾ b10 = !(a1 < 2);

	let ℝ c1 = 2.0 + 1.0;
	let ℝ c2 = 2.0 - 1.0;
	let ℝ c3 = 2.0 * 1.0;
	let ℝ c4 = 2.0 / 1.0;
	let ℝ c5 = -c1;
	let ℝ c6 = ℝ.MaxValue;
	let ℝ c7 = 1.0e-10;

	let ℝ[2] d1 = [1.0, 2.0];
	let ℝ[2] d2 = perp(d1);
	let ℝ[2] d3 = ℝ[2](0.);

	let ℝ[3] e = [1.0, 2.0, 3.0];

	let ℝ[2,2] g = [ [1.0, 0.0], [0.0, 1.0] ];
	let ℝ h = (a1 == 1 ? 0.0 : 1.0);

	ℕ i1;
	ℕ[2] i2;

	ℝ t;
	ℝ[2] X{nodes};

	ℕ s{cells};
	ℝ u{cells}, v{cells};
	ℝ[2] w{cells, nodesOfCell};
	ℝ x{cells, nodesOfCell};
	ℝ α{cells, cells}; 

	iterate n while (n < option_max_iterations);

	UpdateU: u^{n+1} = solveLinearSystem(α, u^{n});

	ComputeV: ∀j∈cells(), v{j} = reduceMin{r∈nodesOfCell(j)}(x{j,r} + s{j});

	ComputeX: ∀ j∈cells(), {
		let ℝ ee = 1.0;
		u^{n}{j} = ee * 4;
		∀r∈nodesOfCell(j), x{j,r} = norm(w{j,r});
	}
	'''

	//TODO : add a BinaryOperationsTypeProviderTest to cover all cases
	@Test
	def void testGetTypeFor()
	{
		val rs = resourceSetProvider.get
		parseHelper.parse(readFileAsString(TestUtils.CartesianMesh2DPath), rs)
		val linearAlgebraExt = parseHelper.parse(lightLinearAlgebraModel, rs) as DefaultExtension
		val module = parseHelper.parse(nablaModel, rs) as NablaModule
		Assert.assertNotNull(module)
		Assert.assertEquals(0, module.validate.filter(i | i.severity == Severity.ERROR).size)

		val xVar = module.getVariableByName("x") as ConnectivityVar
 		val cells = xVar.supports.get(0)
 		val nodesOfCell = xVar.supports.get(1)
		val computeV = module.getJobByName("ComputeV")
		val computeX = module.getJobByName("ComputeX")

		assertTypesFor(new NSTIntScalar, module, "a1")
		assertTypesFor(new NSTIntScalar, module, "a2")
		assertTypesFor(new NSTIntScalar, module, "a3")
		assertTypesFor(new NSTIntArray1D(createIntConstant(2)), module, "a4")
		assertTypesFor(new NSTIntArray1D(createIntConstant(2)), module, "a5")
		assertTypesFor(new NSTIntArray2D(createIntConstant(2), createIntConstant(2)), module, "a6")
		assertTypesFor(new NSTIntScalar, module, "a7")

		assertTypesFor(new NSTBoolScalar, module, "b1")
		assertTypesFor(new NSTBoolScalar, module, "b2")
		assertTypesFor(new NSTBoolScalar, module, "b3")
		assertTypesFor(new NSTBoolScalar, module, "b4")
		assertTypesFor(new NSTBoolScalar, module, "b5")
		assertTypesFor(new NSTBoolScalar, module, "b6")
		assertTypesFor(new NSTBoolScalar, module, "b7")
		assertTypesFor(new NSTBoolScalar, module, "b8")
		assertTypesFor(new NSTBoolScalar, module, "b9")
		assertTypesFor(new NSTBoolScalar, module, "b10")

		assertTypesFor(new NSTRealScalar, module, "c1")
		assertTypesFor(new NSTRealScalar, module, "c2")
		assertTypesFor(new NSTRealScalar, module, "c3")
		assertTypesFor(new NSTRealScalar, module, "c4")
		assertTypesFor(new NSTRealScalar, module, "c5")
		assertTypesFor(new NSTRealScalar, module, "c6")
		assertTypesFor(new NSTRealScalar, module, "c7")

		assertTypesFor(new NSTRealArray1D(createIntConstant(2)), module, "d1")
		assertTypesFor(new NSTRealArray1D(createIntConstant(2)), module, "d2")
		assertTypesFor(new NSTRealArray1D(createIntConstant(2)), module, "d3")

		assertTypesFor(new NSTRealArray1D(createIntConstant(3)), module, "e")

		assertTypesFor(new NSTRealArray2D(createIntConstant(2), createIntConstant(2)), module, "g")
		assertTypesFor(new NSTRealScalar, module, "h")

		assertTypesFor(new NSTIntScalar, module, "i1")
		assertTypesFor(new NSTIntArray1D(createIntConstant(2)), module, "i2")

		assertTypesFor(new NablaConnectivityType(#[cells], new NSTIntScalar), module, "s")

		assertTypesFor(new NablaConnectivityType(#[cells], new NSTRealScalar), module, "v")
		assertTypesFor(new NablaConnectivityType(#[cells, nodesOfCell], new NSTRealArray1D(createIntConstant(2))), module, "w")
		assertTypesFor(new NablaConnectivityType(#[cells, nodesOfCell], new NSTRealScalar), module, "x")

		assertTypesFor(new NLATMatrix(linearAlgebraExt, createCardExpression(cells), createCardExpression(cells)), module, "α")
		assertTypesFor(new NLATVector(linearAlgebraExt, createCardExpression(cells)), module, "u")

		assertTypesFor(new NSTRealScalar, computeV, "v")

		assertTypesFor(new NSTRealScalar, computeX, "ee")
		assertTypesFor(new NSTRealScalar, computeX, "u")
		assertTypesFor(new NSTRealScalar, computeX, "x")
	}

	private def assertTypesFor(NablaType expectedType, NablaModule module, String varName)
	{
		val variable = module.getVariableByName(varName)
		Assert.assertNotNull(variable)
		assertTypesFor(expectedType, variable)
	}

	private def assertTypesFor(NablaType expectedType, Job job, String varName, boolean affectationRHSDefined)
	{
		val variable = job.getVarByName(varName)
		val affectation = job.getVarAffectationByName(varName)
		Assert.assertTrue(variable !== null || affectation !== null)
		if (variable !== null)
			assertTypesFor(expectedType, variable)
		if (affectation !== null)
		{
			if (affectationRHSDefined)
				assertTypesFor(expectedType, affectation)
			else
				Assert.assertNull(affectation.right.typeFor)
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
		if (variable.value !== null)
			Assert.assertEquals(expectedType, variable.value.typeFor)
	}

	private def assertTypesFor(NablaType expectedType, Affectation affectation)
	{
		// We test both variable type and expression type
		Assert.assertEquals(expectedType, affectation.left.typeFor)
		Assert.assertEquals(expectedType, affectation.right.typeFor)
	}
}