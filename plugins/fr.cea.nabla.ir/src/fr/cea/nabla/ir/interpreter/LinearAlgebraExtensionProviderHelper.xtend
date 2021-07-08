/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.ir.DefaultExtensionProvider
import java.lang.reflect.Constructor
import java.lang.reflect.Method
import org.eclipse.xtend.lib.annotations.Accessors

import static extension fr.cea.nabla.ir.ExtensionProviderExtensions.*

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

	new(DefaultExtensionProvider provider, String wsPath)
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
