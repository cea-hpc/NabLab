/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.tests.typeprovider

import com.google.inject.Inject
import com.google.inject.Provider
import fr.cea.nabla.ArgOrVarExtensions
import fr.cea.nabla.NablaModuleExtensions
import fr.cea.nabla.nabla.ConnectivityVar
import fr.cea.nabla.nabla.DefaultExtension
import fr.cea.nabla.nabla.Job
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NablaRoot
import fr.cea.nabla.nabla.Var
import fr.cea.nabla.tests.NablaInjectorProvider
import fr.cea.nabla.tests.TestUtils
import fr.cea.nabla.typing.ExpressionTypeProvider
import fr.cea.nabla.typing.NLATVector
import fr.cea.nabla.typing.NSTBoolScalar
import fr.cea.nabla.typing.NSTIntArray1D
import fr.cea.nabla.typing.NSTIntArray2D
import fr.cea.nabla.typing.NSTIntScalar
import fr.cea.nabla.typing.NSTRealArray1D
import fr.cea.nabla.typing.NSTRealArray2D
import fr.cea.nabla.typing.NSTRealScalar
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
	@Inject extension ArgOrVarExtensions
	@Inject extension NablaModuleExtensions
	@Inject extension TestUtils

	@Test
	def void testGetTypeFor()
	{
		val lightLinearAlgebraModel =
		'''
		linearalgebra extension LinearAlgebra;

		def <x> real[x] solveLinearSystem(real[x, x] a, real[x] b) return b;
		'''

		val nablaModel =
		'''
		module Test;

		with LinearAlgebra.*;
		with CartesianMesh2D.*;

		red real reduceMin(real.MaxValue) (a, b) : return a;

		def real[2] perp(real[2] a) return a;
		def <x> real norm(real[x] a) return 1.0;

		let real X_EDGE_LENGTH = 1.;
		let real Y_EDGE_LENGTH = X_EDGE_LENGTH;
		let int X_EDGE_ELEMS = 2;
		let int Y_EDGE_ELEMS = 2;
		let real option_stoptime = 0.1;
		let int option_max_iterations = 500;

		let int a1 = 1;
		let int a2 = 9 % 4;
		let int a3 = int.MinValue;
		let int[2] a4 = [1,1];
		let int[2] a5 = int[2](1);
		let int[2,2] a6 = int[2,2](1);
		let int a7 = a6[0,2];

		let bool b1 = true;
		let bool b2 = false || true;
		let bool b3 = false && true;
		let bool b4 = (a1 == 2);
		let bool b5 = (a1 != 2);
		let bool b6 = (a1 > 2);
		let bool b7 = (a1 >= 2);
		let bool b8 = (a1 <= 2);
		let bool b9 = (a1 < 2);
		let bool b10 = !(a1 < 2);

		let real c1 = 2.0 + 1.0;
		let real c2 = 2.0 - 1.0;
		let real c3 = 2.0 * 1.0;
		let real c4 = 2.0 / 1.0;
		let real c5 = -c1;
		let real c6 = real.MaxValue;
		let real c7 = 1.0e-10;

		let real[2] d1 = [1.0, 2.0];
		let real[2] d2 = perp(d1);
		let real[2] d3 = real[2](0.);

		let real[3] e = [1.0, 2.0, 3.0];

		let real[2,2] g = [ [1.0, 0.0], [0.0, 1.0] ];
		let real h = (a1 == 1 ? 0.0 : 1.0);

		real t;
		real[2] X{nodes};

		int s{cells};
		real u{cells}, v{cells};
		real[2] w{cells, nodesOfCell};
		real x{cells, nodesOfCell};
		real alpha{cells, cells}; 

		iterate n while (n < option_max_iterations);

		UpdateU: u^{n+1} = solveLinearSystem(alpha, u^{n});

		ComputeV: forall j in cells(), v{j} = reduceMin{r in nodesOfCell(j)}(x{j,r} + s{j});

		ComputeX: forall  j in cells(), {
			let real ee = 1.0;
			u^{n}{j} = ee * 4;
			forall r in nodesOfCell(j), x{j,r} = norm(w{j,r});
		}
		'''

		val rs = resourceSetProvider.get
		parseHelper.parse(readFileAsString(TestUtils.CartesianMesh2DPath), rs)
		val linearAlgebraExt = parseHelper.parse(lightLinearAlgebraModel, rs) as DefaultExtension
		val module = parseHelper.parse(nablaModel, rs) as NablaModule
		Assert.assertNotNull(module)
		Assert.assertEquals(0, module.validate.filter(i | i.severity == Severity.ERROR).size)

		val xVar = module.getVarByName("x") as ConnectivityVar
		val cells = xVar.supports.get(0)
		val updateU = module.getJobByName("UpdateU")
		val computeV = module.getJobByName("ComputeV")
		val computeX = module.getJobByName("ComputeX")

		assertDefaultValue(new NSTIntScalar, module.getVarByName("a1"))
		assertDefaultValue(new NSTIntScalar, module.getVarByName("a2"))
		assertDefaultValue(new NSTIntScalar, module.getVarByName("a3"))
		assertDefaultValue(new NSTIntArray1D(createIntConstant(2), 2), module.getVarByName("a4"))
		assertDefaultValue(new NSTIntArray1D(createIntConstant(2), 2), module.getVarByName("a5"))
		assertDefaultValue(new NSTIntArray2D(createIntConstant(2), createIntConstant(2), 2, 2), module.getVarByName("a6"))
		assertDefaultValue(new NSTIntScalar, module.getVarByName("a7"))

		assertDefaultValue(new NSTBoolScalar, module.getVarByName("b1"))
		assertDefaultValue(new NSTBoolScalar, module.getVarByName("b2"))
		assertDefaultValue(new NSTBoolScalar, module.getVarByName("b3"))
		assertDefaultValue(new NSTBoolScalar, module.getVarByName("b4"))
		assertDefaultValue(new NSTBoolScalar, module.getVarByName("b5"))
		assertDefaultValue(new NSTBoolScalar, module.getVarByName("b6"))
		assertDefaultValue(new NSTBoolScalar, module.getVarByName("b7"))
		assertDefaultValue(new NSTBoolScalar, module.getVarByName("b8"))
		assertDefaultValue(new NSTBoolScalar, module.getVarByName("b9"))
		assertDefaultValue(new NSTBoolScalar, module.getVarByName("b10"))

		assertDefaultValue(new NSTRealScalar, module.getVarByName("c1"))
		assertDefaultValue(new NSTRealScalar, module.getVarByName("c2"))
		assertDefaultValue(new NSTRealScalar, module.getVarByName("c3"))
		assertDefaultValue(new NSTRealScalar, module.getVarByName("c4"))
		assertDefaultValue(new NSTRealScalar, module.getVarByName("c5"))
		assertDefaultValue(new NSTRealScalar, module.getVarByName("c6"))
		assertDefaultValue(new NSTRealScalar, module.getVarByName("c7"))

		assertDefaultValue(new NSTRealArray1D(createIntConstant(2), 2), module.getVarByName("d1"))
		assertDefaultValue(new NSTRealArray1D(createIntConstant(2), 2), module.getVarByName("d2"))
		assertDefaultValue(new NSTRealArray1D(createIntConstant(2), 2), module.getVarByName("d3"))

		assertDefaultValue(new NSTRealArray1D(createIntConstant(3), 3), module.getVarByName("e"))

		assertDefaultValue(new NSTRealArray2D(createIntConstant(2), createIntConstant(2), 2, 2), module.getVarByName("g"))
		assertDefaultValue(new NSTRealScalar, module.getVarByName("h"))

		assertAffectation(new NLATVector(linearAlgebraExt, createCardExpression(cells), -1), updateU, module.getVarByName("u"))

		assertAffectation(new NSTRealScalar, computeV, module.getVarByName("v"))

		assertDefaultValue(new NSTRealScalar, computeX.eAllContents.filter(Var).findFirst[x | x.name == "ee"])
		assertAffectation(new NSTRealScalar, computeX, module.getVarByName("u"))
		assertAffectation(new NSTRealScalar, computeX, module.getVarByName("x"))
	}

	private def assertDefaultValue(NablaType expectedType, Var variable)
	{
		Assert.assertNotNull(variable)
		Assert.assertNotNull(variable.value)
		Assert.assertEquals(expectedType, variable.value.typeFor)
	}

	private def assertAffectation(NablaType expectedType, Job job, Var variable)
	{
		val affectation = job.getVarAffectationByName(variable.name)
		Assert.assertNotNull(affectation)
		Assert.assertEquals(expectedType, affectation.left.typeFor)
		Assert.assertEquals(expectedType, affectation.right.typeFor)
	}
}