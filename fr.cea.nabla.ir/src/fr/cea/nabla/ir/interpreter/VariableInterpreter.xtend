package fr.cea.nabla.ir.interpreter

import fr.cea.nabla.ir.ir.ConnectivityVariable
import fr.cea.nabla.ir.ir.SimpleVariable

import static extension fr.cea.nabla.ir.interpreter.BaseTypeValueProvider.*
import static extension fr.cea.nabla.ir.interpreter.ExpressionInterpreter.*

class VariableInterpreter 
{
	static def dispatch NablaValue getValueOf(SimpleVariable it, Context c)
	{
		if (defaultValue === null)
			type.valueOf
		else
			defaultValue.interprete
	}
	
	static def dispatch NablaValue getValueOf(ConnectivityVariable it, Context c)
	{
		var connectivitySizes = 0
		for (s : supports)
			connectivitySizes += c.connectivitySizes.get(s)
		val NablaSimpleValue[] values = newArrayOfSize(connectivitySizes)
		new NablaConnectivityValue(supports, values)
	}
}