package fr.cea.nabla.generator

import fr.cea.nabla.generator.ir.Nabla2Ir
import fr.cea.nabla.nabla.NablaModule
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.emf.mwe2.runtime.Mandatory
import org.eclipse.emf.mwe2.runtime.workflow.IWorkflowContext
import org.eclipse.xtend.lib.annotations.Accessors

class Nabla2IrWorkflowComponent extends NablaWorkflowComponent  
{
	@Accessors(PUBLIC_GETTER) String nablaModelPath
	val nabla2ir = injector.getInstance(Nabla2Ir)
		
	@Mandatory def setNablaModelPath(String value) { nablaModelPath = value }
	
	override internalInvoke(IWorkflowContext ctx) 
	{
		val uri = URI::createURI(nablaModelPath, true)
		val input = rSet.createResource(uri)
		EcoreUtil::resolveAll(rSet)
		input.load(null)
		val module = input.contents.filter(NablaModule).head
		
		if (!module.jobs.empty)
		{
			model = nabla2ir.toIrModule(module)
			createAndSaveResource
		}
	}
}