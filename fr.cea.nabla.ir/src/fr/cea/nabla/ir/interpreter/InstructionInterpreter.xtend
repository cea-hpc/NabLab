package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.ir.Affectation
import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.InstructionBlock
import fr.cea.nabla.ir.ir.SimpleVariable
import fr.cea.nabla.ir.ir.VarDefinition

class InstructionInterpreter 
{
	static def dispatch void interprete(VarDefinition it, Context context)
	{ 
		for (v : variables)
			context.variables.put(v.name, (buildValue(v, context)))
	}
	
	static def dispatch void interprete(InstructionBlock it, Context context)
	{
		for (i : instructions)
			interprete(i, context)
	}
	
	static def dispatch void interprete(Affectation it, Context context)
	{
		
	}
	
	private static def dispatch VariableValue buildValue(SimpleVariable it, Context context)
	{
		if (defaultValue === null)
		{
//			val totalSize = type.sizes.totalSize
//			switch (type.root)
//			{
//				case INT: new IntVariableValue(type.sizes, newIntArrayOfSize(totalSize))
//				case REAL: new RealVariableValue(type.sizes, newDoubleArrayOfSize(totalSize))
//				case BOOL: new BoolVariableValue(type.sizes, newBooleanArrayOfSize(totalSize))
//				default: throw new RuntimeException("Invalid variable root type")
//			}
//		}
//		else
//		{
//			val v = defaultValue.interprete
//			switch (type.root)
//			{
//				case INT: v as IntVariableValue
//				case REAL: v as RealVariableValue
//				case BOOL: v as BoolVariableValue
//				default: throw new RuntimeException("Invalid variable root type")
//			}
		}
	}
	
	private static def dispatch VariableValue buildValue(ConnectivityVariable it, Context context)
	{
		if (defaultValue === null)
		{
//			var totalSize = type.sizes.totalSize;
//			for (d : dimensions) totalSize *= context.connectivitySizes.get(d.name)
//			switch (type.root)
//			{
//				case INT: new IntVariableValue(type.sizes, newIntArrayOfSize(totalSize))
//				case REAL: new RealVariableValue(type.sizes, newDoubleArrayOfSize(totalSize))
//				case BOOL: new BoolVariableValue(type.sizes, newBooleanArrayOfSize(totalSize))
//				default: throw new RuntimeException("Invalid variable root type")
//			}
//		}
//		else
//		{
//			val v = defaultValue.interprete
//			switch (type.root)
//			{
//				case INT: v as IntVariableValue
//				case REAL: v as RealVariableValue
//				case BOOL: v as BoolVariableValue
//				default: throw new RuntimeException("Invalid variable root type")
//			}
		}
	}
}