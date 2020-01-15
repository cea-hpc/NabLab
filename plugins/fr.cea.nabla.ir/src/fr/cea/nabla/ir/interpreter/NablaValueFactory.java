/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.interpreter;

import fr.cea.nabla.ir.ir.IrType;
import fr.cea.nabla.ir.ir.PrimitiveType;

public class NablaValueFactory
{
	static NablaValue createValue(IrType t)
	{
		PrimitiveType p = IrTypeExtensions.getPrimitive(t);
		NablaValue result = null;
		switch (p)
		{
			case BOOL: result = new NV0Bool(false); break;
			case INT: result = new NV0Int(0); break;
			case REAL: result = new NV0Real(0.0); break;
		}
		return result;
	}

	static NablaValue createValue(IrType t, int size)
	{
		PrimitiveType p = IrTypeExtensions.getPrimitive(t);
		NablaValue result = null;
		switch (p)
		{
			case BOOL: result = new NV1Bool(new boolean[size]); break;
			case INT: result = new NV1Int(new int[size]); break;
			case REAL: result = new NV1Real(new double[size]); break;
		}
		return result;
	}

	static NablaValue createValue(IrType t, int size1, int size2)
	{ 
		PrimitiveType p = IrTypeExtensions.getPrimitive(t);
		NablaValue result = null;
		switch (p)
		{
			case BOOL: result = new NV2Bool(new boolean[size1][size2]); break;
			case INT: result = new NV2Int(new int[size1][size2]); break;
			case REAL: result = new NV2Real(new double[size1][size2]); break;
		}
		return result;
	}

	static NablaValue createValue(IrType t, int size1, int size2, int size3)
	{ 
		PrimitiveType p = IrTypeExtensions.getPrimitive(t);
		NablaValue result = null;
		switch (p)
		{
			case BOOL: result = new NV3Bool(new boolean[size1][size2][size3]); break;
			case INT: result = new NV3Int(new int[size1][size2][size3]); break;
			case REAL: result = new NV3Real(new double[size1][size2][size3]); break;
		}
		return result;
	}

	static NablaValue createValue(IrType t, int size1, int size2, int size3, int size4)
	{
		PrimitiveType p = IrTypeExtensions.getPrimitive(t);
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
