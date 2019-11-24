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
			case BOOL: result = new NV0Bool(false);
			case INT: result = new NV0Int(0);
			case REAL: result = new NV0Real(0.0);
		}
		return result;
	}

	static NablaValue createValue(IrType t, int size)
	{ 
		PrimitiveType p = IrTypeExtensions.getPrimitive(t);
		NablaValue result = null;
		switch (p)
		{
			case BOOL: result = new NV1Bool(new boolean[size]);
			case INT: result = new NV1Int(new int[size]);
			case REAL: result = new NV1Real(new double[size]);
		}
		return result;
	}

	static NablaValue createValue(IrType t, int size1, int size2)
	{ 
		PrimitiveType p = IrTypeExtensions.getPrimitive(t);
		NablaValue result = null;
		switch (p)
		{
			case BOOL: result = new NV2Bool(new boolean[size1][size2]);
			case INT: result = new NV2Int(new int[size1][size2]);
			case REAL: result = new NV2Real(new double[size1][size2]);
		}
		return result;
	}

	static NablaValue createValue(IrType t, int size1, int size2, int size3)
	{ 
		PrimitiveType p = IrTypeExtensions.getPrimitive(t);
		NablaValue result = null;
		switch (p)
		{
			case BOOL: result = new NV3Bool(new boolean[size1][size2][size3]);
			case INT: result = new NV3Int(new int[size1][size2][size3]);
			case REAL: result = new NV3Real(new double[size1][size2][size3]);
		}
		return result;
	}

	static NablaValue createValue(IrType t, int size1, int size2, int size3, int size4)
	{
		PrimitiveType p = IrTypeExtensions.getPrimitive(t);
		NablaValue result = null;
		switch (p)
		{
			case BOOL: result = new NV4Bool(new boolean[size1][size2][size3][size4]);
			case INT: result = new NV4Int(new int[size1][size2][size3][size4]);
			case REAL: result = new NV4Real(new double[size1][size2][size3][size4]);
		}
		return result;
	}
}
