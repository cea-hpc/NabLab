/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.ir.ExternFunction
import fr.cea.nabla.ir.ir.IrModule
import java.lang.reflect.Method
import java.util.HashMap

abstract class CallableExtensionProviderHelper implements ExtensionProviderHelper
{
	val methods = new HashMap<ExternFunction, Method>

	def void init(Iterable<ExternFunction> functions)
	{
		for (f : functions)
		{
			val javaTypes = f.inArgs.map[a | FunctionCallHelper.getJavaType(a.type, this)]
			val providerClass = getProviderClass(f.name)
			val method = providerClass.getDeclaredMethod(f.name, javaTypes)
			method.setAccessible(true)
			methods.put(f, method)
		}
	}

	def NablaValue call(IrModule module, ExternFunction f, NablaValue[] args)
	{
		val javaValues = args.map[x | FunctionCallHelper.getJavaValue(x)].toArray
		val method = methods.get(f)
		val providerInstance = getProviderInstance(module)
		val result = method.invoke(providerInstance, javaValues)
		return FunctionCallHelper.createNablaValue(result, this)
	}
}
