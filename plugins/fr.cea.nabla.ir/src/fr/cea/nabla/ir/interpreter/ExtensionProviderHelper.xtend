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

import fr.cea.nabla.ir.ir.IrModule

interface ExtensionProviderHelper
{
	def void createProviderInstance(IrModule module)
	def Class<?> getProviderClass(String functionName)
	def Object getProviderInstance(IrModule module)

	def jsonInit(IrModule module, String jsonContent)
	{
		val functionName = "jsonInit"
		val providerClass = getProviderClass(functionName)
		val jsonInitMethod = providerClass.getDeclaredMethod(functionName, String)
		val providerInstance = getProviderInstance(module)
		jsonInitMethod.invoke(providerInstance, jsonContent)
	}
}
