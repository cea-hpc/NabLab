package fr.cea.nabla.ir.generator

import fr.cea.nabla.ir.ir.IrModule
import fr.cea.nabla.ir.transformers.IrTransformationStep
import java.util.List

interface IrGenerator 
{
	def String getFileExtension()
	def List<? extends IrTransformationStep> getTransformationSteps()
	def CharSequence getFileContent(IrModule it)	
}