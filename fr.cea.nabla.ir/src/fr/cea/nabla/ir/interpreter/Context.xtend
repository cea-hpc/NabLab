package fr.cea.nabla.ir.interpreter

import java.util.HashMap
import org.eclipse.xtend.lib.annotations.Accessors

class Context 
{
	@Accessors val connectivitySizes = new HashMap<String, Integer>
	@Accessors val variables = new HashMap<String, VariableValue>
}