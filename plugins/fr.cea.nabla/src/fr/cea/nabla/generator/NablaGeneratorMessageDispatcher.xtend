package fr.cea.nabla.generator

import com.google.inject.Singleton
import java.util.ArrayList
import org.eclipse.xtend.lib.annotations.Accessors

@Singleton
class NablaGeneratorMessageDispatcher
{
	enum MessageType { Start, Exec, End }

	@Accessors val traceListeners = new ArrayList<(MessageType, String) => void>

	def post(MessageType msgType, String msg)
	{
		traceListeners.forEach[apply(msgType, msg)]
	}
}