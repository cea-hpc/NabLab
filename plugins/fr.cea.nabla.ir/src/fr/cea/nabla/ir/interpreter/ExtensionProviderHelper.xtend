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

import fr.cea.nabla.ir.ir.ExtensionProvider
import fr.cea.nabla.ir.ir.ExternFunction
import fr.cea.nabla.ir.ir.IrModule
import java.lang.reflect.Constructor
import java.lang.reflect.Method
import java.net.URL
import java.net.URLClassLoader
import java.util.HashMap
import org.eclipse.xtend.lib.annotations.Accessors

import static extension fr.cea.nabla.ir.ExtensionProviderExtensions.*

abstract class ExtensionProviderHelper
{
	protected val functionToMethod  = new HashMap<ExternFunction, Method>

	abstract def Class<?> getProviderClass()
	abstract def Object getProviderInstance(IrModule module)

	def void initFunctions(Iterable<ExternFunction> functions)
	{
		for (function : functions)
		{
			val javaTypes = function.inArgs.map[a | FunctionCallHelper.getJavaType(a.type, this)]
			val method = providerClass.getDeclaredMethod(function.name, javaTypes)
			method.setAccessible(true)
			functionToMethod.put(function, method)
		}
	}

	def NablaValue invokeMethod(IrModule module, ExternFunction f, NablaValue[] args)
	{
		val javaValues = args.map[x | FunctionCallHelper.getJavaValue(x)].toArray
		val method = functionToMethod.get(f)
		val result = method.invoke(getProviderInstance(module), javaValues)
		return FunctionCallHelper.createNablaValue(result, this)
	}
}

class MathExtensionProviderHelper extends ExtensionProviderHelper
{
	val Class<?> providerClass

	new()
	{
		providerClass = Class.forName("java.lang.Math", true, class.classLoader)
	}

	override getProviderClass() { providerClass }
	override getProviderInstance(IrModule module) { null } // static call
}

class DefaultExtensionProviderHelper extends ExtensionProviderHelper
{
	protected val providerInstances = new HashMap<IrModule, Object>
	protected URLClassLoader cl
	val Class<?> providerClass

	new(ExtensionProvider provider, String wsPath)
	{
		val url = new URL("file://" + wsPath + provider.installPath + "/" + provider.libName + ".jar")
		cl = new URLClassLoader(#[url])
		val className = provider.packageName + '.' + provider.className
		providerClass = Class.forName(className, true, cl)
	}

	override getProviderClass() { providerClass }
	override getProviderInstance(IrModule module) { providerInstances.get(module) }

	def void createInstance(IrModule module)
	{
		providerInstances.put(module, providerClass.constructor.newInstance)
	}

	def jsonInit(IrModule module, String jsonContent)
	{
		val jsonInitMethod = providerClass.getDeclaredMethod("jsonInit", String)
		val providerInstance = providerInstances.get(module)
		jsonInitMethod.invoke(providerInstance, jsonContent)
	}
}

class LinearAlgebraExtensionProviderHelper extends DefaultExtensionProviderHelper
{
	@Accessors val Class<?> vectorClass
	@Accessors val Constructor<?> vectorCstr
	@Accessors val Method vectorGetValueMethod
	@Accessors val Method vectorSetValueMethod

	@Accessors val Class<?> matrixClass
	@Accessors val Constructor<?> matrixCstr
	@Accessors val Method matrixGetValueMethod
	@Accessors val Method matrixSetValueMethod

	new(ExtensionProvider provider, String wsPath)
	{
		super(provider, wsPath)

		val vectorClassName = provider.packageName + '.' + fr.cea.nabla.ir.IrTypeExtensions.VectorClass
		vectorClass = Class.forName(vectorClassName, true, cl)
		vectorCstr = vectorClass.getConstructor(String, int)
		vectorGetValueMethod = vectorClass.getMethod("getValue", int)
		vectorSetValueMethod = vectorClass.getMethod("setValue", int, double)

		val matrixClassName = provider.packageName + '.' + fr.cea.nabla.ir.IrTypeExtensions.MatrixClass
		matrixClass = Class.forName(matrixClassName, true, cl)
		matrixCstr = matrixClass.getConstructor(String, int, int)
		matrixGetValueMethod = matrixClass.getMethod("getValue", int, int)
		matrixSetValueMethod = matrixClass.getMethod("setValue", int, int, double)
	}
}
