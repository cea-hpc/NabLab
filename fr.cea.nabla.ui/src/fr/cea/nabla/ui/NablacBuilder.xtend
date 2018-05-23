package fr.cea.nabla.ui

import org.eclipse.core.resources.IncrementalProjectBuilder
import java.util.Map
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.core.runtime.CoreException

class NablacBuilder extends IncrementalProjectBuilder 
{
	override protected build(int kind, Map<String, String> args, IProgressMonitor monitor) throws CoreException 
	{
		println('NablacBuilder::build : ' + args)
		return null
	}
}