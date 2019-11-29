package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.SimpleVariable

import static fr.cea.nabla.ir.interpreter.BaseTypeValueFactory.*
import static fr.cea.nabla.ir.interpreter.ExpressionInterpreter.*
import static fr.cea.nabla.ir.interpreter.IrTypeExtensions.*
import static fr.cea.nabla.ir.interpreter.NablaValueFactory.*
import static fr.cea.nabla.ir.interpreter.NablaValueSetter.*

class VariableValueFactory 
{
	static def dispatch NablaValue createValue(SimpleVariable it, Context context)
	{
//		si scalar (sizes.empty), on la crée  + si dV on set
//		sinon comme avant

		if (type.sizes.empty)
		{
			val nv = createValue(type, context)
			if (defaultValue !== null)
				setValue(nv, #[], interprete(defaultValue, context))
			return nv
		}
		else
		{
			if (defaultValue === null)
				createValue(type, context)
			else
				interprete(defaultValue, context)
		}
	}

	static def dispatch NablaValue createValue(ConnectivityVariable it, Context context)
	{
		if (defaultValue === null)
		{
			var sizes = getIntSizes(type, context)
			switch sizes.size
			{
				case 1: createValue(type, sizes.get(0))
				case 2: createValue(type, sizes.get(0), sizes.get(1))
				case 3: createValue(type, sizes.get(0), sizes.get(1), sizes.get(2))
				case 4: createValue(type, sizes.get(0), sizes.get(1), sizes.get(2), sizes.get(3))
				default: throw new RuntimeException("Dimension not yet implemented: " + sizes.size + " for variable " + name)
			}
		}
		else
			interprete(defaultValue, context)
	}
}