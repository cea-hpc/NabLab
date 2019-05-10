package fr.cea.nabla.generator

import fr.cea.nabla.ir.generator.IrGenerator
import fr.cea.nabla.ir.generator.java.Ir2Java
import fr.cea.nabla.ir.generator.kokkos.Ir2Kokkos
import org.apache.log4j.Logger
import org.eclipse.emf.mwe2.runtime.workflow.IWorkflowContext
import org.eclipse.xtend.lib.annotations.Accessors

abstract class Ir2CodeWorkflowComponent extends NablaWorkflowComponent
{ 	  
	static val logger = Logger.getLogger(Ir2CodeWorkflowComponent);

	@Accessors String outputFilePath
	
	override internalInvoke(IWorkflowContext ctx) 
	{
		val g = codeGenerator
		val fileName = outputFilePath + '/' +  model.name.toLowerCase + '/' + model.name + '.' + g.fileExtension
		logger.info("Generating '" + fileName + "' file")
		val fileContent = g.getFileContent(model)
		configuredFileSystemAccess.generateFile(fileName, fileContent)
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