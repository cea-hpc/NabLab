package fr.cea.nabla.sirius.nablagen

import fr.cea.nabla.nablagen.ChildComponent
import fr.cea.nabla.nablagen.Workflow
import fr.cea.nabla.ui.launchconfig.NablagenRunner
import fr.cea.nabla.ui.internal.NablaActivator

import static extension fr.cea.nabla.workflow.WorkflowComponentExtensions.*

class PresentationServices 
{
	def replaceUpperCaseWithSpace(String it)
	{
		val separator = ' '
		
		if (contains('_'))
			replace('_', separator)
		else 
			// chaine de la forme monNom
			Character::toUpperCase(charAt(0)) + toCharArray.tail.map[c | if (Character::isUpperCase(c)) separator + c else c  ].join
	}	
	
	def void disableBranch(ChildComponent it)
	{
		disabled = true
		nexts.forEach[disableBranch]
	}
	
	def void enableBranch(ChildComponent it)
	{
		disabled = false
		nexts.forEach[enableBranch]
	}
	
	def void execute(Workflow w)
	{
		val injector = NablaActivator::instance.getInjector(NablaActivator::FR_CEA_NABLA_NABLAGEN)
		val runner = injector.getInstance(NablagenRunner)
		runner.launch(w)
	}
}