package fr.cea.nabla.ir.generator

import org.eclipse.xtend.lib.annotations.Data

@Data
class GenerationContent
{
	val String fileName
	val CharSequence fileContent
	val boolean generateOnce
}

