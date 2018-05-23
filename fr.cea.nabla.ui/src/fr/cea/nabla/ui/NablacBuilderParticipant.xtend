package fr.cea.nabla.ui

import org.eclipse.xtext.builder.IXtextBuilderParticipant
import org.eclipse.xtext.builder.IXtextBuilderParticipant.IBuildContext
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.core.runtime.CoreException

class NablacBuilderParticipant implements IXtextBuilderParticipant 
{
	override build(IBuildContext context, IProgressMonitor monitor) throws CoreException 
	{
		println('### NablacBuilderParticipant::build : ' + context.deltas.map[x|x.uri.toString].join(', '))
	}
}