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

import fr.cea.nabla.ir.ir.IrModule

class MathExtensionProviderHelper extends CallableExtensionProviderHelper
{
	val Class<?> javaLangProviderClass
	val Class<?> math3ProviderClass

	new()
	{
		javaLangProviderClass = Class.forName("java.lang.Math", true, class.classLoader)
		math3ProviderClass = Class.forName("org.apache.commons.math3.special.Erf", true, class.classLoader)
	}

	override createProviderInstance(IrModule module)
	{
		/* nothing to do, static methods */
	}

	override getProviderClass(String functionName) 
	{
		(functionName == 'erf' ? math3ProviderClass : javaLangProviderClass)
	}

	override getProviderInstance(IrModule module)
	{
		null /* static methods */
	}
}
