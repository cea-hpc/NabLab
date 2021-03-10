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
import fr.cea.nabla.ir.ir.Function
import java.lang.reflect.Constructor
import java.lang.reflect.Method
import java.util.HashMap
import org.eclipse.xtend.lib.annotations.Accessors

import static extension fr.cea.nabla.ir.ExtensionProviderExtensions.*

abstract class ExtensionProviderHelper
{
	@Accessors(PUBLIC_GETTER) val HashMap<Function, Method> functionToMethod  = new HashMap<Function, Method>

	def Class<?> getProviderClass()
	def Object getProviderInstance()
	def void jsonInit(String jsonContent)

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

	def NablaValue invokeMethod(Function f, NablaValue[] args)
	{
		val javaValues = args.map[x | FunctionCallHelper.getJavaValue(x)].toArray
		val m = functionToMethod.get(f)
		val result = m.invoke(providerInstance, javaValues)
		return FunctionCallHelper.createNablaValue(result, this)
	}
}

class StaticExtensionProviderHelper extends ExtensionProviderHelper
{
	val Class<?> providerClass

	new(ExtensionProvider provider, ClassLoader cl, String packageName)
	{
		val className = (packageName.nullOrEmpty ? provider.className : packageName + "." + provider.className)
		providerClass = Class.forName(className, true, cl)
	}

	override getProviderClass() { providerClass }
	override getProviderInstance() { null }
	
	override jsonInit(String jsonContent) {}
}

class DefaultExtensionProviderHelper extends ExtensionProviderHelper
{
	val Class<?> providerClass
	@Accessors(PUBLIC_GETTER) val Object providerInstance

	new(ExtensionProvider provider, ClassLoader cl, String wsPath)
	{
		val className = provider.packageName + '.' + provider.className
		providerClass = Class.forName(className, true, cl)
		providerInstance = providerClass.constructor.newInstance
	}

	override getProviderClass() { providerClass }
	override getProviderInstance() { providerInstance }

	override jsonInit(String jsonContent)
	{
		val jsonInitMethod = providerClass.getDeclaredMethod("jsonInit", String)
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

	new(ExtensionProvider provider, ClassLoader cl, String wsPath)
	{
		super(provider, cl, wsPath)

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
