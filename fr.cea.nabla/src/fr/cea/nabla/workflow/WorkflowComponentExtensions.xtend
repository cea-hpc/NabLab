package fr.cea.nabla.workflow

import fr.cea.nabla.nablagen.ChildComponent
import fr.cea.nabla.nablagen.Workflow
import fr.cea.nabla.nablagen.WorkflowComponent

import static extension fr.cea.nabla.Utils.*

class WorkflowComponentExtensions 
{
	static def getNexts(WorkflowComponent it)
	{
		workflow.components.filter(ChildComponent).filter[c | c.parent == it]
	}
	
	static def getEclipseProject(WorkflowComponent it)
	{
		eResource.toEclipseFile.project
	}
	
	private static def getWorkflow(WorkflowComponent it)
	{
		eContainer as Workflow
	}
}