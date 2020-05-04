package fr.cea.nabla.generator

import com.google.inject.Singleton
import java.util.ArrayList

@Singleton
class NablaGeneratorMessageDispatcher
{
	val listeners = new ArrayList<(String) => void>

	def addListener((String) => void listener)
	{
		listeners += listener
	}

	def post(String msg)
	{
		listeners.forEach[apply(msg)]
	}
}