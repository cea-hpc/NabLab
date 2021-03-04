/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.interpreter

import com.google.gson.Gson
import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.Iterator
import fr.cea.nabla.javalib.mesh.CartesianMesh2D
import fr.cea.nabla.javalib.mesh.CartesianMesh2DFactory
import java.lang.reflect.Method
import java.util.HashMap
import org.eclipse.xtend.lib.annotations.Accessors

class CartesianMesh2DMeshWrapper
{
	val CartesianMesh2D mesh
	val Class<?> providerClass
	val HashMap<Connectivity, Method> connectivityToMethod
	@Accessors val HashMap<Connectivity, Integer> connectivitySizes

	new(Gson gson, String jsonMeshContent)
	{
		val f = new CartesianMesh2DFactory()
		f.jsonInit(jsonMeshContent)
		mesh = f.create

		val tccl = Thread.currentThread().getContextClassLoader()
		providerClass = Class.forName(CartesianMesh2D.name, true, tccl)
		connectivityToMethod = new HashMap<Connectivity, Method>
		connectivitySizes = new HashMap<Connectivity, Integer>
	}

	def getNodes() { mesh.geometry.nodes }
	def getQuads() { mesh.geometry.quads }

	def void init(Connectivity[] connectivities)
	{
		for (c : connectivities)
		{
			val methodName = "get" + c.name.toFirstUpper
			val nbArgs = c.inTypes.size
			connectivityToMethod.put(c, getMeshMethod(methodName, nbArgs))
			if (c.multiple)
			{
				if (c.inTypes.empty)
					connectivitySizes.put(c, getNbElems(c))
				else
					connectivitySizes.put(c, getMaxNbElems(c))
			}
		}
	}

	def int getIndexOf(Iterator iterator, int id)
	{
		throw new RuntimeException("Not implemented yet")
	}

	def int[] getElements(Connectivity connectivity, int[] args)
	{
		val method = connectivityToMethod.get(connectivity)
		callMeshMethod(method, args) as int[]
	}

	def int getSingleton(Connectivity connectivity, int[] args)
	{
		val method = connectivityToMethod.get(connectivity)
		callMeshMethod(method, args) as Integer
	}

	private def int getNbElems(Connectivity connectivity)
	{
		val methodName = "getNb" + connectivity.name.toFirstUpper
		val method = getMeshMethod(methodName, 0)
		callMeshMethod(method, newIntArrayOfSize(0)) as Integer
	}

	private def int getMaxNbElems(Connectivity connectivity)
	{
		val fieldName = "MaxNb" + connectivity.name.toFirstUpper
		try 
		{
			val field = providerClass.getDeclaredField(fieldName)
			field.setAccessible(true)
			return field.getInt(mesh)
		}
		catch (NoSuchFieldException e)
		{
			println("** Field 'CartesianMesh2D::" + fieldName + "' not found")
			throw(e);
		}
	}

	private def Method getMeshMethod(String methodName, int nbArgs)
	{
		try 
		{
			// all arguments are of type int
			val Class<?>[] parameterTypes = newArrayOfSize(nbArgs)
			for (i : 0..<parameterTypes.size) parameterTypes.set(i, typeof(int))
			val method = providerClass.getDeclaredMethod(methodName, parameterTypes)
			method.setAccessible(true)
			return method
		}
		catch (NoSuchMethodException e)
		{
			println("** Method 'CartesianMesh2D::" + methodName + "' not found")
			throw(e);
		}
	}

	private def Object callMeshMethod(Method method, int[] args)
	{
		val Object[] parameterValues = newArrayOfSize(args.size)
		for (i : 0..<parameterValues.size) parameterValues.set(i, args.get(i))
		return method.invoke(mesh, parameterValues)
	}
}
