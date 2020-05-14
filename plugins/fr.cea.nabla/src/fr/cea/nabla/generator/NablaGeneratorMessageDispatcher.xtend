package fr.cea.nabla.generator

import com.google.inject.Singleton
import fr.cea.nabla.ir.ir.IrModule
import java.util.ArrayList
import org.eclipse.xtend.lib.annotations.Accessors

@Singleton
class NablaGeneratorMessageDispatcher
{
	@Accessors val traceListeners = new ArrayList<(String) => void>
	@Accessors val irModuleListeners = new ArrayList<(IrModule) => void>

	def post(String msg)
	{
		traceListeners.forEach[apply(msg)]
	}

	def post(IrModule module)
	{
		irModuleListeners.forEach[apply(module)]
	}
}