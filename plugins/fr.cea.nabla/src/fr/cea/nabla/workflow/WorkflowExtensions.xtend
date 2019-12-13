package fr.cea.nabla.workflow

import fr.cea.nabla.nablagen.Workflow
import fr.cea.nabla.nablagen.Nabla2IrComponent

class WorkflowExtensions 
{
	static def getRoots(Workflow it)
	{
		components.filter(Nabla2IrComponent)
	}
}