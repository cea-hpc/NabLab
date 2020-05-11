package fr.cea.nabla.generator

import com.google.inject.Singleton
import java.util.ArrayList
import org.eclipse.xtend.lib.annotations.Accessors

@Singleton
class NablaGeneratorMessageDispatcher
{
	@Accessors val listeners = new ArrayList<(String) => void>

	def post(String msg)
	{
		listeners.forEach[apply(msg)]
	}
}