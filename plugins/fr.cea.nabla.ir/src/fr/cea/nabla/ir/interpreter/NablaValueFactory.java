/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.interpreter;

import fr.cea.nabla.ir.ir.PrimitiveType;

public class NablaValueFactory
{
	static NablaValue createValue(PrimitiveType p)
	{
		NablaValue result = null;
		switch (p)
		{
			case BOOL: result = new NV0Bool(false); break;
			case INT: result = new NV0Int(0); break;
			case REAL: result = new NV0Real(0.0); break;
		}
		return result;
	}

	static NablaValue createValue(PrimitiveType p, String name, int size, ExtensionProviderHelper provider)
	{
		switch (p)
		{
			case BOOL: return new NV1Bool(new boolean[size]);
			case INT: return new NV1Int(new int[size]);
			case REAL:
			{
				if (provider != null && provider instanceof LinearAlgebraExtensionProviderHelper)
					return new NVVector(name, size, (LinearAlgebraExtensionProviderHelper)provider);
				else
					return new NV1Real(new double[size]);
			}
			default: return null;
		}
	}

	static NablaValue createValue(PrimitiveType p, String name, int nbRows, int nbCols, ExtensionProviderHelper provider)
	{
		switch (p)
		{
			case BOOL: return new NV2Bool(new boolean[nbRows][nbCols]);
			case INT: return new NV2Int(new int[nbRows][nbCols]);
			case REAL:
			{
				if (provider != null && provider instanceof LinearAlgebraExtensionProviderHelper)
					return new NVMatrix(name, nbRows, nbCols, (LinearAlgebraExtensionProviderHelper)provider);
				else
					return new NV2Real(new double[nbRows][nbCols]);
			}
			default: return null;
		}
	}

	static NablaValue createValue(PrimitiveType p, int size1, int size2, int size3)
	{ 
		NablaValue result = null;
		switch (p)
		{
			case BOOL: result = new NV3Bool(new boolean[size1][size2][size3]); break;
			case INT: result = new NV3Int(new int[size1][size2][size3]); break;
			case REAL: result = new NV3Real(new double[size1][size2][size3]); break;
		}
		return result;
	}

	static NablaValue createValue(PrimitiveType p, int size1, int size2, int size3, int size4)
	{
		NablaValue result = null;
		switch (p)
		{
			case BOOL: result = new NV4Bool(new boolean[size1][size2][size3][size4]); break;
			case INT: result = new NV4Int(new int[size1][size2][size3][size4]); break;
			case REAL: result = new NV4Real(new double[size1][size2][size3][size4]); break;
		}
		return result;
	}
}
