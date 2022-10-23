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
import fr.cea.nabla.NablaModuleExtensions
import fr.cea.nabla.nabla.ConnectivityVar
import fr.cea.nabla.nabla.DefaultExtension
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.nabla.NablaRoot
import fr.cea.nabla.nabla.Var
import fr.cea.nabla.nabla.VarDeclaration
import fr.cea.nabla.tests.NablaInjectorProvider
import fr.cea.nabla.tests.TestUtils
import fr.cea.nabla.typing.ArgOrVarTypeProvider
import fr.cea.nabla.typing.NLATMatrix
import fr.cea.nabla.typing.NLATVector
import fr.cea.nabla.typing.NSTBoolArray1D
import fr.cea.nabla.typing.NSTBoolArray2D
import fr.cea.nabla.typing.NSTBoolScalar
import fr.cea.nabla.typing.NSTIntArray1D
import fr.cea.nabla.typing.NSTIntArray2D
import fr.cea.nabla.typing.NSTIntScalar
import fr.cea.nabla.typing.NSTRealArray1D
import fr.cea.nabla.typing.NSTRealArray2D
import fr.cea.nabla.typing.NSTRealScalar
import fr.cea.nabla.typing.NablaConnectivityType
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.xtext.diagnostics.Severity
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith
import org.eclipse.xtext.validation.Issue

/**
 * Test ArgOrVarTypeProvider class.
 * Variables are created with no default value.
 * Default values are expressions. They are tested in ExpressionTypeProviderTest.
 */
@RunWith(XtextRunner)
@InjectWith(NablaInjectorProvider)
class ArgOrVarTypeProviderTest
{
	@Inject Provider<ResourceSet> resourceSetProvider
	@Inject ParseHelper<NablaRoot> parseHelper
	@Inject extension ValidationTestHelper
	@Inject extension ArgOrVarTypeProvider
	@Inject extension NablaModuleExtensions
	@Inject extension TestUtils

	@Test
	def void testArgOrVarTypeProvider()
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

		def <x> real norm(real[x] a) return 1.0;

		// bool scalar
		bool b;
		let bool optb = false;

		// int scalar
		int i;
		let int opti = 3;

		// real scalar
		real r;
		let real optr = 3.3;

		// bool array 1D
		bool[2] tabb;
		let bool[3] opttabb = [ true, false, true ];

		// int array 1D
		int[2] tabi;
		let int[3] opttabi = [ 3, 4, 5 ];

		// real array 1D
		real[2] tabr;
		let real[3] opttabr = [ 1.1, 2.2, 3.3 ];

		// bool array 2D
		bool[2, 3] tab2b;
		let bool[3, 2] opttab2b = [ [true, false], [true, false], [true, false] ];

		// int array 2D
		int[2, 3] tab2i;
		let int[3, 2] opttab2i = [ [1, 2], [3, 4], [5, 6] ];

		// real array 2D
		real[2, 3] tab2r;
		let real[3, 2] opttab2r = [ [1.1, 2.2], [3.3, 4.4], [5.5, 6.6] ];

		// array with size from a const
		let int dim = 6;
		real[dim] dimtab;

		// dynamic array not allowed on global variables
		// except with options
		int dyndimopt;
		real[dyndimopt] dyndimtabopt;

		// connectivity variables
		real[2] X{nodes};
		real pressure{cells};
		real Cjr{cells, nodesOfCell};
		real[2] w{cells, nodesOfCell};

		// linear algebra
		real u{cells};
		real alpha{cells, cells};

		iterate n while (true);

		UpdateU: u^{n+1} = solveLinearSystem(alpha, u^{n});

		// local variable
		ComputeX: forall  j in cells(), {
			let real ee = 1.0;
			u^{n}{j} = ee * 4;
			forall r in nodesOfCell(j), Cjr{j,r} = norm(w{j,r});
		}

		TestSpaceIteratorIndex: forall r, spaceIteratorIndex in nodes(), X{r}[spaceIteratorIndex] = 0.0;
		TestIntervalIndex: forall r in nodes(), forall intervalIndex in [0;2[, X{r}[intervalIndex] = 0.0;
		'''

		val rs = resourceSetProvider.get
		parseHelper.parse(readFileAsString(TestUtils.CartesianMesh2DPath), rs)
		val linearAlgebraExt = parseHelper.parse(lightLinearAlgebraModel, rs) as DefaultExtension
		val module = parseHelper.parse(nablaModel, rs) as NablaModule
		Assert.assertNotNull(module)
		for(Issue iss : module.validate){
			if(iss.severity == Severity.ERROR)
				println(
					iss.toString
				)
		}
		Assert.assertEquals(0, module.validate.filter(i | i.severity == Severity.ERROR).size)

		// bool scalar
		Assert.assertEquals(new NSTBoolScalar, module.getVarByName("b").typeFor)
		Assert.assertEquals(new NSTBoolScalar, module.getVarByName("optb").typeFor)

		// int scalar
		Assert.assertEquals(new NSTIntScalar, module.getVarByName("i").typeFor)
		Assert.assertEquals(new NSTIntScalar, module.getVarByName("opti").typeFor)

		// real scalar
		Assert.assertEquals(new NSTRealScalar, module.getVarByName("r").typeFor)
		Assert.assertEquals(new NSTRealScalar, module.getVarByName("optr").typeFor)

		// bool array 1D
		Assert.assertEquals(new NSTBoolArray1D(createIntConstant(2), 2), module.getVarByName("tabb").typeFor)
		Assert.assertEquals(new NSTBoolArray1D(createIntConstant(3), 3), module.getVarByName("opttabb").typeFor)

		// int array 1D
		Assert.assertEquals(new NSTIntArray1D(createIntConstant(2), 2), module.getVarByName("tabi").typeFor)
		Assert.assertEquals(new NSTIntArray1D(createIntConstant(3), 3), module.getVarByName("opttabi").typeFor)

		// real array 1D
		Assert.assertEquals(new NSTRealArray1D(createIntConstant(2), 2), module.getVarByName("tabr").typeFor)
		Assert.assertEquals(new NSTRealArray1D(createIntConstant(3), 3), module.getVarByName("opttabr").typeFor)

		// bool array 2D
		Assert.assertEquals(new NSTBoolArray2D(createIntConstant(2), createIntConstant(3), 2, 3), module.getVarByName("tab2b").typeFor)
		Assert.assertEquals(new NSTBoolArray2D(createIntConstant(3), createIntConstant(2), 3, 2), module.getVarByName("opttab2b").typeFor)

		// int array 2D
		Assert.assertEquals(new NSTIntArray2D(createIntConstant(2), createIntConstant(3), 2, 3), module.getVarByName("tab2i").typeFor)
		Assert.assertEquals(new NSTIntArray2D(createIntConstant(3), createIntConstant(2), 3, 2), module.getVarByName("opttab2i").typeFor)

		// real array 2D
		Assert.assertEquals(new NSTRealArray2D(createIntConstant(2), createIntConstant(3), 2, 3), module.getVarByName("tab2r").typeFor)
		Assert.assertEquals(new NSTRealArray2D(createIntConstant(3), createIntConstant(2), 3, 2), module.getVarByName("opttab2r").typeFor)

		// array with size from a const
		val dimtab = module.getVarByName("dimtab")
		val dimref = (dimtab.eContainer as VarDeclaration).type.sizes.head
		Assert.assertEquals(new NSTIntScalar, module.getVarByName("dim").typeFor)
		Assert.assertEquals(new NSTRealArray1D(dimref, 6), dimtab.typeFor)

		// dynamic array with options
		val dyndimtabopt = module.getVarByName("dyndimtabopt")
		val dyndimoptref = (dyndimtabopt.eContainer as VarDeclaration).type.sizes.head
		Assert.assertEquals(new NSTIntScalar, module.getVarByName("dyndimopt").typeFor)
		Assert.assertEquals(new NSTRealArray1D(dyndimoptref, -1), dyndimtabopt.typeFor)

		// connectivity variables
		val cjrVar = module.getVarByName("Cjr") as ConnectivityVar
		val cells = cjrVar.supports.get(0)
		val nodesOfCell = cjrVar.supports.get(1)
		val xVar = module.getVarByName("X") as ConnectivityVar
		val nodes = xVar.supports.get(0)
		Assert.assertEquals(new NablaConnectivityType(#[nodes], new NSTRealArray1D(createIntConstant(2), 2)), xVar.typeFor)
		Assert.assertEquals(new NablaConnectivityType(#[cells], new NSTRealScalar), module.getVarByName("pressure").typeFor)
		Assert.assertEquals(new NablaConnectivityType(#[cells, nodesOfCell], new NSTRealScalar), cjrVar.typeFor)
		Assert.assertEquals(new NablaConnectivityType(#[cells, nodesOfCell], new NSTRealArray1D(createIntConstant(2), 2)), module.getVarByName("w").typeFor)

		// linear algebra
		Assert.assertEquals(new NLATMatrix(linearAlgebraExt, createCardExpression(cells), createCardExpression(cells), -1, -1), module.getVarByName("alpha").typeFor)
		Assert.assertEquals(new NLATVector(linearAlgebraExt, createCardExpression(cells), -1), module.getVarByName("u").typeFor)

		// local variable
		val computeX = module.getJobByName("ComputeX")
		Assert.assertEquals(new NSTRealScalar, computeX.eAllContents.filter(Var).findFirst[x | x.name == "ee"].typeFor)
	}
}