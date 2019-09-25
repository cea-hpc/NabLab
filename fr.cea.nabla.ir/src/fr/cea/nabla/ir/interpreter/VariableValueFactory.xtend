package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.SimpleVariable

import static fr.cea.nabla.ir.interpreter.IrTypeExtensions.*
import static fr.cea.nabla.ir.interpreter.NablaValueFactory.*

import static extension fr.cea.nabla.ir.interpreter.BaseTypeValueFactory.*
import static extension fr.cea.nabla.ir.interpreter.ExpressionInterpreter.*

class VariableValueFactory 
{
	static def dispatch NablaValue createValue(SimpleVariable it, Context c)
	{
		if (defaultValue === null)
			type.createValue
		else
			defaultValue.interprete(c)
	}
	
	static def dispatch NablaValue createValue(ConnectivityVariable it, Context c)
	{
		var sizes = getSizes(type, c)
		switch sizes.size
		{
			case 1: createValue(type, sizes.get(0))
			case 2: createValue(type, sizes.get(0), sizes.get(1))
			case 3: createValue(type, sizes.get(0), sizes.get(1), sizes.get(2))
			default: throw new RuntimeException("Dimension not yet implemented: " + sizes.size)			
		}
	}
}