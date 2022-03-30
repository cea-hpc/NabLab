/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.java

import fr.cea.nabla.ir.ir.ExternFunction
import fr.cea.nabla.ir.ir.InternFunction
import fr.cea.nabla.ir.ir.IrModule

import static extension fr.cea.nabla.ir.ExtensionProviderExtensions.*
import static extension fr.cea.nabla.ir.IrModuleExtensions.*

class JavaGeneratorUtils
{
	static def dispatch getCodeName(InternFunction it)
	{
		name
	}

	static def dispatch getCodeName(ExternFunction it)
	{
		if (provider.extensionName == "Math")
		{
			if (name == 'erf')
				// no erf function in java Math
				'org.apache.commons.math3.special.Erf.erf'
			else
				'Math.' + name
		}
		else provider.instanceName + '.' + name
	}

	static def getPackageName(IrModule it)
	{
		irRoot.name.toLowerCase
	}
}
