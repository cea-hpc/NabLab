package fr.cea.nabla.ir.interpreter

import java.util.HashMap
import org.eclipse.xtend.lib.annotations.Accessors
import fr.cea.nabla.ir.ir.Connectivity
import fr.cea.nabla.ir.ir.Variable

class Context 
{
	@Accessors val connectivitySizes = new HashMap<Connectivity, Integer>
	@Accessors val variableValues = new HashMap<Variable, NablaValue>
	
	// if multi-thread interpreter, must be placed into an inner context
	@Accessors val iteratorRefValues = new HashMap<String, Integer>
}