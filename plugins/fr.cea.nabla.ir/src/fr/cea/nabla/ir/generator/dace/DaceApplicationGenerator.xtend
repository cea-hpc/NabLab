package fr.cea.nabla.ir.generator.dace

import fr.cea.nabla.ir.generator.ApplicationGenerator
import fr.cea.nabla.ir.generator.GenerationContent
import fr.cea.nabla.ir.ir.IrRoot

class DaceApplicationGenerator implements ApplicationGenerator
{
	override getName() { 'DaCe' }

	override getIrTransformationStep() { null }

	// Only one file generated corresponding to the application
	override getGenerationContents(IrRoot ir)
	{
		#[new GenerationContent(ir.name + '.py', ir.fileContent, false)]
	}

	private def getFileContent(IrRoot ir)
	'''
		// TODO
	'''
}