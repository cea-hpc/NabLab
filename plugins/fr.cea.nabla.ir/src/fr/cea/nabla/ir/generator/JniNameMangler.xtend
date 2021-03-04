/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator

import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.ExtensionProvider
import fr.cea.nabla.ir.ir.ExternFunction
import fr.cea.nabla.ir.ir.IrType
import fr.cea.nabla.ir.ir.LinearAlgebraType

import static extension fr.cea.nabla.ir.ExtensionProviderExtensions.*

class JniNameMangler
{
	static def getJniClassName(ExtensionProvider p)
	{
		getNsPrefix(p, '.').replace('.', '_') + p.className
	}

	static def getJniFunctionName(ExtensionProvider p, String name)
	{
		'Java_'+ p.jniClassName + '_' + name
	}

	static def getJniFunctionName(ExtensionProvider provider, ExternFunction f)
	{
		val allFunctions = f.eContainer.eAllContents.filter(ExternFunction)
		val overloaded = allFunctions.exists[x | x !== f && x.name == f]
		if (overloaded)
			getJniFunctionName(provider, f.name) + f.inArgs.map[x | x.type.mangleType].join("_")
		else
			getJniFunctionName(provider, f.name)
	}

	private static def mangleType(IrType it)
	{
		switch it
		{
			BaseType:
			{
				switch primitive
				{
					case BOOL: 'Z'
					case INT: 'I'
					case REAL: 'D'
				}
			}
			LinearAlgebraType case sizes.size == 1: 'J' + provider.jniClassName + '_Vector2'
			LinearAlgebraType case sizes.size == 2: 'J' + provider.jniClassName + '_Matrix2'
			default: throw new RuntimeException("Ooops. Can not be there, normally...")
		}
	}
}
