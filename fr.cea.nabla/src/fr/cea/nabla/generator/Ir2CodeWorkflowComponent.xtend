package fr.cea.nabla.generator

import org.eclipse.emf.mwe2.runtime.workflow.IWorkflowContext
import fr.cea.nabla.ir.generator.IrGenerator
import fr.cea.nabla.ir.generator.java.Ir2Java
import fr.cea.nabla.ir.generator.kokkos.Ir2Kokkos

abstract class Ir2CodeWorkflowComponent extends NablaWorkflowComponent
{ 	  
	override internalInvoke(IWorkflowContext ctx) 
	{
		val g = codeGenerator
		println('\tGenerating .' + g.fileExtension + ' file')
		val fileContent = g.getFileContent(model)
		configuredFileSystemAccess.generateFile(outputFilePath, fileContent)
	}
	
	abstract def IrGenerator getCodeGenerator()
}

class Ir2JavaWorkflowComponent extends Ir2CodeWorkflowComponent
{	
	override getCodeGenerator() { injector.getInstance(Ir2Java) }	
}

class Ir2KokkosWorkflowComponent extends Ir2CodeWorkflowComponent
{
	override getCodeGenerator() { injector.getInstance(Ir2Kokkos) }	
}