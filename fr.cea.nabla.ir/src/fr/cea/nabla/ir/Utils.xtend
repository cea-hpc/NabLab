package fr.cea.nabla.ir

import org.eclipse.emf.ecore.EObject
import fr.cea.nabla.ir.ir.IrModule

class Utils 
{
	static def IrModule getIrModule(EObject o)
	{
		if (o === null) null
		else if (o instanceof IrModule) o as IrModule
		else o.eContainer.irModule
	}
}