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

import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.ExternFunction
import fr.cea.nabla.ir.ir.InternFunction
import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.ir.IrType
import fr.cea.nabla.ir.ir.LinearAlgebraType
import fr.cea.nabla.ir.ir.PrimitiveType

import static extension fr.cea.nabla.ir.ContainerExtensions.*
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

	static def dispatch CharSequence getDbBytes(BaseType it)
	{
		switch (primitive)
		{
			case PrimitiveType.INT : "Integer.BYTES"
			case PrimitiveType.BOOL : "1"
			case PrimitiveType.REAL : "Double.BYTES"
			default: ""
		}
	}

	static def dispatch CharSequence getDbBytes(ConnectivityType it) { getDbBytes(base) }
	static def dispatch CharSequence getDbBytes(LinearAlgebraType it) { "Double.BYTES" }
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
		connectivities.map[c | c.nbElems].join(",") + ( base.intSizes.empty ? "" : ", " + getDbSizes(base, variableName))
	}
	static def dispatch CharSequence getDbSizes(LinearAlgebraType it, String variableName) 
	{
		switch it.sizes.size
		{
			case 1: variableName + ".getSize()"
			case 2: variableName + ".getData().getRowDimension(), " + variableName + ".getData().getColumnDimension()"
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
			return (getDbSizesIndexes(intSizes.tail, variableName).length == 0 ? "" : getDbSizesIndexes(intSizes.tail, variableName) + ", ") + variableName + indexes + ".length"
		}
		else return "";
	}
}
