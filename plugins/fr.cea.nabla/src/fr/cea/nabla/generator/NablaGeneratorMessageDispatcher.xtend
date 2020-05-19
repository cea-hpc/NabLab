package fr.cea.nabla.generator

import com.google.inject.Singleton
import fr.cea.nabla.ir.ir.IrModule
import java.util.ArrayList
import org.eclipse.xtend.lib.annotations.Accessors

@Singleton
class NablaGeneratorMessageDispatcher
{
	enum MessageType { Start, Exec, End }

	@Accessors val traceListeners = new ArrayList<(MessageType, String) => void>
	@Accessors val irModuleListeners = new ArrayList<(IrModule) => void>

	def post(MessageType msgType, String msg)
	{
		traceListeners.forEach[apply(msgType, msg)]
	}

	def post(IrModule module)
	{
		irModuleListeners.forEach[apply(module)]
	}
}