package fr.cea.nabla.generator

import com.google.inject.Singleton
import java.util.ArrayList

@Singleton
class NablaGeneratorMessageDispatcher
{
	val traceListeners = new ArrayList<(String) => void>

	def addWorkflowTraceListener((String) => void listener)
	{
		traceListeners += listener
	}

	def post(String msg)
	{
		traceListeners.forEach[apply(msg)]
	}
}