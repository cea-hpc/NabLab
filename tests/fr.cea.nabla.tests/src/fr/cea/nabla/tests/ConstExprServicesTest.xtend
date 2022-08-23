/*******************************************************************************
 * Copyright (c) 2022 CEA
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
import fr.cea.nabla.ConstExprServices
import fr.cea.nabla.NablaModuleExtensions
import fr.cea.nabla.nabla.NablaModule
import fr.cea.nabla.typing.ArgOrVarTypeProvider
import fr.cea.nabla.typing.BaseTypeTypeProvider
import fr.cea.nabla.typing.NSTRealArray1D
import fr.cea.nabla.typing.NSTRealArray2D
import fr.cea.nabla.typing.NablaConnectivityType
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(XtextRunner)
@InjectWith(NablaInjectorProvider)
class ConstExprServicesTest
{
	@Inject extension TestUtils
	@Inject extension BaseTypeTypeProvider
	@Inject extension ArgOrVarTypeProvider
	@Inject extension NablaModuleExtensions
	@Inject ConstExprServices constExprServices
	@Inject ParseHelper<NablaModule> parseHelper
	@Inject Provider<ResourceSet> resourceSetProvider

	@Test
	def void testConstExprOnGlobalVariables()
	{
		val model =
		'''
		«testModule»
		let int dim = 2;
		int unknownDim;
		real[2] X{nodes};
		real[1 + 1, unknownDim] Y;
		// let real[dim] orig = [0.0, 1.1];
		'''

		val rs = resourceSetProvider.get
		parseHelper.parse(readFileAsString(TestUtils.CartesianMesh2DPath), rs)
		val module = parseHelper.parse(model, rs)
		Assert.assertNotNull(module)

		// Get the variables
		val dim = module.getVarByName("dim")
		val unknownDim = module.getVarByName("unknownDim")
		val X = module.getVarByName("X")
		val X_type = X.typeFor
		val Y = module.getVarByName("Y")
		val Y_type = Y.typeFor

		// Assertions
		Assert.assertTrue(constExprServices.isConstExpr(dim))
		Assert.assertFalse(constExprServices.isConstExpr(unknownDim))

		Assert.assertFalse(constExprServices.isConstExpr(X))
		Assert.assertTrue(X_type instanceof NablaConnectivityType)
		val X_type_connect = X_type as NablaConnectivityType
		Assert.assertTrue(X_type_connect.simple instanceof NSTRealArray1D)
		val X_type_simple = X_type_connect.simple as NSTRealArray1D
		Assert.assertTrue(constExprServices.isConstExpr(X_type_simple.size))

		Assert.assertFalse(constExprServices.isConstExpr(Y))
		Assert.assertTrue(Y_type instanceof NSTRealArray2D)
		val Y_type_simple = Y_type as NSTRealArray2D
		Assert.assertTrue(constExprServices.isConstExpr(Y_type_simple.nbRows))
		Assert.assertFalse(constExprServices.isConstExpr(Y_type_simple.nbCols))
	}

	@Test
	def void testConstExprOnFunctions()
	{
		val model =
		'''
		«emptyTestModule»
		def <x,y> real[x+y] f(real[x] a, real[y] b) 
		{
			let real[x+y] c = 2.0;
			c = a * 2.0;
			return c + 4.0;
		}
		def real g() 
		{
			real[4] n;
			real[4, 2] m;
			forall  i in [0;4[, 
			{
				n[i] = 4.0;
				forall  j in [0;2[, m[i,j] = 3.0;
			}
			return 4.0;
		}
		'''

		val rs = resourceSetProvider.get
		parseHelper.parse(readFileAsString(TestUtils.CartesianMesh2DPath), rs)
		val module = parseHelper.parse(model, rs)
		Assert.assertNotNull(module)

		// Get the functions
		val f = module.functions.findFirst[v | v.name == "f"]
		val f_a1 = f.inArgs.get(0)
		val f_a1_type = f_a1.typeFor
		val f_x = f.variables.get(0)
		val f_a2 = f.inArgs.get(1)
		val f_a2_type = f_a2.typeFor
		val f_y = f.variables.get(1)
		val g = module.functions.findFirst[v | v.name == "g"]

		// Assertions
		// As functions are not inlined in c++ generation, function can't be constexpr
		//Assert.assertTrue(constExprServices.isConstExpr(f))
		Assert.assertFalse(constExprServices.isConstExpr(f))

		Assert.assertTrue(f_a1_type instanceof NSTRealArray1D)
		val f_a1_type_simple = f_a1_type as NSTRealArray1D
		Assert.assertTrue(constExprServices.isConstExpr(f_a1_type_simple.size))
		Assert.assertTrue(constExprServices.isConstExpr(f_x))

		Assert.assertTrue(f_a2_type instanceof NSTRealArray1D)
		val f_a2_type_simple = f_a2_type as NSTRealArray1D
		Assert.assertTrue(constExprServices.isConstExpr(f_a2_type_simple.size))
		Assert.assertTrue(constExprServices.isConstExpr(f_y))

		val f_return_type = f.returnTypeDeclaration.returnType.typeFor
		Assert.assertTrue(f_return_type instanceof NSTRealArray1D)
		val f_return_type_simple = f_return_type as NSTRealArray1D
		Assert.assertTrue(constExprServices.isConstExpr(f_return_type_simple.size))

		// As functions are not inlined in c++ generation, function can't be constexpr
		//Assert.assertTrue(constExprServices.isConstExpr(g))
		Assert.assertFalse(constExprServices.isConstExpr(g))
	}
}