package fr.cea.nabla.sirius.services

import org.eclipse.emf.ecore.EObject
import org.eclipse.sirius.business.api.session.SessionManager

class TraceServices 
{
	static def trace(EObject o) 
	{
		if (o === null) println("NULL")
		else println(o + ' : ' + o.class.name)
		return o	
	}
	
	static def traceWithVars(EObject o)
	{
		val manager = SessionManager::INSTANCE
		val session = manager.getSession(o)
		val interpreter = session.interpreter
		val variables = interpreter.variables
		println("Variables [" + variables.size + "] : ")
		variables.keySet.forEach[v | println('  - ' + v + ' : ' + variables.get(v))]
		o.trace
	}	
}