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

import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.ConnectivityType
import fr.cea.nabla.ir.ir.IrType
import fr.cea.nabla.ir.ir.LinearAlgebraType
import fr.cea.nabla.ir.ir.PrimitiveType

class FunctionCallHelper
{
	static def Class<?> getJavaType(IrType it, ExtensionProviderHelper provider) 
	{
		switch it
		{
			BaseType: getJavaType(primitive, sizes.size, provider)
			ConnectivityType: getJavaType(base.primitive, (connectivities+base.sizes).size, provider)
			LinearAlgebraType: getJavaType(PrimitiveType::REAL, sizes.size, provider)
		}
	}

	private static def Class<?> getJavaType(PrimitiveType primitive, int dimension, ExtensionProviderHelper provider)
	{
		switch (primitive)
		{
			case BOOL: 
			{
				switch dimension
				{
					case 0: typeof(boolean)
					case 1: typeof(boolean[])
					case 2: typeof(boolean[][])
					default: throw new RuntimeException("Unexpected dimension: " + dimension) 
				}
			}
			case INT:
			{
				switch dimension
				{
					case 0: typeof(int)
					case 1: typeof(int[])
					case 2: typeof(int[][])
					default: throw new RuntimeException("Unexpected dimension: " + dimension) 
				}
			}
			case REAL:
			{
				switch dimension
				{
					case 0: typeof(double)
					case 1: (provider instanceof LinearAlgebraExtensionProviderHelper ? provider.vectorClass : typeof(double[]))
					case 2: (provider instanceof LinearAlgebraExtensionProviderHelper ? provider.matrixClass : typeof(double[][]))
					default: throw new RuntimeException("Unexpected dimension: " + dimension) 
				}
			}
		}
	}

	static def Object getJavaValue(NablaValue v)
	{
		switch v
		{
			NV0Bool: v.data
			NV1Bool: v.data
			NV2Bool: v.data
			NV0Int: v.data
			NV1Int: v.data
			NV2Int: v.data
			NV0Real: v.data
			NV1Real: v.data
			NV2Real: v.data
			NVVector: v.data
			NVMatrix: v.data
		}
	}

	static def NablaValue createNablaValue(Object o, ExtensionProviderHelper provider)
	{
		switch o
		{
			Boolean: new NV0Bool(o)
			boolean[]: new NV1Bool(o)
			boolean[][]: new NV2Bool(o)
			Integer: new NV0Int(o)
			int[]: new NV1Int(o)
			int[][]: new NV2Int(o)
			Double: new NV0Real(o)
			double[]: new NV1Real(o)
			double[][]: new NV2Real(o)
			default: switch provider
			{
				LinearAlgebraExtensionProviderHelper case provider.vectorClass == o.class: new NVVector(o, provider)
				LinearAlgebraExtensionProviderHelper case provider.matrixClass == o.class: new NVMatrix(o, provider)
				default: throw new RuntimeException('Unexpected provider: ' + provider.class.name)
			}
		}
	}
}