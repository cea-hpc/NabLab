package fr.cea.nabla.ir.generator

import fr.cea.nabla.ir.ir.ExtensionProvider

interface ProviderGenerator
{
	def String getName()
	def Iterable<GenerationContent> getGenerationContents(ExtensionProvider provider)
}