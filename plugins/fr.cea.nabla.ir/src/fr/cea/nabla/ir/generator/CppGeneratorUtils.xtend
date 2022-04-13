/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator

import fr.cea.nabla.ir.IrUtils
import fr.cea.nabla.ir.generator.cpp.ExpressionContentProvider
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.ExternFunction
import fr.cea.nabla.ir.ir.Function
import fr.cea.nabla.ir.ir.InternFunction
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.IrType
import fr.cea.nabla.ir.ir.LinearAlgebraType
import fr.cea.nabla.ir.ir.PrimitiveType
import org.eclipse.xtend.lib.annotations.Accessors

import static extension fr.cea.nabla.ir.ContainerExtensions.*
import static extension fr.cea.nabla.ir.ExtensionProviderExtensions.getInstanceName
import static extension fr.cea.nabla.ir.IrModuleExtensions.getClassName

class CppGeneratorUtils
{

	@Accessors extension ExpressionContentProvider expressionContentProvider

	static def getFreeFunctionNs(IrModule it)
	{
		className.toLowerCase + "freefuncs"
	}

	static def getCodeName(Function f)
	{
		switch f
		{
			InternFunction:
			{
				val irModule = IrUtils.getContainerOfType(f, IrModule)
				irModule.freeFunctionNs + '::' + f.name
			}
			ExternFunction:
			{
				if (f.provider.extensionName == "Math") 'std::' + f.name
				else f.provider.instanceName + '.' + f.name
			}
		}
	}

	static def getHDefineName(String name)
	{
		'__' + name.toUpperCase + '_H_'
	}

	static def dispatch CharSequence getDbPutMethodName(ConnectivityType it) {"putDBVector"}
	static def dispatch CharSequence getDbPutMethodName(LinearAlgebraType it) {"putDBVector"}
	static def dispatch CharSequence getDbPutMethodName(BaseType it) {"putDBValue"}

	static def dispatch CharSequence getDbBytes(BaseType it)
	{
		switch (primitive)
		{
			case PrimitiveType.INT : "sizeof(int)"
			case PrimitiveType.BOOL : "sizeof(bool)"
			case PrimitiveType.REAL : "sizeof(double)"
			default: ""
		}
	}

	static def dispatch CharSequence getDbBytes(ConnectivityType it) { getDbBytes(base) }
	static def dispatch CharSequence getDbBytes(LinearAlgebraType it) { "sizeof(double)" }
	static def dispatch CharSequence getDbBytes(IrType it) {""}

	static def dispatch CharSequence getDbSizes(BaseType it, String variableName)
	{
		if (isIsStatic)
			intSizes.empty ? "" : intSizes.map[i | i ].join(", ")
		else
			getDbSizesIndexes(intSizes, variableName)
	}
	static def dispatch CharSequence getDbSizes(ConnectivityType it, String variableName)
	{
		connectivities.map[c | c.nbElems].join(", ") + ( base.intSizes.empty ? "" : ", " + getDbSizes(base, variableName))
	}
	static def dispatch CharSequence getDbSizes(LinearAlgebraType it, String variableName)
	{
		switch it.sizes.size
		{
			case 1: variableName + ".getSize()"
			case 2: variableName + ".getNbRows(), " + variableName + ".getNbCols()"
			default: throw new RuntimeException("Unexpected dimension: " + it.sizes.size)
		}
	}
	static def dispatch CharSequence getDbSizes(IrType it, String variableName) {""}

	private static def CharSequence getDbSizesIndexes(Iterable<Integer> intSizes, String variableName)
	{
		if (!intSizes.empty)
		{
			var indexes = ""
			for (i : 0 ..< intSizes.size -1)
				indexes += "[0]"
			return (getDbSizesIndexes(intSizes.tail, variableName).length == 0 ? "" : getDbSizesIndexes(intSizes.tail, variableName) + ", ") + variableName + indexes + ".size()"
		}
		else return "";
	}
}
