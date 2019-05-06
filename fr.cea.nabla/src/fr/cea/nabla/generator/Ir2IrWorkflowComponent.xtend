package fr.cea.nabla.generator

import fr.cea.nabla.ir.transformers.IrTransformationStep
import fr.cea.nabla.ir.transformers.OptimizeConnectivities
import fr.cea.nabla.ir.transformers.ReplaceInternalReductions
import fr.cea.nabla.ir.transformers.ReplaceUtf8Chars
import fr.cea.nabla.ir.transformers.TagPersistentVariables
import java.util.HashMap
import org.eclipse.emf.mwe2.runtime.workflow.IWorkflowContext
import org.eclipse.xtend.lib.annotations.Accessors
import fr.cea.nabla.ir.transformers.FillJobHLTs

abstract class Ir2IrWorkflowComponent extends NablaWorkflowComponent  
{
	override internalInvoke(IWorkflowContext ctx) 
	{
		println('\tIR -> IR: ' + step.description)
		val ok = step.transform(model)
		createAndSaveResource
		if (!ok) 
			throw new RuntimeException("Error in IR transformation step")
	}
	
	abstract def IrTransformationStep getStep()
}

class TagPersistentVariablesWorkflowComponent extends Ir2IrWorkflowComponent
{
	static class OutputVar
	{
		@Accessors String nabla
		@Accessors String output		
	}

	val outputVars = new HashMap<String, String>
	
	override getStep() { new TagPersistentVariables(outputVars) }
	
	def addOutputVar(OutputVar it) { outputVars.put(nabla, output) }
}

class ReplaceUtf8CharsWorkflowComponent extends Ir2IrWorkflowComponent
{
	override getStep() { new ReplaceUtf8Chars }
}

class ReplaceInternalReductionsWorkflowComponent extends Ir2IrWorkflowComponent
{
	override getStep() { new ReplaceInternalReductions }
}

class OptimizeConnectivitiesWorkflowComponent extends Ir2IrWorkflowComponent
{
	override getStep() { new OptimizeConnectivities }
}

class FillJobHLTsWorkflowComponent extends Ir2IrWorkflowComponent
{
	override getStep() { new FillJobHLTs }
}