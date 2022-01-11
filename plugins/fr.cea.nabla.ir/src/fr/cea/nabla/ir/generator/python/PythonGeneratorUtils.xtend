/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.python

import fr.cea.nabla.ir.ArgOrVarExtensions
import fr.cea.nabla.ir.ContainerExtensions
import fr.cea.nabla.ir.ir.ArgOrVar
import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.Container
import fr.cea.nabla.ir.ir.ExternFunction
import fr.cea.nabla.ir.ir.Function
import fr.cea.nabla.ir.ir.InternFunction
import fr.cea.nabla.ir.ir.Iterator

import static extension fr.cea.nabla.ir.ExtensionProviderExtensions.*

class PythonGeneratorUtils
{
	static val SysFunction = #["min", "max", "abs"]

	static def getCodeName(Function f)
	{
		switch f
		{
			InternFunction: 'self.__' + f.name
			ExternFunction:
				if (f.provider.extensionName == "Math")
					if (SysFunction.contains(f.name))
						f.name
					else
						'math.' + f.name
				else
					'self.' + f.provider.instanceName + '.' + f.name
		}
	}

	static def getCodeName(ArgOrVar v)
	{
		if (ArgOrVarExtensions.isIteratorCounter(v))
			(v.eContainer as Iterator).index.name
		else if (ArgOrVarExtensions.isGlobal(v))
			"self." + v.name
		else
			v.name
	}

	static def getNbElemsVar(Container c)
	{
		if (ContainerExtensions.getConnectivityCall(c).args.empty)
			"self.__" + ContainerExtensions.getNbElemsVar(c)
		else
			ContainerExtensions.getNbElemsVar(c)
	}

	static def getNbElemsVar(Connectivity c)
	{
		"self.__" + ContainerExtensions.getNbElemsVar(c)
	}
}
